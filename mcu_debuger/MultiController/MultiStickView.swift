//
//  MultiStickView.swift
//  mcu_debuger
//
//  Created by Taiga on 2024/05/30.
//

import SwiftUI

struct MultiStickView: View {
    @ObservedObject var mcu_connection_handler: MCUConnectionHandler
    @ObservedObject var param_mcu: ParamMCUConnection
    @ObservedObject var joystickValue: JoystickValue
    
    var body: some View {
        ZStack{
            HStack{
                XYControllerView(JV: joystickValue)
                    .padding(.bottom, 50.0)
                Spacer()
            }
            
            HStack{
                Spacer()
                XControllerView(JV: joystickValue)
                    .padding(.bottom, 50.0)
            }
            VStack{
                Button(action: {
                    joystickValue.valve_power = 100
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        joystickValue.valve_power = -100
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            joystickValue.valve_power = 0
                            
                        }
                    }
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(width: 150, height: 50)
                        Text("発射ボタン")
                            .foregroundStyle(.black)
                    }
                    .padding(.all)
                    
                })
                Spacer()
            }
  
        }
    }
}
