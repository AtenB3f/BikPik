//
//  ToDo.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/14.
//

import UIKit

struct Task: Codable, Equatable{
    var id : Int = 0
    var name : String? = nil
    var inToday : Bool = false
    var date : String = ""
    var time : String = "00:00"
    var alram : Bool = false
    var isDone : Bool = false
    var project : String?
    var color : String?
}

struct Habit: Codable, Equatable {
    var task: Task = Task()
    var start : String
    var end : String
    var days : [Bool] = [Bool](repeating: false, count: 7)
}

/*
 [Save File]
 1. "ToDoIdList.json"
 2. "ToDoList.json"
 3. "ToDoTaskList.json"
 
 [File detail]
 1. "ToDoIdList.json"
 This File stores a ID list. It manage that identify for same name tasks.
 When a task with the same name is created, the ID of the task is incremented.
 ex) If you created "Study" task again. "Study" task exist two, so  "Study" ID is 1. (ID is start from 0.)
 
 
 2. "ToDoList.json"
 This file is saving To Do Task that dictionary format - [String: Task]
 Key format is "Task Name" + "_" + "ID number"
 ex) Study_0, Study_1
 
 3. "ToDoTaskList.json"
 This file is saving To Do Task Array(taskList).
 
 
 */
class ToDoManager {
    
    var tasks: [String: Task] = [:]     // KEY is [task name + "_" + ID]
    var idList: [String : Int] = [:]    // KEY is [task name] , VALUE is [ID]
    var taskList: [String] = []         // VALUE is [task name]
    
    var storage = Storage.disk
    
    static let managerToDo: ToDoManager = ToDoManager()
    private init() {
        loadTaskList()
    }

    // return number of ID
    func loadId(_ name: String) -> Int {
        var num: Int = 0
        let idFile: String = "ToDoIdList.json"
        idList = storage.Search(idFile, as: [String: Int].self) ?? [:]
        if (idList[name] != nil) {
            // Start ID to 0, so number of ID is plus one.
            num = idList[name]! + 1
        } else {
            num = 0
        }
        
        return num
    }
    
    func loadTaskList() {
        let file: String = "ToDoTaskList.json"
        taskList = storage.Search(file, as: [String].self) ?? []
    }
    
    /*
     [Load Task]
     This function loading the list of tasks for that day.
     date : "yyyyMMdd" Format   (ex)20200706
     list : String Array
     */
    func loadTask(_ date: String, _ list : inout [String]){
        let taskFile: String = "ToDoList.json"
        var taskName: String
        
        // Clear Array
        list.removeAll()
        
        tasks = storage.Search(taskFile, as: [String: Task].self) ?? [:]
        
        let numTask = taskList.count - 1
        if numTask >= 0 {
            for n in  0 ... numTask {
                taskName = taskList[n]
                print("TASK NAME :: \(taskName)")
                
                if searchTask(date, taskName) {
                    list.append(taskName)
                }
            }
        }
        
        sortTimeline(&list)
    }
    
    func sortTimeline(_ taskArr: inout [String]) {
        var tmpArr = taskArr
        var sortArr: [String] = []
        var deleteIdx: [Int] = []
        var cnt = 0
        var key: String
        
        cnt = taskArr.count - 1
        if cnt >= 0 {
            // Seleted "in today"
            for n in 0 ... cnt {
                key = taskArr[n]
                if tasks[key]?.inToday == true {
                    sortArr.append(taskArr[n])
                    deleteIdx.append(n)
                }
            }
        }
        
        // delete "In Today" Task
        cnt = deleteIdx.count - 1
        if cnt >= 0 {
            for n in 0 ... cnt {
                let idx = cnt - n
                tmpArr.remove(at: deleteIdx[idx])
            }
        }
        
        // Time Line
        sortArr.append(contentsOf: tmpArr.sorted(by: <))
        taskArr = sortArr
    }
    
    func searchTask(_ date: String, _ taskName: String) -> Bool{
        /*
        var intStart: Int
        var intEnd: Int
        let intDate: Int = Int(date) ?? 0
        */
        
        if tasks[taskName]?.date == date{
            return true
        }
        
        /*
        if tasks[taskName]?.habit == false {
            return false
        }
        if let start = tasks[taskName]?.start {intStart = Int(start) ?? 0} else {return false}
        if let end = tasks[taskName]?.start {intEnd = Int(end) ?? 0} else {return false}
        
        
        if intStart <= intDate || intDate <= intEnd {
            return true
        }
        */
        return false
    }
    
    func createTask(_ data : inout Task) {
        var key: String = ""
        var id :Int = 0
        key = data.name!
        
        // Find same named Task
        if idList[key] == nil {
            id = 0
            idList[key] = 0
        } else {
            idList[key]! += 1
            id = idList[key]!
        }
        
        // KEY protocol is "NAME + ID"
        key = key + "_" + String(id)
        tasks[key] = data
        
        // save task
        saveTask(tasks)
        saveID(idList)
        
        //taskList.append(data.name)
        taskList.append(key)
        saveTaskList(taskList)
    }
    
    func deleteTask(_ date : String, _ key: String) {
        guard let taskName = tasks[key]!.name else {return}
        
        if tasks[key] != nil {
            tasks.removeValue(forKey: key)
            saveTask(tasks)
        }
        
        if let id = idList[taskName] {
            if id > 0 {
                idList[taskName] = idList[taskName]! - 1
            } else {
                idList.removeValue(forKey: taskName)
            }
            saveID(idList)
        }
        
        if let arrIdx = taskList.firstIndex(of: key) {
            taskList.remove(at: arrIdx)
            saveTaskList(taskList)
        }
        
        tasks.removeValue(forKey: key)
    }
    
    func saveTask (_ data: [String:Task]) {
        storage.Save(data, "ToDoList.json")
    }
    func saveID (_ list: [String:Int]) {
        storage.Save(list, "ToDoIdList.json")
    }
    func saveTaskList (_ arr: [String]) {
        storage.Save(arr, "ToDoTaskList.json")
    }
    
    
}
