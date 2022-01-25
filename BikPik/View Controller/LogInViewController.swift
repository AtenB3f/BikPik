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
        setButtonView()
    }
    
    // instance
    var viewButtons = UIView()
    private let googleButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .wide
        button.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        return button
    }()
    
    
    // Set View
    private func setButtonView() {
        self.view.addSubview(viewButtons)
        viewButtons.snp.remakeConstraints ({ make in
            make.centerX.centerY.equalTo(self.view.center)
            make.width.equalTo(300)
            make.height.equalTo(100)
        })
        
        // Google Button
        viewButtons.addSubview(googleButton)
        googleButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
    
    // apple, etc ...
    
    // Actons
    
    @objc func handleGoogleLogin() {
        GIDSignIn.sharedInstance.signIn(with: mngFirebase.signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            self.mngAccount.account.email = user.profile?.email
            if self.mngAccount.account.name == nil {
                self.mngAccount.account.name = user.profile?.name
            }
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
