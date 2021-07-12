//
//  ContentView.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/12.
//

import SwiftUI

struct ContentView: View {
    @State var currentTime = Time(sec: 0, min: 0, hr: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    
    var width = WKInterfaceDevice.current().screenBounds.size.width
    
    var body: some View {
        ZStack{
            // Main clock
            Circle()
                .fill(Color(.blue).opacity(0.1))
            
            // Seconds and Min dots
            
//            ForEach(0..<60, id: \.self) {i in
//                Rectangle()
//                    .fill(Color(.green))
//                    .frame(width: 2, height: (i % 5) == 0 ? 10 : 5)
//                    .offset(y: (width - 40) / 2)
//                    .rotationEffect(.init(degrees: Double(i * 6)))
//            }
            
            // Second hand
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: (width - 60) / 2)
                .offset(y: -(width - 60) / 4)
                .rotationEffect(.init(degrees: Double(currentTime.sec) * 6))
            
            // Minute hand
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: (width - 90) / 2)
                .offset(y: -(width - 90) / 4)
                .rotationEffect(.init(degrees: Double(currentTime.min) * 6 + Double(currentTime.sec) * 0.1))
            
            // Hour hand
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: (width - 120) / 2)
                .offset(y: -(width - 120) / 4)
                .rotationEffect(.init(degrees: Double(currentTime.hr) * 30 + Double(currentTime.min) * 0.5 + Double(currentTime.sec) * 0.5/60))
            
            // Center Circle
            Circle()
                .fill(Color.red)
                .frame(width:8, height: 8)
        }
        .onReceive(receiver, perform: { _ in
            let calendar = Calendar.current
            
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hr = calendar.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)) {
                self.currentTime = Time(sec: sec, min: min, hr: hr)
            }
        })
        
        
    }
}

struct Time {
    var sec: Int
    var min: Int
    var hr: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
