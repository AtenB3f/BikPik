//
//  SideMenuViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/10/13.
//

import UIKit
import SideMenu

class SideMenuViewController: UIViewController {

    let mngAccount = AccountManager.mngAccount
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateAccount()
    }
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBAction func btnSetting(_ sender: Any) {
        let vc = storyboard.self?.instantiateViewController(withIdentifier: "SettingVC") as! SettingViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var btnOpenSource: UIButton!
    @IBAction func btnOpenSource(_ sender: Any) {
        let vc = storyboard.self?.instantiateViewController(withIdentifier: "OpenSourceVC") as! OpenSourceViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    func updateAccount() {
        if let name = mngAccount.account.name {
            labelName.text = name
        } else {
            labelName.text = "로그인 하기"
        }
        
        if let email = mngAccount.account.email {
            labelEmail.text = email
        } else {
            labelEmail.text = "E-mail"
        }
        
    }
}
