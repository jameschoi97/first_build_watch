//
//  caterpillar.swift
//  first_build_watch WatchKit Extension
//
//  Created by James Choi on 2021/07/15.
//

import SwiftUI

struct Caterpillar: View {
    
    @State var imgIndex: Int = 1
    @State var moving: Bool = false
    
    @State var xPos: CGFloat = 0
    @State var yPos: CGFloat = 50
    
    var body: some View{
        Image("caterpillar-\(imgIndex)")
            .scaleEffect(0.4)
            .offset(x: xPos, y: yPos)
    }
    
    func move(){
        print("moving")
        self.moving = true
        self.yPos = 40
        self.moving = false
        print(self.yPos)
    }
}
