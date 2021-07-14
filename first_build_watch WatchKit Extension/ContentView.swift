//
//  ContentView.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/12.
//

import SwiftUI

struct ContentView: View {
    @State var currentTime = Time(ms: 0, sec: 0, min: 0, hr: 0)
    @State var receiver = Timer.publish(every: 0.2, on: .current, in: .default).autoconnect()
    @State var secondReceiver = Timer.publish(every: 0.1, on: .current, in: .default).autoconnect()
    
    @State var particleDirection: Double = 60
    var width = WKInterfaceDevice.current().screenBounds.size.width
    var height = WKInterfaceDevice.current().screenBounds.size.height
    
    var leftBound: CGFloat = -90
    var rightBound: CGFloat = 90
    var topBound: CGFloat = -80
    var bottomBound: CGFloat = 110

    
    @State var stickIndex: Int = 1
    @State var petalsY1: CGFloat = 0
    @State var petalsY2: CGFloat = -340
    @State var petalsY3: CGFloat = 0
    @State var petalsY4: CGFloat = -160
    @State var particleX: CGFloat = 0
    @State var particleY: CGFloat = 0
    
    
    
    
    
    var body: some View {
        ZStack{
            
            
            // Main clock
            Rectangle()
                .fill(Color(.black))
        
            Image("stick-\(stickIndex)")
                .scaleEffect(0.3)
                .offset(y: -(width) / 4)
                .rotationEffect(.init(degrees: currentTime.secAngle()))
                .zIndex(2)
            
            Image("petals")
                .offset(y: petalsY1)
                .scaleEffect(0.6)
                .opacity(0.6)
                .zIndex(3)

            Image("petals")
                .offset(y: petalsY2)
                .opacity(0.6)
                .scaleEffect(0.6)
                .zIndex(3)

            Image("petals")
                .rotationEffect(.init(degrees:180))
                .scaleEffect(0.4)
                .opacity(0.15)
                .offset(y: petalsY3)
                .zIndex(1)
                

            Image("petals")
                .rotationEffect(.init(degrees:180))
                .scaleEffect(0.4)
                .opacity(0.15)
                .offset(y: petalsY4)
                .zIndex(1)
            
            Image("particle")
                .scaleEffect(0.1)
                .zIndex(4)
                .offset(x: particleX, y: particleY)
                

            
            
            
            // Seconds and Min dots
            
//            ForEach(0..<60, id: \.self) {i in
//                Rectangle()
//                    .fill(Color(.green))
//                    .frame(width: 2, height: (i % 5) == 0 ? 10 : 5)
//                    .offset(y: (width - 40) / 2)
//                    .rotationEffect(.init(degrees: Double(i * 6)))
//            }
            
            // Second hand
//            Rectangle()
//                .fill(Color.red)
//                .frame(width: 2, height: (width - 40) / 2)
//                .offset(y: -(width - 60) / 4)
//                .rotationEffect(.init(degrees: Double(currentTime.sec) * 6))
            
            // Minute hand
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: (width - 70) / 2)
                .offset(y: -(width - 90) / 4)
                .rotationEffect(.init(degrees: currentTime.minAngle()))
                .zIndex(2)
            
            // Hour hand
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: (width - 100) / 2)
                .offset(y: -(width - 120) / 4)
                .rotationEffect(.init(degrees: currentTime.hrAngle()))
                .zIndex(2)
            
            // Center Circle
            Circle()
                .fill(Color.red)
                .frame(width:8, height: 8)
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
            self.stickIndex = (stickIndex + 1) % 77 + 1
            self.petalsY1 += 5
            self.petalsY2 += 5
            self.petalsY3 += 2
            self.petalsY4 += 2
            if (petalsY1 > 340){
                petalsY1 = -340
            }
            if (petalsY2 > 340){
                petalsY2 = -340
            }
            if (petalsY3 > 160){
                petalsY3 = -160
            }
            if (petalsY4 > 160){
                petalsY4 = -160
            }
            
            self.particleX += CGFloat(5 * cos(particleDirection * Double.pi / 180))
            self.particleY += CGFloat(5 * sin(particleDirection * Double.pi / 180))
            
            if (particleX < leftBound){
                particleX = leftBound
                self.particleDirection = Double.random(in: -90.0 ..< 90.0)
            }
            if (particleX > rightBound){
                particleX = rightBound
                self.particleDirection = Double.random(in: 90.0 ..< 270.0)
            }
            if (particleY < topBound){
                particleY = topBound
                self.particleDirection = Double.random(in: 0 ..< 180)
            }
            if (particleY > bottomBound){
                particleY = bottomBound
                self.particleDirection = Double.random(in: 180 ..< 360)
            }
            
            
        }
        
        
    }
    
}

struct Time {
    var ms: Int
    var sec: Int
    var min: Int
    var hr: Int
    
    func secAngle() -> Double {
        return Double(sec) * 6 + Double(ms) * 6/1000000000
    }
    
    func minAngle() -> Double {
        return Double(min) * 6 + Double(sec)*0.1 + Double(ms) * 0.1/1000000000
    }
    
    func hrAngle() -> Double {
        return Double(hr) * 30 + Double(min) * 0.5 + Double(sec) * 0.5/60 + Double(ms) * 0.5/60000000000
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
