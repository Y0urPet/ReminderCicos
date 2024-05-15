//
//  ContentView.swift
//  BasicWatch Watch App
//
//  Created by Timothy Andrian on 13/05/24.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State var isClockIn = false
    @State var isEndOfDay = false
    @State var timeRemaining = 46800 - ((Calendar.current.component(.hour, from: Date.now)) * 3600 + Calendar.current.component(.minute, from: Date.now) * 60 + Calendar.current.component(.second, from: Date.now))
    @State var formattedString = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let formatter = DateComponentsFormatter()
    let now = Date()

    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                VStack(spacing: 24) {
                    if(isClockIn) {
                        if (isEndOfDay) {
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.green)
                                .id("satu")
                                .onTapGesture {
                                    isEndOfDay = false
                                    isClockIn = false
//                                    timeRemaining = 14400
                                }
                            VStack {
                                Text("See you")
                                Text("Tommorow!")
                            }
                        } else {
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.red)
                                .id("satu")
                            VStack {
                                Text("Clock Out in")
                                Text("\(formattedString)")
                                    .onReceive(timer) { _ in
                                        if(timeRemaining < 0) {
                                            timeRemaining = 86400 - ((Calendar.current.component(.hour, from: Date.now)) * 3600 + Calendar.current.component(.minute, from: Date.now) * 60 + Calendar.current.component(.second, from: Date.now))
                                        }
                                        
                                        
                                        formatter.allowedUnits = [.hour, .minute]
                                        formatter.unitsStyle = .short
                                        
                                        formattedString = formatter.string(from: TimeInterval(timeRemaining))!
                                        
                                        if timeRemaining > 0 {
                                            timeRemaining -= 1
                                        }
                                    }
                                Image(systemName: "arrow.up")
                                    .foregroundStyle(.white)
                                    .padding(.top, 10)
                            }
                            Button {
                                isEndOfDay = true
//                                timeRemaining = 14400
                                withAnimation() {
                                    value.scrollTo("satu")
                                }
                            } label: {
                                Text("Clock Out").foregroundStyle(.white)
                            }
                            .tint(.blue).saturation(10.0)
                        }
                    } else {
                        Image(systemName: "cloud.fill")
                            .resizable()
                            .frame(width: 100, height: 80)
                            .foregroundStyle(.orange)
                            .id("satu")
                        VStack {
                            Text("Remember to")
                            Text("Clock In!")
                            Image(systemName: "arrow.up")
                                .foregroundStyle(.white)
                                .padding(.top, 10)
                        }
                        Button {
                            isClockIn = true
//                            timeRemaining = 14400
                            withAnimation() {
                                value.scrollTo("satu")
                            }
                        } label: {
                            Text("Clock In")
                                .foregroundStyle(.white)
                        }
                        .tint(.blue).saturation(10.0)
                        Button("Schedule Notification") {
                            let content = UNMutableNotificationContent()
                            content.title = "CLock In!!"
    //                        content.subtitle = "you have 10 sec"
                            content.sound = .default
                            content.categoryIdentifier = "myCategory"
                            let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
                            UNUserNotificationCenter.current().setNotificationCategories([category])
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                            let request = UNNotificationRequest(identifier: "milk", content: content, trigger: trigger)
    //                        let request = UNNotificationRequest(identifier: "ClockIn", content: NotificationView(), trigger: nil )
                            UNUserNotificationCenter.current().add(request) { (error) in
                                if let error = error{
                                    print(error.localizedDescription)
                                }else{
                                    print("scheduled successfully")
                                }
                            }
                        }
                    }
//                    Button("Request permission") {
//                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
//                            if success{
//                                print("All set")
//                            } else if let error = error {
//                                print(error.localizedDescription)
//                            }
//                        }
//                    }
                }
                .padding()
                .offset(y: -20)
            }
        }.task {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
                if success{
                    print("All set")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct NotificationView: View {
    var body: some View {
        Text("Remember to Clock In!")
    }
}


#Preview {
    ContentView()
}
