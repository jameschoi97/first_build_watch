//
//  ContentView.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/12.
//

import SwiftUI

struct Watch4View: View {
    @State var currentTime = Time(ns: 0, sec: 0, min: 0, hr: 0)
    @State var receiver = Timer.publish(every: 0.2, on: .current, in: .default).autoconnect()
    @State var secondReceiver = Timer.publish(every: 0.05, on: .current, in: .default).autoconnect()
    @State var thirdReceiver = Timer.publish(every: 0.2, on: .current, in: .default).autoconnect()
    
    @State var waveIndex: Int = 0;
    @State var waveGoingDown: Bool = true;
    @State var waveY: CGFloat = -150;
    
    
    @State var crabOpacity: Double = 0
    @State var crabX: CGFloat = -140
    
    @State var turtleOpacity: Double = 0
    @State var turtleX: CGFloat = -140
    
    @State var fishIndex: Int = 0;
    
    
    var body: some View {
        ZStack{
            
            // Main clock
            Image("watch4_background")
                .scaleEffect(0.50)
                .offset(y: 15)
            
            Image("wave\(waveIndex)")
                .scaleEffect(0.50)
                .offset(y: 15 + waveY)
                .zIndex(5)
            
            Image("watch4_minute")
                .offset(y: -110)
                .scaleEffect(0.38)
                .rotationEffect(.init(degrees: currentTime.secAngle()))
                .zIndex(2)
                .offset(y: 15)
                .opacity(0.5)
            
            Image("crab")
                .offset(x: crabX, y: 120)
                .scaleEffect(0.5)
                .opacity(crabOpacity)
            
            Image("turtle")
                .offset(x: turtleX, y: -70)
                .scaleEffect(0.5)
                .opacity(turtleOpacity)
            
            Image("fish\(fishIndex)")
                .offset(y: -40)
                .scaleEffect(0.5)
                .rotationEffect(.init(degrees: currentTime.hrAngle()))
                .zIndex(2.1)
                .offset(y: 15)
            
            
            
            
            
        }
        .onReceive(receiver, perform: { _ in
            let calendar = Calendar.current
            
            let ns = calendar.component(.nanosecond, from: Date())
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hr = calendar.component(.hour, from: Date())
            
            self.currentTime = Time(ns: ns, sec: sec, min: min, hr: hr)
            
            fishIndex = currentTime.hr % 12
            
            
        })
        .onReceive(thirdReceiver, perform: { _ in
            waveIndex = (waveIndex + 1) % 4
        })
        
        .onReceive(secondReceiver, perform: { _ in
            let secondInNano = currentTime.secondInNano();
            if (secondInNano < 5000000000) {
                waveY = -200 + 140.0/5000000000*CGFloat(secondInNano)
            } else if (secondInNano < 10000000000) {
                waveY = -60
            } else if (secondInNano < 15000000000) {
                waveY = -60 - 140.0/5000000000*CGFloat(secondInNano-10000000000)
            } else {
                waveY = -200
            }
            
            
            if secondInNano < 2500000000 || secondInNano > 12500000000 {
                crabOpacity = 0
            } else {
                crabOpacity = 1
            }
            
            if (secondInNano < 2500000000) {
                crabX = -140
            } else if (secondInNano < 12500000000) {
                crabX = -140 + 280.0/10000000000*CGFloat(secondInNano-2500000000)
            } else {
                crabX = 140
            }
            
            if secondInNano < 15000000000 {
                turtleOpacity = 0
            } else {
                turtleOpacity    = 1
            }
            
            if (secondInNano < 15000000000) {
                turtleX = -140
            } else {
                turtleX = -140 + 280.0/45000000000*CGFloat(secondInNano-15000000000)
            }
            
            
            
            
        })
        
        
        
    }
    
}
