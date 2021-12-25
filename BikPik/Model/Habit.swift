//
//  Habit.swift
//  BikPik
//
//  Created by jihee moon on 2021/09/01.
//

struct Habits: Codable, Equatable {
    var id: Int?
    var task: Task = Task()
    var start : String
    var end : String
    var days : [Bool] = [Bool](repeating: true, count: 7)
    var total = 0
    var isDone : [Bool]?
    
    init(date:String) {
        self.start = date//Date.GetNowDate()
        self.end = date//Date.GetNowDate()
    }
}
