//
//  SetProfileViewController.swift
//  BikPik
//
//  Created by jihee moon on 2022/02/17.
//

import UIKit

class SetProfileViewController: UIViewController {
    let mngAccount = AccountManager.mngAccount
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        if let name = mngAccount.account.value.name {
            textName.text = name
        }
        textName.becomeFirstResponder()
    }
    
    let heightBtn = 44.0

    let viewContent = UIView()
    let btnClose: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "BikPik Color")
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    let labelProfile: UILabel = {
        let label = UILabel()
        label.text = "프로필 설정하기"
        return label
    }()
    let textName: UITextField = {
        let text = UITextField()
        let font = UIFont(name: "GmarketSansTTFLight", size: 24.0)
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        let line = UIView(frame: CGRect(x: 0, y: 42, width: 300, height: 2))
        line.backgroundColor = UIColor(named: "BikPik Color")
        text.font = font
        text.placeholder = "이름을 설정해주세요"
        text.leftView = padding
        text.leftViewMode = .always
        text.addSubview(line)
        return text
    }()
    let btnSet: UIButton = {
        let button = UIButton()
        button.setTitle("설정하기", for: .normal)
        button.tintColor = UIColor(named: "BikPik Color")
        button.backgroundColor = UIColor(named: "BikPik Color")
        button.layer.cornerRadius = 15.0
        button.addTarget(self, action: #selector(handleSet), for: .touchUpInside)
        return button
    }()
    
    private func setLayout() {
        self.view.addSubview(viewContent)
        viewContent.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        viewContent.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.width.height.equalTo(heightBtn)
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        viewContent.addSubview(labelProfile)
        labelProfile.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(btnClose.snp.centerY)
        }
        
        viewContent.addSubview(textName)
        textName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(heightBtn)
            make.top.equalToSuperview().inset(80)
        }
        
        viewContent.addSubview(btnSet)
        btnSet.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(heightBtn)
            make.top.equalTo(textName.snp.bottom).offset(10)
        }
    }
    
    @objc func handleClose() {
        // move root view
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    @objc func handleSet() {
        guard let name = textName.text == "" ? nil : textName.text else { return }
        mngAccount.setName(name: name)
        handleClose()
    }
}
