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
    
    private func saveAccount() {
        storage.Save(account, "Account.json")
    }
    
    func logoutEmail() {
        mngFirebase.logout()
        self.account.email = nil
    }
    
    func setName(name: String?) {
        self.account.name = name
        saveAccount()
    }
    
    func setEmail(_ email: String?) {
        self.account.email = email
        saveAccount()
    }
}
