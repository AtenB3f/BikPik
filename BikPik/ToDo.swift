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
    
    let dataMng = DataManager.dataMng
    
    var storage = Storage.disk
    
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
        dataMng.taskIdList = storage.Search(idFile, as: [String: Int].self) ?? [:]
        if (dataMng.taskIdList[name] != nil) {
            // Start ID to 0, so number of ID is plus one.
            num = dataMng.taskIdList[name]! + 1
        } else {
            num = 0
        }
        
        return num
    }
    
    func loadTaskList() {
        let file: String = "ToDoTaskList.json"
        dataMng.taskList.removeAll()
        dataMng.taskList = storage.Search(file, as: [String].self) ?? []
    }
    
    /*
     [Load Task]
     This function loading the list of tasks for that day.
     date : "yyyyMMdd" Format   (ex)20200706
     list : String Array
     */
    func loadTask() {
        let taskFile: String = "ToDoList.json"
        
        dataMng.tasks.removeAll()
        dataMng.tasks = storage.Search(taskFile, as: [String: Task].self) ?? [:]
    }
    
    func loadTaskIdList() {
        let file = "ToDoIdList.json"
        dataMng.taskIdList.removeAll()
        dataMng.taskIdList = storage.Search(file, as: [String:Int].self) ?? [:]
    }
    
    func loadSelTaskList() {
        var taskName: String
        dataMng.selTaskList.removeAll()
        
        let numTask = dataMng.taskList.count - 1
        if numTask >= 0 {
            for n in  0 ... numTask {
                taskName = dataMng.taskList[n]
                print("TASK NAME :: \(taskName)")
                
                if searchTask(dataMng.selDate, taskName) {
                    dataMng.selTaskList.append(taskName)
                }
            }
        }
    }

    func sortTimeline() {
        var tmpArr = dataMng.selTaskList
        var sortArr: [String] = []
        var deleteIdx: [Int] = []
        var cnt = 0
        var key: String
        
        cnt = dataMng.selTaskList.count - 1
        if cnt >= 0 {
            // Seleted "in today"
            for n in 0 ... cnt {
                key = dataMng.selTaskList[n]
                if dataMng.tasks[key]?.inToday == true {
                    sortArr.append(dataMng.selTaskList[n])
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
        dataMng.selTaskList = sortArr
    }
    
    func searchTask(_ date: String, _ taskName: String) -> Bool{
        /*
        var intStart: Int
        var intEnd: Int
        let intDate: Int = Int(date) ?? 0
        */
        
        if dataMng.tasks[taskName]?.date == date{
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
        if dataMng.taskIdList[key] == nil {
            id = 0
            dataMng.taskIdList[key] = 0
        } else {
            dataMng.taskIdList[key]! += 1
            id = dataMng.taskIdList[key]!
        }
        
        // KEY protocol is "NAME + ID"
        key = key + "_" + String(id)
        dataMng.tasks[key] = data
        
        // save task
        saveTask(dataMng.tasks)
        saveID(dataMng.taskIdList)
        
        //taskList.append(data.name)
        dataMng.taskList.append(key)
        saveTaskList(dataMng.taskList)
    }
    
    func deleteTask(_ key: String) {
        guard let taskName = dataMng.tasks[key]!.name else {return}
        
        // tasks
        if dataMng.tasks[key] != nil {
            dataMng.tasks.removeValue(forKey: key)
            saveTask(dataMng.tasks)
        }
        
        // taskIdList
        if let id = dataMng.taskIdList[taskName] {
            if id > 0 {
                dataMng.taskIdList[taskName] = dataMng.taskIdList[taskName]! - 1
            } else {
                dataMng.taskIdList.removeValue(forKey: taskName)
            }
            saveID(dataMng.taskIdList)
        }
        
        // taskList
        if let arrIdx = dataMng.taskList.firstIndex(of: key) {
            dataMng.taskList.remove(at: arrIdx)
            saveTaskList(dataMng.taskList)
        }
        
        // selTaskList
        if let arrIdx = dataMng.selTaskList.firstIndex(of: key) {
            dataMng.selTaskList.remove(at: arrIdx)
        }
        
        dataMng.tasks.removeValue(forKey: key)
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
