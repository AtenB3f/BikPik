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
    
    func createHabit(_ habitData: Habits) {
        var data = habitData
        
        // setting ID
        let id = habits.count > 0 ? (habits.count - 1) : 0
        data.id = id
        
        habits.append(data)
        saveHabit(habits)
    }
    
    func loadHabit() {
        let fileName = "HabitList.json"
        habits = storage.Search(fileName, as: [Habits].self) ?? []
    }
    
    func saveHabit(_ habits: [Habits]) {
        let fileName = "HabitList.json"
        storage.Save(habits, fileName)
    }
    
    func deleteHabit(_ id: Int) {
        //guard let id = habitData.id else {return}
        habits.remove(at: id)
        saveHabit(habits)
    }
}

