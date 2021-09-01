//
//  Habit.swift
//  BikPik
//
//  Created by jihee moon on 2021/09/01.
//

import UIKit

struct Habits: Codable, Equatable {
    var task: Task = Task()
    var start : String
    var end : String
    var days : [Bool] = [Bool](repeating: false, count: 7)
}

class HabitManager: ToDoManager {
    
}

