//
//  ContentView.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/12.
//

import SwiftUI

struct Watch2View: View {
    @State var currentTime = Time(ms: 0, sec: 0, min: 0, hr: 0)
    @State var receiver = Timer.publish(every: 0.2, on: .current, in: .default).autoconnect()
    @State var secondReceiver = Timer.publish(every: 0.1, on: .current, in: .default).autoconnect()
    
    
    var width = WKInterfaceDevice.current().screenBounds.size.width
    var height = WKInterfaceDevice.current().screenBounds.size.height
    
    var leftBound: CGFloat = -90
    var rightBound: CGFloat = 90
    var topBound: CGFloat = -80
    var bottomBound: CGFloat = 110

    @State var antDirection: Double = 45
    @State var antX: CGFloat = 0
    @State var antY: CGFloat = 0
    @State var targetX: CGFloat = 10
    @State var targetY: CGFloat = 10
    
    @State var antDirection2: Double = 45
    @State var antX2: CGFloat = 0
    @State var antY2: CGFloat = 0
    @State var targetX2: CGFloat = 10
    @State var targetY2: CGFloat = 10
    
    
    var body: some View {
        ZStack{
            
            
            // Main clock
            Rectangle()
                .fill(Color(.white))
            Image("candyBackground")
                .zIndex(0)
                .scaleEffect(0.6)
                .opacity(0.3)
                .offset(y: 15)
            
            Image("ant")
                .scaleEffect(0.01)
                .rotationEffect(.init(degrees: antDirection + 90))
                .zIndex(4)
                .offset(x: antX, y: antY)
            
            Image("ant")
                .scaleEffect(0.006)
                .rotationEffect(.init(degrees: antDirection2 + 90))
                .zIndex(4)
                .offset(x: antX2, y: antY2)
            
            
            
            
          
            Image("kitkat")
                .scaleEffect(0.2)
                .rotationEffect(.init(degrees: 90))
                .offset(y: -35)
                .rotationEffect(.init(degrees: currentTime.minAngle()))
                .zIndex(2)
                .offset(y: 15)
            
            // Hour hand
            Image("lolipop")
                .scaleEffect(0.01)
                .offset(y: -18)
                .rotationEffect(.init(degrees: currentTime.hrAngle()))
                .zIndex(2)
                .offset(y: 15)
            
            
        }
        .onReceive(receiver, perform: { _ in
            let calendar = Calendar.current
            
            let ms = calendar.component(.nanosecond, from: Date())
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hr = calendar.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)) {
                self.currentTime = Time(ms: ms, sec: sec, min: min, hr: hr)
            }
        })
        
        .onReceive(secondReceiver) { _ in
            
            self.antX += CGFloat(3 * cos(antDirection * Double.pi / 180))
            self.antY += CGFloat(3 * sin(antDirection * Double.pi / 180))
            
            
            if (sqrt(pow((antX-targetX),2) + pow((antY-targetY),2)) <= 5){
                targetX = CGFloat.random(in: leftBound ..< rightBound)
                targetY = CGFloat.random(in: topBound ..< bottomBound)
            }
            let xDiff = targetX - antX
            let yDiff = targetY - antY
            self.antDirection = Double(atan(yDiff/xDiff)) * 180 / Double.pi
            if (xDiff < 0) {
                self.antDirection += 180
            }
            
            self.antX2 += CGFloat(5 * cos(antDirection2 * Double.pi / 180))
            self.antY2 += CGFloat(5 * sin(antDirection2 * Double.pi / 180))
            
            
            if (sqrt(pow((antX2-targetX2),2) + pow((antY2-targetY2),2)) <= 7){
                targetX2 = CGFloat.random(in: leftBound ..< rightBound)
                targetY2 = CGFloat.random(in: topBound ..< bottomBound)
            }
            let xDiff2 = targetX2 - antX2
            let yDiff2 = targetY2 - antY2
            self.antDirection2 = Double(atan(yDiff2/xDiff2)) * 180 / Double.pi
            if (xDiff2 < 0) {
                self.antDirection2 += 180
            }
            
        }
        
        
    }
    
}
