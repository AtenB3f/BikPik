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
        start = Date.FullNowDate()
        end = Date.FullNowDate()
    }
}

class HabitManager {
    let storage: Storage = Storage.disk
    static let mngHabit = HabitManager()
    private init() { }
    
    var habits: [Habits] = []
    var habitId: [String:Int] = [:]
    
    func createHabit(_ habitData: Habits) {
        var data = habitData
        
        // setting ID
        let id = habits.count > 0 ? (habits.count - 1) : 0
        data.id = id
        let name = data.task.name!
        habitId[name] = id
        
        habits.append(data)
        saveHabit(habits)
    }
    
    func reviseHabit(id: Int, habit : Habits) {
        habits[id] = habit
        saveHabit()
    }
    
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
    
    func saveHabit(_ habits: [Habits]) {
        let fileName = "HabitList.json"
        storage.Save(habits, fileName)
    }
    
    func saveHabit() {
        let fileName = "HabitList.json"
        storage.Save(habits, fileName)
    }
    
    func deleteHabit(_ id: Int) {
        let name = habits[id].task.name!
        habitId.removeValue(forKey: name)
        habits.remove(at: id)
        saveHabit(habits)
    }
    
    func searchHabitTask (name: String) -> Task? {
        guard let id = habitId[name] else { return nil }
        
        return habits[id].task
    }
    
    func isDoneIndex(habit: Habits, date: String) -> Int? {
        var rptWeek: [Int] = []
        var rptDay = 0
        var retIndex = 0
        let stWeek = Date.GetIntDayWeek(habit.start) ?? 0
        for i in 0...6 {
            let idx = Date.GetIntDayWeek(Date.GetNextDay(date, i)) ?? 0
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
                
                let addDay = Date.GetNextDay(habit.start, (quotient*7)+add)
                if Int(addDay)! > Int(date)! {
                    break
                } else {
                    retIndex += 1
                }
            }
        }
        
        return retIndex - 1
    }
    
    func isDoneCheck(habit : Habits ,date: String) -> Bool {
        let idx = isDoneIndex(habit: habit, date: date) ?? 0
        if habit.isDone == nil { return false }
        if idx <= habit.isDone!.count { return false }
        let done = habit.isDone?[idx] ?? false
        print("isDoneCheck ::  \(idx) , \(done)")
        return done
    }
    
    func isDone(habit: inout Habits,  date: String, done : Bool) {
        let idx = isDoneIndex(habit: habit, date: date) ?? 0
        habit.isDone?[idx] = done
    }
}

