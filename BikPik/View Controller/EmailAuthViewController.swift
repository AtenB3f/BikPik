//
//  EmailAuthViewController.swift
//  BikPik
//
//  Created by jihee moon on 2022/02/18.
//

import UIKit
import Firebase

class EmailAuthViewController: UIViewController {
    let mngFirebase = Firebase.mngFirebase
    let mngAccount = AccountManager.mngAccount

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        mngFirebase.authEmail()
    }
    
    private func setLayout() {
        self.view.addSubview(viewContent)
        viewContent.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        viewContent.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.width.height.equalTo(heightButton)
        }
        
        viewContent.addSubview(textEmail)
        textEmail.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(80)
            make.width.equalTo(300)
            make.height.equalTo(140)
        }
        
        viewContent.addSubview(btnRetry)
        btnRetry.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textEmail.snp.bottom).offset(30)
            make.width.equalTo(300)
            make.height.equalTo(heightButton)
        }
        
        viewContent.addSubview(btnOkay)
        btnOkay.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btnRetry.snp.bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(heightButton)
        }
    }
    
    let heightButton = 44.0
    
    let viewContent = UIView()
    let btnClose: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "BikPik Color")
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    let textEmail: UITextView = {
        let text = UITextView()
        text.text = """
        메일을 보내드렸어요.
        
        인증 링크를 클릭한 뒤
        확인 버튼을 눌러주세요.
        """
        text.font = UIFont(name: "GmarketSansTTFLight", size: 24.0)
        text.textColor = UIColor(named: "TextLightColor")
        text.textAlignment = .left
        text.contentMode = .top
        text.sizeToFit()
        return text
    }()
    let btnRetry: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.systemGray4
        button.setTitle("재시도", for: .normal)
        button.layer.cornerRadius = 15.0
        button.addTarget(self, action: #selector(handleRetry), for: .touchUpInside)
        return button
    }()
    let btnOkay: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "BikPik Color")
        button.setTitle("확인", for: .normal)
        button.layer.cornerRadius = 15.0
        button.addTarget(self, action: #selector(handleOkay), for: .touchUpInside)
        return button
    }()
    
    @objc func handleClose() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRetry() {
        mngFirebase.authEmail()
    }
    
    @objc func handleOkay() {
        mngFirebase.reloadUser()
        mngAccount.setEmail(Auth.auth().currentUser?.email)
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "SetProfileVC") as! SetProfileViewController
        profileVC.modalPresentationStyle = .fullScreen
        profileVC.modalTransitionStyle = .coverVertical
        self.present(profileVC, animated: true, completion: nil)
    }
}
