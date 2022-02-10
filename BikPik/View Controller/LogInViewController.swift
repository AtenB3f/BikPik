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

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBAction func navigationClose(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
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
    private let passwordText: UITextField = {
        let text = UITextField()
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 50 , height: 40))
        let left:UIButton = {
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50 , height: 40))
            btn.setImage(UIImage(systemName: "lock"), for: .normal)
            return btn
        }()
        text.placeholder = "Password"
        text.isSecureTextEntry = true
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
    private let loginButton: UIButton = {
       let button = UIButton()
        //button.titleLabel?.font = UIFont(name: "GmarketSansTTFLight", size: 16.0)
        button.setTitle("로그인", for: .normal)
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
        self.view.addSubview(viewScroll)
        viewScroll.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
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
            make.top.equalToSuperview().inset(450)
        }
    }
    
    private func setLoginView() {
        viewContent.addSubview(viewLogin)
        viewLogin.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            //make.top.equalTo(navigationBar.snp.bottom).offset(30)
            make.height.width.equalTo(300)
        }
        
        viewLogin.addSubview(idText)
        idText.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(heightButton)
            make.top.equalToSuperview().offset(100)
        }
        
        viewLogin.addSubview(passwordText)
        passwordText.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.height.equalTo(heightButton)
            make.top.equalTo(idText.snp.bottom).offset(5)
        }
        
        viewLogin.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.height.equalTo(heightButton)
            make.top.equalTo(passwordText.snp.bottom).offset(20)
        }
        
        
        //
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
    
    // apple, etc ...
    
    // Actons
    
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
        if id == "" {
            self.idText.layer.borderColor = UIColor.red.cgColor
            return
        } else {
            self.idText.layer.borderColor = UIColor.systemGray5.cgColor
        }
        if password == "" {
            self.passwordText.layer.borderColor = UIColor.red.cgColor
            return
        } else {
            self.passwordText.layer.borderColor = UIColor.systemGray5.cgColor
        }
        
        // login
    }
}
