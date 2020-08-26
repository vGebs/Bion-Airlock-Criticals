//
//  NotificationStore.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-06-06.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI
import Combine

class NotificationStore: ObservableObject {
    @Published var notifications: [Notification] = notificationData
}

struct Notification: Identifiable {
    var id = UUID()
    var image: String
    var indicatorColor: Color
    var title: String
    var status: String
    var date: String
}

var notificationData = [
    Notification(image: "lock.circle", indicatorColor: .green, title: "Door Locks", status: "Door locks engaged", date: "4:44 - Jun 12"),
    Notification(image: "rectangle.compress.vertical", indicatorColor: .green, title: "Cabin Pressure", status: "Cabin is pressurizing", date: "4:45 - Jun 12"),
    Notification(image: "rectangle.compress.vertical", indicatorColor: .green, title: "Cabin Pressure", status: "Cabin is pressurizing", date: "4:45 - Jun 12")
]
