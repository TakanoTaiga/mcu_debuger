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
                Picker("motor-1", selection: $param_mcu.target_motor_name_1) {
                    ForEach(Array(mcu_connection_handler.devices.keys), id: \.self) { key in
                        if let device = mcu_connection_handler.devices[key] {
                            Text(device.name).tag(device.name)
                        }
                    }
                }
                Picker("motor-2", selection: $param_mcu.target_motor_name_2) {
                    ForEach(Array(mcu_connection_handler.devices.keys), id: \.self) { key in
                        if let device = mcu_connection_handler.devices[key] {
                            Text(device.name).tag(device.name)
                        }
                    }
                }
                Picker("motor-3", selection: $param_mcu.target_motor_name_3) {
                    ForEach(Array(mcu_connection_handler.devices.keys), id: \.self) { key in
                        if let device = mcu_connection_handler.devices[key] {
                            Text(device.name).tag(device.name)
                        }
                    }
                }
                Picker("motor-4", selection: $param_mcu.target_motor_name_4) {
                    ForEach(Array(mcu_connection_handler.devices.keys), id: \.self) { key in
                        if let device = mcu_connection_handler.devices[key] {
                            Text(device.name).tag(device.name)
                        }
                    }
                }
            }
  
        }
    }
}
