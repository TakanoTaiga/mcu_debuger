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
    
    @Environment(\.colorScheme) var colorScheme
    
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
                            .foregroundColor(colorScheme == .light ? .white : .black)
                        HStack{
                            Text("Device:")
                                .font(.title3)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .bold()
                                .opacity(0.5)
                                
                            Text(param_mcu.target_device_id)
                                .font(.title2)
                                .foregroundColor(colorScheme == .light ? .black : .white)
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

struct SingleStickViewForLandscape: View {
    @ObservedObject var udpAgent: MCUConnectionHandler
    @ObservedObject var param_mcu: ParamMCUConnection
    @ObservedObject var joystickValue: JoystickValue
    
    @Environment(\.colorScheme) var colorScheme
    
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
                            .foregroundColor(colorScheme == .light ? .white : .black)
                        HStack{
                            Text("Device:")
                                .font(.title3)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .bold()
                                .opacity(0.5)
                                
                            Text(param_mcu.target_device_id)
                                .font(.title2)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .bold()
                        }
                    }
                }.id(param_mcu.target_device_id)
                
                Spacer()
            }

            VStack{
                XControllerView(JV: joystickValue)
            }
        }
    }
}
