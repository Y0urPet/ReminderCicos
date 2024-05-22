//
//  ContentView.swift
//  BasicWatch Watch App
//
//  Created by Timothy Andrian on 13/05/24.
//

import SwiftUI
import UserNotifications
import SwiftData
import Foundation

struct ContentView: View {
    @State var isClockIn = false
    @State var isEndOfDay = false
    @State var timeToClockIn = 33300 - ((Calendar.current.component(.hour, from: Date.now)) * 3600 + Calendar.current.component(.minute, from: Date.now) * 60 + Calendar.current.component(.second, from: Date.now))
    @State var timeToClockOut = 46800 - ((Calendar.current.component(.hour, from: Date.now)) * 3600 + Calendar.current.component(.minute, from: Date.now) * 60 + Calendar.current.component(.second, from: Date.now))
    @State var clockOutCountDown = ""
    @State var clockInCountDown = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let formatterClockOut = DateComponentsFormatter()
    let formatterClockIn = DateComponentsFormatter()
    
//    @Environment(\.modelContext) private var modelWatch
    
    func getClockInTime() -> Date {
        var clockInTimeComponent = DateComponents()
        clockInTimeComponent.hour = 09
        clockInTimeComponent.minute = 15
        
        let clockInTime = Calendar.current.date(from: clockInTimeComponent) ?? .now
        return clockInTime
    }
    
    func getClockOutTime() -> Date {
        var clockOutTimeComponent = DateComponents()
        clockOutTimeComponent.hour = 13
        clockOutTimeComponent.minute = 0
        
        let clockOutTime = Calendar.current.date(from: clockOutTimeComponent) ?? .now
        return clockOutTime
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 26) {
                if Date.now.time > getClockInTime().time {
                    if Date.now.time > getClockOutTime().time {
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.green)
                        VStack {
                            Text("See you")
                            Text("Tommorow!")
                        }
                    } else {
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.red)
                        VStack {
                            Text("Clock Out in")
                            // Time Remaining for clock out
                            Text("\(clockOutCountDown)")
                                .onReceive(timer) { _ in
                                    if(timeToClockOut < 0) {
                                        timeToClockOut = (86400 - ((Calendar.current.component(.hour, from: Date.now)) * 3600 + Calendar.current.component(.minute, from: Date.now) * 60 + Calendar.current.component(.second, from: Date.now))) + 46800
                                    }
                                    
                                    formatterClockOut.allowedUnits = [.hour, .minute]
                                    formatterClockOut.unitsStyle = .short
                                    
                                    clockOutCountDown = formatterClockOut.string(from: TimeInterval(timeToClockOut))!
                                    
                                    if timeToClockOut > 0 {
                                        timeToClockOut -= 1
                                    }
                                }
                        }
                    }
                } else {
                    Image(systemName: "cloud.fill")
                        .resizable()
                        .frame(width: 120, height: 80)
                        .foregroundStyle(.orange)

                    VStack {
                        Text("Clock In end in")
                        // Time Remaining for clock in
                        Text("\(clockInCountDown)")
                            .onReceive(timer) { _ in
                                if(timeToClockIn < 0) {
                                    timeToClockIn = (86400 - ((Calendar.current.component(.hour, from: Date.now)) * 3600 + Calendar.current.component(.minute, from: Date.now) * 60 + Calendar.current.component(.second, from: Date.now))) + 33300
                                }
                                
                                formatterClockIn.allowedUnits = [.hour, .minute]
                                formatterClockIn.unitsStyle = .short
                                
                                clockInCountDown = formatterClockIn.string(from: TimeInterval(timeToClockIn))!
                                
                                if timeToClockIn > 0 {
                                    timeToClockIn -= 1
                                }
                            }
                    }
                }
            }
            .padding()
            .offset(y: -20)
        }.task {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
                if success{
                    print("All set")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            var components = DateComponents()
            components.hour = 9
            components.minute = 00
            
            let content = UNMutableNotificationContent()
            content.title = "Clock In!!"
            content.sound = .default
            content.categoryIdentifier = "myCategory"
            let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
//                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: Calendar.current.date(from: components) ?? .now), repeats: true)
            let request = UNNotificationRequest(identifier: "milk", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                    print(error.localizedDescription)
                }else{
                    print("scheduled successfully for Clock In")
                }
            }
            
            var componentsTwo = DateComponents()
            componentsTwo.hour = 13
            componentsTwo.minute = 00
            let contentTwo = UNMutableNotificationContent()
            contentTwo.title = "Clock Out!!"
            contentTwo.sound = .default
            contentTwo.categoryIdentifier = "myCategory"
            let categoryTwo = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([categoryTwo])
//                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
            let triggerTwo = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: Calendar.current.date(from: componentsTwo) ?? .now), repeats: true)
            let requestTwo = UNNotificationRequest(identifier: "milk", content: contentTwo, trigger: triggerTwo)
            
            
            UNUserNotificationCenter.current().add(requestTwo) { (error) in
                if let error = error{
                    print(error.localizedDescription)
                }else{
                    print("scheduled successfully for Clock Out")
                }
            }
        }
    }
    
}

@Model
final class userShift {
    var isAfternoon: Bool
    
    init(isAfternoon: Bool) {
        self.isAfternoon = isAfternoon
    }
}

extension Date {
    var time: Time {
        return Time(self)
    }
}

class Time: Comparable, Equatable {
    
    init(_ date: Date) {
        //get the current calender
        let calendar = Calendar.current

        //get just the minute and the hour of the day passed to it
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)

        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60

        //set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        hour = dateComponents.hour!
        minute = dateComponents.minute!
    }

    init(_ hour: Int, _ minute: Int) {
        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = hour * 3600 + minute * 60

        //set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        self.hour = hour
        self.minute = minute
    }

    var hour : Int
    var minute: Int

    var date: Date {
        //get the current calender
        let calendar = Calendar.current

        //create a new date components.
        var dateComponents = DateComponents()

        dateComponents.hour = hour
        dateComponents.minute = minute

        return calendar.date(byAdding: dateComponents, to: Date())!
    }

    /// the number or seconds since the beggining of the day, this is used for comparisions
    private let secondsSinceBeginningOfDay: Int

    //comparisions so you can compare times
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay == rhs.secondsSinceBeginningOfDay
    }

    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay < rhs.secondsSinceBeginningOfDay
    }

    static func <= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay <= rhs.secondsSinceBeginningOfDay
    }


    static func >= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay >= rhs.secondsSinceBeginningOfDay
    }


    static func > (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay > rhs.secondsSinceBeginningOfDay
    }
}


#Preview {
    ContentView()
}
