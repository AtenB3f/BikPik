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
    var notiUUID: String?
    var isDone : Bool = false
    var tag : String?
    var color : String?     //0xFFFFFF
    
    init(){ }
    init(_ str: String) {
        name = str
        date = Date.GetNowDate()
        inToday = true
    }
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
    var selDate: String = Date.GetNowDate()
    
    let mngHabit = HabitManager.mngHabit
    let mngNoti = Notifications.mngNotification
    /**
     	 Reloading To Do Table View
     */
    func updateData() {
        mngHabit.loadHabit()
        loadTaskList()
        loadTaskIdList()
        loadTask()
        loadSelTaskList()
        sortTimeline()
    }
    
    /**
     Search To Do ID.
     - parameter name : task name
     - returns : ID number
     */
    func searchId(name: String) -> Int {
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
    
    /**
     'taskLisk' array loading. "ToDoTaskList.json"file read.
     */
    func loadTaskList() {
        let file: String = "ToDoTaskList.json"
        taskList.removeAll()
        taskList = storage.Search(file, as: [String].self) ?? []
    }
    
    /**
     'tasks' dictionary loading. "ToDoLisk.json" file read.
     */
    func loadTask() {
        let taskFile: String = "ToDoList.json"
        
        tasks.removeAll()
        tasks = storage.Search(taskFile, as: [String: Task].self) ?? [:]
    }
    
    /**
     'taskIdList' dictionary loading. "ToDoIdList.json" file read.
     */
    func loadTaskIdList() {
        let file = "ToDoIdList.json"
        taskIdList.removeAll()
        taskIdList = storage.Search(file, as: [String:Int].self) ?? [:]
    }
    
    /**
     Habit data and To Do data are loaded into the 'selTaskList' array for the selected date.
     */
    func loadSelTaskList() {
        var taskName: String
        selTaskList.removeAll()
        
        if taskList.count > 0 {
            for n in  0...(taskList.count-1) {
                taskName = taskList[n]
                if searchTask(date: selDate, taskName: taskName) {
                    selTaskList.append(taskName)
                }
            }
        }
        
        if mngHabit.habits.count > 0 {
            for n in 0...(mngHabit.habits.count-1) {
                taskName = mngHabit.habits[n].task.name!
                if searchTask(date: selDate, taskName: taskName) {
                    selTaskList.append(taskName)
                }
            }
        }
        
    }

    /**
     Sort "selTaskLisk" array.
     "selTaskList" display in the To Do table. first, display In Today tasks. and and sorted array out to time.
     */
    func sortTimeline() {
        var tmpArr = selTaskList
        var sortArr: [String] = []
        var deleteIdx: [Int] = []
        var inTodayArr: [String] = []
        var timeArr: [String : String] = [:]
        
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
    
    /**
     If task is setting 'in today', need to sort array out to time. so this function find the tasks to delete in 'sortArr'.
     - parameter sortArr : raw array. task list of selected date.
     - parameter deleteIdx :An array of indices to delete from "sortArr".
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
    
    /**
     Search task in the Habit list and the To Do list.
     - parameter date :format is yyyyMMdd. ex) 20210928
     - parameter taskName : If the task is a habit, the form is the habit name. However, if the task is To Do, the format is "task name" + "_"+"ID".
                            ex) study_01
     - returns : If find the task in the list, return true. didn't find task, return false.
     */
    func searchTask (date: String, taskName: String) -> Bool{
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
                        if (i+1) == Date.GetIntDayWeek(date: selDate) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    /**
     Create task and save the task list.
     - parameter data : 'Task' struct data.
     */
    func createTask(data : Task) {
        var task:Task = data
        var key: String = ""
        var id :Int = 0
        
        if task.name == "" || task.name == nil { return }
        
        key = task.name!
        
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
        tasks[key] = task
        taskList.append(key)
        
        saveTasks()
    }
    
    /**
     Correct the task. correct data and save 'tasks'  array.
     - parameter before : the 'Task' data before modification.
     - parameter after : the 'Task' data after correction.
     */
    func correctTask(before: Task, after: Task) {
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
    
    /**
     Delete task in 'tasks' list.
     - parameter key :If the task is a habit, the form is the habit name. However, if the task is To Do, the format is "task name" + "_"+"ID".
                        ex) study_01
     */
    func deleteTask(key: String) {
        guard let data = tasks[key] else { return }
        
        let taskName = data.name!
        
        if data.alram == true {
            mngNoti.removeNotificationTask(task: data)
        }
        
        // tasks
        tasks.removeValue(forKey: key)
        saveTask(data: tasks)
        
        // taskIdList
        if let id = taskIdList[taskName] {
            if id > 0 {
                taskIdList[taskName] = taskIdList[taskName]! - 1
            } else {
                taskIdList.removeValue(forKey: taskName)
            }
            saveID(data: taskIdList)
        }
        
        // taskList
        if let arrIdx = taskList.firstIndex(of: key) {
            taskList.remove(at: arrIdx)
            saveTaskList(data: taskList)
        }
        
        // selTaskList
        if let arrIdx = selTaskList.firstIndex(of: key) {
            selTaskList.remove(at: arrIdx)
        }
        
        tasks.removeValue(forKey: key)
    }
    
    /**
     Save tasks, task list, task ID list.
     */
    func saveTasks () {
        saveTask(data: tasks)
        saveID(data: taskIdList)
        saveTaskList(data: taskList)
    }
    
    /**
     Save Tasks.
     - parameter data : This parameter is dictionary data. The key format is "task name"+"_"+"ID", and the value consists of a "Task" structure.
     */
    func saveTask (data: [String:Task]) {
        storage.Save(data, "ToDoList.json")
    }
    
    /**
     Save Tasks.
     - parameter data : This parameter is dictionary data. The key format is "task name", and the value is number of task name.
     */
    func saveID (data: [String:Int]) {
        storage.Save(data, "ToDoIdList.json")
    }
    
    /**
     Save Tasks.
     - parameter data : This parameter is String array type. It is an array that shows which task names are stored.
     */
    func saveTaskList (data: [String]) {
        storage.Save(data, "ToDoTaskList.json")
    }
    
    /**
     key format of "tasks" dictionary is "task name"+"_"+"ID", If you need only task name, use this function.
     - parameter key : "task name" + "_" + "ID" format
     - returns : If sucessed split to name, return string data.
     */
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
    
    func setToday() {
        selDate = Date.GetNowDate()
    }
}
