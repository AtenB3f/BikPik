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
        if data.name != nil && data.name != "" {
            revise = true
            reviseTask = data
            fldTask.text = data.name
            swtToday.isOn = data.inToday
            swtAlram.isOn = data.alram
            //viewCalendar.
            pickerTime.date = Date.GetDateTime(date: data.time)
            pickerDate.date = Date.GetDateDay(date: data.date)
        } else {
            // Data Init
            data.time = Date.GetNowTime()
            pickerDate.date = Date.DateForm(data: data.date, input: .fullDate, output: .date) as! Date
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

        guard let name = fldTask.text else { return }
        guard  name != "" else { return }
        if revise == true {
            mngNoti.removeNotificationTask(task: data)
        }
        
        data.name = name
        
        if data.alram {
            data.notiUUID = mngNoti.createNotificationTask(task: data)
        }
        
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
    

    @IBOutlet weak var contentsView: UIView!

    @IBOutlet weak var fldTask: UITextField!
    @IBAction func fldTask(_ sender: Any) {
    }
    
    @IBOutlet weak var pickerDate: UIDatePicker!
    @IBAction func pickerDate(_ sender: Any) {
        data.date = Date.DateForm(picker: pickerDate)
    }
    
    
    @IBOutlet var viewCalendar: UIView!
    
    @IBOutlet weak var todayStackView: UIStackView!
    @IBOutlet weak var labelInToday: UILabel!
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
    
}

extension AddToDoViewController: FSCalendarDataSource, FSCalendarDelegate{
    
    // MARK:- FSCalendarDataSource
        
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
        
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        //self.configure(cell: cell, for: date, at: position)
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(date)")

    }
}
