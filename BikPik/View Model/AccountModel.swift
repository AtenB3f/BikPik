//
//  AccountModel.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/15.
//

import Foundation
import GoogleSignIn

class AccountManager {
    
    static let mngAccount = AccountManager()
    private init() {
        loadAccount()
    }
    
    let mngFirebase = Firebase.mngFirebase
    let store = Storage.disk
    
    var account = Account()
    
    func loadAccount () {
        loadEmail()
        
    }
    
    func loadEmail() {
        if let googleAccount = GIDSignIn.sharedInstance.currentUser?.profile?.email {
            print(googleAccount)
            account.email = googleAccount
            return
        }
    }
    
}
