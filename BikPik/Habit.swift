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
    
    func isDoneCheck(habit : Habits ,date: String) -> Bool {
        var rptDay = 0
        var resDay = 0
        
        for i in 0...6 {
            if habit.days[i] == true {
                rptDay += 1
            }
        }
        let quotient = (Date.GetDays(start: habit.start, end: date)-1) / 7
        let remainder = (Date.GetDays(start: habit.start, end: date)-1) % 7
        if remainder>0{
            let gap = Date.GetIntDayWeek(habit.start)! - Date.GetIntDayWeek(date)!
            var n = Date.GetIntDayWeek(habit.start)!
            if gap > 0 {
                for _ in 1...(7-gap) {
                    if n > 7 {
                        n = 1
                    }
                    if ((habit.isDone?[n-1]) != nil) {
                        resDay += 1
                    }
                    n += 1
                }
            } else if gap < 0 {
                for _ in gap ... -1 {
                    if ((habit.isDone?[n-1]) != nil) {
                        resDay += 1
                    }
                    n += 1
                }
            }
        }
        
        let idx = (quotient * rptDay) + resDay
        let done = habit.isDone?[idx] ?? false
        
        return done
    }
    
    func isDone(habit: inout Habits,  date: String, done : Bool) {
        var rptDay = 0
        var resDay = 0
        
        for i in 0...6 {
            if habit.days[i] == true {
                rptDay += 1
            }
        }
        let quotient = (Date.GetDays(start: habit.start, end: date)-1) / 7
        let remainder = (Date.GetDays(start: habit.start, end: date)-1) % 7
        if remainder>0{
            let gap = Date.GetIntDayWeek(habit.start)! - Date.GetIntDayWeek(date)!
            var n = Date.GetIntDayWeek(habit.start)!
            if gap > 0 {
                for _ in 1...(7-gap) {
                    if n > 7 {
                        n = 1
                    }
                    if ((habit.isDone?[n-1]) != nil) {
                        resDay += 1
                    }
                    n += 1
                }
            } else if gap < 0 {
                for _ in gap ... -1 {
                    if ((habit.isDone?[n-1]) != nil) {
                        resDay += 1
                    }
                    n += 1
                }
            }
        }
        
        let idx = (quotient * rptDay) + resDay
        habit.isDone?[idx] = done
    }
}

