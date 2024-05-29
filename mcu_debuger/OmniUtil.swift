//
//  OmniUtil.swift
//  mcu_debuger
//
//  Created by Taiga on 2024/05/30.
//

import Foundation

class OmniUtil{
    public var power: Double
    public var angle: Double
    public var rotation: Double
    
    init(power: Double, angle: Double, rotation: Double) {
        self.power = power
        self.angle = angle
        self.rotation = rotation
    }
    
    func ConvertToMotorPower() -> (Double, Double, Double, Double) {
        let x = cos(self.angle) * -1.0
        let y = sin(self.angle)
        let z = Double(self.rotation)
        
        if(self.power < 3.0){
            self.power = 0.0
        }
        let FrontRight =  self.power * ( 0.707106781 * x - 0.707106781 * y) + z * 0.5;
        let FrontLeft  =  self.power * (-0.707106781 * x - 0.707106781 * y) + z * 0.5;
        let RearLeft   =  self.power * (-0.707106781 * x + 0.707106781 * y) + z * 0.5;
        let RearRight  =  self.power * ( 0.707106781 * x + 0.707106781 * y) + z * 0.5;
        
        return (FrontRight, FrontLeft, RearLeft, RearRight)
    }
}
