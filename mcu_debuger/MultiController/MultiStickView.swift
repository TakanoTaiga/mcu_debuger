//
//  MultiStickView.swift
//  mcu_debuger
//
//  Created by Taiga on 2024/05/30.
//

import SwiftUI

struct MultiStickView: View {
    @ObservedObject var udpAgent: UDPAgent
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
                YControllerView(JV: joystickValue)
                    .padding(.bottom, 50.0)
            }
            
            VStack{
                Picker("motor-1", selection: $udpAgent.target_motor_name_1) {
                    ForEach(Array(udpAgent.devices.keys), id: \.self) { key in
                        if let device = udpAgent.devices[key] {
                            Text(device.name).tag(device.name)
                        }
                    }
                }
                Picker("motor-2", selection: $udpAgent.target_motor_name_2) {
                    ForEach(Array(udpAgent.devices.keys), id: \.self) { key in
                        if let device = udpAgent.devices[key] {
                            Text(device.name).tag(device.name)
                        }
                    }
                }
                Picker("motor-3", selection: $udpAgent.target_motor_name_3) {
                    ForEach(Array(udpAgent.devices.keys), id: \.self) { key in
                        if let device = udpAgent.devices[key] {
                            Text(device.name).tag(device.name)
                        }
                    }
                }
                Picker("motor-4", selection: $udpAgent.target_motor_name_4) {
                    ForEach(Array(udpAgent.devices.keys), id: \.self) { key in
                        if let device = udpAgent.devices[key] {
                            Text(device.name).tag(device.name)
                        }
                    }
                }
            }
  
        }
    }
}
