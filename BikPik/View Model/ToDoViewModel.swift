//
//  ToDoViewModel.swift
//  BikPik
//
//  Created by jihee moon on 2021/12/23.
//

import UIKit

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
    var tasks: [String: Task] = [:]         // KEY is [task name + "_" + ID]
    var taskIdList: [String : Int] = [:]    // KEY is [task name] , VALUE is [ID]
    var selTaskList = Observable(Array<String>())
    var selDate = Observable(Date.GetNowDate())
    
    let storage = Storage.disk
    static let mngToDo = ToDoManager()
    let mngHabit = HabitManager.mngHabit
    let mngNoti = Notifications.mngNotification
    let mngFirebase = Firebase.mngFirebase
    
    private init() { }
    
    /**
          Reloading To Do Table View
     */
    func updateData() {
        mngHabit.loadHabit()
        loadTaskIdList()
        loadTask()
        loadSelTaskList()
        sortTimeline()
    }
    
    func changeSelectDate(date:String) {
        selDate.value = date
    }
    
    func changeSelectDate(index : Int) {
        selDate.value = Date.GetNextDay(date: selDate.value, fewDays: index)
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
        var arr = [String]()
        let date = selDate.value
        for (key, val) in tasks {
            if val.date == date {
                arr.append(key)
            }
        }
        for habit in mngHabit.habits {
            if habit.isDone?[date] != nil {
                arr.append(habit.task.name)
            }
        }
        selTaskList.value = arr
    }

    /**
     Sort "selTaskLisk" array.
     "selTaskList" display in the To Do table. first, display In Today tasks. and and sorted array out to time.
     */
    func sortTimeline() {
        var sortArr: [String] = []
        var inTodayArr: [String] = []
        var timeArr: [String : String] = [:]
        var task = Task()
        
        for tmp in selTaskList.value {
            if let id = mngHabit.habitId[tmp] {
                task = mngHabit.habits[id].task
            } else if tasks.keys.contains(tmp) {
                task = tasks[tmp]!
            }
            if task.inToday {
                inTodayArr.append(tmp)
            } else {
                timeArr[task.time] = tmp
            }
        }
        
        sortArr = inTodayArr.sorted()
        for key in timeArr.keys.sorted() {
            if let task = timeArr[key] {
                sortArr.append(task)
            }
        }
        
        selTaskList.value = sortArr
        
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
            
            if mngHabit.habits.count <= id {
                return false
            }
            
            let habit = mngHabit.habits[id]
            
            let start = Int(habit.start) ?? 0
            let end = Int(habit.end) ?? 0
            let sel = Int(selDate.value) ?? 0
            if (start <= sel && sel <= end) {
                for i in 0...6 {
                    if habit.days[i] {
                        if (i+1) == Date.WeekForm(data: selDate.value, input: .fullDate, output: .intIndex) as! Int {
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
        if data.name == "" { return }
        
        let task = data
        var id = 0
        
        // Find same named Task
        if taskIdList[task.name] == nil {
            taskIdList[task.name] = 0
        } else {
            taskIdList[task.name]! += 1
            id = taskIdList[task.name]!
        }
        
        // KEY protocol is "NAME + ID"
        let key = task.name + "_" + String(id)
        tasks[key] = task
        if data.date == selDate.value {
            selTaskList.value.append(key)
        }
        
        mngFirebase.uploadTask(task: task)
        
        saveTasks()
    }
    
    /**
     Correct the task. correct data and save 'tasks'  array.
     - parameter before : the 'Task' data before modification.
     - parameter after : the 'Task' data after correction.
     */
    func correctTask(before: Task, after: Task) {
        if before.name == "" || after.name == "" { return }
        
        let beforeKey = before.name + "_" + String(before.id)
        let afterKey = after.name + "_" + String(after.id)
        
        if beforeKey != afterKey {
            tasks.removeValue(forKey: beforeKey)
            if (taskIdList[before.name]! == 0) {
                taskIdList.removeValue(forKey: before.name)
            } else {
                taskIdList[before.name]! -= 1
            }
            if taskIdList[after.name] != nil {
                taskIdList[after.name]! += 1
            } else {
                taskIdList[after.name] = 0
            }
        }
        
        tasks[afterKey]  = after
        
        if before.date != after.date {
            if after.date == selDate.value {
                selTaskList.value.append(afterKey)
            } else if before.date == selDate.value {
                for (idx, val) in selTaskList.value.enumerated() {
                    if beforeKey == val {
                        selTaskList.value.remove(at: idx)
                        break
                    }
                }
            }
        }
        saveTasks()
    }
    
    /**
     Delete task in 'tasks' list.
     - parameter key :If the task is a habit, the form is the habit name. However, if the task is To Do, the format is "task name" + "_"+"ID".
                        ex) study_01
     */
    func deleteTask(key: String) {
        guard let data = tasks[key] else { return }
        
        let name = data.name
        
        if data.alram == true {
            mngNoti.removeNotificationTask(task: data)
        }
        
        // tasks
        tasks.removeValue(forKey: key)
        saveTask(data: tasks)
        
        // taskIdList
        if let id = taskIdList[name] {
            if id > 0 {
                taskIdList[name] = taskIdList[name]! - 1
            } else {
                taskIdList.removeValue(forKey: name)
            }
            saveID(data: taskIdList)
        }
        
        // selTaskList
        if let arrIdx = selTaskList.value.firstIndex(of: key) {
            selTaskList.value.remove(at: arrIdx)
        }
        
        tasks.removeValue(forKey: key)
    }
    
    /**
     Save tasks, task list, task ID list.
     */
    func saveTasks () {
        saveTask(data: tasks)
        saveID(data: taskIdList)
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
        changeSelectDate(date: Date.GetNowDate())
    }
}

