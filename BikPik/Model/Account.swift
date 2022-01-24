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

struct Account: Codable, Equatable {
    var name:String? = nil
    var email:String? = nil
    //var type:LoginType = .none
    
    init () {}
    
    init (name: String, email: String, type: LoginType) {
        self.name = name
        self.email = email
        //self.type = type
    }
}
