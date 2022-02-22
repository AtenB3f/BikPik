//
//  AccountViewController.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/19.
//

import UIKit

class AccountViewController: UIViewController {
    
    let mngAccount = AccountManager.mngAccount
    let mngFirebase = Firebase.mngFirebase

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        addTarget()
        
        mngAccount.account.bind(listener: { [weak self] account in
            if self?.correctName == false {
                self?.btnName.setTitle(account.name, for: .normal)
            }
            self?.btnEmail.setTitle(account.email, for: .normal)
        })
    }
    
    let heightContent = 44.0
    let padding = 20.0
    var correctName = false
    
    let viewContent: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0.0
        view.distribution = .fill
        return view
    }()
    let btnClose: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = UIColor(named: "BikPik Color")
        button.addTarget(self, action: #selector(actionClose), for: .touchUpInside)
        return button
    }()
    let viewName = UIView()
    let labelName: UILabel = {
        let label = UILabel()
        label.text = "이름"
        return label
    }()
    let btnName: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "BikPik Color")
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(actionCorrectName), for: .touchUpInside)
        return button
    }()
    let viewNameFld = UIView()
    let fldName:UITextField = {
        let text = UITextField()
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44.0))
        text.backgroundColor = UIColor(named: "BikPik Light Color")
        text.layer.cornerRadius = 15.0
        text.leftView = padding
        text.rightView = padding
        text.leftViewMode = .always
        text.rightViewMode = .always
        return text
    }()
    let btnSave:UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(UIColor(named: "BikPik Color"), for: .normal)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(actionSave), for: .touchUpInside)
        return button
    }()
    let viewEmail:UIView = {
        let view = UIView()
        return view
    }()
    let labelEmail:UILabel = {
        let label = UILabel()
        label.text = "연동된 이메일"
        return label
    }()
    let btnEmail:UIButton = {
        let button = UIButton()
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.contentHorizontalAlignment = .right
        return button
    }()
    let viewLogout = UIView()
    let labelLogout:UILabel = {
        let label = UILabel()
        label.text = "로그아웃"
        return label
    }()
    let btnLogout:UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "BikPik Color")
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(actionLogout), for: .touchUpInside)
        return button
    }()
    let viewDeleteUser = UIView()
    let labelDeleteUser:UILabel = {
        let label = UILabel()
        label.text = "회원탈퇴"
        return label
    }()
    let btnDeleteUser: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = UIColor(named: "BikPik Color")
        button.addTarget(self, action: #selector(actionDeleteUser), for: .touchUpInside)
        return button
    }()
    let viewBottom = UIView()
    
    private func setLayout() {
        setLayoutContent()
        setLayoutName()
        setLayoutCorrectName(false)
        setLayoutEmail()
        setLayoutLogout()
        setLayoutDeleteUser()
    }
    
    private func setLayoutContent() {
        self.view.addSubview(viewContent)
        viewContent.snp.remakeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        viewContent.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.left.top.equalToSuperview().inset(16)
        }
        
        viewContent.addArrangedSubview(viewName)
        viewName.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightContent)
        }
        
        viewContent.addArrangedSubview(viewNameFld)
        viewNameFld.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(0)
        }
        
        viewContent.addArrangedSubview(viewEmail)
        viewEmail.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightContent)
        }
        
        viewContent.addArrangedSubview(viewLogout)
        viewLogout.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightContent)
        }
        
        viewContent.addArrangedSubview(viewDeleteUser)
        viewDeleteUser.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightContent)
        }
        
        viewContent.addArrangedSubview(viewBottom)
        viewBottom.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightContent)
        }
    }
    
    // Name Set
    private func setLayoutName() {
        viewName.addSubview(labelName)
        labelName.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(padding)
            make.width.equalTo(100)
            make.height.equalTo(heightContent)
            make.top.equalToSuperview()
        }
        
        viewName.addSubview(btnName)
        btnName.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(heightContent)
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(padding)
        }
    }
    
    private func setLayoutCorrectName(_ open:Bool) {
        viewNameFld.addSubview(fldName)
        viewNameFld.addSubview(btnSave)
    
        viewNameFld.snp.remakeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(open ? heightContent : 0)
        }
        
        fldName.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(86)
            make.height.equalTo(open ? heightContent : 0)
        }
        btnSave.snp.remakeConstraints { make in
            make.right.equalToSuperview().inset(36)
            make.width.equalTo(70)
            make.height.equalTo(open ? heightContent : 0)
        }
    }
    
    // Email Set
    private func setLayoutEmail() {
        
        viewEmail.addSubview(labelEmail)
        labelEmail.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.width.equalTo(150)
            make.height.equalTo(heightContent)
            make.top.equalToSuperview()
        }
        
        viewEmail.addSubview(btnEmail)
        btnEmail.snp.makeConstraints { make in
            make.height.equalTo(heightContent)
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(padding)
        }
    }
    
    private func setLayoutLogout() {
        viewLogout.addSubview(labelLogout)
        labelLogout.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            //make.width.equalTo(100)
            make.height.equalTo(heightContent)
            make.top.equalToSuperview()
        }
        
        viewLogout.addSubview(btnLogout)
        btnLogout.snp.makeConstraints { make in
            make.height.equalTo(heightContent)
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(padding)
        }
    }
    
    private func setLayoutDeleteUser() {
        viewDeleteUser.addSubview(labelDeleteUser)
        labelDeleteUser.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.height.equalTo(heightContent)
            make.top.equalToSuperview()
        }
        
        viewDeleteUser.addSubview(btnDeleteUser)
        btnDeleteUser.snp.makeConstraints { make in
            make.height.equalTo(heightContent)
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(padding)
        }
    }
    
    private func addTarget() {
        viewName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionCorrectName)))
        viewLogout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionLogout)))
        viewDeleteUser.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionDeleteUser)))
    }
    @objc private func actionClose() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @objc private func actionSave() {
        mngAccount.setName(name: fldName.text)
        actionCorrectName()
        self.btnName.setTitle(self.mngAccount.account.value.name, for: .normal)
    }
    @objc private func actionLogout() {
        let alert = UIAlertController(title:mngAccount.account.value.email , message: "로그아웃 합니다.", preferredStyle: .alert)
        let logout = UIAlertAction(title: "로그아웃", style: .destructive, handler: {action in self.presentingViewController?.dismiss(animated: true, completion: {
            self.mngAccount.loadAccount()
            })
        })
        let cancle = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(logout)
        alert.addAction(cancle)
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func actionCorrectName() {
        correctName.toggle()
        
        if correctName == false {
            self.btnSave.setTitle("", for: .normal)
            self.fldName.text = ""
        }
        
        setLayoutCorrectName(correctName)
        
        UIView.animate(withDuration: 0.6, animations: {
            self.viewContent.layoutIfNeeded()
        }, completion: {_ in
            if self.correctName {
                self.becomeFirstResponder()
                self.fldName.text = self.mngAccount.account.value.name
                self.btnSave.setTitle("Save", for: .normal)
            }
        })
    }
    @objc private func actionDeleteUser() {
        let alert = UIAlertController(title:mngAccount.account.value.email , message: "탈퇴를 진행할 경우 서버의 데이터는 삭제됩니다.", preferredStyle: .alert)
        let logout = UIAlertAction(title: "회원탈퇴", style: .destructive, handler: {action in self.presentingViewController?.dismiss(animated: true, completion: {
            self.mngAccount.deleteAccount()
            })
        })
        let cancle = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(logout)
        alert.addAction(cancle)
        self.present(alert, animated: true, completion: nil)
    }
}
