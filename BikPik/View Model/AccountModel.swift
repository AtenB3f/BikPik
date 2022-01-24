//
//  AccountModel.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/15.
//

import Foundation
import GoogleSignIn
import Firebase

class AccountManager {
    
    static let mngAccount = AccountManager()
    private init() {
        loadAccount()
    }
    
    let mngFirebase = Firebase.mngFirebase
    let storage = Storage.disk
    
    var account = Account()
    
    func loadAccount () {
        account = storage.Search("Account.json", as: Account.self) ?? Account()
        
        // Google
        if let googleAccount = GIDSignIn.sharedInstance.currentUser?.profile {
            print(googleAccount)
            account.email = googleAccount.email
            if account.name == nil {
                account.name = googleAccount.name
            }
            return
        }
    }
    
    private func saveName() {
        storage.Save(account, "Account.json")
    }
    
    func logoutEmail() {
        // Firebase Logout
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
         
        
        // Google Logout
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                print("Google Login signed-OUT")
            } else {
                print("Google Login signed-IN")
                GIDSignIn.sharedInstance.signOut()
                return
            }
          }
        
        self.account.email = nil
    }
    
    func setName(name: String?) {
        self.account.name = name
        saveName()
    }
}
