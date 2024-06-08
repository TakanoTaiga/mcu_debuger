//
//  SingleStickView.swift
//  mcu_debuger
//
//  Created by Taiga on 2024/05/30.
//

import SwiftUI

struct SingleStickView: View {
    @ObservedObject var udpAgent: MCUConnectionHandler
    @ObservedObject var param_mcu: ParamMCUConnection
    @ObservedObject var joystickValue: JoystickValue
    
    var body: some View {
        ZStack{
            VStack{
                Menu {
                    Picker(selection: $param_mcu.target_device_id) {
                        ForEach(Array(udpAgent.devices.keys), id: \.self) { key in
                            if let device = udpAgent.devices[key] {
                                Text(device.name).tag(device.name)
                            }
                        }
                    } label: {}
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(height: 60)
                            .foregroundColor(.white)
                        HStack{
                            Text("Device:")
                                .font(.title3)
                                .foregroundStyle(.black)
                                .bold()
                                .opacity(0.5)
                                
                            Text(param_mcu.target_device_id)
                                .font(.title2)
                                .foregroundStyle(.black)
                                .bold()
                        }
                    }
                }.id(param_mcu.target_device_id)
                
                Spacer()
            }

            VStack{
                YControllerView(JV: joystickValue)
            }
        }
    }
}
