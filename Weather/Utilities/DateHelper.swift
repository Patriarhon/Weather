//
//  DateHelper.swift
//  Weather
//
//  Created by Petr on 21/01/2019.
//  Copyright © 2019 Petr. All rights reserved.
//

import Foundation

class DateHelper {
    static func getStringDate(from timeStamp: Double, format: String) -> String {
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date as Date)
    }
    
    static func getDay(timestamp: Double?) -> Int? {
        let today = Date()
        if let timeStamp = timestamp {
            let forecastDate = Date(timeIntervalSince1970: timeStamp)
            let calendar = Calendar.current
            
            let date1 = calendar.startOfDay(for: today)
            let date2 = calendar.startOfDay(for: forecastDate)
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            return components.day
        } else {
            return nil
        }
    }
}
