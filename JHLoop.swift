//
//  JHLoop.swift
//  loops
//
//  Created by Jeff Holtzkener on 3/2/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//

import Foundation
import UIKit



// add extension to override loop


class JHLoop: NSObject{
    var trigger: Int {
        return Int(60 * duration)  // 60fps * t in seconds
    }
    var counter: Int = 0
    var duration: Double  = 1.0 // in seconds
    var displayLink: CADisplayLink?
    weak var delegate: JHLoopDelegate?
    
    init(dur: Double) {
        duration = dur
    }
    
    func stopLoop() {
        displayLink?.invalidate()
    }
    
    func startLoop() {
        counter = 0
        displayLink = CADisplayLink(target: self, selector: "update")
        displayLink?.frameInterval = 1
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func update() {
        if counter < trigger {
            counter++
        } else {
            counter = 0
            
            // execute loop here
            NSLog("loop executed")
            delegate!.loopBody()
        }
    }
}

@objc protocol JHLoopDelegate: class {
    func loopBody()
}