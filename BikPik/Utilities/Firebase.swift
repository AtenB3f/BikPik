//
//  Firebase.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/13.
//

//import Foundation
import Firebase
import GoogleSignIn


class Firebase {
    
    static let mngFirebase = Firebase()
    private init() { }
    
    var ref: DatabaseReference! = Database.database().reference()
    
    func uploadTask(task: Task) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //self.ref.child("test/users/\(uid)/tasks/\(task.date)").setValue(task)
    }
    
}
