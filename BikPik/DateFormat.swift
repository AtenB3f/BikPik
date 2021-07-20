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
    
    /*
     [GetDayOfWeek]
     date : "20200719"
     return: "Mon" / "Tue" / ...
     */
    static func GetDayWeek (_ date: String) -> String {
        let IdxYM = date.index(date.startIndex, offsetBy: 4)
        let IdxMD = date.index(date.startIndex, offsetBy: 6)
        
        let year:Int = Int(date[date.startIndex ..< IdxYM])!
        let month:Int = Int(date[IdxYM..<IdxMD])!
        let day:Int = Int(date[IdxMD ..< date.endIndex])!

        let week = GetDayWeek(year: year, month: month, day: day)
        
        return week!
    }
    
    /*
     [GetDayOfWeek]
     year : "2020"
     month : "7"
     day: "19"
     return: "Mon" / "Tue" / ...
     */
    static func GetDayWeek (year: Int, month: Int, day: Int) -> String? {
        let calendar = Calendar(identifier: .gregorian)
        
        guard let targetDate: Date = {
            let comps = DateComponents(calendar:calendar, year: year, month: month, day: day)
            return comps.date
            }() else { return nil }
        
        var dd = Calendar.current.component(.weekday, from: targetDate)
        if year%4 == 0 {
            dd -= 1
        }
        
        // "Sun" / "Mon" / "Tue" / "Wed" / "Thu" / "Fri"/ "Sat"
        return Calendar.current.shortWeekdaySymbols[dd]
    }
    
    /*
     [GetIntDate]
     String to Int Date form
     date : "20200719"
     year : "2020"
     month : "7"
     day: "19"
     */
    static func GetIntDate (_ date:String, _ year: inout Int, _ month: inout Int, _ day: inout Int) {
        let IdxYM = date.index(date.startIndex, offsetBy: 4)
        let IdxMD = date.index(date.startIndex, offsetBy: 6)
        
        year = Int(date[date.startIndex ..< IdxYM])!
        month = Int(date[IdxYM..<IdxMD])!
        day = Int(date[IdxMD ..< date.endIndex])!
    }
}
