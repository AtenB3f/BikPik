//
//  DateFormat.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/15.
//

import UIKit
extension Date {
    static func TimeForm(_ time: UIDatePicker) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: time.date)
    }
    
    static func DateForm(_ date: UIDatePicker) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: date.date)
    }
    
    static func UserNowDate() -> String {
        
        let nowDate = Date()
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "M/d"

        return dateFormatter.string(from: nowDate)
    }
    
    static func FullNowDate() -> String {
        let nowDate = Date()
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        return dateFormatter.string(from: nowDate)
    }
    
    static func NowTime() -> String {
        let nowDate = Date()
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: nowDate)
    }
}
