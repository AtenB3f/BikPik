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
    
    /**
     
     - returns
     case intIndex      day index ( Mon: 1, Tue: 2, Wed: 3, Thr: 4, Fri: 5, Sat: 6 , Sun: 7)
     case stringDay     Mon / Tue / Wed / Thr / Fri / Sat / Sun
     */
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
    static func GetIntTime (time: String, hour: inout Int, minutes: inout Int) {
        let preCol = time.index(time.startIndex, offsetBy: 2)
        let postCol = time.index(time.startIndex, offsetBy: 3)
        
        hour = Int(time[time.startIndex ..< preCol]) ?? 0
        minutes = Int(time[postCol ..< time.endIndex]) ?? 0
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
        let d = DateForm(data: date, input: .fullDate, output: .date) as! Date
        let n = Calendar.current.date(byAdding: .day, value: 1, to: d) ?? Date()
        
        return DateForm(data: n, input: .date, output: .fullDate) as! String
    }
    
    /**
     This function returns the date by adding "fewDay" to the parameter "date".
     - parameter date :"yyyyMMdd" format string date
     - parameter fewDays: Integer type that can be negative or positive.
     - returns:A date in the format "yyyyMMdd" with "date" plus "fewDays".
     */
    static func GetNextDay (date: String, fewDays: Int) -> String {
        let d = DateForm(data: date, input: .fullDate, output: .date) as! Date
        let n = Calendar.current.date(byAdding: .day, value: fewDays, to: d) ?? Date()
        
        return DateForm(data: n, input: .date, output: .fullDate) as! String
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
        var count = 0
        var current = start
        var cmp = start.compare(end)
        while (cmp == .orderedAscending || cmp == .orderedSame){
            let index = self.WeekForm(data: current, input: .date, output: .intIndex) as! Int
            var add = 1
            if index == week {
                count += 1
                add = 7
            }
            
            current = Calendar.current.date(byAdding: .day, value: add, to: current) ?? Date()
            cmp = current.compare(end)
        }
        
        return count
    }
    
    static func GetWeekDaysArray(start: Date, end: Date, week: Int) -> [String] {
        var days:[String] = []
        var current = start
        var cmp = start.compare(end)
        while (cmp == .orderedAscending || cmp == .orderedSame){
            let index = self.WeekForm(data: current, input: .date, output: .intIndex) as! Int
            var add = 1
            if index == week {
                days.append(self.DateForm(data: current, input: .date, output: .fullDate) as! String)
                add = 7
            }
            
            current = Calendar.current.date(byAdding: .day, value: add, to: current) ?? Date()
            cmp = current.compare(end)
        }
        
        return days
    }
    /**
     "HH:mm" format string convert to Date structure.
     - parameter date: "HH:mm" format string time.
     - returns : Date structure
     */
    static func GetDateTime(time: String) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        
        var hour = 0
        var minute = 0
        
        GetIntTime(time: time, hour: &hour, minutes: &minute)
        
        return DateComponents(calendar: calendar, hour: hour, minute: minute).date ?? Date()
    }
}
