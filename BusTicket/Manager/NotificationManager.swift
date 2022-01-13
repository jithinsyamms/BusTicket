//
//  NotificationManager.swift
//  BusTicket
//
//  Created by Jithin on 13/01/22.
//


import UIKit

class NotificationManager {

    static let shared = NotificationManager()

    private init() {

    }

    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
                completion(granted)
            }
    }

    func scheduleNotification(displayName: String, bookedDate: Date, remindBefore: Int) {

        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Bus Ticket Alert"
        notificationContent.body = "Hi %@, Your bus will leave at %@ please leave now to make it in time"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "jithin",
                                            content: notificationContent,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
