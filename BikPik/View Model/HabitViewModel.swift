//
//  HabitViewModel.swift
//  BikPik
//
//  Created by jihee moon on 2021/12/23.
//

import UIKit

class HabitManager {
    let storage: Storage = Storage.disk
    static let mngHabit = HabitManager()
    private init() { }
    
    var habits: [String:Habits] = [:]
    var listHabit: [String] = []
    
    let mngFirebase = Firebase.mngFirebase
    /**
     Create and save the habit data.
     - parameter haibt : "Habits" struct data.
     */
    func createHabit(habit: Habits) {
        var data = habit
        
        let uuid = UUID().uuidString
        
        // isDone Dictionary
        data.isDone = createIsDone(habit: habit)
        
        habits[uuid] = data
        listHabit.append(uuid)
        
        mngFirebase.uploadHabit(uuid: uuid, habit: data)
        saveHabit()
    }
    
    /**
     A function that modifies and save habit data.
     - parameter id : "habits" of index
     - parameter habit: "Habit" struct data.
     */
    func correctHabit(uuid: String, habit : Habits) {
        habits[uuid] = habit
        mngFirebase.correctHabit(uuid: uuid, habit: habit)
        saveHabit()
    }
    
    /**
     Loading Habit data from "HabitList.json" file.
     */
    func loadHabit() {
        let fileName = "HabitList.json"
        habits.removeAll()
        habits = storage.Search(fileName, as: [String:Habits].self) ?? [:]
        listHabit = habits.keys.sorted()
    }
    
    /**
     Save the "habits" habit array to "HabitList.json" file.
     */
    func saveHabit() {
        let fileName = "HabitList.json"
        storage.Save(habits, fileName)
    }
    
    /**
     Delete "habits" array value of "id" Index.
     */
    func deleteHabit(uuid: String) {
        habits.removeValue(forKey: uuid)
        if let idx = listHabit.firstIndex(of: uuid) {
            listHabit.remove(at: idx)
        }
        mngFirebase.removeHabit(uuid: uuid)
        saveHabit()
    }
    
    /**
     The number of "isDone" arrays in the habit data is the total amount calculated based on the "days" arrays selected.
     so if you check the "isDone" array, need to calculate index of "isDone" array.
     This function calculate the index of the "isDone" array for the selected date.
     - parameter habit : Habits structure data.
     - parameter date: yyyyMMdd format date. ex) 20210929
     - returns : if find the index, return index. if doesn't find the index, return nil.
     */
    func isDoneIndex(habit: Habits, date: String) -> Int? {
        let selIdx = Date.WeekForm(data: date, input: .fullDate, output: .intIndex) as! Int
        var resDay = 0
        var rptWeek: [Int] = []
        var cntDay = habit.start

        for i in 0...6 {
            let nextDay = Date.GetNextDay(date: habit.start,fewDays: i)
            let idx = Date.WeekForm(data: nextDay, input: .fullDate, output: .intIndex) as! Int
            if(habit.days[i] == true) {
                rptWeek.append(idx)
            }
        }
        for i in 0...6 {
            let nextDay = Date.GetNextDay(date: habit.start,fewDays: i)
            let idx = Date.WeekForm(data: nextDay, input: .fullDate, output: .intIndex) as! Int
            
            if selIdx == idx {
                cntDay = nextDay
                break
            } else {
                resDay += 1
            }
        }
        if rptWeek.count == 0 { return nil }
        
        let quotient = (Date.GetDays(start: cntDay, end: date)-1) / 7
        let ret = (rptWeek.count*quotient) + resDay
        
        return ret
    }
    
    /**
     This function is check the "isDone" array value on the seleted day.
     - parameter habit : "Habits" structure data.
     - parameter date : yyyyMMdd format date. ex) 20210929
     - returns : Returns a value if the array value is checked, or nil if the array does not exist.
     */
    func isDoneCheck(habit : Habits ,date: String) -> Bool {
        if habit.isDone == nil {
            print("isDoneCheck Error :: No Exist isDone Array")
            return false
        }
        if let done = habit.isDone?[date] {
            return done
        }
        
        print("isDoneCheck Error :: No Exist isDone Array value")
         return false
    }
    
    /**
     This functions write "isDone" array.
     - parameter habit : "Habits" structure data.
     - parameter date : yyyyMMdd format date. ex) 20210929
     - parameter done : true / false
     */
    func isDone(habit: inout Habits,  date: String, done : Bool) {
        if habit.isDone == nil { return }
        if habit.isDone!.keys.contains(date) {
            habit.isDone?[date] = done
        }
    }
    
    func createIsDone(habit: Habits) -> [String:Bool] {
        var dic = [String:Bool]()
        
        var date = habit.start
        for _ in 0..<habit.total {
            let idx = Date.WeekForm(data: date, input: .fullDate, output: .intIndex) as! Int - 1
            if habit.days[idx] {
                dic[date] = false
            }
            date = Date.GetNextDay(date: date)
        }
        
        return dic
    }
    
    /** Calcuate Habit percent
     */
    func calculatePercent(habit : Habits) -> Int {
        if habit.isDone == nil { return 0 }
        
        var cnt = 0
        for elemnt in habit.isDone! {
            if elemnt.value {
                cnt += 1
            }
        }
        
        return Int(round(Float(cnt)/Float(habit.total)*100.0))
    }
}

