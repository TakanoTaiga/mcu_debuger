//
//  YController.swift
//  mcu_debuger
//
//  Created by Taiga on 2024/05/30.
//

import SwiftUI

struct YControllerView: View {
    @ObservedObject var JV : JoystickValue
    @State var dragValue = CGSize.zero
    @State var isDragging = false
    @State var firstFlag = true
    
    var body: some View {
        VStack {
            XYStick()
                .offset(x: dragValue.width * 0.05, y: dragValue.height * 0.05)
                .frame(width: 180, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: isDragging ? (55 - abs(dragValue.height) / 10) : 55, style: .continuous))
                .offset(x: dragValue.width, y: dragValue.height)
                .gesture(
                    DragGesture().onChanged { value in
                        let limit: CGFloat = 200
                        let xOff = value.translation.width
                        let yOff = value.translation.height
                        let dist = sqrt(xOff*xOff + yOff*yOff);
                        let factor = 1 / (dist / limit + 1)
                        self.dragValue = CGSize(width: 0 , height: value.translation.height * factor)
                        self.isDragging = true
                        
                        powerManger(inputObjectPowerWidth: dragValue.height)

                    }
                        .onEnded { value in
                            self.dragValue = .zero
                            self.isDragging = false
                            powerManger(inputObjectPowerWidth: dragValue.height)
                            
                        }
                )
                .animation(.spring(response: 0.2, dampingFraction: 0.6, blendDuration: 0), value: self.dragValue)
        }
    }
    
    func powerManger(inputObjectPowerWidth: CGFloat){
        let inputObjectPower = Double(inputObjectPowerWidth)
        if sqrt(pow(inputObjectPower, 2)) <= 20 {
            JV.YControllerPower = 0
            JV.YControllerPower = 0
        }else if sqrt(pow(inputObjectPower, 2)) >= 80{
            if inputObjectPower > 0 {
                JV.YControllerPower = -200
                
            }else{
                JV.YControllerPower = 200
            }
        }else{
            if inputObjectPower > 0 {
                JV.YControllerPower = Int(((sqrt(pow(inputObjectPower, 2)) - 20.0) / 60.0 ) * -200.0)
                
            }else{
                JV.YControllerPower = Int(((sqrt(pow(inputObjectPower, 2)) - 20.0) / 60.0 ) * 200)
            }
        }
    }
}
