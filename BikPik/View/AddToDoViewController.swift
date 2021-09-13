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
    
    var data: Task = Task()
    
    func setLayout() {
        
    }
    
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
        
        // Save Data
        managerToDo.createTask(&data)
        
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
        data.date = Date.DateForm(pickerDate)
    }
    
    @IBOutlet weak var todayStackView: UIStackView!
    @IBOutlet weak var labelInToday: UILabel!
    @IBOutlet weak var swtToday: UISwitch!
    @IBAction func swtToday(_ sender: Any) {
        data.inToday = swtToday.isOn
        if swtToday.isOn {
            data.time = "00:00"
            // pickerTime, swtAlram 비활성화
            
        } else {
            data.time = Date.TimeForm(pickerTime)
            // pickerTime, swtAlram 활성화
        }
    }
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBAction func pickerTime(_ sender: Any) {
        data.time = Date.TimeForm(pickerTime)
        print("time")
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
}
