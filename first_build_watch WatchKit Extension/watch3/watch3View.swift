//
//  ContentView.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/12.
//

import SwiftUI

struct Watch3View: View {
    @State var currentTime = Time(ms: 0, sec: 0, min: 0, hr: 0)
    @State var receiver = Timer.publish(every: 0.2, on: .current, in: .default).autoconnect()
    @State var secondReceiver = Timer.publish(every: 0.3, on: .current, in: .default).autoconnect()
    
    
    //Caterpillar var
    @State var imgIndex: Int = 2;
    @State var moving: Bool = false;
    @State var xPos: CGFloat = 0;
    @State var yPos: CGFloat = 50;
    
    
    
    var width = WKInterfaceDevice.current().screenBounds.size.width
    var height = WKInterfaceDevice.current().screenBounds.size.height
    
    var leftBound: CGFloat = -90
    var rightBound: CGFloat = 90
    var topBound: CGFloat = -80
    var bottomBound: CGFloat = 110
    
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
            
            Image("caterpillar-\(imgIndex)")
                .scaleEffect(0.4)
                .offset(x: xPos, y: yPos)
            
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
            if (!moving){
                moving = true
                self.imgIndex = 2
            } else if (imgIndex == 2) {
                self.imgIndex = 3
            } else if (imgIndex == 3) {
                self.imgIndex = 1
                self.yPos -= 40
                moving = false
            }
            
            
        }
        
        
    }
    
}
