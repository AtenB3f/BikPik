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
    
    init() {
        start = Date.FullNowDate()
        end = Date.FullNowDate()
    }
}

class HabitManager: ToDoManager {
    
    let disk: Storage = Storage.disk
    
    var habits: [Habits] = []
    var habitIdList: [String] = []
    func createHabit(_ habitData: Habits) {
        let fileName = "HabitList.json"
        disk.Save(habitData, fileName)
        
    }
    
    func loadHabit() {
        let fileName = "HabitList.json"
        habits = disk.Search(fileName, as: [Habits].self) ?? []
    }
}

