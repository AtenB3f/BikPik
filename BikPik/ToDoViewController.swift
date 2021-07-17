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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPostCommentNotification(_:)), name: AddToDoVC, object: nil)
        
    }
    
    // 태스크 추가 후에 테이블 뷰 적용될 수 있게 하는 기능
    @objc func didDismissPostCommentNotification(_ noti: Notification) {
        self.mngToDo.LoadTask(Date.FullNowDate(), &self.taskList)
            OperationQueue.main.addOperation {
                self.ToDoTable.reloadData()
            }
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ToDoCell {
            let taskID = taskList[indexPath.row]
            
            cell.task.text = mngToDo.tasks[taskID]?.name
            cell.displayTask(mngToDo.tasks[taskID]!.isDone)
            cell.time.text = displayTime(taskID)
            cell.isDone.tag = indexPath.row
            cell.isDone.addTarget(self, action: #selector(clickIsDone(_:)), for: .touchUpInside)
            
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    /*
     [clickIsDone]
     테이블 뷰의 셀의 버튼을 클릭했을 때 버튼의 상태(완성/미완성)을 태스크 리스트에 적용하고 데이터를 저장하는 메소드
     ToDoCell 클래스의 isDone 함수에서는 버튼의 상태에 따라 아이콘과 라벨 스타일이 바뀌는 작업을 한다.
     */
    @objc func clickIsDone (_ sender: UIButton) {
        
        // Do not Toggle "sender.isSeleted". because it toggled in "isDone" function.
        
        let id = sender.tag
        let str: String = taskList[id]
        mngToDo.tasks[str]?.isDone = sender.isSelected
        
        //save data
        mngToDo.saveTask(mngToDo.tasks)
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
}

class ToDoCell: UITableViewCell {

    let mngToDo : ToDoManager = ToDoManager.managerToDo
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var isDone: UIButton!
    @IBOutlet weak var task: UILabel!
    
    /*
     [isDone]
    버튼 선택(완료/미완료)에 따라 아이콘과 텍스트 스타일 변경하는 메소드
     */
    @IBAction func isDone(_ sender: Any) {
        isDone.isSelected.toggle()
        
        isDone.tintColor = .red
        if isDone.isSelected {
            let img = UIImage(named: "CheckBox_fill.png")
            self.isDone.setImage(img, for: .normal)
            displayTask(true)
        } else {
            let img = UIImage(named: "CheckBox.png")
            self.isDone.setImage(img, for: .normal)
            displayTask(false)
        }
    }
    
    func displayTask(_ isDone: Bool) {
        
        if isDone == true {
            let attr = NSAttributedString(
                string: self.task.text! ,
                attributes: [
                    NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue
                ])
            task.attributedText = attr
        } else {
            let attr = NSAttributedString(
                string: self.task.text! ,
                attributes: [
                    NSAttributedString.Key.ligature : NSUnderlineStyle.single.rawValue
                ])
            task.attributedText = attr
        }
    }
}

