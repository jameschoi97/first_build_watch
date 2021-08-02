//
//  ContentView.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/12.
//

import SwiftUI

struct Watch5View: View {
    @State var currentTime = Time(ns: 0, sec: 0, min: 0, hr: 0)
    @State var receiver = Timer.publish(every: 0.2, on: .current, in: .default).autoconnect()
    @State var secondReceiver = Timer.publish(every: 0.05, on: .current, in: .default).autoconnect()
    @State var thirdReceiver = Timer.publish(every: 0.4, on: .current, in: .default).autoconnect()
    
    @State var hourIndex: Int = 0
    @State var minuteIndex: Int = 0
    @State var surferIndex: Int = 0
    
    @State var surferX: CGFloat = -15
    
    @State var personX: CGFloat = -80
    @State var personY: CGFloat = 60
    
    @State var seagullX: CGFloat = -50
    @State var seagullY: CGFloat = -50
    @State var seagullD: Double = 0
    
    @State var tubeX: CGFloat = -150
    @State var tubeY: CGFloat = -150
    @State var tubeD: Double = 45
    
    @State var ballX: CGFloat = 0
    @State var ballY: CGFloat = 0
    @State var targetX: CGFloat = 100
    @State var targetY: CGFloat = 100
    @State var ballD: Double = 0
    
    var body: some View {
        ZStack{
            
            // Main clock
            Image("background5")
                .scaleEffect(0.5)
                .offset(y: 15)
            
            Image("hour\(hourIndex)")
                .scaleEffect(0.4)
                .offset(y: -20)
                .rotationEffect(.init(degrees: currentTime.hrAngle()))
                .offset(y: 15)
            
            ZStack{
                Image("minute\(minuteIndex)")
                    .scaleEffect(0.4)
                
                Image("surfer\(surferIndex)")
                    .scaleEffect(0.5)
                    .rotationEffect(.init(degrees: -90))
                    .offset(x: surferX)
            }
            .offset(x: -5, y:-50)
            .rotationEffect(.init(degrees: currentTime.minAngle()))
            .offset(y: 20)
            
            Image("person")
                .scaleEffect(0.5)
                .offset(x: personX, y: personY)
            
            Image("seagull")
                .scaleEffect(0.3)
                .rotationEffect(.init(degrees: 90+seagullD))
                .offset(x:seagullX, y: seagullY)
                
            Image("tube")
                .scaleEffect(0.5)
                .rotationEffect(.init(degrees: 90+tubeD))
                .offset(x:tubeX, y: tubeY + 15)
            
            Image("ball")
                .scaleEffect(0.5)
                .offset(x: ballX, y: ballY)
            
            
            
            
            
        
        }
        .onReceive(receiver, perform: { _ in
            let calendar = Calendar.current
            
            let ns = calendar.component(.nanosecond, from: Date())
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hr = calendar.component(.hour, from: Date())
            
            self.currentTime = Time(ns: ns, sec: sec, min: min, hr: hr)
            
            
        })
        
        .onReceive(secondReceiver, perform: { _ in
            let secondInNano = currentTime.secondInNano();
            
            let twoSecondRemainder = secondInNano % 2000000000
            
            if (twoSecondRemainder < 1000000000) {
                surferX = -15 + 30/1000000000*CGFloat(twoSecondRemainder)
            } else {
                surferX = 15 - 30/1000000000*CGFloat(twoSecondRemainder-1000000000)
            }
            
            
            
            let thirtySecondRemainder = secondInNano % 30000000000
            
            if (thirtySecondRemainder < 15000000000) {
                personX = -80 + 160/15000000000*CGFloat(thirtySecondRemainder)
            } else {
                personX = 80 - 160/15000000000*CGFloat(thirtySecondRemainder-15000000000)
            }
            
            let tenSecondRemainder = (secondInNano+2500000000) % 10000000000
            
            if (tenSecondRemainder < 5000000000) {
                personY = 60 + 40/5000000000*CGFloat(tenSecondRemainder)
            } else {
                personY = 100 - 40/5000000000*CGFloat(tenSecondRemainder-5000000000)
            }
            
            if distance(seagullX, seagullY) > 150 {
                seagullX = seagullX * 0.8
                seagullY = seagullY * 0.8
                seagullD = Double.random(in: 0 ..< 360)
            }
            
            self.seagullX += CGFloat(2 * cos(seagullD * Double.pi / 180))
            self.seagullY += CGFloat(2 * sin(seagullD * Double.pi / 180))
            
            if thirtySecondRemainder < 5000000000 {
                tubeX = -150
                tubeY = -150
                tubeD = 45
            } else if thirtySecondRemainder < 12000000000 {
                tubeX = -150 + 110/7000000000*CGFloat(thirtySecondRemainder-5000000000)
                tubeY = -150 + 110/7000000000*CGFloat(thirtySecondRemainder-5000000000)
                tubeD = 45
            } else if thirtySecondRemainder < 15000000000 {
                tubeX = -40
                tubeY = -40
                tubeD = 45 + 180/3000000000*Double(thirtySecondRemainder-12000000000)
            } else if thirtySecondRemainder < 22000000000 {
                tubeX = -40-110/7000000000*CGFloat(thirtySecondRemainder-15000000000)
                tubeY = -40-110/7000000000*CGFloat(thirtySecondRemainder-15000000000)
                tubeD = 225
            } else {
                tubeX = -150
                tubeY = -150
                tubeD = 45
            }
            
            
            self.ballX += CGFloat(0.5 * cos(ballD * Double.pi / 180))
            self.ballY += CGFloat(0.5 * sin(ballD * Double.pi / 180))
            
            
            if (sqrt(pow((ballX-targetX),2) + pow((ballY-targetY),2)) <= 5){
                targetX = CGFloat.random(in: -90 ..< 90)
                targetY = CGFloat.random(in: -75 ..< 105)
            }
            let xDiff = targetX - ballX
            let yDiff = targetY - ballY
            self.ballD = Double(atan(yDiff/xDiff)) * 180 / Double.pi
            if (xDiff < 0) {
                self.ballD += 180
            }
            
            
        })
        
        .onReceive(thirdReceiver, perform: { _ in
            hourIndex = (hourIndex + 1) % 3
            minuteIndex = (minuteIndex + 1) % 4
            surferIndex = (surferIndex + 1) % 2
            
            
        })
        
    }
    
    
    func distance(_ x:CGFloat, _ y:CGFloat) -> Double {
        return sqrt(Double(pow(x, 2)) + Double(pow(y, 2)))
    }

    
}
