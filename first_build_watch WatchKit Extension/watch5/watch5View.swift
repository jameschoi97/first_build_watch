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

    @State var shadowX: CGFloat = 10
    @State var shadowY: CGFloat = -200

    var body: some View {
        ZStack {

            // Main clock
            Image("background5")
                .scaleEffect(0.5)
                .offset(y: 15)
                .zIndex(0)

            Image("hour\(hourIndex)")
                .scaleEffect(0.4)
                .offset(y: -25)
                .rotationEffect(.init(degrees: currentTime.hrAngle()))
                .offset(y: 20)
                .zIndex(1)

                Image("minute\(minuteIndex)")
                    .scaleEffect(0.4)
                    .offset(x: -5, y: -50)
                    .rotationEffect(.init(degrees: currentTime.minAngle()))
                    .offset(y: 20)
                    .zIndex(1)

                Image("surfer\(surferIndex)")
                    .scaleEffect(0.5)
                    .rotationEffect(.init(degrees: -90))
                    .offset(x: surferX)
                    .offset(x: -5, y: -50)
                    .rotationEffect(.init(degrees: currentTime.minAngle()))
                    .offset(y: 20)
                    .zIndex(3)

            Image("person")
                .scaleEffect(0.5)
                .offset(x: personX, y: personY)
                .zIndex(2)

            Image("seagull")
                .scaleEffect(0.3)
                .rotationEffect(.init(degrees: 90+seagullD))
                .offset(x: seagullX, y: seagullY)
                .zIndex(4)

            Image("tube")
                .scaleEffect(0.5)
                .rotationEffect(.init(degrees: 90+tubeD))
                .offset(x: tubeX, y: tubeY + 15)
                .zIndex(2)

            Image("ball")
                .scaleEffect(0.5)
                .offset(x: ballX, y: ballY)
                .zIndex(2)

            Image("shadow")
                .scaleEffect(0.5)
                .offset(x: shadowX, y: shadowY)
                .zIndex(0.1)

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
            let secondInMili = currentTime.secondInMili()

            let twoSecondRemainder = secondInMili % 2000

            if twoSecondRemainder < 1000 {
                surferX = -15 + 30/1000*CGFloat(twoSecondRemainder)
            } else {
                surferX = 15 - 30/1000*CGFloat(twoSecondRemainder-1000)
            }

            let thirtySecondRemainder = secondInMili % 30000

            if thirtySecondRemainder < 15000 {
                personX = -80 + 160/15000*CGFloat(thirtySecondRemainder)
            } else {
                personX = 80 - 160/15000*CGFloat(thirtySecondRemainder-15000)
            }

            let tenSecondRemainder = (secondInMili+2500) % 10000

            if tenSecondRemainder < 5000 {
                personY = 60 + 40/5000*CGFloat(tenSecondRemainder)
            } else {
                personY = 100 - 40/5000*CGFloat(tenSecondRemainder-5000)
            }

            if distance(x: seagullX, y: seagullY) > 150 {
                seagullX *= 0.8
                seagullY *= 0.8
                seagullD = Double.random(in: 0 ..< 360)
            }

            self.seagullX += CGFloat(2 * cos(seagullD * Double.pi / 180))
            self.seagullY += CGFloat(2 * sin(seagullD * Double.pi / 180))

            if thirtySecondRemainder < 5000 {
                tubeX = -150
                tubeY = -150
                tubeD = 45
            } else if thirtySecondRemainder < 12000 {
                tubeX = -150 + 110/7000*CGFloat(thirtySecondRemainder-5000)
                tubeY = -150 + 110/7000*CGFloat(thirtySecondRemainder-5000)
                tubeD = 45
            } else if thirtySecondRemainder < 15000 {
                tubeX = -40
                tubeY = -40
                tubeD = 45 + 180/3000000000*Double(thirtySecondRemainder-12000)
            } else if thirtySecondRemainder < 22000 {
                tubeX = -40-110/7000*CGFloat(thirtySecondRemainder-15000)
                tubeY = -40-110/7000*CGFloat(thirtySecondRemainder-15000)
                tubeD = 225
            } else {
                tubeX = -150
                tubeY = -150
                tubeD = 45
            }

            self.ballX += CGFloat(0.5 * cos(ballD * Double.pi / 180))
            self.ballY += CGFloat(0.5 * sin(ballD * Double.pi / 180))

            if sqrt(pow((ballX-targetX), 2) + pow((ballY-targetY), 2)) <= 5 {
                targetX = CGFloat.random(in: -90 ..< 90)
                targetY = CGFloat.random(in: -75 ..< 105)
            }
            let xDiff = targetX - ballX
            let yDiff = targetY - ballY
            self.ballD = Double(atan(yDiff/xDiff)) * 180 / Double.pi
            if xDiff < 0 {
                self.ballD += 180
            }

            if thirtySecondRemainder < 10000 {
                shadowX = 10
                shadowY = -150
            } else if secondInMili < 15000 {
                shadowX = 10 + 20/5000*CGFloat(thirtySecondRemainder-10000)
                shadowY = -150 + 300/5000*CGFloat(thirtySecondRemainder-10000)
            } else {
                shadowX = 30
                shadowY = 150
            }

        })

        .onReceive(thirdReceiver, perform: { _ in
            hourIndex = (hourIndex + 1) % 3
            minuteIndex = (minuteIndex + 1) % 4
            surferIndex = (surferIndex + 1) % 2

        })

    }

    func distance(x: CGFloat, y: CGFloat) -> Double {
        return sqrt(Double(pow(x, 2)) + Double(pow(y, 2)))
    }

}
