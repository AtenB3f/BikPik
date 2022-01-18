//
//  Account.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/15.
//


enum LoginType {
    case none
    case bikpik
    case google
    case apple
}

struct Account{
    var nickName:String?
    var email:String?
    var type:LoginType
    
    init () {
        type = .none
    }
    
    init (name: String, email: String, type: LoginType) {
        self.nickName = name
        self.email = email
        self.type = type
    }
}
