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
    
    static func GetIntDayWeek(date: Date) -> Int? {
        let year = Calendar.current.component(.year, from: date)
        var dd = Calendar.current.component(.weekday, from: date)
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
    
    static func GetIntTime (date: String, hour: inout Int, miniute: inout Int) {
        let preCol = date.index(date.startIndex, offsetBy: 2)
        let postCol = date.index(date.startIndex, offsetBy: 3)
        
        hour = Int(date[date.startIndex ..< preCol]) ?? 0
        miniute = Int(date[postCol ..< date.endIndex]) ?? 0
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
    
    static func GetDays(start: String, end: String) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        var year = 0
        var month = 0
        var day = 0
        
        GetIntDate(start, &year, &month, &day)
        let startDate = DateComponents(calendar:calendar, year: year, month: month, day: day).date ?? Date()
        GetIntDate(end, &year, &month, &day)
        let endDate = DateComponents(calendar:calendar, year: year, month: month, day: day).date ?? Date()

        return GetDays(start: startDate, end: endDate)
    }

    // week : Mon(1) / Tue(2) / Wed(3) / ... / Sun(7)
    static func GetWeekDays(start: Date, end: Date, week: Int) -> Int {
        var weekCnt = 0
        let stWeek = GetIntDayWeek(date: start) ?? 0
        var addDay: Int = 0
        
        if stWeek > week {
            addDay = 7 - (stWeek - week)
        } else {
            addDay = week - stWeek
        }
        
        var selWeekDate = Calendar.current.date(byAdding: .day, value: addDay, to: start) ?? start
        var cnt = (Calendar.current.dateComponents([.weekOfYear], from: selWeekDate, to: end).weekOfYear ?? 0)
        
        /*
         * 위의 cnt를 구할 때 selWeekDate가 만약 월요일이면 다음주 월요일 까지 반환하는 값이 0이고 화요일부터 1이 됨.
         * 선택한 날짜의 다음 주 부터 1일의 격차가 생겨 아래 if else문이 이를 보완하는 작업이다.
         */
        if (cnt >= 0) && (week == GetIntDayWeek(date: start)) {
            cnt += 1
        } else if (cnt >= 0) && (week == GetIntDayWeek(date: end)) {
            cnt += 1
        }
        
        for _ in 0...cnt {
            if Calendar.current.compare(selWeekDate, to: end, toGranularity: .day).rawValue > 0 {
                return weekCnt
            } else {
                weekCnt += 1
                selWeekDate = Calendar.current.date(byAdding: .day, value: 7, to: selWeekDate)!
            }
        }
        
        return weekCnt
    }
    
    static func GetDateDay(date: String) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        
        var year = 0
        var month = 0
        var day = 0
        
        GetIntDate(date, &year, &month, &day)
        
        return DateComponents(calendar: calendar, year: year, month: month, day: day).date ?? Date()
    }
    static func GetDateTime(date: String) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        
        var hour = 0
        var minute = 0
        
        GetIntTime(date: date, hour: &hour, miniute: &minute)
        
        return DateComponents(calendar: calendar, hour: hour, minute: minute).date ?? Date()
    }
}
