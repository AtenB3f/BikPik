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
    
    static func GetStringDate (_ year: Int, _ month: Int, _ day: Int) -> String {
        var date: String = String(year)
        
        date = month >= 10 ? date+String(month) : date+"0"+String(month)
        date = day >= 10 ? date+String(day) : date+"0"+String(day)
        
        return date
    }
    
    static func NextDay(_ date: String) -> String {
        var year: Int = 0
        var month: Int = 0
        var day: Int = 0
        
        self.GetIntDate(date, &year, &month, &day)
        
        switch month {
        case 1,3,5,7,8,10,12 :
            if day >= 31 {
                day = 1
                if month == 12 {
                    month = 1
                } else {
                    month += 1
                }
            } else {
                day += 1
            }
            break
        case 2 :
            if year % 4 == 0 {
                if day >= 29 {
                    month += 1
                    day = 1
                } else {
                    day += 1
                }
            } else {
                if day >= 30 {
                    month += 1
                    day = 1
                } else {
                    day += 1
                }
            }
            break
        case 4,6,9,11 :
            if day >= 30 {
                day = 1
                month += 1
            } else {
                day += 1
            }
            break
        default:
           break
        }
        
        return GetStringDate(year, month, day)
    }
}
