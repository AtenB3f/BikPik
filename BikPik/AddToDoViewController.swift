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
        
        setLayout()
        
        // Data Init
        data.date = Date.FullNowDate()
        data.time = Date.NowTime()
        
    }
    
    
    func setLayout() {
        //fldTask.translatesAutoresizingMaskIntoConstraints = true
        //fldTask.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive =  true
        //fldTask.widthAnchor.constraint(equalTo: contentsView.widthAnchor, multiplier: 0.4 ).isActive = true
        //fldTask.widthAnchor.constraint(equalTo: fldTask.superview?.widthAnchor ?? view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        
        //fldTask.topAnchor.constraint(equalTo: navigationAddTask.bottomAnchor , constant: 30).isActive = true
        
        todayStackView.translatesAutoresizingMaskIntoConstraints = true
        todayStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        viewTimeSel.translatesAutoresizingMaskIntoConstraints = true
        viewTimeSel.topAnchor.constraint(equalTo: todayStackView.bottomAnchor, constant: 20).isActive = true
        viewTimeSel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        //viewTimeSel.widthAnchor.constraint(equalTo: todayStackView.widthAnchor, multiplier: 2.0).isActive = true
        
        timePicker.translatesAutoresizingMaskIntoConstraints = true
        timePicker.trailingAnchor.constraint(equalTo: viewTimeSel.trailingAnchor, constant: 10.0).isActive = true
        
        viewAlram.translatesAutoresizingMaskIntoConstraints = true
        viewAlram.centerXAnchor.constraint(equalTo: viewTimeSel.centerXAnchor).isActive = true
        
        // Radius Settings
        viewTimeSel.layer.cornerRadius = 10

        
        timeSelViewSize = viewTimeSel.frame
        print("FRAME SIZE IS \(timeSelViewSize)")
    }
    
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
        managerToDo.createTask(&data)
        
        // Back to To Do LIst Page
        self.presentingViewController?.dismiss(animated: true)
        
        NotificationCenter.default.post(name: AddToDoVC, object: nil, userInfo: nil)
    }
    

    @IBOutlet weak var contentsView: UIView!
    
    // timeSelView size copy
    var timeSelViewSize: CGRect? = nil
    var data: Task! = Task()
    
    
    @IBOutlet weak var fldTask: UITextField!
    // Scroll View
    @IBAction func fldTask(_ sender: Any) {
    }
    
    @IBOutlet weak var todayStackView: UIStackView!
    @IBOutlet weak var swtToday: UISwitch!
    @IBOutlet weak var viewTimeSel: UIView!
    @IBAction func swtToday(_ sender: Any) {
        data.inToday = swtToday.isOn
        if swtToday.isOn {
            data.time = "00:00"
            closeSetTimeView()
        } else {
            data.time = Date.TimeForm(timePicker)
            openSetTimeView()
        }
        
        print(viewTimeSel.frame)
    }
    
    func openSetTimeView() {
        // setTimeView height = ??
        // TimePicker height = ??
        // Alram height = ??
        
        let sizeH: CGFloat = 110.0
        viewTimeSel.frame.origin = timeSelViewSize!.origin
        viewTimeSel.frame.size.height = sizeH
        contentsView.addSubview(viewTimeSel)
        timePicker.frame.size.height = 30.0
        contentsView.addSubview(timePicker)
        
    }
    
    func closeSetTimeView() {
        // setTimeView height = 0
        // TimePicker height = 0
        // Alram height = 0
        let sizeH: CGFloat = 0.0
        viewTimeSel.frame.origin = timeSelViewSize!.origin
        viewTimeSel.frame.size.height = sizeH
        contentsView.addSubview(viewTimeSel)
        timePicker.frame.size.height = sizeH
        contentsView.addSubview(timePicker)
    }
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBAction func timePicker(_ sender: Any) {
        data.date = Date.DateForm(timePicker)
        data.time = Date.TimeForm(timePicker)
    }
    
    @IBOutlet weak var viewAlram: UIStackView!
    // Button Alram
    @IBOutlet weak var swtAlram: UISwitch!
    @IBAction func swtAlram(_ sender: Any) {
        data.alram = swtAlram.isOn
    }
    
    /*
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
 */
}
