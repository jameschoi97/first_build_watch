//
//  ContentView.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/12.
//

import SwiftUI

struct Watch1View: View {
    
    @State var currentTime = Time(ns: 0, sec: 0, min: 0, hr: 0)
    @State var receiver = Timer.publish(every: 0.2, on: .current, in: .default).autoconnect()
    
    @State var lightsOn: Bool = false
    
    
    
    
    
    var body: some View {
        ZStack{
            
            Rectangle()
                .fill(Color(.black))
                .frame(width: 600, height: 600)
            
            
            // Main clock
            Image("1b_background")
                .scaleEffect(0.49)
                .offset(y: 15)
        
            Image("layer-\(currentTime.hr % 12)")
                .scaleEffect(0.49)
                .offset(y: 15)
                .opacity(lightsOn ? 0.75 : 0)
            
            Image("second_hand-\(currentTime.hr % 6)")
                .scaleEffect(0.49)
                .offset(y: -45)
                .rotationEffect(.init(degrees: currentTime.secAngle()))
                .offset(y: 15)
                .opacity(lightsOn ? 1 : 0)
            
            Image("minute_hand-\(currentTime.hr % 12 == 0 ? 0 : 1)")
                .scaleEffect(0.49)
                .offset(y: -35)
                .rotationEffect(.init(degrees: currentTime.minAngle()))
                .offset(y: 15)
                .opacity(lightsOn ? 1 : 0)
            
        }
        .onReceive(receiver, perform: { _ in
            let calendar = Calendar.current
            
            let ms = calendar.component(.nanosecond, from: Date())
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hr = calendar.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)) {
                self.currentTime = Time(ns: ms, sec: sec, min: min, hr: hr)
            }
        })
        
        .onTapGesture {
            if (lightsOn) {
                lightsOn = false
            } else {
                lightsOn = true
            }
        }
        
        
    }
    
}
