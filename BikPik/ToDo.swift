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
    let storage = Storage.disk
    static let mngToDo = ToDoManager()
    private init() {
        updateData()
    }
    
    var tasks: [String: Task] = [:]         // KEY is [task name + "_" + ID]
    var taskIdList: [String : Int] = [:]    // KEY is [task name] , VALUE is [ID]
    var taskList: [String] = []             // VALUE is [task name]
    var selTaskList : [String] = []
    var selDate: String = Date.FullNowDate()
    
    
    func updateData() {
        loadTaskList()
        loadTaskIdList()
        loadTask()
        loadSelTaskList()
        sortTimeline()
    }

    // return number of ID
    func searchId(_ name: String) -> Int {
        var num: Int = 0
        let idFile: String = "ToDoIdList.json"
        taskIdList = storage.Search(idFile, as: [String: Int].self) ?? [:]
        if (taskIdList[name] != nil) {
            // Start ID to 0, so number of ID is plus one.
            num = taskIdList[name]! + 1
        } else {
            num = 0
        }
        
        return num
    }
    
    func loadTaskList() {
        let file: String = "ToDoTaskList.json"
        taskList.removeAll()
        taskList = storage.Search(file, as: [String].self) ?? []
    }
    
    /*
     [Load Task]
     This function loading the list of tasks for that day.
     date : "yyyyMMdd" Format   (ex)20200706
     list : String Array
     */
    func loadTask() {
        let taskFile: String = "ToDoList.json"
        
        tasks.removeAll()
        tasks = storage.Search(taskFile, as: [String: Task].self) ?? [:]
    }
    
    func loadTaskIdList() {
        let file = "ToDoIdList.json"
        taskIdList.removeAll()
        taskIdList = storage.Search(file, as: [String:Int].self) ?? [:]
    }
    
    func loadSelTaskList() {
        var taskName: String
        selTaskList.removeAll()
        
        let numTask = taskList.count - 1
        if numTask >= 0 {
            for n in  0 ... numTask {
                taskName = taskList[n]
                print("TASK NAME :: \(taskName)")
                
                if searchTask(selDate, taskName) {
                    selTaskList.append(taskName)
                }
            }
        }
    }

    func sortTimeline() {
        var tmpArr = selTaskList
        var sortArr: [String] = []
        var deleteIdx: [Int] = []
        var cnt = 0
        var key: String
        
        cnt = selTaskList.count - 1
        if cnt >= 0 {
            // Seleted "in today"
            for n in 0 ... cnt {
                key = selTaskList[n]
                if tasks[key]?.inToday == true {
                    sortArr.append(selTaskList[n])
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
        selTaskList = sortArr
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
        if taskIdList[key] == nil {
            id = 0
            taskIdList[key] = 0
        } else {
            taskIdList[key]! += 1
            id = taskIdList[key]!
        }
        
        // KEY protocol is "NAME + ID"
        key = key + "_" + String(id)
        tasks[key] = data
        
        // save task
        saveTask(tasks)
        saveID(taskIdList)
        
        //taskList.append(data.name)
        taskList.append(key)
        saveTaskList(taskList)
    }
    
    func deleteTask(_ key: String) {
        guard let taskName = tasks[key]!.name else {return}
        
        // tasks
        if tasks[key] != nil {
            tasks.removeValue(forKey: key)
            saveTask(tasks)
        }
        
        // taskIdList
        if let id = taskIdList[taskName] {
            if id > 0 {
                taskIdList[taskName] = taskIdList[taskName]! - 1
            } else {
                taskIdList.removeValue(forKey: taskName)
            }
            saveID(taskIdList)
        }
        
        // taskList
        if let arrIdx = taskList.firstIndex(of: key) {
            taskList.remove(at: arrIdx)
            saveTaskList(taskList)
        }
        
        // selTaskList
        if let arrIdx = selTaskList.firstIndex(of: key) {
            selTaskList.remove(at: arrIdx)
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
