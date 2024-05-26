//
//  MainMenu.swift
//  BasicWatch Watch App
//
//  Created by Timothy Andrian on 22/05/24.
//

import SwiftUI
import SwiftData

struct MainMenuView: View {
    @State private var timeToClockIn: Int = 0
    @State private var timeToClockOut: Int = 0
    @State private var clockOutCountDown: String = ""
    @State private var clockInCountDown: String = ""
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let formatterClockOut = DateComponentsFormatter()
    private let formatterClockIn = DateComponentsFormatter()
    let userShift: UserShift
    
    private func endOfSessionView() -> some View {
        VStack(spacing: 26) {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(.green)
            VStack {
                Text("See you")
                Text("Tommorow!")
            }
        }
    }
    
    private func middleOfSessionView() -> some View {
        VStack(spacing:26) {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(.red)
            VStack {
                Text("Clock Out in")
                Text("\(clockOutCountDown)")
                    .onReceive(timer) { _ in
                        formatterClockOut.allowedUnits = [.hour, .minute]
                        formatterClockOut.unitsStyle = .short
                        
                        clockOutCountDown = formatterClockOut.string(from: TimeInterval(timeToClockOut))!
                        
                        if timeToClockOut > 0 {
                            timeToClockOut -= 1
                        }
                    }
            }
        }
    }
    
    private func startOfSessionView() -> some View {
        VStack(spacing: 26) {
            Image(systemName: "cloud.fill")
                .resizable()
                .frame(width: 120, height: 80)
                .foregroundStyle(.orange)

            VStack {
                Text("Clock In end in")
                Text("\(clockInCountDown)")
                    .onReceive(timer) { _ in
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
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 26) {
                if Date.now.time > userShift.getClockInTime().time {
                    if Date.now.time > userShift.getClockOutTime().time {
                        endOfSessionView()
                    } else {
                        middleOfSessionView()
                    }
                } else {
                    startOfSessionView()
                }
            }
            .padding()
        }
        .task {
            timeToClockIn = userShift.getClockInRemainingTime()
            timeToClockOut = userShift.getClockOutRemainingTime()
            userShift.scheduleClockInNotifications()
            userShift.scheduleClockOutNotifications()
        }
    }
}

#Preview {
    MainMenuView(userShift: UserShift(isAfternoon: false))
}
