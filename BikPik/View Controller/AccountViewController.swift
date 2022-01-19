//
//  AccountViewController.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/19.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    @IBAction func navigationClose(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    let viewContent = UIStackView()
    let viewName = UIView()
    let fldName = UITextField()
    let viewEmail = UIView()
    let labelEmail = UILabel()
    let btnEmail = UIButton()
    let viewLogout = UIView()
    let labelLogout = UILabel()
    let btnLogout = UIButton()
    
    let heightContent = 44.0
    let spacing = 10.0
    
    private func setLayout() {
        self.view.addSubview(viewContent)
        viewContent.snp.makeConstraints { make in
            make.width.height.centerX.centerY.equalTo(self.view.safeAreaInsets)
        }
        viewContent.axis = .vertical
        viewContent.spacing = spacing
        viewContent.distribution = .fillEqually
        
        setLayoutName()
        setLayoutEmail()
        setLayoutLogout()
    }
    
    private func setLayoutName() {
        viewContent.addSubview(viewName)
        viewName.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightContent)
        }
        viewName.backgroundColor = .yellow
    }
    
    private func setLayoutEmail() {
        viewContent.addSubview(viewEmail)
        viewEmail.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightContent)
        }
        viewEmail.backgroundColor = .blue
    }
    
    private func setLayoutLogout() {
        viewContent.addSubview(viewLogout)
        viewLogout.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightContent)
        }
        viewLogout.backgroundColor = .red
    }
}
