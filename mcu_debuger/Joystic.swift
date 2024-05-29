//
//  Joystic.swift
//  mcu_debuger
//
//  Created by TaigaTakano on 2024/03/09.
//

import Foundation
import SwiftUI
class JoystickValue : ObservableObject {
    @Published var YControllerPower : Int = 0
    @Published var XYControllerPower : Double = 0
    @Published var XYControllerDegree : Double = 0
}

struct XYControllerView: View {
    @ObservedObject var JV : JoystickValue
    @State var dragValue = CGSize.zero
    @State var isDragging = false
    
    var body: some View {
        VStack {
            XYStick()
                .offset(x: dragValue.width * 0.05, y: dragValue.height * 0.05) //0.05
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
                        self.dragValue = CGSize(width: value.translation.width * factor , height: value.translation.height * factor)
                        self.isDragging = true
                        powerManger(inputObjectPower: Int(sqrt(pow(dragValue.height, 2) + pow(dragValue.width, 2))))
                        radManger(dragValueHeight: dragValue.height, dragValueWidgh: dragValue.width)
                    }
                        .onEnded { value in
                            self.dragValue = .zero
                            self.isDragging = false
                            JV.XYControllerPower = 0
                            JV.XYControllerDegree = 365
                        }
                )
                .animation(.spring(response: 0.2, dampingFraction: 0.6, blendDuration: 0), value: self.dragValue)
            
        }    }
    
    func powerManger(inputObjectPower: Int){
        if inputObjectPower <= 20 {
            JV.XYControllerPower = 0
        }else if inputObjectPower >= 65{
            JV.XYControllerPower = 100
        }else{
            JV.XYControllerPower = ((Double(inputObjectPower) - 20.0) / 45.0 ) * 100.0
        }
        NSLog("PWR\(JV.XYControllerPower)")
    }
    
    func radManger(dragValueHeight: CGFloat , dragValueWidgh: CGFloat){
        let height: Double = Double(dragValueHeight)
        let widgh: Double = Double(dragValueWidgh)
        let diagonally: Double = sqrt(pow(height, 2) + pow(widgh, 2))
        
        var valueOfRad: Double = asin(height / diagonally) * -1
        if diagonally == 0 {
            valueOfRad = 0.0
        }
        
        if valueOfRad > 0{
            if widgh > 0 {
                //1
            }else{
                //2
                valueOfRad = (Double.pi / 2 - valueOfRad) + Double.pi / 2
            }
        }else{
            if widgh < 0 {
                //3
                valueOfRad = valueOfRad * -1 + Double.pi
            }else{
                //4
                valueOfRad = (Double.pi / 2 - valueOfRad * -1) + (Double.pi / 2) * 3
                
            }
        }
        JV.XYControllerDegree = valueOfRad
        NSLog("DEG:\(JV.XYControllerDegree)")
    }
}



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

struct XYStick: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 130, height: 130, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.gray.opacity(0.5))
            Circle()
                .frame(width: 115, height: 115, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
        }
    }
}
