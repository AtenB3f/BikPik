//
//  SideMenuViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/10/13.
//

import UIKit
import SideMenu

class SideMenuViewController: UIViewController {
    let mngFirebase = Firebase.mngFirebase
    let mngAccount = AccountManager.mngAccount
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mngAccount.account.bind(listener: {_ in
            self.updateAccount()
        })
        
        BtnName.titleLabel?.font = UIFont(name: "GmarketSansTTFLight", size: 30.0)
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
    
    @IBOutlet weak var BtnName: UIButton!
    @IBOutlet weak var BtnEmail: UIButton!
    
    @IBAction func tapButton(_ sender: Any) {
        var vc: UIViewController? = nil
        if mngAccount.account.value.email == nil {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
        } else if !mngFirebase.isAuthEmailVerified() {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailAuthVC") as! EmailAuthViewController
        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountViewController
        }
        vc!.modalPresentationStyle = .fullScreen
        vc!.modalTransitionStyle = .crossDissolve
        present(vc!, animated: true, completion: nil)
    }
    
    func updateAccount() {
        if let name = mngAccount.account.value.name {
            BtnName.setTitle(name, for: .normal)
        } else {
            BtnName.setTitle("로그인 하기", for: .normal)
        }
        
        if let email = mngAccount.account.value.email {
            BtnEmail.setTitle(email, for: .normal)
        } else {
            BtnEmail.setTitle("Email", for: .normal)
        }
        
    }
}
