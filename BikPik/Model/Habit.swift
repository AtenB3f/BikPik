//
//  Habit.swift
//  BikPik
//
//  Created by jihee moon on 2021/09/01.
//

struct Habits: Codable, Equatable {
    var task: Task = Task()
    var start : String
    var end : String
    var days : [Bool] = [Bool](repeating: true, count: 7)
    var total = 0
    var isDone : [String:Bool]?
    var percent : Int = 0
    
    init(date:String) {
        self.start = date
        self.end = date
    }
}
