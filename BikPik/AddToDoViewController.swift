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
    
    
    @IBOutlet weak var btnRepeatAll: UIButton!
    @IBOutlet weak var btnRepeatMon: UIButton!
    @IBOutlet weak var btnRepeatTue: UIButton!
    @IBOutlet weak var btnRepeatWed: UIButton!
    @IBOutlet weak var btnRepeatThu: UIButton!
    @IBOutlet weak var btnRepeatFri: UIButton!
    @IBOutlet weak var btnRepeatSat: UIButton!
    @IBOutlet weak var btnRepeatSun: UIButton!
    
    
    var btnRepeatSel = [Bool](repeating: false, count: 8)
    @IBAction func btnRepeat(_ btn: UIButton) {
        btnRepeatSel[btn.tag] = btnRepeatSel[btn.tag] ? false : true
        
        if btnRepeatSel[btn.tag] {
            btn.layer.backgroundColor = UIColor.init(named: "BikPik Color")?.cgColor
        }
        else {
            btn.layer.backgroundColor = UIColor.init(named: "Background Color")?.cgColor
        }
        
    }
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewStart: UIView!
    @IBOutlet weak var viewEnd: UIView!
    
    @IBOutlet weak var swtAlram: UISwitch!
    @IBAction func swtAlram(_ sender: Any) {
    }
}
