//
//  time.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/15.
//

import Foundation

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
