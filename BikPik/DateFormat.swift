//
//  DateFormat.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/15.
//

import UIKit
extension Date {
    static func TimeForm(_ picker: UIDatePicker) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: picker.date)
    }
    
    static func DateForm(_ picker: UIDatePicker) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: picker.date)
    }
    
    static func GetUserDateForm() -> String {
        
        let nowDate = Date()
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "M/d"

        return dateFormatter.string(from: nowDate)
    }
    
    static func GetUserDateForm(_ picker: UIDatePicker) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "M/d"

        return dateFormatter.string(from: picker.date)
    }
    
    static func GetUserDate(_ date: String) -> String{
        var year = 0
        var month = 0
        var day = 0
        
        GetIntDate(date, &year, &month, &day)
        
        return String(month) + "/" + String(day)
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
        
        let dd = GetIntDayWeek(year: year, month: month, day: day) ?? 0
        // "Sun" / "Mon" / "Tue" / "Wed" / "Thu" / "Fri"/ "Sat"
        //Calendar.current.veryShortWeekdaySymbols[dd]
        return Calendar.current.shortWeekdaySymbols[dd]
    }
    
    static func MondayFirstInt(_ dayIdx: Int) -> Int {
        if dayIdx == 1 {
            return 7
        } else {
            return dayIdx - 1
        }
    }
    
    static func GetIntDayWeek (year: Int, month: Int, day: Int) -> Int? {
        let calendar = Calendar(identifier: .gregorian)
        
        guard let targetDate: Date = {
            let comps = DateComponents(calendar:calendar, year: year, month: month, day: day)
            return comps.date
            }() else { return nil }
        
        var dd = Calendar.current.component(.weekday, from: targetDate)
        if year%4 == 0 {
            dd -= 1
        }
        
        return MondayFirstInt(dd)
    }
    
    static func GetIntDayWeek (_ date: String) -> Int? {
        var year = 0
        var month = 0
        var day = 0
        
        GetIntDate(date, &year, &month, &day)
        
        return GetIntDayWeek(year: year, month: month, day: day)
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
    
    static func GetNextDay(_ date: String) -> String {
        var year: Int = 0
        var month: Int = 0
        var day: Int = 0
        
        self.GetIntDate(date, &year, &month, &day)
        
        CalculateDate(&year, &month, &day, true)
        
        return GetStringDate(year, month, day)
    }
    
    static func GetNextDay (_ date: String, _ fewDays: Int) -> String {
        var year: Int = 0
        var month: Int = 0
        var day: Int = 0
        
        GetIntDate(date, &year, &month, &day)
        
        let cnt: Int = (fewDays >= 0) ? fewDays : 0 - fewDays
        let oper = fewDays >= 0 ? true : false
        
        if cnt > 0 {
            for _ in 1 ... cnt {
                CalculateDate(&year, &month, &day, oper)
            }
        }
        
        return GetStringDate(year, month, day)
    }
    
    static func CalculateDate (_ year: inout Int, _ month: inout Int, _ day: inout Int, _ oper: Bool) {
        var carry = false
        
        if oper {
            // + 1
            switch month {
            case 1,3,5,7,8,10:
                carry = day >= 31 ? true : false
                break
            case 2:
                let standard = (year % 4) == 0 ? 29 : 28
                carry = day >= standard ? true : false
                break
            case 4,6,9,11:
                carry = day >= 30 ? true : false
                break
            case 12:
                carry = day >= 31 ? true : false
                if carry {
                    year = 1
                }
                break
            default :
                break
            }
            
            if carry {
                month += 1
                day = 1
            } else {
                day += 1
            }
            
        } else {
            // - 1
            if day == 1 {
                switch month {
                case 1 :
                    year -= 1
                    month = 12
                    day = 31
                    break
                case 5,7,8,10,12:
                    month -= 1
                    day = 30
                    break
                case 2,4,6,9,11:
                    month -= 1
                    day = 31
                    break
                case 3:
                    month = 2
                    day = (year % 4) == 0 ? 29 : 28
                default:
                    break
                }
            } else {
                day -= 1
            }
        }
    }
    
    static func GetDays(start: Date, end: Date) -> Int {
        let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        return days + 1
    }

}
