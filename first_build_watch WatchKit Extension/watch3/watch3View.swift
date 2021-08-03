//
//  ContentView.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/12.
//

import SwiftUI
import AVFAudio

enum CaterpillarBehavior: Int {
    case drawingMinute = 0
    case freeMoving = 1
    case waiting = 2
}

struct Watch3View: View {
    @State var currentTime = Time(ns: 0, sec: 0, min: 0, hr: 0)
    @State var receiver = Timer.publish(every: 0.2, on: .current, in: .default).autoconnect()
    @State var secondReceiver = Timer.publish(every: 0.3, on: .current, in: .default).autoconnect()
    @State var thirdReceiver = Timer.publish(every: 0.05, on: .current, in: .default).autoconnect()

    // Minutehand var
    @State var xMinute: CGFloat = 0
    @State var yMinute: CGFloat = 0
    var holeCount: Int = 12
    @State var holeOpacity: [Double] = Array(repeating: 1.0, count: 12)
    @State var holeSize: [Double] = (0..<12).map { _ in Double.random(in: 8 ... 15) }

    // Caterpillar var
    @State var imgIndex: Int = 2
    @State var moving: Bool = false
    @State var xPos: CGFloat = 0
    @State var yPos: CGFloat = 50
    @State var direction: Double = 0
    @State var xTarget: CGFloat = 10
    @State var yTarget: CGFloat = 10
    @State var stepSize: Double = 14
    @State var dTarget: Double = 0
    @State var dIncrement: Double = 0
    @State var currentBehavior: CaterpillarBehavior = .freeMoving

    // Screen bounds for the random target selection
    var leftBound: CGFloat = -90
    var rightBound: CGFloat = 90
    var topBound: CGFloat = -75
    var bottomBound: CGFloat = 105

    var body: some View {
        ZStack {

            // Minute hand, or the holes
            ForEach(0..<holeCount) { index in
                Circle()
                    .fill(Color(.black))
                    .frame(width: CGFloat(holeSize[index]), height: CGFloat(holeSize[index]))
                    .offset(x: holePosition(minutePosition: xMinute, index: index), y: holePosition(minutePosition: yMinute, index: index))
                    .offset(y: 15)
                    .opacity(holeOpacity[index])
                    .zIndex(1)
            }

            Image("leaf_background2")
                .zIndex(0)
                .scaleEffect(0.5)
                .opacity(1)
                .offset(y: 15)
                .zIndex(0)

            Image("caterpillar-\(imgIndex)")
                .offset(y: 30)
                .scaleEffect(0.6)
                .rotationEffect(.init(degrees: 90 + direction))
                .offset(x: xPos, y: yPos)
                .zIndex(3)

            //Hour hand and its shadow
            Image("branch")
                .rotationEffect(.init(degrees: -90))
                .offset(y: -130)
                .scaleEffect(0.22)
                .rotationEffect(.init(degrees: currentTime.hrAngle()))
                .zIndex(2)
                .offset(y: 15)
            Image("branch_shadow")
                .rotationEffect(.init(degrees: -90))
                .offset(y: -130)
                .scaleEffect(0.22)
                .rotationEffect(.init(degrees: currentTime.hrAngle()))
                .zIndex(1.9)
                .offset(x: 5, y: 20)

        }
        .onReceive(receiver, perform: { _ in
            let calendar = Calendar.current

            let ns = calendar.component(.nanosecond, from: Date())
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hr = calendar.component(.hour, from: Date())

            self.currentTime = Time(ns: ns, sec: sec, min: min, hr: hr)

            xMinute = CGFloat(90 * cos((currentTime.absMinAngle()-90) * Double.pi / 180))
            yMinute = CGFloat(90 * sin((currentTime.absMinAngle()-90) * Double.pi / 180))

        })

        .onReceive(secondReceiver) { _ in
            // Next action if the caterpillar has reached its target
            if sqrt(pow((xPos-xTarget), 2) + pow((yPos-yTarget), 2)) <= 3 {
                if currentBehavior == .waiting {
                    // Usually this should trigger at 0 second when the minute has changed, but since the caterpillar might not get to the starting point on time, we wait up to 40 seconds
                    if currentTime.sec <= 40 {
                        currentBehavior = .drawingMinute
                        xMinute = CGFloat(90 * cos((currentTime.absMinAngle()-90) * Double.pi / 180))
                        yMinute = CGFloat(90 * sin((currentTime.absMinAngle()-90) * Double.pi / 180))
                        holeSize = (0..<12).map { _ in Double.random(in: 8 ... 15) }
                        xTarget = xMinute
                        yTarget = yMinute + 15
                    }
                } else if currentBehavior == .drawingMinute {
                    // If the caterpillar reached a target while drawing the minute, that means the minute drawing is complete. We let it move around freely now
                    currentBehavior = .freeMoving
                    xTarget = CGFloat.random(in: leftBound ..< rightBound)
                    yTarget = CGFloat.random(in: topBound ..< bottomBound)
                } else {
                    if xTarget == 0 && yTarget == 15 {
                        // If the target was the origin, then the caterpillar was coming back to the starting point. Make it wait until the minute changes
                        currentBehavior = .waiting
                    } else if holeOpacity[0] == 0 || currentTime.sec > 40 {
                        // If the minute has disappeared (minute has passed) or its past 40 seconds, start making its way back to the center of the clock
                        xTarget = 0
                        yTarget = 15
                    } else {
                        xTarget = CGFloat.random(in: leftBound ..< rightBound)
                        yTarget = CGFloat.random(in: topBound ..< bottomBound)
                    }
                }
                let distance = sqrt(pow((xPos-xTarget), 2) + pow((yPos-yTarget), 2))
                let steps: Int = Int(distance) / 15 + 1
                stepSize = Double(distance) / Double(steps)

            }
            if sqrt(pow((xPos-xTarget), 2) + pow((yPos-yTarget), 2)) > 3 {
                // If target hasn't been reached, calculate the direction and face the target
                let xDiff = xTarget - xPos
                let yDiff = yTarget - yPos
                self.dTarget = Double(atan(yDiff/xDiff)) * 180 / Double.pi
                if xDiff < 0 {
                    self.dTarget += 180
                }}
            let dDiff = dTarget == direction ? 0 : (dTarget - direction).truncatingRemainder(dividingBy: 360)

            if abs(dDiff) < 3 {
                // Only move when turning is over
                dIncrement = 0
                if !moving {
                    imgIndex = 1
                }
                if currentBehavior != .waiting {
                    // If supposed to be moving, change image and take small steps to make it look natural
                    if !moving {
                        moving = true
                        self.imgIndex = 2
                    } else if imgIndex == 2 {
                        self.imgIndex = 3
                    } else if imgIndex == 3 {
                        self.imgIndex = 4
                    } else {
                        self.imgIndex = 1
                        if currentBehavior == .drawingMinute {
                            // If while drawing the minute, make the holes appear as the caterpillar gets closer
                            for index in 0..<holeCount {
                                let xHole = holePosition(minutePosition: xMinute, index: index)
                                let yHole = holePosition(minutePosition: yMinute, index: index)
                                if sqrt(pow((xPos-xHole), 2) + pow((yPos-yHole), 2)) <= 20 {
                                    holeOpacity[index] = 1
                                }
                            }
                        }
                        self.xPos += CGFloat(stepSize * cos(direction * Double.pi / 180))
                        self.yPos += CGFloat(stepSize * sin(direction * Double.pi / 180))
                        if currentBehavior == .drawingMinute {
                            // Check the proximity to the holes again after the movement too
                            for index in 0..<holeCount {
                                let xHole = holePosition(minutePosition: xMinute, index: index)
                                let yHole = holePosition(minutePosition: yMinute, index: index)
                                if sqrt(pow((xPos-xHole), 2) + pow((yPos-yHole), 2)) <= 20 {
                                    holeOpacity[index] = 1
                                }
                            }
                        }
                        moving = false
                    }
                }
            }
        }
        .onReceive(thirdReceiver) { _ in
            var dDiff = (dTarget - direction).truncatingRemainder(dividingBy: 360)
            if dDiff > 180 {
                // Turn anticlockwise if it would be more efficient
                dDiff = dDiff - 360
            }
            if dTarget != direction {
                // Turn to the direction of the target, change the image while turning to make it look more natural
                let turns: Int = Int(abs(dDiff)) / 5 + 1
                dIncrement = dDiff / Double(turns)
                direction = (direction + dIncrement).truncatingRemainder(dividingBy: 360)
                if dIncrement < -1 {
                    imgIndex = 5
                } else if dIncrement > 1 {
                    imgIndex = 6
                }
            }
            if currentTime.sec > 58 {
                // If the second has passed 58 seconds, start making the holes disappear
                for index in 0..<holeCount {
                    holeOpacity[index] = holeOpacity[index] - 0.1
                }
            }
        }

    }

    func holePosition(minutePosition: CGFloat, index: Int) -> CGFloat {
        return minutePosition / CGFloat(holeCount) * CGFloat(index)
    }

}
