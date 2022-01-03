//
//  ToDoViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/05.
//

import UIKit
import SideMenu
import FSCalendar

class ToDoViewController: UIViewController {
    let mngToDo = ToDoManager.mngToDo
    let mngHabit = HabitManager.mngHabit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPostCommentNotification(_:)), name: notiAddToDo, object: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell))
        ToDoTable.addGestureRecognizer(longPress)
        
        fldFastAddTask.delegate = self
        let tabToDoList = UITapGestureRecognizer(target: self, action: #selector(tabPressList))
        ToDoTable.addGestureRecognizer(tabToDoList)
        
        mngToDo.selDate.bind{ [weak self] date in
            self?.btnDay.setTitle(Date.DateForm(data: date, input: .fullDate, output: .userDate) as? String, for: .normal)
            self?.updateDate()
        }

        mngToDo.selTaskList.bind{ [weak self] _ in
            self?.ToDoTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mngToDo.setToday()
    }
    
    // 태스크 추가 후에 테이블 뷰 적용될 수 있게 하는 기능
    @objc func didDismissPostCommentNotification(_ noti: Notification) {
        updateDate()
        ToDoTable.reloadData()
    }
    
    /***
     sorting the tasks of seleted date.
     */
    func updateDate() {
        // task list update
        mngToDo.updateData()
        // week button update
        updateWeekDate()
        //ToDoTable.reloadData()
    }
 
    @IBOutlet weak var topView: UIView!
    
    var calendar: FSCalendar? = nil
    @IBOutlet weak var btnDay: UIButton!
    @IBAction func btnDay(_ sender: Any) {
        if calendar == nil {
            enableCalendar()
        } else {
            disableCalendar()
        }
    }
    
    func enableCalendar() {
        let y = topView.fs_bottom + 60
        let rect = CGRect(x: (view.fs_width - 300)/2, y: y, width: 300, height: 300)
        calendar = CustomCalendar(style: .month, frame: rect)
        calendar?.allowsMultipleSelection = false
        calendar?.delegate = self
        calendar?.dataSource = self
        calendar!.currentPage = Date.DateForm(data: mngToDo.selDate.value, input: .fullDate, output: .date) as! Date
        view.addSubview(calendar!)
    }
    
    func disableCalendar() {
        for view in self.view.subviews {
            if view.isEqual(calendar) {
                view.removeFromSuperview()
                calendar = nil
            }
        }
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
        for (i, val) in arrBtn.enumerated() {
            if sender == val {
                sender.isSelected = true
                idx = i
            } else {
                val.isSelected = false
            }
        }
        let cnt = idx - (Date.WeekForm(data: mngToDo.selDate.value, input: .fullDate, output: .intIndex) as! Int) + 1
        mngToDo.changeSelectDate(index: cnt)
    }
    
    func updateWeekDate(){
        var year: Int = 0
        var month: Int = 0
        var day: Int = 0
        
        let arrDay: [UIButton] = [MonDate, TueDate, WedDate, ThuDate, FriDate, SatDate, SunDate]
        let idx = Date.WeekForm(data: mngToDo.selDate.value, input: .fullDate, output: .intIndex) as! Int
        
        for i in 0...6 {
            let strDate = Date.GetNextDay(date: mngToDo.selDate.value,fewDays: i-idx+1)
            Date.GetIntDate(date: strDate, year: &year, month: &month, day: &day)
            arrDay[i].setTitle(String(day), for: .normal)
            arrDay[i].isSelected = i == (idx-1) ? true : false
        }
    }
    
    @IBOutlet weak var btnFastAddTask: UIButton!
    @IBAction func btnFaskAddTask(_ sender: Any) {
        let task = fldFastAddTask.text
        if task != "" && task != nil {
            var data:Task = Task(name: task!, date: Date.GetNowDate(), inToday: true)
            data.date = mngToDo.selDate.value
            mngToDo.createTask(data: data)
            fldFastAddTask.text = ""
        }
    }
    
    @IBOutlet weak var fldFastAddTask: UITextField!
    
    @IBAction func btnMenu(_ sender: Any) {
        let sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuViewController
        let menu = CustomSideMenuViewController(rootViewController: sideMenuViewController)
        
        present(menu, animated: true, completion: nil)
    }
    
    @IBOutlet weak var btnAddTask: UIButton!
    @IBAction func btnAddTask(_ sender: Any) {
        // Present Add To Do VC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoVC") as! AddToDoViewController
        vc.modalTransitionStyle = .coverVertical
        vc.data.date = mngToDo.selDate.value
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var ToDoTable: UITableView!
}

extension ToDoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mngToDo.selTaskList.value.count
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
        let taskName: String = mngToDo.selTaskList.value[id]
        if mngToDo.tasks[taskName] != nil {
            mngToDo.tasks[taskName]?.isDone = sender.isSelected
            mngToDo.saveTask(data: mngToDo.tasks)
        } else if mngHabit.searchHabitTask(name: taskName) != nil {
            let id = mngHabit.habitId[taskName]!
            mngHabit.isDone(habit: &mngHabit.habits[id], date: mngToDo.selDate.value, done: sender.isSelected)
            mngHabit.saveHabit()
        }
    }
    
    @objc func clickSetting (_ sender: UIButton) {
        let id = sender.tag
        let key = mngToDo.selTaskList.value[id]
        let name:String = mngToDo.splitToName(key: key) ?? ""
        if mngToDo.tasks[key] != nil {
            mngToDo.deleteTask(key: key)
        } else if mngHabit.habitId[key] != nil {
            presentHabitAlert(name: name, key: key)
        }
    }
    
    @objc func longPressCell (_ sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: ToDoTable)
            
            if let row = ToDoTable.indexPathForRow(at: touchPoint) {
                let idx = row[1]
                
                let key = mngToDo.selTaskList.value[idx]
                let name = mngToDo.splitToName(key: key) ?? ""
                if mngToDo.tasks[key] != nil {
                    // To Do
                    presentToDoAlert(name: name, key: key)
                } else {
                    // habit
                    presentHabitAlert(name: name, key: key)
                }
            }
        }
    }
    
    func presentToDoAlert(name: String, key: String) {
        let alert = UIAlertController(title: name, message: "To Do", preferredStyle: .alert)
        let actCorrect = UIAlertAction(title: "수정", style: .default, handler: {alertAction in self.alertCorrect(key)})
        let actDelete = UIAlertAction(title: "삭제", style: .default, handler: {alertAction in self.alertDelete(key)})
        let cancle = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(actCorrect)
        if mngToDo.selDate.value == Date.GetNowDate() {
            let actTomorrow = UIAlertAction(title: "내일 하기", style: .default, handler: {alertAction in self.alertTomorrow(key)})
            alert.addAction(actTomorrow)
        }
        alert.addAction(actDelete)
        alert.addAction(cancle)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentHabitAlert(name: String, key: String) {
        let alert = UIAlertController(title: key, message: "Habit", preferredStyle: .alert)
        let revise = UIAlertAction(title: "수정", style: .default, handler: {UIAlertAction in self.alertReviseHabit(habitName: key)})
        let cancle = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(revise)
        alert.addAction(cancle)
        present(alert, animated: true, completion: nil)
    }
    
    func alertCorrect(_ taskname: String) {
        let vc = storyboard.self?.instantiateViewController(withIdentifier: "AddToDoVC") as! AddToDoViewController
        vc.modalTransitionStyle = .coverVertical
        vc.data = mngToDo.tasks[taskname]!
        self.present(vc, animated: true, completion: nil)
    }
    
    func alertTomorrow(_ key: String) {
        if let before:Task = mngToDo.tasks[key] {
            var after = before
            after.date = Date.GetNextDay(date: before.date)
            mngToDo.correctTask(before: before, after: after)
        }
    }
    
    func alertDelete(_ taskName: String) {
        mngToDo.deleteTask(key: taskName)
    }
    
    func alertReviseHabit (habitName : String) {
        let vc = storyboard.self?.instantiateViewController(withIdentifier: "AddHabitVC") as! AddHabitViewController
        vc.modalTransitionStyle = .coverVertical
        guard let id = mngHabit.habitId[habitName] else { return }
        vc.data = mngHabit.habits[id]
        self.present(vc, animated: true, completion: nil)
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
            let col: UIColor = UIColor.init(named: "BikPik Dark Color") ?? .cyan
            let img = UIImage(named: "CheckBox_fill.png")?.withRenderingMode(.alwaysTemplate)
            isDone.setImage(img, for: .normal)
            isDone.tintColor = col
            task.textColor = col
            time.textColor = col
            
            /*
            let attr = NSAttributedString(
                string: self.task.text! ,
                attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            task.attributedText = attr
             */
        } else {
            let col: UIColor = UIColor(named: "TextLightColor") ?? .lightText
            let img = UIImage(named: "CheckBox.png")?.withRenderingMode(.alwaysTemplate)
            isDone.setImage(img, for: .normal)
            isDone.tintColor = col
            task.textColor = col
            time.textColor = col
            
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
                time = "Today"
            } else {
                time = mngToDo.tasks[taskId]?.time
            }
        } else if (mngHabit.habitId[taskId] != nil) {
            let id = mngHabit.habitId[taskId] ?? 0
            let habit = mngHabit.habits[id]
            if habit.task.inToday == true {
                time = "Today"
            } else {
                time = mngHabit.habits[id].task.time
            }
            
        } else {
            time = "Today"
        }
        
        return time!
    }
    
    func updateCell(indexPathRow row: Int) {
        if row >= mngToDo.selTaskList.value.count{
            return
        }
        let taskID = mngToDo.selTaskList.value[row]
        if let task = mngToDo.tasks[taskID] {
            displayDone(done: task.isDone)
            setting.setImage(UIImage(systemName: "x.circle"), for: .normal)
        } else if let id = mngHabit.habitId[taskID] {
            let habit = mngHabit.habits[id]
            let done = mngHabit.isDoneCheck(habit: habit, date: mngToDo.selDate.value)
            displayDone(done: done)
            setting.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        }
        
        if let name = mngToDo.splitToName(key: taskID) {
            task.text = name
        } else {
            task.text = taskID
        }
        time.text = displayTime(taskID)
        
        isDone.tag = row
        setting.tag = row
    }
}

extension ToDoViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let task = textField.text
        {
            let data:Task = Task(name: task, date: Date.GetNowDate(), inToday: true)
            mngToDo.createTask(data: data)
            textField.text = nil
        }
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @objc func tabPressList(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ToDoViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        mngToDo.changeSelectDate(date: Date.DateForm(data: date, input: .date, output: .fullDate) as! String)
        disableCalendar()
    }
}