//
//  OmniUtil.swift
//  mcu_debuger
//
//  Created by Taiga on 2024/05/30.
//

import Foundation

class OmniUtil{
    private var x_power: Double
    private var y_power: Double
    private var rotation_power: Double
    
    init(x_power_: Double, y_power_: Double, rotation_power_: Double) {
        self.x_power = x_power_
        self.y_power = y_power_
        self.rotation_power = rotation_power_
    }
    
    func ConvertToMotorPower() -> (Double, Double, Double, Double) {
        let FrontRight =  ( 0.707106781 * self.x_power - 0.707106781 * self.y_power) + self.rotation_power * 0.5;
        let FrontLeft  =  (-0.707106781 * self.x_power - 0.707106781 * self.y_power) + self.rotation_power * 0.5;
        let RearLeft   =  (-0.707106781 * self.x_power + 0.707106781 * self.y_power) + self.rotation_power * 0.5;
        let RearRight  =  ( 0.707106781 * self.x_power + 0.707106781 * self.y_power) + self.rotation_power * 0.5;
        
        return (FrontRight, FrontLeft, RearLeft, RearRight)
    }
}
