//
//  +DragDrop.swift
//  Listing
//
//  Created by Johnny on 25/8/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

extension SubList {
        func canHandle(_ session: UIDropSession) -> Bool {
               return session.canLoadObjects(ofClass: NSString.self)
        }
        
        func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
            let placeItem = itemsArray[indexPath.row].title

            let data = placeItem!.data(using: .utf8)
               let itemProvider = NSItemProvider()
               
               itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
                   completion(data, nil)
                   return nil
               }

               return [
                   UIDragItem(itemProvider: itemProvider)
               ]
        }

}
