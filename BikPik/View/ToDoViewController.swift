//
//  ToDoViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/05.
//

import UIKit

class ToDoViewController: UIViewController {
    
    let mngToDo = ToDoManager.mngToDo
    let mngHabit = HabitManager.mngHabit
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
        btnWeekDate()
        mngToDo.updateData()
    }
    
    // 태스크 추가 후에 테이블 뷰 적용될 수 있게 하는 기능
    @objc func didDismissPostCommentNotification(_ noti: Notification) {
        mngToDo.updateData()
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
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        datePick = sender.date
        mngToDo.selDate = Date.DateForm(sender)
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
        btnWeekDate()
        
        // 테이블 뷰 리로드
        mngToDo.loadTask()
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
        
        let cnt = idx - (Date.GetIntDayWeek(mngToDo.selDate) ?? 0) + 1
        mngToDo.selDate = Date.GetNextDay(mngToDo.selDate, cnt)
        btnDay.setTitle(Date.GetUserDate(mngToDo.selDate), for: .normal)
        mngToDo.updateData()
        ToDoTable.reloadData()
    }
    
    func btnWeekDate() {
        let weekIdx = Date.GetIntDayWeek(mngToDo.selDate) ?? 0
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
        
        Date.GetIntDate(mngToDo.selDate, &year, &month, &day)
        
        let idx: Int = Date.GetIntDayWeek(year: year, month: month, day: day) ?? 0
        
        for i in 1...7 {
            let strDate = Date.GetNextDay(mngToDo.selDate, i-idx)
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
    
}

extension ToDoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mngToDo.selTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ToDoCell {
            cell.updateCell(indexPathRow: indexPath.row)
            cell.isDone.addTarget(self, action: #selector(clickIsDone(_:)), for: .touchUpInside)
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
        let id = sender.tag
        let taskName: String = mngToDo.selTaskList[id]
        if mngToDo.tasks[taskName] != nil {
            mngToDo.tasks[taskName]?.isDone = sender.isSelected
            mngToDo.saveTask(mngToDo.tasks)
        } else if mngHabit.searchHabitTask(name: taskName) != nil {
            let id = mngHabit.habitId[taskName]!
            mngHabit.isDone(habit: &mngHabit.habits[id], date: mngToDo.selDate, done: sender.isSelected)
            mngHabit.saveHabit()
        }
    }
    
    @objc func clickSetting (_ sender: UIButton) {
        // 임시 삭제 함수.
        //내일 하기, 수정하기, 삭제하기 등의 기능이 있는 뷰 띄우기 필요
        let id = sender.tag
        let taskName: String = mngToDo.selTaskList[id]
        mngToDo.deleteTask(taskName)
        mngToDo.updateData()
        self.ToDoTable.reloadData()
    }
    
    @objc func longPressCell (_ sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: ToDoTable)
            
            if let row = ToDoTable.indexPathForRow(at: touchPoint) {
                let idx = row[1]
                
                let taskName = mngToDo.selTaskList[idx]
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
        mngToDo.updateData()
        self.ToDoTable.reloadData()
    }
    
    func alertDelete(_ taskName: String) {
        mngToDo.deleteTask(taskName)
        mngToDo.updateData()
        self.ToDoTable.reloadData()
    }
}

class ToDoCell: UITableViewCell {

    let mngToDo = ToDoManager.mngToDo
    let mngHabit = HabitManager.mngHabit
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
        displayDone(done: isDone.isSelected)
    }
    
    func displayDone(done: Bool) {
        isDone.isSelected = done
        if done {
            let col: UIColor = UIColor.init(named: "BikPik Color") ?? .cyan
            let img = UIImage(named: "CheckBox_fill.png")?.withRenderingMode(.alwaysTemplate)
            isDone.setImage(img, for: .normal)
            isDone.tintColor = col
            task.textColor = col
            
            /*
            let attr = NSAttributedString(
                string: self.task.text! ,
                attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            task.attributedText = attr
             */
        } else {
            let col: UIColor = .lightGray
            let img = UIImage(named: "CheckBox.png")?.withRenderingMode(.alwaysTemplate)
            isDone.setImage(img, for: .normal)
            isDone.tintColor = col
            task.textColor = col
            
            /*
            let attr = NSAttributedString(
                string: self.task.text! ,
                attributes: [NSAttributedString.Key.ligature : NSUnderlineStyle.single.rawValue])
            task.attributedText = attr
             */
        }
    }
    
    func displayTime(_ taskId: String) -> String{
        var time: String?
        
        if mngToDo.tasks[taskId] != nil {
            if mngToDo.tasks[taskId]?.inToday == true {
                time = ""
            } else {
                time = mngToDo.tasks[taskId]?.time
            }
        } else if (mngHabit.habitId[taskId] != nil) {
            let id = mngHabit.habitId[taskId] ?? 0
            time = mngHabit.habits[id].task.time
        } else {
            time = ""
        }
        
        return time!
    }
    
    /*
    func displayTask(taskID:String) -> String {
        var name: String = ""
        if let task = mngToDo.tasks[taskID] {
            name = task.name ?? ""
            displayDone(done : mngToDo.tasks[taskID]!.isDone)
        } else if let habit = mngHabit.searchHabit(name: taskID) {
            name = habit.name ?? ""
            
            let idx =  mngHabit.habitId[name] ?? 0
            let done = mngHabit.isDoneCheck(habit: mngHabit.habits[idx], date: mngToDo.selDate)
            
            displayDone(done: done)
        }
        return name
    }
     */
    
    func updateCell(indexPathRow row: Int) {
        let taskID = mngToDo.selTaskList[row]
        if let task = mngToDo.tasks[taskID] {
            displayDone(done: task.isDone)
        } else if let id = mngHabit.habitId[taskID] {
            let habit = mngHabit.habits[id]
            let done = mngHabit.isDoneCheck(habit: habit, date: mngToDo.selDate)
            displayDone(done: done)
        }
        task.text = taskID
        time.text = displayTime(taskID)
        
        isDone.tag = row
        setting.tag = row
    }
}
