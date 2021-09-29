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
        
        if data.name != nil && data.name != "" {
            revise = true
            reviseTask = data
            fldTask.text = data.name
            swtToday.isOn = data.inToday
            swtAlram.isOn = data.alram
            pickerTime.date = Date.GetDateTime(date: data.time)
            pickerDate.date = Date.GetDateDay(date: data.date)
        } else {
            // Data Init
            data.date = Date.GetNowDate()
            data.time = Date.GetNowTime()
        }
    }
    
    var data: Task = Task()
    var revise: Bool = false
    var reviseTask :Task?	
    
    // Navigation Cancle
    @IBOutlet weak var navigationAddTask: UINavigationBar!
    @IBAction func btnCancle(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    // Navigation Add
    let managerToDo = ToDoManager.mngToDo
    @IBAction func btnAdd(_ sender: Any) {

        guard let name = fldTask.text else { return }
        guard  name != "" else { return }
        
        data.name = name
        if revise == true {
            managerToDo.correctTask(before: reviseTask ?? Task() , after: data)
        } else {
            // Save Data
            managerToDo.createTask(data: &data)
        }
        
        // Back to To Do LIst Page
        self.presentingViewController?.dismiss(animated: true)
        
        NotificationCenter.default.post(name: AddToDoVC, object: nil, userInfo: nil)
    }
    

    @IBOutlet weak var contentsView: UIView!

    @IBOutlet weak var fldTask: UITextField!
    @IBAction func fldTask(_ sender: Any) {
    }
    
    @IBOutlet weak var pickerDate: UIDatePicker!
    @IBAction func pickerDate(_ sender: Any) {
        data.date = Date.DateForm(picker: pickerDate)
    }
    
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
        print("alram")
        if swtAlram.isOn {
            // 알람 설정
        } else {
            // 알람 해제
        }
    }
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBAction func pickerTime(_ sender: Any) {
        data.time = Date.TimeForm(picker: pickerTime)
    }
}
