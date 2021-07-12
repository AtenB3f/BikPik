//
//  ToDoViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/05.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var taskList: [String] = []
    var selDate: String = Date.FullNowDate()
    let mngToDo : ToDoManager = ToDoManager.managerToDo
    
    @IBOutlet weak var Day: UILabel!
    @objc func timerProc(){
        Day.text = Date.UserNowDate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Today Date Change
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerProc), userInfo: nil, repeats: true)
        timerProc()
        
        mngToDo.LoadTask(Date.FullNowDate(), &taskList)
        sortTimeline(&taskList)
    }
    

    @IBAction func btnMenu(_ sender: Any) {
        
    }  
    
    @IBOutlet weak var btnAddTask: UIButton!
    @IBAction func btnAddTask(_ sender: Any) {
        // Present Add To Do VC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoVC") as! AddToDoViewController
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var ToDoTable: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt: Int = taskList.count
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ToDoCell {
            let taskId = taskList[indexPath.row]
            
            //cell.textLabel!.text = text
            cell.task.text = mngToDo.tasks[taskId]?.name
            cell.time.text = displayTime(taskId)
            
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func displayTime(_ taskId: String) -> String{
        var time: String?
        
        if mngToDo.tasks[taskId]?.inToday == true {
            time = ""
        } else {
            time = mngToDo.tasks[taskId]?.time
        }
        
        return time!
    }
    
    func sortTimeline(_ taskArr: inout [String]) {
        var tmpArr = taskArr
        var sortArr: [String] = []
        let cnt = taskArr.count - 1
        var key: String
        
        // Seleted "in today"
        for n in 0 ... cnt {
            key = taskArr[n]
            if mngToDo.tasks[key]?.inToday == true {
                sortArr.append(taskArr[n])
                tmpArr.remove(at: n)
            }
        }
        
        // Time Line
        sortArr.append(contentsOf: tmpArr.sorted(by: <))
        taskArr = sortArr
    }
}

class ToDoCell: UITableViewCell {
 
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var isDone: UIButton!
    @IBOutlet weak var task: UILabel!
    
    @IBAction func isDone(_ sender: Any) {
        
    }
}

