//
//  DateFormat.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/15.
//

import UIKit

struct IntDate {
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
}

enum DateFormat {
    case picker
    case date
    case fullDate
    case userDate
    case intDate
}

enum WeekInput {
    case date
    case fullDate
    case intDate
}

enum WeekOutput {
    case intIndex
    case stringDay
}

extension Date {
    /**
     Date data conver function.
     - parameter data : UIDatePicker / Date / yyyyMMdd string / M/d string / IntDate structure
     - parameter input : Input data format. enum DateFormat
     - parameter output : Output data format. enum DateFormat
     */
    static func DateForm(data: Any, input: DateFormat, output: DateFormat) ->Any {
        if input == output { return data }
        
        let calendar = Calendar(identifier: .gregorian)
        
        let dateFormatter = Foundation.DateFormatter()
        var convertDate: Date?
        
        switch input {
        case .picker:
            let datePicker: UIDatePicker = data as! UIDatePicker
            convertDate = datePicker.date
        case .date:
            convertDate = data as? Date
        case .fullDate:
            var year = 0
            var month = 0
            var day = 0
            GetIntDate(date: data as! String , year: &year, month: &month, day: &day)
            let cmp = DateComponents(year: year, month: month, day: day)
            convertDate = calendar.date(from: cmp)
        case .intDate:
            let intDate: IntDate = data as! IntDate
            convertDate = DateComponents(calendar: calendar, year: intDate.year, month: intDate.month, day: intDate.day).date
        default:
            convertDate = Date()
        }
        
        switch output {
        case .picker:
            let picker = UIDatePicker()
            picker.date = convertDate!
            return picker
        case .date:
            return convertDate!
        case .fullDate:
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: convertDate!)
        case .userDate:
            dateFormatter.dateFormat = "M/d"
            return dateFormatter.string(from: convertDate!)
        case .intDate:
            var intDate = IntDate()
            intDate.year = calendar.component(.year, from: convertDate!)
            intDate.month = calendar.component(.month, from: convertDate!)
            intDate.day = calendar.component(.day, from: convertDate!)
            return intDate
        //default:
            //return convertDate!
        }
    }
    /**
     Date time data convert to string data of HH:mm format .
     - parameter picker : UIDatePicker of time data
     - returns : HH:mm format string data.
     */
    static func TimeForm(picker: UIDatePicker) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: picker.date)
    }
    
    /**
     current date convert to "yyyyMMdd" format string.
     - returns :current date in "yyyyMMdd" format string
     */
    static func GetNowDate() -> String {
        let nowDate = Date()
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        return dateFormatter.string(from: nowDate)
    }
    
    /**
     current time convert to "HH:mm" format string.
     - returns :current time in "HH:mm" format string
     */
    static func GetNowTime() -> String {
        let nowDate = Date()
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: nowDate)
    }
    
    static func WeekForm(data : Any, input: WeekInput, output : WeekOutput) -> Any {
        var date: Date = Date()
        var year: Int = 0
        var ret: Any
        switch input {
        case .date:
            date = data as! Date
            
            break
        case .fullDate:
            date = DateForm(data: data, input: .fullDate, output: .date) as! Date
            break
        case .intDate:
            let intDate: IntDate = data as! IntDate
            //year = intDate.year
            date = DateForm(data: intDate, input: .intDate, output: .date) as! Date
            break
        }
        year = Calendar.current.component(.year, from: date)
        var dd = Calendar.current.component(.weekday, from: date)
        if year%4 == 0 {
            dd -= 1
        }
        switch output {
        case .intIndex:
            ret = dd
            ret = MondayFirstInt(idx: dd)
            return ret
        case .stringDay:
            ret = Calendar.current.shortWeekdaySymbols[dd]
            ret = MondayFirstInt(idx: dd)
            return ret
        }
    }
    

    
    /**
     A function that changes the index so that the week starts on Monday instead of Sunday.
     - parameter idx : day index. ( Sun: 1, Mon: 2, Tue: 3, Wed: 4, Thr: 5, Fri: 6, Sat: 7 )
     - returns : changed day index ( Mon: 1, Tue: 2, Wed: 3, Thr: 4, Fri: 5, Sat: 6 , Sun: 7)
     */
    static func MondayFirstInt(idx: Int) -> Int {
        if idx == 1 {
            return 7
        } else {
            return idx - 1
        }
    }
    
    /**
     A function that converts a date into an index of the day of the week.
     - parameter year: Year  expressed as an integer.
     - parameter month:Month expressed as an integer.
     - parameter day: A day expressed as an integer.
     - returns : day index ( Mon: 1, Tue: 2, Wed: 3, Thr: 4, Fri: 5, Sat: 6 , Sun: 7).
                Returns nil when an error occurs.
     */
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
        
        return MondayFirstInt(idx: dd)
    }
    
    /**
     A function that converts a date into an index of the day of the week.
     - parameter date : Date structure data.
     - returns :day index ( Mon: 1, Tue: 2, Wed: 3, Thr: 4, Fri: 5, Sat: 6 , Sun: 7).
                Returns nil when an error occurs.
     */
    static func GetIntDayWeek(date: Date) -> Int? {
        let year = Calendar.current.component(.year, from: date)
        var dd = Calendar.current.component(.weekday, from: date)
        if year%4 == 0 {
            dd -= 1
        }
        
        return MondayFirstInt(idx: dd)
    }
    
    /**
     A function that converts a date into an index of the day of the week.
     - parameter date : Date string data.
     - returns :day index ( Mon: 1, Tue: 2, Wed: 3, Thr: 4, Fri: 5, Sat: 6 , Sun: 7).
                Returns nil when an error occurs.
     */
    static func GetIntDayWeek (date: String) -> Int? {
        var year = 0
        var month = 0
        var day = 0
        
        GetIntDate(date: date, year: &year, month: &month, day: &day)
        
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
    /**
     String date convert to Int date.
     ex) 20210929 -> year: 2020, month:9, day: 29
     - parameter date : "yyyyMMdd" format string date.
     - parameter year : Int type year.
     - parameter month : Int type month.
     - parameter day : Int type day.
     */
    static func GetIntDate (date:String, year: inout Int, month: inout Int, day: inout Int) {
        let IdxYM = date.index(date.startIndex, offsetBy: 4)
        let IdxMD = date.index(date.startIndex, offsetBy: 6)
        
        year = Int(date[date.startIndex ..< IdxYM])!
        month = Int(date[IdxYM..<IdxMD])!
        day = Int(date[IdxMD ..< date.endIndex])!
    }
    
    /**
     String Time convert to int time.
     ex)  21:13 -> hour: 21, minute: 13
     - parameter date: "HH:mm" format string time.
     - parameter hour: Int type hour.
     - parameter minutes: Int type minutes.
     */
    static func GetIntTime (date: String, hour: inout Int, minutes: inout Int) {
        let preCol = date.index(date.startIndex, offsetBy: 2)
        let postCol = date.index(date.startIndex, offsetBy: 3)
        
        hour = Int(date[date.startIndex ..< preCol]) ?? 0
        minutes = Int(date[postCol ..< date.endIndex]) ?? 0
    }
    
    /**
     Integer type data combine to string data.
     ex) year: 2021, month: 9, day: 29 -> 20210929
     - parameter year:Int type year.
     - parameter month:Int type month.
     - parameter day:Int type day.
     - returns : "yyyyMMdd" format string date.
     */
    static func GetStringDate (year: Int, month: Int, day: Int) -> String {
        var date: String = String(year)
        
        date = month >= 10 ? date+String(month) : date+"0"+String(month)
        date = day >= 10 ? date+String(day) : date+"0"+String(day)
        
        return date
    }
    
    /**
     A function that returns the next day of the parameter "date".
     - parameter date : "yyyyMMdd" format string date.
     - returns : next day of "date"
     */
    static func GetNextDay(date: String) -> String {
        var year: Int = 0
        var month: Int = 0
        var day: Int = 0
        
        self.GetIntDate(date: date, year: &year, month: &month, day: &day)
        
        CalculateDate(year: &year, month: &month, day: &day, oper: true)
        
        return GetStringDate(year: year, month: month, day: day)
    }
    
    /**
     This function returns the date by adding "fewDay" to the parameter "date".
     - parameter date :"yyyyMMdd" format string date
     - parameter fewDays: Integer type that can be negative or positive.
     - returns:A date in the format "yyyyMMdd" with "date" plus "fewDays".
     */
    static func GetNextDay (date: String, fewDays: Int) -> String {
        var year: Int = 0
        var month: Int = 0
        var day: Int = 0
        
        GetIntDate(date: date, year: &year, month: &month, day: &day)
        
        let cnt: Int = (fewDays >= 0) ? fewDays : 0 - fewDays
        let oper = fewDays >= 0 ? true : false
        
        if cnt > 0 {
            for _ in 1 ... cnt {
                CalculateDate(year: &year,month: &month,day: &day,oper: oper)
            }
        }
        
        return GetStringDate(year: year, month: month,day: day)
    }
    
    /**
     The date entered as a parameter plus one day.
     - parameter year: Integer type year.
     - parameter month: Integer type month.
     - parameter day: Integer type day.
     - parameter oper: true( add 1 ) / false ( add -1 )
     */
    static func CalculateDate (year: inout Int, month: inout Int, day: inout Int, oper: Bool) {
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
                    year += 1
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
    
    /**
     This function counts the number of days between the start date and the end date.
     Start day and End day is Date type.
     - parameter start : start day
     - parameter end : end day
     - returns : the number of days between the start date and the end date.
     */
    static func GetDays(start: Date, end: Date) -> Int {
        let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        return days + 1
    }
    
    /**
     This function counts the number of days between the start date and the end date.
     Start day and End day is "yyyyMMdd" format string.
     - parameter start : start day
     - parameter end : end day
     - returns : the number of days between the start date and the end date.
     */
    static func GetDays(start: String, end: String) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        var year = 0
        var month = 0
        var day = 0
        
        GetIntDate(date: start, year: &year, month: &month, day: &day)
        let startDate = DateComponents(calendar:calendar, year: year, month: month, day: day).date ?? Date()
        GetIntDate(date: end, year: &year, month: &month, day: &day)
        let endDate = DateComponents(calendar:calendar, year: year, month: month, day: day).date ?? Date()

        return GetDays(start: startDate, end: endDate)
    }

    /**
     시작일과 종료일 사이에 "week"요일이 며칠이 있는지 세는 함수.
     Start day and End day is "yyyyMMdd" format string.
     - parameter start : start day
     - parameter end : end day
     - parameter week : Mon(1) / Tue(2) / Wed(3) / ... / Sun(7)
     - returns :
     */
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
    /**
     "HH:mm" format string convert to Date structure.
     - parameter date: "HH:mm" format string time.
     - returns : Date structure
     */
    static func GetDateTime(date: String) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        
        var hour = 0
        var minute = 0
        
        GetIntTime(date: date, hour: &hour, minutes: &minute)
        
        return DateComponents(calendar: calendar, hour: hour, minute: minute).date ?? Date()
    }
}
