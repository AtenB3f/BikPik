//
//  Firebase.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/13.
//

//import Foundation
import Firebase
import GoogleSignIn
import FirebaseDatabase


class Firebase {
    
    static let mngFirebase = Firebase()
    private init() { }
    
    
    let ref: DatabaseReference! = Database.database().reference()
    
    func uploadTask(uuid: String ,task: Task) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let taskRef = self.ref.child("test/users/\(uid)/tasks/\(uuid)")
        setRefTask(task: task, ref: taskRef)
    }
    
    private func setRefTask(task: Task, ref: DatabaseReference) {
        var data:[String:Any] = [
                    "name" : task.name,
                    "date" : task.date,
                    "time" : task.time,
                    "alram" : task.alram,
                    "inToday" : task.inToday,
                    "isDone" : task.isDone,
        ]
        if let tag = task.tag {
            data["tag"] = tag
        }
        if let color = task.color {
            data["color"] = color
        }
        
        ref.setValue(data)
    }
    
    func uploadHabit(habit: Habits) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let habitRef = self.ref.child("test/users/\(uid)/haibts/\(habit.task.name)")
        
        habitRef.child("start").setValue(habit.start)
        habitRef.child("end").setValue(habit.end)
        habitRef.child("days").setValue(habit.days)
        if habit.isDone != nil {
            habitRef.child("isDone").setValue(habit.isDone)
        }
        
        setRefTask(task: habit.task, ref: habitRef)
    }
    
    
    
    func updateTask(saveTask: (_ task: Task)->()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var ret: Task?
        
        self.ref.child("test/users/\(uid)/tasks/").observe(.childChanged, with: { [self] snapshot in
            let value = snapshot.value as! [String:Any]
            ret = handleUpdateTask(value)
        }) { error in
            print(error.localizedDescription)
        }
        
        if ret != nil {
            saveTask(ret!)
        }
    }
    
    private func handleUpdateTask(_ value :[String:Any]) -> Task {
        var task = Task()
        for v in value.keys {
            switch v {
            case "name":
                task.name = value[v] as! String
            case "alram":
                task.alram = value[v] as! Bool
            case "date":
                task.date = value[v] as! String
            case "inToday":
                task.inToday = value[v] as! Bool
            case "isDone":
                task.isDone = value[v] as! Bool
            case "time":
                task.time = value[v] as! String
            case "tag":
                task.tag = value[v] as? String
            case "color":
                task.color = value[v] as? String
            default:
                print("Error :: handleUpdateTask() ")
            }
        }
        return task
    }
}
