//
//  BasicWatchApp.swift
//  BasicWatch Watch App
//
//  Created by Timothy Andrian on 13/05/24.
//

import SwiftUI
import UserNotifications

@main
struct BasicWatch_Watch_AppApp: App {
    
    @State var appState: WKApplicationState = .inactive
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Access the current app state on initial appearance
//                    appState = WKApplication.shared().applicationState
                }
        }
        
//        .backgroundTask(.appRefresh("My_App_Updates")) { Sendable in
//            let content = UNMutableNotificationContent()
//            content.title = "Clock In!!"
//            content.sound = .default
//            content.categoryIdentifier = "myCategory"
//            let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
//            UNUserNotificationCenter.current().setNotificationCategories([category])
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//            let request = UNNotificationRequest(identifier: "milk", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request) { (error) in
//                if let error = error{
//                    print(error.localizedDescription)
//                }else{
//                    print("scheduled successfully")
//                }
//            }
//        }
    }
}
