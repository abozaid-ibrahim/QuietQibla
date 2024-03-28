//
//  LocalNotification.swift
//  QuietQibla
//
//  Created by abuzeid on 26.03.24.
//

import Foundation
import UserNotifications

struct Notification {
    let title: String
    let body: String
}

struct LocalNotification {
    init() {
        askForPermissions()
    }

    func askForPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Authorization granted")
            } else {
                print("Authorization denied: \(error?.localizedDescription ?? "")")
            }
        }
    }

    func sendNotification(notif: Notification) {
        let content = UNMutableNotificationContent()
        content.title = notif.title
        content.body = notif.body

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "focusChanged", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
}
