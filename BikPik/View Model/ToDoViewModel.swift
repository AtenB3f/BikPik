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
    //var taskIdList: [String : Int] = [:]    // KEY is [task name] , VALUE is [ID]
    var selTaskList = Observable(Array<String>())
    var selDate = Observable(Date.GetNowDate())
    
    let storage = Storage.disk
    static let mngToDo = ToDoManager()
    let mngHabit = HabitManager.mngHabit
    let mngNoti = Notifications.mngNotification
    let mngFirebase = Firebase.mngFirebase
    
    private init() {
        mngFirebase.updateTask(handleSaveTask: saveServerTask)
    }
    
    /**
          Reloading To Do Table View
     */
    func updateData() {
        mngHabit.loadHabit()
        loadTask()
        loadSelTaskList()
        sortTimeline()
    }
    
    func saveServerTask(uuid: String, task: Task) {
        if tasks[uuid] == nil {
            // create
            self.tasks[uuid] = task
            self.saveTasks()
        } else {
            // correct
            self.correctTask(uuid: uuid, after: task)
        }
        
        self.updateData()
    }
    
    func changeSelectDate(date:String) {
        selDate.value = date
    }
    
    func changeSelectDate(index : Int) {
        selDate.value = Date.GetNextDay(date: selDate.value, fewDays: index)
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
        
        for (uuid,habit) in mngHabit.habits {
            if habit.isDone?[date] != nil {
                arr.append(uuid)
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
            if mngHabit.habits.keys.contains(tmp) {
                task = mngHabit.habits[tmp]!.task
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
     Create task and save the task list.
     - parameter data : 'Task' struct data.
     */
    func createTask(data : Task) {
        if data.name == "" { return }
        
        let uuid = UUID().uuidString
        tasks[uuid] = data
        if data.date == selDate.value {
            selTaskList.value.append(uuid)
        }
        
        mngFirebase.uploadTask(uuid: uuid, task: data)
        saveTasks()
    }
    
    /**
     Correct the task. correct data and save 'tasks'  array.
     - parameter before : the 'Task' data before modification.
     - parameter after : the 'Task' data after correction.
     */
    func correctTask(uuid: String, after: Task) {
        guard let before = tasks[uuid] else { return }
        if after.name == "" { return }
        
        tasks[uuid]  = after
        
        if before.date != after.date {
            if after.date == selDate.value {
                selTaskList.value.append(uuid)
            } else if before.date == selDate.value {
                if let idx = selTaskList.value.firstIndex(of: uuid) {
                    selTaskList.value.remove(at: idx)
                }
            }
        }
        
        mngFirebase.correctTask(uuid: uuid, task: after)
        saveTasks()
    }
    
    /**
     Delete task in 'tasks' list.
     - parameter key :If the task is a habit, the form is the habit name. However, if the task is To Do, the format is "task name" + "_"+"ID".
                        ex) study_01
     */
    func deleteTask(uuid: String) {
        guard let data = tasks[uuid] else { return }
        
        if data.alram == true {
            mngNoti.removeNotificationTask(uuid: uuid)
        }
        
        // tasks
        tasks.removeValue(forKey: uuid)
        saveTask(data: tasks)
        
        // selTaskList
        if let arrIdx = selTaskList.value.firstIndex(of: uuid) {
            selTaskList.value.remove(at: arrIdx)
        }
        
        tasks.removeValue(forKey: uuid)
        mngFirebase.removeTask(uuid: uuid)
    }
    
    /**
     Save tasks, task list, task ID list.
     */
    func saveTasks () {
        saveTask(data: tasks)
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
    
    func setToday() {
        changeSelectDate(date: Date.GetNowDate())
    }
}

