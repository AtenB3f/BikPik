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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // Timer 설정
        // Today Date Change
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerProc), userInfo: nil, repeats: true)
        timerProc()
         */
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPostCommentNotification(_:)), name: AddToDoVC, object: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell))
        ToDoTable.addGestureRecognizer(longPress)
        
        setLayout()
        
        updateDate()
        updateWeekDate()
        btnWeekDate(Date.GetIntDayWeek(selDate) ?? 0)
        
        mngToDo.loadTask(selDate, &taskList)

    }
    
    // 태스크 추가 후에 테이블 뷰 적용될 수 있게 하는 기능
    @objc func didDismissPostCommentNotification(_ noti: Notification) {
        self.mngToDo.loadTask(Date.FullNowDate(), &self.taskList)
        OperationQueue.main.addOperation {
            self.ToDoTable.reloadData()
        }
    }
    
    @objc func timerProc(){
        updateDate()
    }
    
    func updateDate() {
        btnDay.setTitle(Date.GetUserDateForm(), for: .normal)
    }
    func updateDate(_ date: String) {
        btnDay.setTitle(date, for: .normal)
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        datePick = sender.date
        selDate = Date.DateForm(sender)
        btnDay.setTitle(Date.GetUserDateForm(sender), for: .normal)
        //updateDate()
        
        // 데이트 뷰 삭제
        for view in self.view.subviews {
            if view.isEqual(datePicker) {
                view.removeFromSuperview()
                datePicker = nil
            }
        }
        
        // 주간 요일 바꾸기
        updateWeekDate()
        btnWeekDate(Date.GetIntDayWeek(selDate) ?? 0)
        
        // 테이블 뷰 리로드
        mngToDo.loadTask(selDate, &taskList)
        self.ToDoTable.reloadData()
        
    }
    
    @IBOutlet weak var topView: UIView!
    func setLayout() {
        topView.layer.cornerRadius = 20.0
    }
    
    var datePick: Date = Date()
    var datePicker: UIDatePicker? = nil
    @IBOutlet weak var btnDay: UIButton!
    @IBAction func btnDay(_ sender: Any) {
        
        if datePicker != nil { return }
        
        datePicker = UIDatePicker()
        datePicker!.date = datePick
        
        // mode & style
        datePicker!.preferredDatePickerStyle = .inline
        datePicker!.datePickerMode = .date
        datePicker!.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        view.addSubview(datePicker!)
        
        // layout
        datePicker!.translatesAutoresizingMaskIntoConstraints = false
        datePicker!.layer.backgroundColor = CGColor(red: 0.88, green: 0.9, blue: 1.0, alpha: 1.0)
        datePicker!.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            datePicker!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @IBOutlet weak var MonDate: UIButton!
    @IBOutlet weak var TueDate: UIButton!
    @IBOutlet weak var WedDate: UIButton!
    @IBOutlet weak var ThuDate: UIButton!
    @IBOutlet weak var FriDate: UIButton!
    @IBOutlet weak var SatDate: UIButton!
    @IBOutlet weak var SunDate: UIButton!
    
    @IBAction func btnWeekDate(_ sender: UIButton) {
        let arrBtn: [UIButton] = [MonDate, TueDate, WedDate, ThuDate, FriDate, SatDate, SunDate]
        var idx = 0
        for n in 0 ... (arrBtn.count-1) {
            if sender == arrBtn[n] {
                sender.isSelected = true
                idx = n
            } else {
                arrBtn[n].isSelected = false
            }
        }
        
        let cnt = idx - (Date.GetIntDayWeek(selDate) ?? 0) + 1
        selDate = Date.GetNextDay(selDate, cnt)
        btnDay.setTitle(Date.GetUserDate(selDate), for: .normal)
        mngToDo.loadTask(selDate, &taskList)
        ToDoTable.reloadData()
    }
    
    func btnWeekDate(_ weekIdx: Int) {
        let arrBtn: [UIButton] = [MonDate, TueDate, WedDate, ThuDate, FriDate, SatDate, SunDate]
        for i in 0 ... 6 {
            arrBtn[i].isSelected = (i == (weekIdx-1)) ? true : false
        }
    }
    
    func updateWeekDate(){
        var year: Int = 0
        var month: Int = 0
        var day: Int = 0
        
        let arrDay: [UIButton] = [MonDate, TueDate, WedDate, ThuDate, FriDate, SatDate, SunDate]
        
        Date.GetIntDate(selDate, &year, &month, &day)
        
        let idx: Int = Date.GetIntDayWeek(year: year, month: month, day: day) ?? 0
        
        for i in 1...7 {
            let strDate = Date.GetNextDay(selDate, i-idx)
            Date.GetIntDate(strDate, &year, &month, &day)
            arrDay[i-1].setTitle(String(day), for: .normal)
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
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ToDoCell {
            let taskID = taskList[indexPath.row]
            
            cell.task.text = mngToDo.tasks[taskID]?.name
            cell.displayTask(mngToDo.tasks[taskID]!.isDone)
            cell.time.text = displayTime(taskID)
            cell.isDone.tag = indexPath.row
            cell.isDone.addTarget(self, action: #selector(clickIsDone(_:)), for: .touchUpInside)
            cell.setting.tag = indexPath.row
            cell.setting.addTarget(self, action: #selector(clickSetting(_:)), for: .touchUpInside)
            
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
    
    @objc func clickSetting (_ sender: UIButton) {
        // 임시 삭제 함수.
        //내일 하기, 수정하기, 삭제하기 등의 기능이 있는 뷰 띄우기 필요
        let id = sender.tag
        let taskName: String = taskList[id]
        mngToDo.deleteTask(selDate, taskName)
        mngToDo.loadTask(selDate, &taskList)
        self.ToDoTable.reloadData()
    }
    
    @objc func longPressCell (_ sender: UIGestureRecognizer) {
        // 뷰 띄우기
        let taskName: String

        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: ToDoTable)
            
            if let row = ToDoTable.indexPathForRow(at: touchPoint) {
                let idx = row[1]
                taskName = taskList[idx]
                
                // ålert 출력 이름 뒤에 아이디 빼기
                
                let alert = UIAlertController(title: taskName, message: "", preferredStyle: .alert)
                let actRevise = UIAlertAction(title: "수정", style: .default, handler: {alertAction in self.alertRevise(taskName)})
                let actTomorrow = UIAlertAction(title: "내일 하기", style: .default, handler: {alertAction in self.alertTomorrow(taskName)})
                let actDelete = UIAlertAction(title: "삭제", style: .default, handler: {alertAction in self.alertDelete(taskName)})
                
                alert.addAction(actRevise)
                alert.addAction(actTomorrow)
                alert.addAction(actDelete)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func alertRevise(_ taskname: String) {
        print("revise")
    }
    
    func alertTomorrow(_ taskName: String) {
        let date = mngToDo.tasks[taskName]!.date
        
        mngToDo.tasks[taskName]!.date = Date.GetNextDay(date)
        mngToDo.saveTask(mngToDo.tasks)
        mngToDo.loadTask(selDate, &taskList)
        self.ToDoTable.reloadData()
    }
    
    func alertDelete(_ taskName: String) {
        mngToDo.deleteTask(selDate, taskName)
        mngToDo.loadTask(selDate, &taskList)
        self.ToDoTable.reloadData()
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
    @IBOutlet weak var setting: UIButton!
    
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

