//
//  CicoWatcher.swift
//  BasicWatch Watch App
//
//  Created by Timothy Andrian on 20/05/24.
//

import SwiftUI

struct CicoWatcher: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                VStack(spacing: 20){
                    Image(systemName: "cloud.fill")
                        .resizable()
                        .frame(width: 120,height: 80).foregroundStyle(.orange)
                    VStack {
                        Text("Clock In in").font(.title2)
                        Text("00:00:00").font(.title3)
                    }
                }.frame(width: 200)
                VStack(spacing: 20){
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 80,height: 80).foregroundStyle(.red)
                        
                    VStack {
                        Text("Clock Out in").font(.title2)
                        Text("00:00:00").font(.title3)
                    }
                }.frame(width: 200)
                    .padding(.trailing, 1)
            }
        }
    }
}

#Preview {
    CicoWatcher()
}
