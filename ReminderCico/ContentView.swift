//
//  ContentView.swift
//  ReminderCico
//
//  Created by Timothy Andrian on 20/05/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
//        VStack {
//            Text("Please Intall the Reminder Cico")
//            Text("in your Apple Watch")
//        }
        ScrollView {
            Text("Please Intall the Reminder Cico")
            Text("in your Apple Watch")
        }
        .refreshable {
            print("Do your refresh work here")
        }
    }
}

#Preview {
    ContentView()
}
