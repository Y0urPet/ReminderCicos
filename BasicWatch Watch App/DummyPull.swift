//
//  DummyPull.swift
//  BasicWatch Watch App
//
//  Created by Timothy Andrian on 25/05/24.
//

import SwiftUI
import UIKit
import Foundation

struct DummyPull: View {
  @State private var isRefreshing = false

  var body: some View {
      VStack {
          Text("jashflsjdhf")
      }
      .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onEnded({ value in
          if value.translation.height > 0 {
              // down
              print("down")
          }
      }))
//    List {
//      Text("Please Install the Reminder Cico")
//        .opacity(isRefreshing ? 0.5 : 1) // Dim the list when refreshing
//      Text("in your Apple Watch")
//    }
//    .refreshable { // Ensure .refreshable is on the outermost scrollable view
//      print("Refresh triggered!") // Print statement for debugging
//      isRefreshing = true // Show loading indicator
//      // Replace with your actual refresh logic (fetch data, etc.)
//      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//        isRefreshing = false // Hide loading indicator after a delay (simulate refresh)
//      }
//    }
//    .overlay(
//      isRefreshing ? LoadingIndicator() : nil // Show indicator conditionally
//    )
      
  }
}

struct LoadingIndicator: View {
  @State private var animation = false

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .center) {
        Circle()
          .stroke(lineWidth: 4)
          .scaleEffect(2)
          .opacity(animation ? 0.2 : 1)
          .rotationEffect(.degrees(animation ? 360 : 0))
          .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
          .onAppear {
            animation.toggle()
          }
        Circle()
          .trim(from: 0, to: animation ? 0.8 : 0)
          .stroke(lineWidth: 4)
          .scaleEffect(2)
          .foregroundColor(.accentColor)
          .rotationEffect(.degrees(animation ? 360 : 0))
          .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
  }
}

#Preview {
    DummyPull()
}
