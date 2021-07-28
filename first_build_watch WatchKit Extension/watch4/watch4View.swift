//
//  ContentView.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/12.
//

import SwiftUI

struct Watch4View: View {
    @State var currentTime = Time(ms: 0, sec: 0, min: 0, hr: 0)
    @State var receiver = Timer.publish(every: 0.2, on: .current, in: .default).autoconnect()
    @State var secondReceiver = Timer.publish(every: 0.05, on: .current, in: .default).autoconnect()
    @State var thirdReceiver = Timer.publish(every: 0.2, on: .current, in: .default).autoconnect()
    
    @State var waveIndex: Int = 1;
    @State var waveGoingDown: Bool = true;
    @State var waveY: CGFloat = -150;
    
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
            
            
        }
        .onReceive(receiver, perform: { _ in
            let calendar = Calendar.current
            
            let ms = calendar.component(.nanosecond, from: Date())
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hr = calendar.component(.hour, from: Date())
            
            self.currentTime = Time(ms: ms, sec: sec, min: min, hr: hr)
            
            
        })
        .onReceive(thirdReceiver, perform: { _ in
            waveIndex = (waveIndex + 1) % 4 + 1
            
            
        })
        
        .onReceive(secondReceiver, perform: { _ in
            if waveY >= 0 {
                waveGoingDown = false
            }
            if waveY < -200 {
                waveGoingDown = true
            }
            waveY += waveGoingDown ? 5 : -5
        })
        
    }
    
}
