//
//  SettingView.swift
//  mcu_debuger
//
//  Created by Taiga Takano on 2024/07/05.
//

import SwiftUI

struct SettingView: View {
    private let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    private let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    var body: some View {
        Text("\(version)(\(build))")
        
//        VStack{
//            
//            Spacer()
//            
//            Picker("motor-1", selection: $param_mcu.target_motor_name_1) {
//                ForEach(Array(mcu_connection_handler.devices.keys), id: \.self) { key in
//                    if let device = mcu_connection_handler.devices[key] {
//                        Text(device.name).tag(device.name)
//                    }
//                }
//            }
//            Picker("motor-2", selection: $param_mcu.target_motor_name_2) {
//                ForEach(Array(mcu_connection_handler.devices.keys), id: \.self) { key in
//                    if let device = mcu_connection_handler.devices[key] {
//                        Text(device.name).tag(device.name)
//                    }
//                }
//            }
//            Picker("motor-3", selection: $param_mcu.target_motor_name_3) {
//                ForEach(Array(mcu_connection_handler.devices.keys), id: \.self) { key in
//                    if let device = mcu_connection_handler.devices[key] {
//                        Text(device.name).tag(device.name)
//                    }
//                }
//            }
//            Picker("motor-4", selection: $param_mcu.target_motor_name_4) {
//                ForEach(Array(mcu_connection_handler.devices.keys), id: \.self) { key in
//                    if let device = mcu_connection_handler.devices[key] {
//                        Text(device.name).tag(device.name)
//                    }
//                }
//            }
//            
//            Picker("Valve", selection: $param_mcu.target_valve_1) {
//                ForEach(Array(mcu_connection_handler.devices.keys), id: \.self) { key in
//                    if let device = mcu_connection_handler.devices[key] {
//                        Text(device.name).tag(device.name)
//                    }
//                }
//            }
//        }
//        
    }
}

#Preview {
    SettingView()
}
