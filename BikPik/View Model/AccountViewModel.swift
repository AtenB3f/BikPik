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
    
    var account = Observable(Account())
    
    func loadAccount () {
        account.value = storage.Search("Account.json", as: Account.self) ?? Account()
        
        // Google
        if let googleAccount = GIDSignIn.sharedInstance.currentUser?.profile {
            print(googleAccount)
            account.value.email = googleAccount.email
            if account.value.name == nil {
                account.value.name = googleAccount.name
            }
            return
        }
    }
    
    private func saveAccount() {
        storage.Save(account.value, "Account.json")
    }
    
    func logoutEmail() {
        mngFirebase.logout()
        self.account.value.email = nil
    }
    
    func setName(name: String?) {
        self.account.value.name = name
        saveAccount()
    }
    
    func setEmail(_ email: String?) {
        self.account.value.email = email
        saveAccount()
    }
}
