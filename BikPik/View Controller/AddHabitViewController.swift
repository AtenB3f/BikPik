//
//  AddHabitViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/09/01.
//

import UIKit
import FSCalendar
import SnapKit

let notiAddHabit: Notification.Name = Notification.Name("notiAddHabit")

class AddHabitViewController: UIViewController {
    
    let mngHabit = HabitManager.mngHabit
    let mngNoti = Notifications.mngNotification
    
    var uuid: String?
    var data: Habits = Habits(date: Date.GetNowDate())
    var revise : Bool = false
    
    var term: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        addTarget()
        
        if data.task.name == "" {
            // new habit create
            data = Habits(date: Date.GetNowDate())
        } else {
            // habit revise
            revise = true
            fldHabitName.text = data.task.name
            let arrBtn: [UIButton] = [btnMon, btnTue, btnWed, btnThu, btnFri, btnSat, btnSun]
            for n in 0...(data.days.count-1) {
                arrBtn[n].isSelected = data.days[n]
            }
            swtInToday.isOn = data.task.inToday
            swtAlram.isOn = data.task.alram
            pickerTime.date = Date.GetDateTime(time: data.task.time)
        }
        setSelectBtn()
        calurateTotal()
    }
    
    func calurateTotal() {
        let arrBtn: [UIButton] = [btnMon, btnTue, btnWed, btnThu, btnFri, btnSat, btnSun]
        var total = 0
        for n in 0...6 {
            if arrBtn[n].isSelected == true {
                let st = Date.DateForm(data: data.start, input: .fullDate, output: .date) as! Date
                let ed = Date.DateForm(data: data.end, input: .fullDate, output: .date) as! Date
                total += Date.GetWeekDays(start: st, end: ed, week: n+1)
            }
        }
        data.total = total
    }
    
    @IBOutlet weak var nabigationBar: UINavigationBar!
    @IBAction func btnAdd(_ sender: Any) {
        guard let name = fldHabitName.text else { return }
        if name == "" { return }
        
        if revise {
            if self.uuid == nil { return }
            if data.task.notiUUID != nil {
                mngNoti.removeNotificationHabit(habit: data)
            }
        } else {
            self.uuid = UUID().uuidString
        }
        
        data.task.name = name
        data.task.time = Date.TimeForm(picker: pickerTime)
        calurateTotal()
        data.task.alram = swtAlram.isOn
        
        if data.task.alram {
             mngNoti.createNotificationHabit(habit: data)
        }
        
        if revise == true {
            mngHabit.correctHabit(uuid: uuid!, habit: data)
        } else {
            // create Habit
            mngHabit.createHabit(habit: data)
        }
        
        self.presentingViewController?.dismiss(animated: true)
        
        NotificationCenter.default.post(name: notiAddHabit, object: nil, userInfo: nil)
    }
    
    @IBAction func btnCancle(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }

    // objects
    let viewContents = UIView()
    let fldHabitName = UITextField()
    var calendar = CustomCalendar(style: .habit, frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let labelRpt = UILabel()
    let viewButton = UIView()
    let btnMon = UIButton()
    let btnTue = UIButton()
    let btnWed = UIButton()
    let btnThu = UIButton()
    let btnFri = UIButton()
    let btnSat = UIButton()
    let btnSun = UIButton()
    let viewInToday = UIView()
    let labelInToday = UILabel()
    let swtInToday = UISwitch()
    //let viewAlram = UIView()
    let labelAlram = UILabel()
    let swtAlram = UISwitch()
    //let viewTime = UIView()
    let labelTime = UILabel()
    let pickerTime = UIDatePicker()
    
    // values
    let widthRate = 0.80
    let heightGap = 20.0
    let textCol = UIColor(named: "TextColor")
    
    
    //functions
    func setLayout() {
        setViewContentsLayout()
        setTextFieldLayout()
        setCalendarLayout()
        setViewButtonLayout()
        setButtonLayout()
        setInTodayLayout()
        setViewInTodayLayout(data.task.inToday)
    }
    
    func setViewContentsLayout() {
        self.view.addSubview(viewContents)
        
        // Contents View Layout
        viewContents.snp.makeConstraints { make in
            make.top.equalTo(nabigationBar.snp.bottom)
            make.width.centerX.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setTextFieldLayout() {
        viewContents.addSubview(fldHabitName)
        
        // Text Field Layout
        fldHabitName.snp.makeConstraints { make in
            make.width.equalTo(viewContents).multipliedBy(widthRate)
            make.centerX.equalTo(viewContents.snp.centerX)
            make.top.equalTo(viewContents.snp.top).offset(30)
            make.height.equalTo(58.0)
        }
        
        fldHabitName.placeholder = "Habit"
        fldHabitName.font = UIFont(name: "GmarketSansTTFLight", size: 40.0)
    }
    
    func setCalendarLayout() {
        let rect = CGRect(x: fldHabitName.frame.minX, y: fldHabitName.frame.maxY + heightGap, width: 300, height: 300)
        calendar = CustomCalendar(style: .month, frame: rect)
        
        setCalendar()
        calendar(self.calendar, boundingRectWillChange: rect, animated: false)
    }
    
    func setCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        viewContents.addSubview(calendar)
        calendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.accessibilityIdentifier = "calendar"
        
        let st = Date.DateForm(data: data.start, input: .fullDate, output: .date) as! Date
        let ed = Date.DateForm(data: data.end, input: .fullDate, output: .date) as! Date
        selectDays(start: st, end: ed)
    }
    
    let heightBtn = 30
    let widthBtn = 24
    func setViewButtonLayout() {
        viewContents.addSubview(viewButton)
        viewContents.addSubview(labelRpt)
        
        labelRpt.text = "반복"
        labelRpt.font = UIFont.systemFont(ofSize: 17)
        labelRpt.textColor = textCol
        labelRpt.snp.makeConstraints { make in
            make.leading.equalTo(calendar.snp.leading).offset(5)
            make.top.equalTo(calendar.snp.bottom).offset(18)
            
        }
        
        viewButton.snp.makeConstraints { make in
            make.width.equalTo(216)
            //make.leading.equalTo(labelRpt.snp.trailing).offset(-10)
            make.trailing.equalTo(calendar.snp.trailing)
            make.height.equalTo(heightBtn)
            //make.centerX.equalToSuperview()
            make.centerY.equalTo(labelRpt.snp.centerY)
        }
        
    }
     
    func setButtonLayout() {
        let arrBtn: [UIButton] = [btnMon, btnTue, btnWed, btnThu, btnFri, btnSat, btnSun]
        let arrTest: [String] = ["월", "화", "수", "목", "금", "토", "일"]
        
        for i in 0...(arrBtn.count-1) {
            viewButton.addSubview(arrBtn[i])
        }
        
        for i in 0...(arrBtn.count-1) {
            let btn: UIButton = arrBtn[i]
            btn.setTitle(arrTest[i], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            btn.layer.cornerRadius = 8.0
            
            let x = ((widthBtn+8) * (i))
            btn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(widthBtn)
                make.height.equalTo(heightBtn)
                make.leading.equalTo(x)
            }
        }
    }
    
    func setInTodayLayout() {
        viewContents.addSubview(labelInToday)
        viewContents.addSubview(swtInToday)
        
        swtInToday.onTintColor = UIColor(named: "BikPik Color")
        swtInToday.snp.makeConstraints { make in
            make.top.equalTo(viewButton.snp.bottom).offset(5)
            make.trailing.equalTo(viewButton.snp.trailing).offset(-3)
            make.height.equalTo(34)
        }
        labelInToday.text = "오늘 동안"
        labelInToday.textColor = textCol
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
            labelAlram.textColor = textCol
            swtAlram.isEnabled = true
        } else {
            labelAlram.textColor = .systemGray2
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
            labelTime.textColor = textCol
            pickerTime.isEnabled = true
            
        } else {
            labelTime.textColor = .systemGray2
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
    
    private func addTarget() {
        let arrBtn: [UIButton] = [btnMon, btnTue, btnWed, btnThu, btnFri, btnSat, btnSun]
        
        swtAlram.addTarget(self, action: #selector(self.actionAlram(_:)), for: .allTouchEvents)
        swtInToday.addTarget(self, action: #selector(self.actionInToday(_:)), for: .allTouchEvents)
        arrBtn.forEach { btn in
            btn.addTarget(self, action: #selector(self.actionBtn(_:)), for: .touchUpInside)
        }
    }
    
    func setSelectBtn() {
        let arrBtn: [UIButton] = [self.btnMon, btnTue, btnWed, btnThu, btnFri, btnSat, btnSun]
        
        for i in 0...(data.days.count-1) {
            let btn = arrBtn[i]
            btn.isSelected = data.days[i]
            
            if btn.isSelected {
                btn.backgroundColor = UIColor(named: "BikPik Color")
                btn.setTitleColor(.white, for: .normal)
            } else {
                btn.backgroundColor = UIColor(named: "BikPik Light Color")
                btn.setTitleColor(.darkGray, for: .normal)
            }
            
        }
    }
    
    @objc func actionBtn(_ sender: UIButton) {
        let arrBtn: [UIButton] = [self.btnMon, btnTue, btnWed, btnThu, btnFri, btnSat, btnSun]
        sender.isSelected.toggle()
        for i in 0...(data.days.count-1) {
            if (sender == arrBtn[i]) {
                data.days[i] = sender.isSelected
                break
            }
        }
        setSelectBtn()
    }
    
    @objc func actionAlram(_ sender: UISwitch) {
        data.task.alram = sender.isOn
    }
    
    @objc func actionInToday(_ sender: UISwitch) {
        data.task.inToday = sender.isOn
        setViewInTodayLayout(sender.isOn)
        if data.task.inToday {
            data.task.time = "00:00"
        } else {
            data.task.time = Date.TimeForm(picker: pickerTime)
        }
    }
}

extension AddHabitViewController: FSCalendarDelegate, FSCalendarDataSource {
    // Need to use SnapKit
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.width.equalTo(bounds.width)
            make.height.equalTo(bounds.height)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(fldHabitName.snp.bottom).offset(heightGap)
        }
    }
    
    // When selected calendar cell
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        setStartEnd(date: date)
        term.toggle()
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        setStartEnd(date: date)
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
     
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func setStartEnd(date: Date) {
        let fullDate: String = Date.DateForm(data: date, input: .date, output: .fullDate) as! String
        deselectDays()
        if (term) { // select multi
            if (data.start > fullDate) {
                data.end = data.start
                data.start = fullDate
                selectDays(start:date , end: Date.DateForm(data: data.end, input: .fullDate, output: .date) as! Date)
            } else {
                data.end = fullDate
                selectDays(start:Date.DateForm(data: data.start, input: .fullDate, output: .date) as! Date , end: date)
            }
        } else {    // select single
            data.start = fullDate
            data.end = fullDate
            selectDays(start:date , end: date)
        }
    }
    
    private func selectDays(start: Date, end: Date) {
        let cnt = Date.GetDays(start: start, end: end)
        let gregorian = Calendar(identifier: .gregorian)
        
        for i in 0..<cnt {
            let next = gregorian.date(byAdding: .day, value: i, to: start)!
            calendar.select(next)
        }
    }
    
    private func deselectDays() {
        calendar.selectedDates.forEach { delete in
            calendar.deselect(delete)
        }
    }
    
    func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = cell as! CustomCalendarCell
        var selectionType = SelectionType.none
        
        if calendar.selectedDates.contains(date) {
            let st = Date.DateForm(data: data.start, input: .fullDate, output: .date) as! Date
            let ed = Date.DateForm(data: data.end, input: .fullDate, output: .date) as! Date
            
            if st == ed {
                selectionType = .single
            } else if date == st {
                selectionType = .leftBorder
            } else if date == ed {
                selectionType = .rightBorder
            } else {
                selectionType = .middle
            }
        }
        else {
            let today = Date.GetNowDate()
            if Date.DateForm(data: date, input: .date, output: .fullDate) as! String == today {
                selectionType = .today
            } else {
                selectionType = .none
            }
        }
        
        diyCell.selectionType = selectionType
        
    }
}
