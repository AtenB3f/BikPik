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
    
    let mngHabit = HabitManager.mngHabit
    
    func updateData() {
        mngHabit.loadHabit()
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
        
        if taskList.count > 0 {
            for n in  0...(taskList.count-1) {
                taskName = taskList[n]
                if searchTask(selDate, taskName) {
                    selTaskList.append(taskName)
                }
            }
        }
        
        if mngHabit.habits.count > 0 {
            for n in 0...(mngHabit.habits.count-1) {
                taskName = mngHabit.habits[n].task.name!
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
        var inTodayArr: [String] = []
        var timeArr: [String : String] = [:]
        
        //checkSelDateHabit(sortArr: &sortArr)
        checkInToday(sortArr: &inTodayArr, deleteIdx: &deleteIdx)
        sortArr.append(contentsOf: inTodayArr.sorted(by: <))
        
        // delete "In Today" Task
        if deleteIdx.count > 0 {
            for n in 0...deleteIdx.count-1 {
                let idx = deleteIdx.count - n - 1
                tmpArr.remove(at: deleteIdx[idx])
            }
        }
        
        // time sort
        if tmpArr.count > 0 {
            for n in 0...(tmpArr.count-1) {
                let name = tmpArr[n]
                if let task = tasks[name] {
                    timeArr[name] = task.time
                } else if let id = mngHabit.habitId[name] {
                    let st:Int = Int(mngHabit.habits[id].start) ?? 0
                    let ed:Int = Int(mngHabit.habits[id].end) ?? 0
                    let sel:Int = Int(selDate) ?? 0
                    if (st <= sel) && (ed >= sel) {
                        timeArr[name] = mngHabit.habits[id].task.time
                    }
                }
            }
        }
        
        let sortTimeArr = timeArr.sorted{$0.1 < $1.1}
        
        if sortTimeArr.count > 0 {
            for n in 1...sortTimeArr.count {
                sortArr.append(sortTimeArr[n-1].key)
            }
        }
        
        selTaskList = sortArr
    }
    /*
    func checkSelDateHabit(sortArr: inout[String]){
        guard mngHabit.habits.count > 0 else { return }
        
        let cnt = mngHabit.habits.count - 1
        
        for n in 0 ... cnt {
            let sel: Int = Int(selDate) ?? 1
            let start: Int = Int(mngHabit.habits[n].start) ?? 2
            let end: Int = Int(mngHabit.habits[n].end) ?? 0
            
            guard (start <= sel) && (sel <= end) else { continue }
            
            for i in 0...6 {
                
                guard let day = Date.GetIntDayWeek(selDate) else { break }
                
                if (day - 1) == i {
                    if mngHabit.habits[n].days[i] == true {
                        let name = mngHabit.habits[n].task.name!
                        sortArr.append(name)
                    }
                }
            }
        }
    }
    */
    func checkInToday(sortArr: inout[String], deleteIdx: inout[Int]) {
        let cnt = selTaskList.count - 1
        var key: String
        if cnt >= 0 {
            // Seleted "in today"
            for n in 0 ... cnt {
                key = selTaskList[n]
                if tasks[key] != nil {
                    if tasks[key]?.inToday == true {
                        sortArr.append(selTaskList[n])
                        deleteIdx.append(n)
                    }
                } else if let id = mngHabit.habitId[key] {
                    if mngHabit.habits[id].task.inToday == true {
                        sortArr.append(selTaskList[n])
                        deleteIdx.append(n)
                    }
                }
            }
        }
    }
    
    func searchTask(_ date: String, _ taskName: String) -> Bool{
        if tasks[taskName]?.date == date{
            return true
        }
        
        if let id = mngHabit.habitId[taskName] {
            let habit = mngHabit.habits[id]
            
            let start = Int(habit.start) ?? 0
            let end = Int(habit.end) ?? 0
            let sel = Int(selDate) ?? 0
            if (start <= sel && sel <= end) {
                for i in 0...6 {
                    if habit.days[i] {
                        if (i+1) == Date.GetIntDayWeek(selDate) {
                            return true
                        }
                    }
                }
            }
        }
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
        taskList.append(key)
        
        saveTasks()
    }
    
    func reviseTask(before: Task, after: Task) {
        if before.name == nil { return }
        if after.name == nil { return }
        
        let beforeKey = before.name! + "_" + String(before.id)
        let afterKey = after.name! + "_" + String(after.id)
        
        if beforeKey != afterKey {
            tasks.removeValue(forKey: beforeKey)
            if (taskIdList[before.name!]! == 0) {
                taskIdList.removeValue(forKey: before.name!)
            } else {
                taskIdList[before.name!]! -= 1
            }
            if taskIdList[after.name!] != nil {
                taskIdList[after.name!]! += 1
            } else {
                taskIdList[after.name!] = 0
            }
            if taskList.count > 0 {
                for n in 0...(taskList.count-1) {
                    if taskList[n] == beforeKey {
                        taskList.remove(at: n)
                        break
                    }
                }
            }
            taskList.append(afterKey)
        }
        
        tasks[afterKey]  = after
        saveTasks()
    }
    
    func deleteTask(_ key: String) {
        if tasks[key] != nil {        // To Do Task
            let taskName = tasks[key]!.name!
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
        } else if let id = mngHabit.habitId[key] {           // Habit Task
            // 비활성화 처리 필요
            if let arrIdx = selTaskList.firstIndex(of: key) {
                selTaskList.remove(at: arrIdx)
            }
        }
    }
    
    func saveTasks () {
        saveTask(tasks)
        saveID(taskIdList)
        saveTaskList(taskList)
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
    
    func splitToName(key : String) -> String? {
        var idx: [Int]? = []
        var cnt = 0
        for i in key {
            cnt += 1
            if i == "_" {
                idx!.append(cnt)
            }
        }
        if idx?.count == 0 {
            return nil
        } else {
            if idx!.last! <= 0 { return nil }
            let nameIdx = key.index(key.startIndex, offsetBy: (idx!.last! - 1))
            let name: String = String(key[key.startIndex ..< nameIdx])
            print (name)
            
            return name
        }
        
    }
}
