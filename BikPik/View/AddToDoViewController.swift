//
//  AddToDoViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/05.
//

import UIKit
import FSCalendar
import SnapKit

let notiAddToDo: Notification.Name = Notification.Name("notiAddToDo")

class AddToDoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        addTarget()
        
        let dateform: Date = Date.DateForm(data: data.date, input: .fullDate, output: .date) as! Date
        let dates = [dateform]
        dates.forEach { (date) in
           self.calendar.select(date, scrollToDate: false)
       }
        
        if data.name != nil && data.name != "" {
            revise = true
            reviseTask = data
            fldTaskName.text = data.name
            swtInToday.isOn = data.inToday
            swtAlram.isOn = data.alram
            //viewCalendar.
            pickerTime.date = Date.GetDateTime(date: data.time)
            //pickerDate.date = Date.GetDateDay(date: data.date)
            
            
        } else {
            // Data Init
            data.time = Date.GetNowTime()
            //pickerDate.date = Date.DateForm(data: data.date, input: .fullDate, output: .date) as! Date
        }
    }
    
    
    let managerToDo = ToDoManager.mngToDo
    let mngNoti = Notifications.mngNotification
    
    var data: Task = Task()
    var revise: Bool = false
    var reviseTask :Task?	
    
    // Navigation Cancle
    @IBOutlet weak var navigationAddTask: UINavigationBar!
    @IBAction func btnCancle(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    // Navigation Add
    @IBAction func btnAdd(_ sender: Any) {

        guard let name = fldTaskName.text else { return }
        guard  name != "" else { return }
        if revise == true {
            mngNoti.removeNotificationTask(task: data)
        }
        
        data.name = name
        
        if data.alram {
            data.notiUUID = mngNoti.createNotificationTask(task: data)
        }
        
        data.time = Date.TimeForm(picker: pickerTime)
        
        if revise == true {
            managerToDo.correctTask(before: reviseTask ?? Task() , after: data)
        } else {
            // Save Data
            managerToDo.createTask(data: data)
        }
        
        // Back to To Do LIst Page
        self.presentingViewController?.dismiss(animated: true)
        
        NotificationCenter.default.post(name: notiAddToDo, object: nil, userInfo: nil)
    }
    
    // objects
    let viewContents = UIView()
    let fldTaskName = UITextField()
    var calendar = CustomCalendar(style: .month, frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let viewInToday = UIView()
    let labelInToday = UILabel()
    let swtInToday = UISwitch()
    let viewAlram = UIView()
    let labelAlram = UILabel()
    let swtAlram = UISwitch()
    let viewTime = UIView()
    let labelTime = UILabel()
    let pickerTime = UIDatePicker()
    
    // values
    let widthRate = 0.80
    let heightGap = 30.0
    
    //functions
    func setLayout() {
        setViewContentsLayout()
        setTextFieldLayout()
        setCalendarLayout()
        setInTodayLayout()
        setViewInTodayLayout(data.inToday)
    }
    
    func setViewContentsLayout() {
        self.view.addSubview(viewContents)
        
        // Contents View Layout
        viewContents.snp.makeConstraints { make in
            make.top.equalTo(navigationAddTask.snp.bottom)
            make.width.centerX.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setTextFieldLayout() {
        viewContents.addSubview(fldTaskName)
        
        // Text Field Layout
        fldTaskName.snp.makeConstraints { make in
            make.width.equalTo(viewContents).multipliedBy(widthRate)
            make.centerX.equalTo(viewContents.snp.centerX)
            make.top.equalTo(viewContents.snp.top).offset(50.0)
            make.height.equalTo(58.0)
        }
        
        fldTaskName.placeholder = "Task"
        fldTaskName.font = UIFont.systemFont(ofSize: 40.0)
    }
    
    func setCalendarLayout() {
        let rect = CGRect(x: fldTaskName.frame.minX, y: fldTaskName.frame.maxY + heightGap, width: 300, height: 300)
        calendar = CustomCalendar(style: .month, frame: rect)
        
        setCalendar()
        calendar(self.calendar, boundingRectWillChange: rect, animated: false)
    }
    
    func setCalendar() {
        calendar.allowsMultipleSelection = true
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = false
        viewContents.addSubview(calendar)
    }
    
    func setInTodayLayout() {
        viewContents.addSubview(labelInToday)
        viewContents.addSubview(swtInToday)
        
        swtInToday.onTintColor = UIColor(named: "BikPik Color")
        swtInToday.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(heightGap)
            make.trailing.equalTo(calendar.snp.trailing).offset(-3)
            make.height.equalTo(34)
        }
        labelInToday.text = "오늘 동안"
        labelInToday.snp.makeConstraints { make in
            make.centerY.equalTo(swtInToday.snp.centerY)
            make.leading.equalTo(calendar.snp.leading).offset(3)
            make.height.equalTo(34)
        }
    }
    
    func setViewInTodayLayout(_ on: Bool) {
        viewContents.addSubview(viewInToday)
        
        viewInToday.snp.makeConstraints { make in
            make.top.equalTo(swtInToday.snp.bottom).offset(5)
            make.centerX.equalTo(viewContents.snp.centerX)
            make.width.equalTo(calendar.snp.width)
            make.height.equalTo(100)
        }
        
        setAlramLayout(on)
        setTimeLayout(on)
    }
    
    func setAlramLayout(_ on: Bool) {
        viewInToday.addSubview(labelAlram)
        viewInToday.addSubview(swtAlram)
        
        let height = 34
        if !on {
            labelAlram.textColor = .black
            swtAlram.isEnabled = true
        } else {
            labelAlram.textColor = .lightGray
            swtAlram.isEnabled = false
        }
        
        swtAlram.onTintColor = UIColor(named: "BikPik Color")
        swtAlram.snp.makeConstraints { make in
            make.top.equalTo(swtInToday.snp.bottom).offset(5)
            make.trailing.equalTo(calendar.snp.trailing).offset(-5)
            make.height.equalTo(height)
        }
        
        labelAlram.text = "알람"
        labelAlram.snp.makeConstraints { make in
            make.top.equalTo(swtInToday.snp.bottom).offset(5)
            make.leading.equalTo(calendar.snp.leading).offset(5)
            make.height.equalTo(height)
        }
    }
    
    func setTimeLayout(_ on: Bool) {
        viewInToday.addSubview(pickerTime)
        viewInToday.addSubview(labelTime)
        
        let height = 48
        if !on {
            labelTime.textColor = .black
            pickerTime.isEnabled = true
            
        } else {
            labelTime.textColor = .lightGray
            pickerTime.isEnabled = false
        }
        pickerTime.datePickerMode = .time
        pickerTime.preferredDatePickerStyle = .inline
        pickerTime.snp.makeConstraints { make in
            make.top.equalTo(swtAlram.snp.bottom)
            make.trailing.equalTo(calendar.snp.trailing).offset(5)
            make.height.equalTo(height)
        }
        
        labelTime.text = "시간"
        labelTime.snp.makeConstraints { make in
            make.centerY.equalTo(pickerTime.snp.centerY)
            make.leading.equalTo(calendar.snp.leading).offset(5)
        }
    }
    
    func addTarget() {
        swtAlram.addTarget(self, action: #selector(self.actionAlram(_:)), for: .allTouchEvents)
        swtInToday.addTarget(self, action: #selector(self.actionInToday(_:)), for: .allTouchEvents)
    }
    
    @objc func actionAlram(_ sender: UISwitch) {
        data.alram = sender.isOn
    }
    
    @objc func actionInToday(_ sender: UISwitch) {
        data.inToday = sender.isOn
        setViewInTodayLayout(sender.isOn)
    }
    
    /*
    @IBOutlet weak var fldTask: UITextField!
    @IBOutlet weak var pickerDate: UIDatePicker!
    @IBAction func pickerDate(_ sender: Any) {
        data.date = Date.DateForm(picker: pickerDate)
    }
    
    @IBOutlet weak var todayStackView: UIStackView!
    @IBOutlet weak var labelToday: UILabel!
    @IBOutlet weak var swtToday: UISwitch!
    @IBAction func swtToday(_ sender: Any) {
        data.inToday = swtToday.isOn
        if swtToday.isOn {
            data.time = "00:00"
            swtAlram.isEnabled = false
            pickerTime.isEnabled = false
            labelAlram.textColor = .lightGray
            labelTime.textColor = .lightGray
        } else {
            data.time = Date.TimeForm(picker: pickerTime)
            swtAlram.isEnabled = true
            pickerTime.isEnabled = true
            labelAlram.textColor = .black
            labelTime.textColor = .black
        }
        data.inToday = swtToday.isOn
    }
    
    @IBOutlet weak var viewAlram: UIStackView!
    @IBOutlet weak var labelAlram: UILabel!
    @IBOutlet weak var swtAlram: UISwitch!
    @IBAction func swtAlram(_ sender: Any) {
        data.alram = swtAlram.isOn
    }
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBAction func pickerTime(_ sender: Any) {
        data.time = Date.TimeForm(picker: pickerTime)
    }
    */
}

extension AddToDoViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.width.equalTo(bounds.width)
            make.height.equalTo(bounds.height)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(fldTaskName.snp.bottom).offset(heightGap)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let fullDate: String = Date.DateForm(data: date, input: .date, output: .fullDate) as! String
        data.date = fullDate
    }
}
