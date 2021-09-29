//
//  Habit.swift
//  BikPik
//
//  Created by jihee moon on 2021/09/01.
//
 
import UIKit

struct Habits: Codable, Equatable {
    var id: Int?
    var task: Task = Task()
    var start : String
    var end : String
    var days : [Bool] = [Bool](repeating: true, count: 7)
    var total = 0
    var isDone : [Bool]?
    
    init() {
        task.id = 0
        task.date = ""
        start = Date.GetNowDate()
        end = Date.GetNowDate()
    }
}

class HabitManager {
    let storage: Storage = Storage.disk
    static let mngHabit = HabitManager()
    private init() { }
    
    var habits: [Habits] = []
    var habitId: [String:Int] = [:]
    
    /**
     Create and save the habit data.
     - parameter haibt : "Habits" struct data.
     */
    func createHabit(habit: Habits) {
        var data = habit
        
        // setting ID
        let id = habits.count > 0 ? (habits.count - 1) : 0
        data.id = id
        let name = data.task.name!
        habitId[name] = id
        
        habits.append(data)
        saveHabit()
    }
    
    /**
     A function that modifies and save habit data.
     - parameter id : "habits" of index
     - parameter habit: "Habit" struct data.
     */
    func correctHabit(id: Int, habit : Habits) {
        habits[id] = habit
        saveHabit()
    }
    
    /**
     Loading Habit data from "HabitList.json" file.
     */
    func loadHabit() {
        let fileName = "HabitList.json"
        habits.removeAll()
        habits = storage.Search(fileName, as: [Habits].self) ?? []
        habitId.removeAll()
        
        let cnt = habits.count - 1
        guard cnt >= 0 else { return }
        for n in 0...cnt {
            let name = habits[n].task.name!
            habitId[name] = habits[n].id
        }
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
    func deleteHabit(id: Int) {
        let name = habits[id].task.name!
        habitId.removeValue(forKey: name)
        habits.remove(at: id)
        saveHabit()
    }
    
    /**
     Search task in "habits" array.
     - parameter name : habit name
     - returns : The task element of the habit structure.
     */
    func searchHabitTask (name: String) -> Task? {
        guard let id = habitId[name] else { return nil }
        
        return habits[id].task
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
        var rptWeek: [Int] = []
        var rptDay = 0
        var retIndex = 0
        let stWeek = Date.GetIntDayWeek(date: habit.start) ?? 0
        for i in 0...6 {
            let idx = Date.GetIntDayWeek(date: Date.GetNextDay(date: date,fewDays: i)) ?? 0
            if habit.days[idx-1] == true {
                rptWeek.append(idx)
                rptDay += 1
            }
        }
        if rptWeek.count == 0 { return nil }
        
        
        let quotient = (Date.GetDays(start: habit.start, end: date)-1) / 7
        
        for _ in 0...quotient {
            for n in 0...(rptWeek.count-1) {
                let add : Int = (rptWeek[n] - stWeek) >= 0 ? rptWeek[n] - stWeek : rptWeek[n] - stWeek + 7
                
                let addDay = Date.GetNextDay(date: habit.start,fewDays: (quotient*7)+add)
                if Int(addDay)! > Int(date)! {
                    break
                } else {
                    retIndex += 1
                }
            }
        }
        
        return retIndex - 1
    }
    
    /**
     This function is check the "isDone" array value on the seleted day.
     - parameter habit : "Habits" structure data.
     - parameter date : yyyyMMdd format date. ex) 20210929
     - returns : Returns a value if the array value is checked, or nil if the array does not exist.
     */
    func isDoneCheck(habit : Habits ,date: String) -> Bool {
        let idx = isDoneIndex(habit: habit, date: date) ?? 0
        if habit.isDone == nil { return false }
        if idx <= habit.isDone!.count { return false }
        let done = habit.isDone?[idx] ?? false
        print("isDoneCheck ::  \(idx) , \(done)")
        return done
    }
    
    /**
     This functions write "isDone" array.
     - parameter habit : "Habits" structure data.
     - parameter date : yyyyMMdd format date. ex) 20210929
     - parameter done : true / false
     */
    func isDone(habit: inout Habits,  date: String, done : Bool) {
        let idx = isDoneIndex(habit: habit, date: date) ?? 0
        habit.isDone?[idx] = done
    }
}

