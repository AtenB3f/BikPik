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
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)
        print(uuidString)
        listIdentifer[task.name!] = uuidString
        // Schedule the request with the system.
        //let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              print("createNotificationTask Error")
           }
        }
        
        return uuidString
    }
    
    func removeNotificationTask(task: Task) {
        guard let identifers = task.notiUUID else { return }
        
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
    }

}
