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
    var onCalendar = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addGestureRecognizer(scopeGesture)
        //self.tableviewToDo.panGestureRecognizer.require(toFail: scopeGesture)
        
        setLayout()
        
        tableviewToDo.register(ToDoCell.self, forCellReuseIdentifier: "ToDoCell")
        tableviewToDo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabPressList)))
        tableviewToDo.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressCell)))
        
        calendarWeek.delegate = self
        calendarWeek.dataSource = self
        calendarWeek.currentPage = Date.DateForm(data: mngToDo.selDate.value, input: .fullDate, output: .date) as! Date
        
        textFastAddTask.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleAddToDoNoti(_:)), name: notiAddToDo, object: nil)
        
        mngToDo.selDate.bind{ [weak self] date in
            self?.btnSelectDay.setTitle(Date.DateForm(data: date, input: .fullDate, output: .userDate) as? String, for: .normal)
            self?.calendarWeek.currentPage = Date.DateForm(data: date, input: .fullDate, output: .date) as! Date
            self?.updateDate()
        }
        
        mngToDo.selTaskList.bind{ [weak self] _ in
            self?.tableviewToDo.reloadData()
        }
    }
    /*
    lazy var scopeGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self.calendarWeek, action: #selector(self.calendarWeek.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    */
    override func viewWillAppear(_ animated: Bool) {
        mngToDo.setToday()
        calendarWeek.setLayout()
        calendarWeek.layoutIfNeeded()
    }
    
    let viewTop:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BikPik Color")
        return view
    }()
    let btnMenu:UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "square.grid.2x2.fill"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(.init(pointSize: 24.0), forImageIn: .normal)
        button.addTarget(self, action: #selector(actionMenu), for: .touchUpInside)
        return button
    }()
    let btnSelectDay: UIButton = {
        let button = UIButton()
        button.setTitle(Date.GetNowDate(), for: .normal)
        button.titleLabel?.font = UIFont(name: "GmarketSansTTFMedium", size: 24.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(setCalendar), for: .touchUpInside)
        return button
    }()
    let calendarWeek: CustomCalendar = {
        let calendar = CustomCalendar(style: .week, frame: CGRect(x: 0, y: 0, width: 280, height: 100))
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
        button.setPreferredSymbolConfiguration(.init(pointSize: 20.0), forImageIn: .normal)
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
        setLayoutCalendar()
        setLayoutFastView()
        setLayoutTableView()
        setLayoutBottomView()
    }
    
    private func setLayoutTopView() {
        self.view.addSubview(viewTop)
        viewTop.snp.makeConstraints { make in
            make.top.right.left.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        viewTop.addSubview(btnMenu)
        btnMenu.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(16)
            make.width.height.equalTo(44.0)
        }
        
        viewTop.addSubview(btnSelectDay)
        btnSelectDay.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(btnMenu.snp.centerY)
        }
    }
    
    private func setLayoutCalendar(){
        self.view.addSubview(calendarWeek)
        calendarWeek.snp.makeConstraints { make in
            make.width.equalTo(280)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.top.equalTo(viewTop.snp.bottom)
        }
        
        calendarWeek.calendarWeekdayView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(28)
        }
        calendarWeek.daysContainer.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(calendarWeek.calendarWeekdayView.snp.bottom).offset(-5)
        }
        calendarWeek.collectionView.snp.makeConstraints { make in
            make.centerX.width.top.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func setLayoutFastView() {
        self.view.addSubview(viewFast)
        viewFast.snp.makeConstraints { make in
            //make.top.equalTo(viewTop.snp.bottom)
            make.top.equalTo(calendarWeek.snp.bottom)
            make.centerX.right.left.equalToSuperview()
            make.height.equalTo(40.0)
        }
        
        viewFast.addSubview(btnFastAddTask)
        btnFastAddTask.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide).inset(16.0)
            make.width.height.equalTo(40.0)
        }
        
        viewFast.addSubview(textFastAddTask)
        textFastAddTask.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.right.equalTo(self.view.safeAreaLayoutGuide).inset(16.0)
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
            make.left.right.equalToSuperview()//equalTo(self.view.safeAreaLayoutGuide)
        }
        tableviewToDo.insetsContentViewsToSafeArea = true
    }
    private func setLayoutBottomView() {
        self.view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(60.0)
        }
        
        viewBottom.addSubview(btnAddTask)
        btnAddTask.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(44.0)
            make.right.equalTo(self.view.safeAreaLayoutGuide).inset(16.0)
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

    @objc func actionMenu() {
        let sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuViewController
        let menu = CustomSideMenuViewController(rootViewController: sideMenuViewController)
        self.present(menu, animated: true, completion: nil)
    }
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
/*
extension ToDoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            let shouldBegin = self.tableviewToDo.contentOffset.y <= -self.tableviewToDo.contentInset.top
            if shouldBegin {
                let velocity = self.scopeGesture.velocity(in: self.view)
                switch self.calendarWeek.scope {
                case .month:
                    return velocity.y < 0
                case .week:
                    return velocity.y > 0
                @unknown default:
                    print("calendar guesture err")
                }
            }
            return shouldBegin
        }
}
*/
extension ToDoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mngToDo.selTaskList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoCell {
            let uuid = mngToDo.selTaskList.value[indexPath.row]
            if let task = mngToDo.tasks[uuid]{
                cell.updateCell(indexPathRow: indexPath.row, name: task.name, done: task.isDone, time: task.inToday ? "Today" : task.time, type: .ToDo)
            } else if let habit = mngHabit.habits[uuid] {
                cell.updateCell(indexPathRow: indexPath.row, name: habit.task.name, done: mngHabit.isDoneCheck(habit: habit, date: mngToDo.selDate.value), time: habit.task.time, type: .Habit)
            }
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
        if mngToDo.tasks[uuid] != nil {
            mngToDo.deleteTask(uuid: uuid)
        } else if mngHabit.habits[uuid] != nil {
            actionReviseHabit(uuid: uuid)
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
        let revise = UIAlertAction(title: "수정", style: .default, handler: {UIAlertAction in self.actionReviseHabit(uuid: uuid)})
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
    
    func actionReviseHabit (uuid : String) {
        let vc = storyboard.self?.instantiateViewController(withIdentifier: "AddHabitVC") as! AddHabitViewController
        vc.modalTransitionStyle = .coverVertical
        guard let habit = mngHabit.habits[uuid] else { return }
        vc.data = habit
        vc.uuid = uuid
        self.present(vc, animated: true, completion: nil)
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
    @objc func toggleCalendar() {
        if self.calendarWeek.scope == .month {
            self.calendarWeek.setScope(.week, animated: self.onCalendar)
        } else {
            self.calendarWeek.setScope(.month, animated: self.onCalendar)
        }
        self.onCalendar.toggle()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar == self.calendar {
            setCalendar()
        }
        mngToDo.changeSelectDate(date: Date.DateForm(data: date, input: .date, output: .fullDate) as! String)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    /*
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("did select date \(self.dateFormatter.string(from: date))")
       // let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        //print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
*/
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        //print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
}
