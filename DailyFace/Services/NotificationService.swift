//
//  NotificationService.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/28/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import Foundation
import DLLocalNotifications

class NotificationService {
    static let shared = NotificationService()
    
    static func scheduleNotifications() {
        let notification = DLNotification(identifier: "DailyFace", alertTitle: "Take your daily photo", alertBody: "Good morning! Start your day by logging a photo of yourself.", date: Date().addingTimeInterval(TimeInterval(5)), repeats: .Daily)
        
        let scheduler = DLNotificationScheduler()
        scheduler.scheduleNotification(notification: notification)
    }
}

