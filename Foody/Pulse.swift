//
//  Pulse.swift
//  Foody
//
//  Created by Giovanni Lenguito on 07/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class Pulse: CALayer {
    //MARK: Properties
    var group = CAAnimationGroup()
    var scale : Float = 0
    var pulseRate : TimeInterval = 0
    var animationTime : TimeInterval = 0
    var radius : CGFloat = 0
    var totalPulses : Float = Float.infinity
    
    
    //MARK: Functions
    func setupGroup() {
        //declare curve
        let curve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        //set group values
        self.group = CAAnimationGroup()
        self.group.duration = animationTime + pulseRate
        self.group.repeatCount = totalPulses
        self.group.timingFunction = curve
        self.group.animations = [scaleAnimation(), animationOpacity()]
    }
    
    func scaleAnimation () -> CABasicAnimation {
        //set up scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        
        //Set values and duration
        scaleAnimation.fromValue = NSNumber(value: scale)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationTime
        
        //return csbasicanimation
        return scaleAnimation
    }
    
    func animationOpacity() -> CAKeyframeAnimation {
        //set up cskeyframeanimation animation (opacity)
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        
        //set values
        opacityAnimation.duration = animationTime
        opacityAnimation.values = [0.5, 0.7, 0]
        opacityAnimation.keyTimes = [0, 0.3, 1.1]
        
        //return cskeyframeanimation
        return opacityAnimation
    }
    
    
    //MARK: Init
    required init?(coder aDecoder: NSCoder){
        super.init(coder : aDecoder)
    }
    
    override init(layer : Any){
        super.init(layer : layer)
    }
    
    init (numberPulses:Float = Float.infinity, radius:CGFloat, position:CGPoint, duration : TimeInterval, colour : CGColor){
        super.init()
        
        //set values
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.totalPulses = numberPulses
        self.position = position
        self.animationTime = duration
        self.backgroundColor = colour
        
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = radius
        
        
        //add group
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupGroup()
            
            DispatchQueue.main.async {
                self.add(self.group, forKey: "pulse")
            }
        }
        
        
        
    }
    
}
