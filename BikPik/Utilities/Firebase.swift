//
//  Firebase.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/13.
//

//import Foundation
import Firebase
import GoogleSignIn


class Firebase {
    
    static let mngFirebase = Firebase()
    private init() { }
    
    var ref: DatabaseReference! = Database.database().reference()
    
    func uploadTask(task: Task) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let taskRef = self.ref.child("test/users/\(uid)/tasks/\(task.date)/\(task.name!)_\(task.id)")
        
        setRefTask(task: task, ref: taskRef)
    }
    
    private func setRefTask(task: Task, ref: DatabaseReference) {
        ref.child("time").setValue(task.time)
        ref.child("alram").setValue(task.alram)
        ref.child("inToday").setValue(task.inToday)
        ref.child("isDone").setValue(task.isDone)
        if task.tag != nil {
            ref.child("tag").setValue(task.tag)
        }
        if task.color != nil {
            ref.child("color").setValue(task.color)
        }
    }
    
    func uploadHabit(habit: Habits) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let habitRef = self.ref.child("test/users/\(uid)/haibts/\(habit.task.name!)")
        
        habitRef.child("start").setValue(habit.start)
        habitRef.child("end").setValue(habit.end)
        habitRef.child("days").setValue(habit.days)
        if habit.isDone != nil {
            habitRef.child("isDone").setValue(habit.isDone)
        }
        
        setRefTask(task: habit.task, ref: habitRef)
    }
    
}
