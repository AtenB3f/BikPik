//
//  AddToDoViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/05.
//

import UIKit

let AddToDoVC: Notification.Name = Notification.Name("AddToDoVC")

class AddToDoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Radius Settings
        viewDate.layer.cornerRadius = 10
        viewTimeSel.layer.cornerRadius = 10
        viewStart.layer.cornerRadius = 10
        viewEnd.layer.cornerRadius = 10
        btnRepeatAll.layer.cornerRadius = 6
        btnRepeatMon.layer.cornerRadius = 6
        btnRepeatTue.layer.cornerRadius = 6
        btnRepeatWed.layer.cornerRadius = 6
        btnRepeatThu.layer.cornerRadius = 6
        btnRepeatFri.layer.cornerRadius = 6
        btnRepeatSat.layer.cornerRadius = 6
        btnRepeatSun.layer.cornerRadius = 6
        
        // view 초기 접기
        //viewDate.frame.size.height = CGFloat(0)
        
        // Data Init
        data.date = Date.FullNowDate()
        data.time = Date.NowTime()
        data.start = Date.FullNowDate()
        data.end = Date.FullNowDate()
        
        timePicker.frame.size.height = 0
        viewTimeSel.frame.size.height = 0
    }
    
    var data: Task! = Task()
    
    // Navigation Cancle
    @IBOutlet weak var navigationAddTask: UINavigationBar!
    @IBAction func btnCancle(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    // Navigation Add
    let managerToDo = ToDoManager.managerToDo
    @IBAction func btnAdd(_ sender: Any) {

        guard let name = fldTask.text else { return }
        
        data.name = name
        
        // Save Data
        managerToDo.CreateTask(&data)
        
        // Back to To Do LIst Page
        self.presentingViewController?.dismiss(animated: true)
        
        NotificationCenter.default.post(name: AddToDoVC, object: nil, userInfo: nil)
    }
    
    
    @IBOutlet weak var fldTask: UITextField!
    // Scroll View
    @IBAction func fldTask(_ sender: Any) {
    }
    
    
    @IBOutlet weak var swtToday: UISwitch!
    @IBOutlet weak var viewTimeSel: UIView!
    @IBAction func swtToday(_ sender: Any) {
        data.inToday = swtToday.isOn
        if swtToday.isOn {
            // viewTimeSel open
            
            //var size: CGRect = viewTimeSel.frame
            viewTimeSel.frame.size.height = 100
            timePicker.frame.size.height = 60
            
            data.time = "00:00"
        } else {
            timePicker.frame.size.height = 0
            viewTimeSel.frame.size.height = 0
            
            data.time = Date.TimeForm(timePicker)
        }
    }
        
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBAction func timePicker(_ sender: Any) {
        data.date = Date.DateForm(timePicker)
        data.time = Date.TimeForm(timePicker)
    }
    
    @IBOutlet weak var swtRepeat: UISwitch!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewStart: UIView!
    @IBOutlet weak var viewEnd: UIView!
    @IBAction func swtRepeat(_ sender: Any) {
        //let width = viewDate.frame.size.width
        data.habit = swtRepeat.isOn
        if swtRepeat.isOn {
            // viewDate Open
            
        } else {
            //viewDate.frame.size.height = 0.0
        }
    }
    
    // Select Start, End Day
    @IBOutlet weak var startPicker: UIDatePicker!
    @IBAction func startPicker(_ sender: Any) {
        data.start = Date.DateForm(startPicker)
    }
    @IBOutlet weak var endPicker: UIDatePicker!
    @IBAction func endPicker(_ sender: Any) {
        data.end = Date.DateForm(endPicker)
    }
    
    // Select Repeat Days
    @IBOutlet weak var btnRepeatAll: UIButton!
    @IBOutlet weak var btnRepeatMon: UIButton!
    @IBOutlet weak var btnRepeatTue: UIButton!
    @IBOutlet weak var btnRepeatWed: UIButton!
    @IBOutlet weak var btnRepeatThu: UIButton!
    @IBOutlet weak var btnRepeatFri: UIButton!
    @IBOutlet weak var btnRepeatSat: UIButton!
    @IBOutlet weak var btnRepeatSun: UIButton!
    
    @IBAction func btnRepeat(_ btn: UIButton) {
        // toggle switch
        data.rptDay[btn.tag] = data.rptDay[btn.tag] ? false : true
        
        if data.rptDay[btn.tag] {
            btn.layer.backgroundColor = UIColor.init(named: "BikPik Color")?.cgColor
        }
        else {
            btn.layer.backgroundColor = UIColor.init(named: "Background Color")?.cgColor
        }
        
    }
    
    // Button Alram
    @IBOutlet weak var swtAlram: UISwitch!
    @IBAction func swtAlram(_ sender: Any) {
        data.alram = swtAlram.isOn
    }
}
