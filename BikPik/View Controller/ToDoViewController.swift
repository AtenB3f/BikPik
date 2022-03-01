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
    let mngFirebase = Firebase.mngFirebase
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleAddToDoNoti(_:)), name: notiAddToDo, object: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell))
        //ToDoTable.addGestureRecognizer(longPress)
        tableviewToDo.addGestureRecognizer(longPress)
        
        //fldFastAddTask.delegate = self
        textFastAddTask.delegate = self
        let tabToDoList = UITapGestureRecognizer(target: self, action: #selector(tabPressList))
        //ToDoTable.addGestureRecognizer(tabToDoList)
        tableviewToDo.addGestureRecognizer(tabToDoList)
        
        mngToDo.selDate.bind{ [weak self] date in
            self?.btnSelectDay.setTitle(Date.DateForm(data: date, input: .fullDate, output: .userDate) as? String, for: .normal)
            
            self?.updateDate()
        }

        mngToDo.selTaskList.bind{ [weak self] _ in
            //self?.ToDoTable.reloadData()
            self?.tableviewToDo.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mngToDo.setToday()
    }
    
    let viewTop:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BikPik Color")
        return view
    }()
    let btnSelectDay: UIButton = {
        let button = UIButton()
        button.setTitle(Date.GetNowDate(), for: .normal)
        button.titleLabel?.font = UIFont(name: "GmarketSansTTFLight", size: 24.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(setCalendar), for: .touchUpInside)
        return button
    }()
    let calendarWeek: CustomCalendar = {
        let calendar = CustomCalendar(style: .week, frame: CGRect(x: 0, y: 0, width: 280, height: 100))
        calendar.firstWeekday = 1
        return calendar
    }()
    let viewFast: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BikPik Light Color")
        return view
    }()
    let btnFastAddTask: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.app"), for: .normal)
        button.tintColor = UIColor(named: "BikPik Dark Color")
        button.setPreferredSymbolConfiguration(.init(pointSize: 24.0), forImageIn: .normal)
        button.addTarget(self, action: #selector(actionAddFastTask), for: .touchUpInside)
        return button
    }()
    let textFastAddTask: UITextField = {
        let text = UITextField()
        text.placeholder = "Add Task"
        return text
    }()
    let tableviewToDo: UITableView = {
        let view = UITableView()
        return view
    }()
    let viewBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        return view
    }()
    let btnAddTask: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        button.tintColor = UIColor(named: "BikPik Color")
        button.addTarget(self, action: #selector(actionAddTask), for: .touchUpInside)
        return button
    }()
    
    
    private func setLayout() {
        setLayoutTopView()
        setLayoutFastView()
        setLayoutTableView()
        setLayoutBottomView()
    }
    
    private func setLayoutTopView() {
        self.view.addSubview(viewTop)
        viewTop.snp.makeConstraints { make in
            make.top.right.left.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        
        viewTop.addSubview(btnSelectDay)
        btnSelectDay.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setLayoutFastView() {
        self.view.addSubview(viewFast)
        viewFast.snp.makeConstraints { make in
            make.top.equalTo(viewTop.snp.bottom)
            make.centerX.right.left.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(44.0)
        }
        
        viewFast.addSubview(btnFastAddTask)
        btnFastAddTask.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16.0)
            make.width.height.equalTo(44.0)
        }
        
        viewFast.addSubview(textFastAddTask)
        textFastAddTask.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.right.equalToSuperview().inset(16.0)
            make.left.equalTo(btnFastAddTask.snp.right).offset(4.0)
        }
    }
    private func setLayoutTableView() {
        tableviewToDo.delegate = self
        tableviewToDo.dataSource = self
        tableviewToDo.register(ToDoCell.self, forCellReuseIdentifier: "ToDoCell")
        tableviewToDo.separatorStyle = .none
        self.view.addSubview(tableviewToDo)
        tableviewToDo.snp.makeConstraints { make in
            make.top.equalTo(viewFast.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(60.0)
            make.left.right.equalToSuperview()
        }
    }
    private func setLayoutBottomView() {
        self.view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { make in
            make.bottom.width.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(60.0)
        }
        
        viewBottom.addSubview(btnAddTask)
        btnAddTask.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(44.0)
            make.right.equalToSuperview().inset(16.0)
        }
         
    }
    
    
    // 태스크 추가 후에 테이블 뷰 적용될 수 있게 하는 기능
    @objc func handleAddToDoNoti(_ noti: Notification) {
        updateDate()
        //ToDoTable.reloadData()
        tableviewToDo.reloadData()
    }
    
    /***
     sorting the tasks of seleted date.
     */
    func updateDate() {
        // task list update
        mngToDo.updateData()
        // week button update
        //updateWeekDate()
        //ToDoTable.reloadData()
    }
    
 

    
    /*
    @IBOutlet weak var topView: UIView!
    
   
    @IBOutlet weak var btnDay: UIButton!
    @IBAction func btnDay(_ sender: Any) {
        setCalendar()
    }
     */
    var calendar: FSCalendar? = nil
    @objc func setCalendar() {
        if calendar == nil {
            calendar = {
                let calendar = CustomCalendar(style: .month, frame: CGRect(x: 0, y: 0, width: 300, height: 300))
                calendar.allowsMultipleSelection = false
                calendar.delegate = self
                calendar.dataSource = self
                calendar.currentPage = Date.DateForm(data: mngToDo.selDate.value, input: .fullDate, output: .date) as! Date
                return calendar
            }()
            view.addSubview(calendar!)
            calendar?.snp.makeConstraints({ make in
                make.center.equalToSuperview()
                make.width.height.equalTo(300)
            })
        } else {
            for view in self.view.subviews {
                if view.isEqual(calendar) {
                    view.removeFromSuperview()
                    calendar = nil
                }
            }

        }
    }
    
    /*
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
     */
    @objc func actionAddFastTask() {
        let task = textFastAddTask.text
        if task != "" && task != nil {
            var data:Task = Task(name: task!, date: Date.GetNowDate(), inToday: true)
            data.date = mngToDo.selDate.value
            mngToDo.createTask(data: data)
            textFastAddTask.text = ""
        }
    }
    @objc func actionAddTask() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoVC") as! AddToDoViewController
        vc.modalTransitionStyle = .coverVertical
        vc.data.date = mngToDo.selDate.value
        self.present(vc, animated: true, completion: nil)
    }
}

extension ToDoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mngToDo.selTaskList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoCell {
            cell.updateCell(indexPathRow: indexPath.row)
//            cell.isDone.addTarget(self, action: #selector(clickIsDone(_:)), for: .touchUpInside)
//            cell.setting.addTarget(self, action: #selector(clickSetting(_:)), for: .touchUpInside)
            cell.btnDone.addTarget(self, action: #selector(clickIsDone(_:)), for: .touchUpInside)
            cell.btnSetting.addTarget(self, action: #selector(clickSetting(_:)), for: .touchUpInside)
            
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
        let uuid: String = mngToDo.selTaskList.value[id]
        if mngToDo.tasks[uuid] != nil {
            mngToDo.tasks[uuid]?.isDone = sender.isSelected
            mngToDo.saveTask(data: mngToDo.tasks)
            mngFirebase.uploadTask(uuid: uuid, task: mngToDo.tasks[uuid]!)
        } else if mngHabit.habits[uuid] != nil {
            mngHabit.habits[uuid]?.isDone?[mngToDo.selDate.value] = sender.isSelected
            mngHabit.saveHabit()
            mngFirebase.uploadHabitDone(uuid: uuid, habit: mngHabit.habits[uuid]!)
        }
    }
    
    @objc func clickSetting (_ sender: UIButton) {
        let id = sender.tag
        let uuid = mngToDo.selTaskList.value[id]
        let name = mngToDo.tasks[uuid]!.name
        if mngToDo.tasks[uuid] != nil {
            mngToDo.deleteTask(uuid: uuid)
        } else if mngHabit.habits[uuid] != nil {
            presentHabitAlert(name: name, uuid: uuid)
        }
    }
    
    @objc func longPressCell (_ sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            //let touchPoint = sender.location(in: ToDoTable)
            let touchPoint = sender.location(in: tableviewToDo)
            
            //if let row = ToDoTable.indexPathForRow(at: touchPoint) {
            if let row = tableviewToDo.indexPathForRow(at: touchPoint) {
                let idx = row[1]
                
                let uuid = mngToDo.selTaskList.value[idx]
                
                if mngToDo.tasks[uuid] != nil {
                    // To Do
                    let name = mngToDo.tasks[uuid]!.name
                    presentToDoAlert(name: name, uuid: uuid)
                } else if let habit = mngHabit.habits[uuid] {
                    // habit
                    presentHabitAlert(name: habit.task.name, uuid: uuid)
                }
            }
        }
    }
    
    func presentToDoAlert(name: String, uuid: String) {
        let alert = UIAlertController(title: name, message: "To Do", preferredStyle: .alert)
        let actCorrect = UIAlertAction(title: "수정", style: .default, handler: {alertAction in self.alertCorrect(uuid: uuid)})
        let actDelete = UIAlertAction(title: "삭제", style: .default, handler: {alertAction in self.alertDelete(uuid: uuid)})
        let cancle = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(actCorrect)
        if mngToDo.selDate.value == Date.GetNowDate() {
            let actTomorrow = UIAlertAction(title: "내일 하기", style: .default, handler: {alertAction in self.alertTomorrow(uuid: uuid)})
            alert.addAction(actTomorrow)
        }
        alert.addAction(actDelete)
        alert.addAction(cancle)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentHabitAlert(name: String, uuid: String) {
        let alert = UIAlertController(title: name, message: "Habit", preferredStyle: .alert)
        let revise = UIAlertAction(title: "수정", style: .default, handler: {UIAlertAction in self.alertReviseHabit(uuid: uuid)})
        let cancle = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(revise)
        alert.addAction(cancle)
        present(alert, animated: true, completion: nil)
    }
    
    func alertCorrect(uuid: String) {
        let vc = storyboard.self?.instantiateViewController(withIdentifier: "AddToDoVC") as! AddToDoViewController
        vc.modalTransitionStyle = .coverVertical
        vc.uuid = uuid
        vc.data = mngToDo.tasks[uuid]!
        self.present(vc, animated: true, completion: nil)
    }
    
    func alertTomorrow(uuid: String) {
        if let before:Task = mngToDo.tasks[uuid] {
            var after = before
            after.date = Date.GetNextDay(date: before.date)
            mngToDo.correctTask(uuid: uuid, after: after)
        }
    }
    
    func alertDelete(uuid: String) {
        mngToDo.deleteTask(uuid: uuid)
    }
    
    func alertReviseHabit (uuid : String) {
        let vc = storyboard.self?.instantiateViewController(withIdentifier: "AddHabitVC") as! AddHabitViewController
        vc.modalTransitionStyle = .coverVertical
        guard let habit = mngHabit.habits[uuid] else { return }
        vc.data = habit
        vc.uuid = uuid
        self.present(vc, animated: true, completion: nil)
    }
}

class ToDoCell: UITableViewCell {
    let mngToDo = ToDoManager.mngToDo
    let mngHabit = HabitManager.mngHabit
    
    let btnDone:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CheckBox.png"), for: .normal)
        button.tintColor = UIColor(named: "TextLightColor")
        return button
    }()
    let labelTime: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor(named: "TextLightColor")
        return label
    }()
    let labelTask: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "TextLightColor")
        return label
    }()
    let btnSetting: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.tintColor = UIColor(named: "TextLightColor")
        return button
    }()
    /*
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
    */
    func displayDone(done: Bool) {
//        isDone.isSelected = done
//        task.textColor = UIColor(named: "TextLightColor") ?? .lightText
//        time.textColor = UIColor(named: "TextLightColor") ?? .lightText
        btnDone.isSelected = done
        if done {
//            let col: UIColor = UIColor.init(named: "BikPik Dark Color") ?? .cyan
//            let img = UIImage(named: "CheckBox_fill.png")?.withRenderingMode(.alwaysTemplate)
//            isDone.setImage(img, for: .normal)
//            isDone.tintColor = col
//            task.attributedText = NSAttributedString(
//                                    string: self.task.text ?? ""  ,
//                                    attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            btnDone.setImage(UIImage(named: "CheckBox_fill.png"), for: .normal)
            btnDone.tintColor = UIColor(named: "BikPik Dark Color")

            labelTask.attributedText = NSAttributedString(
                                    string: self.labelTask.text ?? ""  ,
                                    attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
        } else {
//            let col: UIColor = UIColor(named: "TextLightColor") ?? .lightText
//            let img = UIImage(named: "CheckBox.png")?.withRenderingMode(.alwaysTemplate)
//            isDone.setImage(img, for: .normal)
//            isDone.tintColor = col
//            task.attributedText = NSAttributedString(
//                                    string: self.task.text ?? "" ,
//                                    attributes: [NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.byWord])
            btnDone.setImage(UIImage(named: "CheckBox.png"), for: .normal)
            btnDone.tintColor = UIColor(named: "TextLightColor")

            labelTask.attributedText = NSAttributedString(
                                    string: self.labelTask.text ?? "" ,
                                    attributes: [NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.byWord])
        }
    }
    
    func displayTime(uuid: String) -> String{
        var time: String?
        
        if mngToDo.tasks[uuid] != nil {
            if mngToDo.tasks[uuid]?.inToday == true {
                time = "Today"
            } else {
                time = mngToDo.tasks[uuid]?.time
            }
        } else if let habit = mngHabit.habits[uuid] {
            if habit.task.inToday == true {
                time = "Today"
            } else {
                time = habit.task.time
            }
            
        } else {
            time = "Today"
        }
        
        return time!
    }
    
    func updateCell(indexPathRow row: Int) {
        /*
        if row >= mngToDo.selTaskList.value.count{
            return
        }
        let uuid = mngToDo.selTaskList.value[row]
        if let data = mngToDo.tasks[uuid] {
            displayDone(done: data.isDone)
            setting.setImage(UIImage(systemName: "x.circle"), for: .normal)
            self.task.text = data.name
        } else if let habit = mngHabit.habits[uuid] {
            let done = mngHabit.isDoneCheck(habit: habit, date: mngToDo.selDate.value)
            displayDone(done: done)
            setting.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
            self.task.text = habit.task.name
        }
        
        time.text = displayTime(uuid: uuid)
        
        isDone.tag = row
        setting.tag = row
        */
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
        //disableCalendar()
    }
}
