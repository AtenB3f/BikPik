//
//  AddToDoViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/05.
//

import UIKit

class AddToDoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDate.layer.cornerRadius = 5
        //viewDate.layer.borderWidth = 4
        viewDate.layer.backgroundColor = UIColor.lightGray.cgColor
        
        viewTimeSel.layer.cornerRadius = 5
        //viewTimeSel.layer.borderWidth = 4
        viewTimeSel.layer.backgroundColor = UIColor.lightGray.cgColor
        
        viewStart.layer.cornerRadius = 5
        viewStart.layer.backgroundColor = UIColor.lightGray.cgColor
        
        viewEnd.layer.cornerRadius = 5
        viewEnd.layer.backgroundColor = UIColor.lightGray.cgColor
    }
    
    // Navigation Add Task
    @IBOutlet weak var navigationAddTask: UINavigationBar!
    @IBAction func btnCancle(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBAction func btnAdd(_ sender: Any) {
        // 데이터 전달 및 저장
    }
    
    // Scroll View
    
    @IBAction func fldTask(_ sender: Any) {
    }
    
    
    @IBOutlet weak var swtToday: UISwitch!
    @IBAction func swtToday(_ sender: Any) {
        if swtToday.isOn {
            
        }
    }
    
    
    @IBOutlet weak var viewTimeSel: UIView!
    
    
    @IBOutlet weak var swtRepeat: UISwitch!
    @IBAction func swtRepeat(_ sender: Any) {
    }
    
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewStart: UIView!
    @IBOutlet weak var viewEnd: UIView!
    
    @IBOutlet weak var swtAlram: UISwitch!
    @IBAction func swtAlram(_ sender: Any) {
    }
}
