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
    var listIdentifer:[String: String] = [:]
    
    func createNotificationTask(task: Task) -> String {
        let content = 	UNMutableNotificationContent()
        content.title = task.name!
        content.body = "오늘 할일 했나요?"
        content.sound = .default
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        var year = 0
        var month = 0
        var day = 0
        var hour = 0
        var miniute = 0
        
        Date.GetIntDate(date: task.date, year: &year, month: &month, day: &day)
        Date.GetIntTime(date: task.time, hour: &hour, minutes: &miniute)
        
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = miniute
        
        let key = task.name! + "_" + String(task.id)
        let uuid = addNotification(content: content, dateComponents: dateComponents, repeats: false)
        listIdentifer[key] = uuid
        
        print(listIdentifer)
        return uuid
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
    
    
    func removeNotificationTask(task: Task) {
        let key = task.name! + "_" + String(task.id)
        guard let identifers = listIdentifer[key] else {
            print("removeNotificationTask :: no identifer")
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
        
        listIdentifer.removeValue(forKey: key)
        print(listIdentifer)
    }

    func createNotificationHabit(habit: Habits) {
        var uuid: String?
        let content =     UNMutableNotificationContent()
        content.title = habit.task.name!
        content.body = "습관 생성 중..."
        content.sound = .default
        
        var hour = 0
        var miniute = 0
        
        Date.GetIntTime(date: habit.task.time, hour: &hour, minutes: &miniute)
        
        let calendar = Calendar.current
        var dateCmp = DateComponents(calendar: calendar, hour: hour, minute: miniute)
        
        for n in 0...6 {
            if habit.days[n] == true {
                dateCmp.weekday = n+1
                uuid = addNotification(content: content, dateComponents: dateCmp, repeats: true)
                let key = habit.task.name! + String(n+1)
                listIdentifer[key] = uuid
            }
        }
        print(listIdentifer)
    }
    
    func removeNotificationHabit(habit: Habits) {
        let name = habit.task.name!
        
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
}
