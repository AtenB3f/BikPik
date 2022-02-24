//
//  Firebase.swift
//  BikPik
//
//  Created by jihee moon on 2022/01/13.
//

//import Foundation
import Firebase
import GoogleSignIn
import FirebaseDatabase
import FirebaseAuth
import UIKit


class Firebase {
    static let mngFirebase = Firebase()
    private init() { }
    
    let ref: DatabaseReference! = Database.database().reference()
    
    func createUser(email:String, password:String, handleError: @escaping (_ :String?) -> ()) {
        var message:String? = nil
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error as NSError? {
                switch err.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    message = "이메일이 이미 사용중입니다."
                case AuthErrorCode.weakPassword.rawValue:
                    message = "6자리 이상의 비밀번호를 입력해주세요."
                case AuthErrorCode.invalidEmail.rawValue:
                    message = "이메일이 존재하지 않습니다."
                default:
                    message = "\(err.code)"
                    print(err)
                }
            } else {
                print("success create user : \(email)")
                if let uid = Auth.auth().currentUser?.uid {
                    self.addUserlist(uid: uid)
                }
            }
            handleError(message)
        }
    }
    
    func addUserlist(uid: String) {
        self.ref.child("userlist/").updateChildValues([uid:true])
    }
    
    func loginUser(email:String, password:String, handleSignIn: @escaping (_ :String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let err = error as NSError? {
                switch err.code {
                case AuthErrorCode.userNotFound.rawValue:
                    fallthrough
                case AuthErrorCode.wrongPassword.rawValue:
                    handleSignIn("이메일 혹은 패스워드가 올바르지 않습니다.")
                default:
                    handleSignIn("\(err.code)")
                    print(err)
                }
            } else {
                handleSignIn(nil)
            }
        }
    }
    
    func deleteUser() {
        if let uid = Auth.auth().currentUser?.uid {
            self.ref.child("userlist/\(uid)").removeValue()
        }
        Auth.auth().currentUser?.delete { error in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
    
    func logout() {
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
                if let error = error {
                    print(error.localizedDescription)
                }
            } else {
                GIDSignIn.sharedInstance.signOut()
                return
            }
        }
    }
    
    // 이메일 인증
    func authEmail() {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { error in
                if error != nil {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    func reloadUser() {
        if let user = Auth.auth().currentUser {
            user.reload(completion: { error in
                if error != nil {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
    func isAuthEmailVerified()->Bool {
        if let user = Auth.auth().currentUser {
            reloadUser()
            return user.isEmailVerified
        }
        return false
    }
    
    func changePassword(password: String) {
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            if error != nil {
                if let email = Auth.auth().currentUser?.email{
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                    }
                }
                
            }
        }
    }
    
    func syncTask(handleSyncData : @escaping (String,[String])->()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let dateFormatter: DateFormatter = {
            let format = DateFormatter()
            format.dateFormat = "yyyyMM"
            return format
        }()
        
        for i in -6..<6 {
            if let date = Calendar.current.date(byAdding: .month, value: i, to: Date()) {
                let ym = dateFormatter.string(from: date)
                self.ref.child("userdata/\(uid)/tasklist/\(ym)").observeSingleEvent(of: .value, with: { snp in
                    if snp.exists() {
                        let arr = snp.value as! [String:Bool]
                        let keys = arr.keys.sorted()
                        handleSyncData(ym,keys)
                    } else {
                        handleSyncData(ym,[])
                    }
                })
            }
        }
    }
    
    func syncHabit(handleSyncData : @escaping ([String])->()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("userdata/\(uid)/habitlist/").observeSingleEvent(of: .value, with: { snp in
            if snp.exists() {
                let arr = snp.value as! [String:Bool]
                handleSyncData(arr.keys.sorted())
            } else {
                handleSyncData([])
            }
        })
    }
    
    
    // Task
    
    func uploadTask(uuid: String ,task: Task) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let taskRef = self.ref.child("userdata/\(uid)/tasks/\(uuid)")
        let data = setTask(task: task)
        taskRef.setValue(data)
    }
    
    private func setTask(task: Task) -> [String:Any]{
        var data:[String:Any] = [
                    "name" : task.name,
                    "date" : task.date,
                    "time" : task.time,
                    "alram" : task.alram,
                    "inToday" : task.inToday,
                    "isDone" : task.isDone,
        ]
        if let tag = task.tag {
            data["tag"] = tag
        }
        if let color = task.color {
            data["color"] = color
        }
        return data
    }
    
    func removeTask(uuid: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("userdata/\(uid)/tasks/\(uuid)").removeValue()
    }
    
    func correctTask(uuid: String, task: Task) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let taskRef = self.ref.child("userdata/\(uid)/tasks/\(uuid)")
        let data = setTask(task: task)
        taskRef.updateChildValues(data)
    }
    
    func downloadTask(uuid: String, handleSaveTask: @escaping (_ uuid: String, _ task: Task) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("userdata/\(uid)/tasks/\(uuid)").observeSingleEvent(of: .value, with: { [self] snapshot in
            let uuid = snapshot.key
            let value = snapshot.value as! [String:Any]
            
            handleUpdateTask(uuid: uuid, value: value, handleSaveTask: handleSaveTask)
        })
    }
    
    /**
     if data changed in firebase server, syncronazate with JSON file of device storage.
     - parameter handleSaveTask : for Json File update function
     */
    func updateTask(handleSaveTask: @escaping (_ uuid: String, _ task: Task) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("userdata/\(uid)/tasks/").observe(.childChanged, with: { [self] snapshot in
            let uuid = snapshot.key
            let value = snapshot.value as! [String:Any]
            
            handleUpdateTask(uuid: uuid, value: value, handleSaveTask: handleSaveTask)
        })
    }
    
    func uploadTaskList(uuid: String, date: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let idx = date.index(date.startIndex, offsetBy: 5)
        let ym = String(date[date.startIndex...idx])
        self.ref.child("userdata/\(uid)/tasklist/\(ym)/").updateChildValues([uuid: true])
    }
    
    func removeTaskList(uuid: String, date: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let idx = date.index(date.startIndex, offsetBy: 5)
        let ym = String(date[date.startIndex...idx])
        self.ref.child("userdata/\(uid)/tasklist/\(ym)/\(uuid)").removeValue()
    }
    
    private func handleUpdateTask(uuid: String, value :[String:Any], handleSaveTask: @escaping(_ uuid: String, _ task: Task) -> ()) {
        var task = Task()
        for v in value.keys {
            switch v {
            case "name":
                task.name = value[v] as! String
            case "alram":
                task.alram = value[v] as! Bool
            case "date":
                task.date = value[v] as! String
            case "inToday":
                task.inToday = value[v] as! Bool
            case "isDone":
                task.isDone = value[v] as! Bool
            case "time":
                task.time = value[v] as! String
            case "tag":
                task.tag = value[v] as? String
            case "color":
                task.color = value[v] as? String
            default:
                print("Error :: handleUpdateTask() ")
            }
        }
        handleSaveTask(uuid, task)
    }
    
    
    //Habit
    
    func uploadHabit(uuid: String, habit: Habits) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let habitRef = self.ref.child("userdata/\(uid)/haibts/\(uuid)")
        let data = setHabit(habit: habit)
        habitRef.setValue(data)
    }
    
    private func setHabit(habit: Habits) -> [String:Any]{
        var data = [
            "start" : habit.start,
            "end" : habit.end,
            "days" : habit.days,
            "total" : habit.total,
            "name" : habit.task.name,
            "date" : habit.task.date,
            "time" : habit.task.time,
            "alram" : habit.task.alram,
            "inToday" : habit.task.inToday,
        ] as [String : Any]
        if habit.isDone != nil {
            data["isDone"] = habit.isDone
        }
        
        return data
    }
    
    func removeHabit(uuid: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let habitRef = self.ref.child("userdata/\(uid)/haibts/\(uuid)")
        habitRef.removeValue()
    }
    
    func correctHabit(uuid:String, habit: Habits) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let habitRef = self.ref.child("userdata/\(uid)/haibts/\(uuid)")
        let data = setHabit(habit: habit)
        habitRef.updateChildValues(data)
    }
    
    func downloadHabit(uuid: String, handleSaveHabit: @escaping (_ uuid: String, _ task: Habits) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("userdata/\(uid)/habits/\(uuid)").observeSingleEvent(of: .value, with: { [self] snapshot in
            let uuid = snapshot.key
            let value = snapshot.value as! [String:Any]
            
            self.handleUpdateHabit(uuid: uuid, value: value, handleSaveHabit: handleSaveHabit)
        })
    }
    
    func updateHabit(handleSaveHabit: @escaping (_ uuid: String, _ habit: Habits) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("userdata/\(uid)/haibts/").observe(.childChanged, with: { [self] snapshot in
            let uuid = snapshot.key
            let value = snapshot.value as! [String:Any]
            
            handleUpdateHabit(uuid: uuid, value: value, handleSaveHabit: handleSaveHabit)
        })
    }
    
    private func handleUpdateHabit(uuid: String, value :[String:Any], handleSaveHabit: @escaping(_ uuid: String, _ habit: Habits) -> ()) {
        var habit = Habits(date: value["date"] as! String)
        for v in value.keys {
            switch v {
            case "name":
                habit.task.name = value[v] as! String
            case "alram":
                habit.task.alram = value[v] as! Bool
            case "date":
                habit.task.date = value[v] as! String
            case "inToday":
                habit.task.inToday = value[v] as! Bool
            case "time":
                habit.task.time = value[v] as! String
            case "tag":
                habit.task.tag = value[v] as? String
            case "color":
                habit.task.color = value[v] as? String
            case "start":
                habit.start = value[v] as! String
            case "end":
                habit.end = value[v] as! String
            case "days":
                habit.days = value[v] as! [Bool]
            case "isDone":
                habit.isDone = value[v] as? [String:Bool]
            case "total":
                habit.total = value[v] as! Int
            default:
                print("Error :: handleUpdateHabit() ")
            }
        }
        handleSaveHabit(uuid, habit)
    }
    
    func uploadHabitDone(uuid: String, habit: Habits) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let isDone = habit.isDone else { return }
        
        let habitRef = self.ref.child("userdata/\(uid)/haibts/\(uuid)/isDone/")
        habitRef.updateChildValues(isDone)
    }
    
    func uploadHabitList(uuid: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("userdata/\(uid)/habitlist/").updateChildValues([uuid: true])
    }
    
    func removeHabitList(uuid: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("userdata/\(uid)/habitlist/\(uuid)").removeValue()
    }
}
