//
//  LogInViewController.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/13.
//

import UIKit
import Firebase
import GoogleSignIn

class LogInViewController: UIViewController {
    
    let mngFirebase = Firebase.mngFirebase
    let mngAccount = AccountManager.mngAccount
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    private func setLayout() {
        setContentView()
        setLoginView()
        setButtonView()
    }
    
    // instance
    let heightButton = 40.0
    
    private let buttonClose: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "BikPik Color")
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
    }()
    private let viewScroll = UIScrollView()
    private let viewContent = UIView()
    private let viewBottom = UIView()
    
    private let viewLogin: UIView = {
        let view = UIView()
        return view
    }()
    private let viewButtons: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 14.0
        return view
    }()
    private let labelIntro: UILabel = {
        let label = UILabel()
        label.text = "다른 기기에서도" + "\n" + "할 일을 관리하세요 :)"
        label.textColor = UIColor(named: "TextLightColor")
        label.font = UIFont(name: "GmarketSansTTFLight", size: 24.0)
        label.textAlignment = .left
        label.contentMode = .top
        //label.sizeToFit()
        return label
    }()
    private let idText: UITextField = {
        let text = UITextField()
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 50 , height: 40))
        let left:UIButton = {
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50 , height: 40))
            btn.setImage(UIImage(systemName: "person"), for: .normal)
            return btn
        }()
        text.placeholder = "E-mail"
        text.backgroundColor = UIColor.systemBackground
        text.layer.cornerRadius = 15.0
        text.layer.borderWidth = 1.0
        text.leftView = padding
        text.leftViewMode = UITextField.ViewMode.always
        text.layer.borderColor = UIColor.systemGray5.cgColor
        text.textColor = UIColor(named: "TextLightColor")
        text.addSubview(left)
        return text
    }()
    private let viewPassword = UIView()
    private let passwordText: UITextField = {
        let text = UITextField()
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 50 , height: 40))
        text.placeholder = "Password"
        text.isSecureTextEntry = true
        text.backgroundColor = UIColor.systemBackground
        text.layer.cornerRadius = 15.0
        text.layer.borderWidth = 1.0
        text.leftView = padding
        text.rightView = padding
        text.leftViewMode = .always
        text.rightViewMode = .always
        text.layer.borderColor = UIColor.systemGray5.cgColor
        text.textColor = UIColor(named: "TextLightColor")
        return text
    }()
    private let btnSecure:UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50 , height: 40))
        btn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        btn.addTarget(self, action: #selector(togglePasswordText), for: .touchUpInside)
        return btn
    }()
    private let labelError: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 11.0)
        return label
    }()
    private let loginButton: UIButton = {
       let button = UIButton()
        //button.titleLabel?.font = UIFont(name: "GmarketSansTTFLight", size: 16.0)
        button.setTitle("계속하기", for: .normal)
        button.setTitleColor(UIColor(named: "TextColor"), for: .normal)
        button.backgroundColor = UIColor(named: "BikPik Color")
        button.layer.cornerRadius = 8.0
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    private let labelLinkedLogin: UILabel = {
        let label = UILabel()
        label.text = "SNS로 로그인하기"
        label.textColor = UIColor(named: "TextLightColor")
        label.font = UIFont.systemFont(ofSize: 11.0)
        return label
    }()
    private let googleButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .iconOnly
        button.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        return button
    }()
    
    
    private func setContentView() {
        self.view.addSubview(buttonClose)
        buttonClose.snp.makeConstraints { make in
            make.width.height.equalTo(heightButton)
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        
        self.view.addSubview(viewScroll)
        viewScroll.snp.makeConstraints { make in
            make.bottom.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        viewScroll.addSubview(viewContent)
        viewContent.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.width.equalTo(300)
            make.height.equalTo(380)
        }
        
        viewScroll.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { make in
            make.width.bottom.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalToSuperview().inset(500)
        }
    }
    
    private func setLoginView() {
        viewContent.addSubview(labelIntro)
        labelIntro.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(300)
        }
        
        viewContent.addSubview(viewLogin)
        viewLogin.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(160)
            make.height.width.equalTo(300)
        }
        
        viewLogin.addSubview(idText)
        idText.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightButton)
            make.top.equalToSuperview()
        }
        
        viewLogin.addSubview(viewPassword)
        viewPassword.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.height.equalTo(heightButton)
            make.top.equalTo(idText.snp.bottom).offset(5)
        }
        
        viewPassword.addSubview(passwordText)
        passwordText.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.height.equalTo(0)
        }
        
        viewLogin.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.height.equalTo(heightButton)
            make.top.equalTo(viewPassword.snp.bottom).offset(40)
        }
        
        viewLogin.addSubview(labelError)
        labelError.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(loginButton.snp.top).offset(-6)
        }
        
        viewLogin.addSubview(labelLinkedLogin)
        labelLinkedLogin.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
        
    }
    
    // Set View
    private func setButtonView() {
        viewScroll.addSubview(viewButtons)
        viewButtons.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(viewLogin.snp.bottom).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        // Google Button
        viewButtons.addArrangedSubview(googleButton)
        googleButton.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(heightButton)
        }
         
    }
    
    private func setPasswordView() {
        passwordText.snp.remakeConstraints { make in
            make.height.equalTo(heightButton)
            make.width.equalToSuperview()
        }
        
        let leftImg:UIButton = {
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50 , height: 40))
            btn.setImage(UIImage(systemName: "lock"), for: .normal)
            return btn
        }()
        
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.passwordText.addSubview(leftImg)
            //self.passwordText.rightView = rightImg
            self.passwordText.addSubview(self.btnSecure)
            self.btnSecure.snp.makeConstraints({ make in
                make.right.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
            })
        })
        
    }
    
    // apple, etc ...
    
    // Actons
    @objc func closeView() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleGoogleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            guard error == nil else { return }
            guard
                let authentication = user?.authentication, let idToken = authentication.idToken
            else { return }
            guard let user = user else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil { return }
            }
            
            self.mngAccount.account.email = user.profile?.email
            if self.mngAccount.account.name == nil {
                self.mngAccount.account.name = user.profile?.name
            }
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogin() {
        let id = self.idText.text
        let password = self.passwordText.text
        
        if emailConform(email: id) == false { return }
        
        if mngFirebase.findUser(email: id!, errorHander: setErrorMessage) {
            loginButton.setTitle("로그인", for: .normal)
        } else {
            loginButton.setTitle("회원가입 하기", for: .normal)
        }
        
        if password == "" {
            // 이메일 검사
            // 패스워드 창 보여주기
            setPasswordView()
        } else {
            // 로그인 혹은 회원가입
            if passwordConform(password: password) == false { return }
            
            mngFirebase.createUser(email: id!, password: password!)
        }
    }
    
    @objc func togglePasswordText() {
        self.passwordText.isSecureTextEntry.toggle()
        if self.passwordText.isSecureTextEntry {
            btnSecure.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            btnSecure.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    private func emailConform(email:String?)->Bool {
        let emailForm = { (_ email: String)->Bool in
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
        
        if email == "" || email == nil{
            self.idText.layer.borderColor = UIColor.red.cgColor
            self.labelError.text = "이메일을 입력하세요."
            return false
        } else if emailForm(email!) == false {
            self.idText.layer.borderColor = UIColor.red.cgColor
            self.labelError.text = "이메일 형식이 아닙니다."
            return false
        } else {
            self.idText.layer.borderColor = UIColor.systemGray5.cgColor
            self.labelError.text = ""
            return true
        }
    }
    
    private func passwordConform(password:String?)->Bool {
        if password == "" || password == nil {
            self.passwordText.layer.borderColor = UIColor.red.cgColor
            self.labelError.text = "비밀번호를 입력하세요."
            return false
        } else if password!.count < 6{
            self.passwordText.layer.borderColor = UIColor.red.cgColor
            self.labelError.text = "6자리 이상의 비밀번호를 설정해주세요."
            return false
        } else {
            self.passwordText.layer.borderColor = UIColor.systemGray5.cgColor
            self.labelError.text = ""
            return true
        }
    }
    
    func setErrorMessage(str: String) {
        labelError.text = str
    }
}
