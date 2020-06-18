//
//  DataManager.swift
//  Listing
//
//  Created by Johnny on 13/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

enum FileError: Error {
    case pathNotFound
    case fileNotFound
}

public class DataManager {
    
    static fileprivate func getDocumentDirectory() throws -> URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileError.pathNotFound
        }
        print(url)
        return url
    }
    
    static func save<T: Encodable>(_ object: T, with fileName: String) {
        do {
            let url = try getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(object)
            
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch FileError.pathNotFound {
            fatalError("Path Not Found")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func load<T: Decodable>(from fileName: String, of type: T.Type) -> T {
        do {
            let url = try getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
            if !FileManager.default.fileExists(atPath: url.path) { fatalError("File not found at path \(url.path)") }
            
            guard let data = FileManager.default.contents(atPath: url.path) else { fatalError() }
            
            let decoder = JSONDecoder()
            let content = try decoder.decode(type, from: data)
            
            return content
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func loadAll<T: Decodable>(from type: T.Type) -> [T] {
          do {
                let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
                
                var modelObjects = [T]()
                
                for fileName in files {
                    modelObjects.append(load(from: fileName, of: type))
                }
                
                return modelObjects
            } catch {
                fatalError("Could not load any files")
            }
    }
    
    static func delete(from fileName: String) {
        guard let url = try? getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false) else { fatalError() }
        
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    static func clearAll() {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            
            for fileName in files {
                delete(from: fileName)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    
    
}

