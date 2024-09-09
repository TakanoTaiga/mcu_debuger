//
//  GamePadSerivce.swift
//  mcu_debuger
//
//  Created by Taiga Takano on 2024/09/01.
//

import Foundation
import GameController


struct GamepadInfoValue{
    var connected : Bool = false
    var battery : Float32 = 0
    var deviceName : String = ""
}

struct GamepadJoysticValue{
    var x : Float32 = 0
    var y : Float32 = 0
    var thumbstickButton : Bool = false
}

struct GamepadTriggerValue{
    var value : Float32 = 0
    var button : Bool = false
}

struct GamepadDpadValue{
    var up : Bool = false
    var down : Bool = false
    var left : Bool = false
    var right : Bool = false
}

struct GamepadButtonValue{
    var x : Bool = false
    var y : Bool = false
    var a : Bool = false
    var b : Bool = false
}

struct GamepadButtonValue2x{
    var x : Bool = false
    var y : Bool = false
    var a : Bool = false
}

struct GamepadValue{
    var leftJoystic =  GamepadJoysticValue()
    var rightJoystic =  GamepadJoysticValue()
    
    var leftTrigger = GamepadTriggerValue()
    var rightTrigger = GamepadTriggerValue()
    
    var spacer = GamepadButtonValue2x()
    
    var dpad = GamepadDpadValue()
    var button = GamepadButtonValue()
    
    var leftShoulderButton = false
    var rightShoulderButton = false
}

class GamePadSerivce: ObservableObject
{
    @Published private (set) public var gamepadValue = GamepadValue()
    @Published private (set) public var info = GamepadInfoValue()
    
    init()
    {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidConnect, object: nil, queue: nil, using: didConnectControllerHandler)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidDisconnect, object: nil, queue: nil, using: didDisconnectController)
        GCController.startWirelessControllerDiscovery{}
    }
    
    private func didConnectControllerHandler(_ notification: Notification)
    {
        info.connected = true
        let controller = notification.object as! GCController
        if let battery = controller.battery{
            info.battery = battery.batteryLevel
        }
        
        controller.extendedGamepad?.leftThumbstick.valueChangedHandler = { (button, xvalue, yvalue) in self.stick(1, xvalue, yvalue) }
        controller.extendedGamepad?.rightThumbstick.valueChangedHandler = { (button, xvalue, yvalue) in self.stick(2, xvalue, yvalue) }
        
        controller.extendedGamepad?.leftTrigger.valueChangedHandler = { (button, value, pressed) in self.trigger(1, value) }
        controller.extendedGamepad?.rightTrigger.valueChangedHandler = { (button, value, pressed) in self.trigger(2, value) }
        
        controller.extendedGamepad?.dpad.left.pressedChangedHandler = { (button, value, pressed) in self.button(0, pressed) }
        controller.extendedGamepad?.dpad.up.pressedChangedHandler = { (button, value, pressed) in self.button(1, pressed) }
        controller.extendedGamepad?.dpad.right.pressedChangedHandler = { (button, value, pressed) in self.button(2, pressed) }
        controller.extendedGamepad?.dpad.down.pressedChangedHandler = { (button, value, pressed) in self.button(3, pressed) }
        
        controller.extendedGamepad?.buttonX.pressedChangedHandler = { (button, value, pressed) in self.button(4, pressed) }
        controller.extendedGamepad?.buttonY.pressedChangedHandler = { (button, value, pressed) in self.button(5, pressed) }
        controller.extendedGamepad?.buttonB.pressedChangedHandler = { (button, value, pressed) in self.button(6, pressed) }
        controller.extendedGamepad?.buttonA.pressedChangedHandler = { (button, value, pressed) in self.button(7, pressed) }
        
        controller.extendedGamepad?.leftThumbstickButton?.pressedChangedHandler = { (button, value, pressed) in self.button(10, pressed) }
        controller.extendedGamepad?.rightThumbstickButton?.pressedChangedHandler = { (button, value, pressed) in self.button(11, pressed) }
        
        controller.extendedGamepad?.leftShoulder.pressedChangedHandler = { (button, value, pressed) in self.button(12, pressed) }
        controller.extendedGamepad?.rightShoulder.pressedChangedHandler = { (button, value, pressed) in self.button(13, pressed) }
        controller.extendedGamepad?.leftTrigger.pressedChangedHandler = { (button, value, pressed) in self.button(14, pressed) }
        controller.extendedGamepad?.rightTrigger.pressedChangedHandler = { (button, value, pressed) in self.button(15, pressed) }
        
    }
    
    private func didDisconnectController(_ notification: Notification)
    {
        info.connected = false
        info.battery = -1
    }
    
    private func stick(_ button: Int, _ xvalue: Float, _ yvalue: Float)
    {
        func normalize(_ value: Float) -> Float {
            if value > 0.1 {
                return (value - 0.1) / 0.9
            } else if value < -0.1 {
                return (value + 0.1) / 0.9
            } else {
                return 0.0
            }
        }
        
        NSLog("LAWVALUE \(xvalue)")
        
        if button == 1 {
            gamepadValue.leftJoystic.x = normalize(xvalue)
            gamepadValue.leftJoystic.y = normalize(yvalue)
        } else if button == 2 {
            gamepadValue.rightJoystic.x = normalize(xvalue)
            gamepadValue.rightJoystic.y = normalize(yvalue)
        }
    }
    
    private func trigger(_ trigger: Int, _ value: Float)
    {
        switch trigger{
        case 1:
            gamepadValue.leftTrigger.value = value
        case 2:
            gamepadValue.rightTrigger.value = value
        default: break
        }
    }
    
    private func button(_ button: Int, _ pressed: Bool)
    {
        switch button {
        case 0:
            gamepadValue.dpad.left = pressed
        case 1:
            gamepadValue.dpad.up = pressed
        case 2:
            gamepadValue.dpad.right = pressed
        case 3:
            gamepadValue.dpad.down = pressed
        case 4:
            gamepadValue.button.x = pressed
        case 5:
            gamepadValue.button.y = pressed
        case 6:
            gamepadValue.button.b = pressed
        case 7:
            gamepadValue.button.a = pressed
        case 10:
            gamepadValue.leftJoystic.thumbstickButton = pressed
        case 11:
            gamepadValue.rightJoystic.thumbstickButton = pressed
        case 12:
            gamepadValue.leftShoulderButton = pressed
        case 13:
            gamepadValue.rightShoulderButton = pressed
        case 14:
            gamepadValue.leftTrigger.button = pressed
        case 15:
            gamepadValue.rightTrigger.button = pressed
            
        default: break
        }
    }
}
