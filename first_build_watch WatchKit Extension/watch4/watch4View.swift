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
    @State var thirdReceiver = Timer.publish(every: 0.4, on: .current, in: .default).autoconnect()
    
    @State var waveIndex: Int = 0;
    @State var waveGoingDown: Bool = true;
    @State var waveX: CGFloat = -100;
    @State var waveY: CGFloat = -250;
    
    
    @State var crabOpacity: Double = 0
    @State var crabX: CGFloat = -170
    
    @State var turtleOpacity: Double = 0
    @State var turtleX: CGFloat = -140
    
    @State var fishIndex: Int = 0;
    
    @State var stepOpacity: Double = 0
    @State var stepOpacity2: Double = 0
    
    @State var crabIndex: Int = 0
    @State var turtleIndex: Int = 0
    
    
    var body: some View {
        ZStack{
            
            // Main clock
            Image("watch4_background")
                .scaleEffect(0.50)
                .offset(y: 15)
            
            Image("wave3")
                .scaleEffect(0.70)
                .offset(x: waveX, y: waveY)
                .zIndex(5)
            
            Image("watch4_minute")
                .offset(y: -110)
                .scaleEffect(0.38)
                .rotationEffect(.init(degrees: currentTime.minAngle()))
                .zIndex(2)
                .offset(y: 15)
                .opacity(0.5)
            
            Image("crab\(crabIndex)")
                .scaleEffect(0.5)
                .offset(x: crabX, y: 75)
                .opacity(crabOpacity)
                .zIndex(6)
            
            Image("turtle\(turtleIndex)")
                .scaleEffect(0.3)
                .offset(x: turtleX, y: -50)
                .opacity(turtleOpacity)
                .zIndex(6)
            
            Image("fish\(fishIndex)")
                .offset(y: -40)
                .scaleEffect(0.5)
                .rotationEffect(.init(degrees: currentTime.hrAngle()))
                .zIndex(2.1)
                .offset(y: 15)
            
            Image("clam")
                .scaleEffect(0.5)
                .offset(x: 65, y: 45)
                
            
            Image("clam2")
                .scaleEffect(0.5)
                .offset(x: 70, y: 80)
                
            
            Image("starfish")
                .scaleEffect(0.5)
                .offset(x: 50, y: 70)
                
            
            ZStack {
                Image("footstep")
                    .scaleEffect(0.3)
                    .offset(x: -70, y: 30)
                    .opacity(stepOpacity)
                
                Image("footstep")
                    .scaleEffect(0.3)
                    .offset(x: -30, y: 70)
                    .opacity(stepOpacity2)
            }
            
            
            
            
            
            
            
            
            
            
            
            
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
        
        .onReceive(secondReceiver, perform: { _ in
            let secondInNano = currentTime.secondInNano();
            
            
            if (secondInNano < 5000000000) {
                waveY = -250 + 130.0/5000000000*CGFloat(secondInNano)
            } else if (secondInNano < 10000000000) {
                waveY = -120
            } else if (secondInNano < 15000000000) {
                waveY = -120 - 130.0/5000000000*CGFloat(secondInNano-10000000000)
            } else {
                waveY = -250
            }
            
            let remainder = secondInNano % 2000000000
            if (remainder < 1000000000) {
                waveX = -100 + 200/1000000000*CGFloat(remainder)
            } else {
                waveX = 100 - 200/1000000000*CGFloat(remainder-1000000000)
            }
            
            
            if secondInNano < 2500000000 || secondInNano > 12500000000 {
                crabOpacity = 0
            } else {
                crabOpacity = 1
            }
            
            if (secondInNano < 2500000000) {
                crabX = -100
            } else if (secondInNano < 12500000000) {
                crabX = -100 + 200/10000000000*CGFloat(secondInNano-2500000000)
            } else {
                crabX = 100
            }
            
            if secondInNano < 15000000000 {
                turtleOpacity = 0
            } else {
                turtleOpacity    = 1
            }
            
            if (secondInNano < 15000000000) {
                turtleX = -100
            } else {
                turtleX = -100 + 200.0/45000000000*CGFloat(secondInNano-15000000000)
            }
            
            if (secondInNano < 20000000000) {
                stepOpacity = 0
            } else if secondInNano < 21000000000 {
                stepOpacity = Double(secondInNano - 20000000000)/1000000000
            } else if secondInNano < 24000000000 {
                stepOpacity = 1
            } else if secondInNano < 25000000000{
                stepOpacity = 1 - Double(secondInNano - 24000000000)/1000000000
            } else {
                stepOpacity = 0
            }
            
            if (secondInNano < 24000000000) {
                stepOpacity2 = 0
            } else if secondInNano < 25000000000 {
                stepOpacity2 = Double(secondInNano - 24000000000)/1000000000
            } else if secondInNano < 28000000000 {
                stepOpacity2 = 1
            } else if secondInNano < 29000000000{
                stepOpacity2 = 1 - Double(secondInNano - 28000000000)/1000000000
            } else {
                stepOpacity2 = 0
            }
            
            
            
            
        })
        .onReceive(thirdReceiver, perform: { _ in
            crabIndex = (crabIndex + 1) % 2
            turtleIndex = (turtleIndex + 1) % 2
        })
        
        
        
    }
    
}
