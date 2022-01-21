//
//  AccountViewController.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/19.
//

import UIKit

class AccountViewController: UIViewController {
    
    let mngAccount = AccountManager.mngAccount

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBAction func navigationClose(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    let viewContent = UIStackView()
    let viewName = UIView()
    let labelName = UILabel()
    let btnName = UIButton()
    let fldName = UITextField()
    let viewEmail = UIView()
    let labelEmail = UILabel()
    let btnEmail = UIButton()
    let viewLogout = UIView()
    let labelLogout = UILabel()
    let btnLogout = UIButton()
    
    var countContent = 3
    let heightContent = 44.0
    let spacing = 0.0
    let leading = 20.0
    var correctName = false
    
    private func setLayout() {
        self.view.addSubview(viewContent)
        viewContent.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(40)
            make.width.centerX.equalTo(self.view.safeAreaLayoutGuide)
            countContent = correctName ? 4 : 3
            let height = (Double(countContent) * heightContent) + (Double(countContent-1) * spacing)
            make.height.equalTo(height)
        }
        viewContent.axis = .vertical
        viewContent.spacing = spacing
        viewContent.distribution = .fillProportionally
        
        setLayoutName()
        setFldName()
        setLayoutEmail()
        setLayoutLogout()
        
    }
    
    // Name Set
    private func setLayoutName() {
        setViewName()
        setLabelName()
        setButtonName()
    }
    
    private func setViewName() {
        viewContent.addArrangedSubview(viewName)
        viewName.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            let height = correctName ? heightContent*2+spacing : heightContent
            make.height.equalTo(height)
        }
    }
    
    private func setLabelName() {
        viewName.addSubview(labelName)
        setMenuLabel(label: labelName, text: "이름")
    }
    
    private func setButtonName() {
        viewName.addSubview(btnName)
        //setValueButton(button: btnName, text: mngAccount.account.nickName)
        setValueButton(button: btnName, text: "yopret", onImage: true)
    }
    
    private func setFldName() {
        if correctName {
            viewName.addSubview(fldName)
            fldName.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.leading.equalTo(labelName.snp.trailing).offset(leading)
                make.trailing.equalToSuperview().offset(-leading)
                make.height.equalTo(heightContent)
            }
        } else {
            for view in viewName.subviews {
                if view == fldName {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    // Email Set
    private func setLayoutEmail() {
        viewContent.addArrangedSubview(viewEmail)
        viewEmail.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightContent)
        }
        
        setLabelEmail()
        setButtonEmail()
    }
    
    private func setLabelEmail() {
        viewEmail.addSubview(labelEmail)
        setMenuLabel(label: labelEmail, text: "연동된 이메일")
    }
    
    private func setButtonEmail() {
        viewEmail.addSubview(btnEmail)
        setValueButton(button: btnEmail, text: mngAccount.account.email, onImage: false)
    }
    
    private func setLayoutLogout() {
        viewContent.addArrangedSubview(viewLogout)
        viewLogout.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightContent)
        }
        
        viewLogout.addSubview(labelLogout)
        labelLogout.textColor = .red
        setMenuLabel(label: labelLogout, text: "로그아웃")
        
        viewLogout.addSubview(btnLogout)
        setValueButton(button: btnLogout, text: nil, onImage: true)
    }
    
    private func setMenuLabel(label: UILabel, text: String) {
        label.text = text
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leading)
            make.width.equalTo(100)
            make.height.equalTo(heightContent)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setValueButton(button : UIButton, text: String?, onImage: Bool) {
        // Image Set
        if onImage {
            button.tintColor = UIColor(named: "BikPik Color")
            button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
        }
        
        // Text Set
        button.setTitle(text, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        button.contentHorizontalAlignment = .right
        button.snp.makeConstraints { make in
            make.height.equalTo(heightContent)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-leading)
        }
    }
}
