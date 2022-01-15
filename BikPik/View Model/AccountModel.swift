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
    private init() {}
    
    let mngFirebase = Firebase.mngFirebase
    
    var account = Account()
    
    func loadAccount () {

    }
    
}
