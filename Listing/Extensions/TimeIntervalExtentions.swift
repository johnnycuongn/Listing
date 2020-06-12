//
//  DateIntervalExtentions.swift
//  Listing
//
//  Created by Johnny on 12/6/20.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func convertToHourMinutes() -> (hour: Int, minutes: Int, second: Int) {
        let hour = Int(self/60/60)
        let minutes = Int(((self/60/60 - Double(hour))*60))+1
        let seconds = Int(((((self/60/60 - Double(hour))*60)+1)-Double(minutes))*60)
        
        return (hour, minutes, seconds)
    }
    
}
