//
//  OnBoardingView.swift
//  BasicWatch Watch App
//
//  Created by Timothy Andrian on 22/05/24.
//

import SwiftUI
import SwiftData

struct OnBoardingView: View {
    @Environment(\.modelContext) private var modelWatch
    @Query private var userShift: [UserShift]
    
    var body: some View {
        NavigationStack {
            VStack {
                if userShift.isEmpty {
                    Text("Which shift are you?")
                    Button {
                        let newUser = UserShift(isAfternoon: false)
                        modelWatch.insert(newUser)
                    } label: {
                        Text("Morning")
                    }
                    Button {
                        let newUser = UserShift(isAfternoon: true)
                        modelWatch.insert(newUser)
                    } label: {
                        Text("Afternoon")
                    }
                } else {
                    MainMenuView(userShift: userShift.first ?? UserShift(isAfternoon: false))
                }
            }.navigationTitle("Welcome!")
        }
    }
}

#Preview {
    OnBoardingView()
}
