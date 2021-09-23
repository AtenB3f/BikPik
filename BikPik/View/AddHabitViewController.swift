//
//  AddHabitViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/09/01.
//

import UIKit

let AddHabitVC: Notification.Name = Notification.Name("AddHabitVC")

class AddHabitViewController: UIViewController {
    
    let mngHabit = HabitManager.mngHabit
    var data: Habits = Habits()
    var revise : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calurateTotal()
        if data.task.name == nil {
            data = Habits()
        } else {
            revise = true
            fldHabit.text = data.task.name
            startDatePicker.date = Date.GetDateDay(date: data.start)
            endDatePicker.date = Date.GetDateDay(date: data.end)
            let arrBtn: [UIButton] = [btnMon, btnTue, btnWed, btnThu, btnFri, btnSat, btnSun]
            for n in 0...(data.days.count-1) {
                arrBtn[n].isSelected = data.days[n]
            }
            swtToday.isOn = data.task.inToday
            swtAlram.isOn = data.task.alram
            timePicker.date = Date.GetDateTime(date: data.task.time)
        }
    }
    
    
    
    @IBOutlet weak var nabigationBar: UINavigationBar!
    @IBAction func btnAdd(_ sender: Any) {
        
        if data.task.name == "", data.task.name == nil { return }
        
        var id :Int?
        if revise {
            id = mngHabit.habitId[data.task.name!]
            if id == nil { return }
        }
        
        data.task.name = fldHabit.text
        data.task.time = Date.TimeForm(timePicker)
        data.start = Date.DateForm(startDatePicker)
        data.end = Date.DateForm(endDatePicker)
        data.isDone = [Bool](repeating: false, count: data.total)
        
        if revise == true {
            mngHabit.reviseHabit(id: id!, habit: data)
        } else {
            if mngHabit.habitId[data.task.name!] != nil { return }
            mngHabit.createHabit(data)
        }
        
        self.presentingViewController?.dismiss(animated: true)
        
        NotificationCenter.default.post(name: AddHabitVC, object: nil, userInfo: nil)
    }
    
    @IBAction func btnCancle(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    @IBOutlet weak var fldHabit: UITextField!
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBAction func pickDate(_ sender: UIDatePicker) {
        if sender == startDatePicker {
            endDatePicker.minimumDate = sender.date
        } else if sender == endDatePicker {
            startDatePicker.maximumDate = sender.date
        }
        calurateTotal()
    }
    
    func calurateTotal() {
        let arrBtn: [UIButton] = [btnMon, btnTue, btnWed, btnThu, btnFri, btnSat, btnSun]
        var total = 0
        for n in 0...6 {
            if arrBtn[n].isSelected == true {
                total += Date.GetWeekDays(start: startDatePicker.date, end: endDatePicker.date, week: n+1)
            }
        }
        data.total = total
    }
    
    @IBOutlet weak var btnMon: UIButton!
    @IBOutlet weak var btnTue: UIButton!
    @IBOutlet weak var btnWed: UIButton!
    @IBOutlet weak var btnThu: UIButton!
    @IBOutlet weak var btnFri: UIButton!
    @IBOutlet weak var btnSat: UIButton!
    @IBOutlet weak var btnSun: UIButton!
    
    @IBAction func btnDay(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        let arrBtn: [UIButton] = [btnMon, btnTue, btnWed, btnThu, btnFri, btnSat, btnSun]
        
        for n in 0 ... 6 {
            if arrBtn[n] == sender {
                data.days[n] = sender.isSelected
            }
        }
        calurateTotal()
    }
    
    @IBOutlet weak var swtToday: UISwitch!
    @IBAction func swtToday(_ sender: Any) {
        if swtToday.isOn {
            swtAlram.isEnabled = false
            timePicker.isEnabled = false
        } else {
            swtAlram.isEnabled = true
            timePicker.isEnabled = true
        }
        data.task.inToday = swtToday.isOn
    }
    
    @IBOutlet weak var swtAlram: UISwitch!
    @IBAction func swtAlram(_ sender: Any) {
        data.task.alram = swtAlram.isOn
    }
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
}
