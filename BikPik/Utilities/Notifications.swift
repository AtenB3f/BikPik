//
//  Notifications.swift
//  BikPik
//
//  Created by jihee moon on 2021/10/11.
//

import UIKit

class Notifications {
    private init() { }
    static let mngNotification = Notifications()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    // [task uuid : notification uuid]
    var listIdentifer:[String: String] = [:]
    
    // test code
    func checkNoti(){
        print("listIdentifer")
        listIdentifer.forEach { key, value in
            print("\(key), \(value)")
        }
    }
    
    func createNotificationTask(uuid: String, task: Task) -> String {
        let content = 	UNMutableNotificationContent()
        content.title = task.name
        content.body = "오늘 할일 했나요?"
        content.sound = .default
        
        var year = 0
        var month = 0
        var day = 0
        var hour = 0
        var miniute = 0
        
        Date.GetIntDate(date: task.date, year: &year, month: &month, day: &day)
        Date.GetIntTime(time: task.time, hour: &hour, minutes: &miniute)
        
        let calendar = Calendar.current
        let cmp = DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hour, minute: miniute)
        
        let uuidNoti = addNotification(content: content, dateComponents: cmp, repeats: false)
        listIdentifer[uuid] = uuidNoti
        
        print(listIdentifer)
        return uuidNoti
    }
    
    func addNotification(content: UNMutableNotificationContent, dateComponents: DateComponents, repeats: Bool) -> String {
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
           if error != nil {
              print("createNotificationTask Error")
           }
        }
        return uuidString
    }
    
    /**
     - parameter uuid: UUID of Task.
     */
    func removeNotificationTask(uuid: String) {
        guard let identifers = listIdentifer[uuid] else {
            print("removeNotificationTask :: no identifer")
            checkNoti()
            return
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notiRequests) in
            var removeIdentifiers = [String]()
            for noti: UNNotificationRequest in notiRequests {
                if noti.identifier == identifers {
                    removeIdentifiers.append(noti.identifier)
                    print(noti.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: removeIdentifiers)
        }
        
        listIdentifer.removeValue(forKey: uuid)
        print(listIdentifer)
    }

    func createNotificationHabit(habit: Habits) {
        var uuid: String?
        let content = UNMutableNotificationContent()
        content.title = habit.task.name
        content.body = "습관 생성 중..."
        content.sound = .default
        
        var hour = 0
        var miniute = 0
        
        Date.GetIntTime(time: habit.task.time, hour: &hour, minutes: &miniute)
        
        let calendar = Calendar.current
        var dateCmp = DateComponents(calendar: calendar, hour: hour, minute: miniute)
        
        for n in 0...6 {
            if habit.days[n] == true {
                dateCmp.weekday = n+1
                uuid = addNotification(content: content, dateComponents: dateCmp, repeats: false)
                let key = habit.task.name + String(n+1)
                listIdentifer[key] = uuid
            }
        }
        print(listIdentifer)
    }
    
    func removeNotificationHabit(habit: Habits) {
        let name = habit.task.name
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { [self] (notiRequests) in
            var removeIdentifiers = [String]()
            for noti: UNNotificationRequest in notiRequests {
                for n in 0...6 {
                    let key = name + String(n+1)
                    let identifer = listIdentifer[key]
                    if noti.identifier == identifer {
                        removeIdentifiers.append(noti.identifier)
                        listIdentifer.removeValue(forKey: key)
                    }
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: removeIdentifiers)
        }
        print(listIdentifer)
    }
    
    func printNotifications() {
        print("[printNotifications]")
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notiRequests) in
            for noti: UNNotificationRequest in notiRequests {
                print(noti.identifier)
            }
        }
    }
    
}
