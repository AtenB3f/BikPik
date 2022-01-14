//
//  Firebase.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/13.
//

import Foundation
import Firebase
import GoogleSignIn

class Firebase {
    
    static let mngFirebase = Firebase()
    private init() {}
    
    let signInConfig = GIDConfiguration.init(clientID: "935887439924-lucmkjqd8k3v69i0jdm93r19su2rcedi.apps.googleusercontent.com")
}
