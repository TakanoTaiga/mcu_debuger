//
//  DeviceListView.swift
//  mcu_debuger
//
//  Created by Taiga on 2024/05/30.
//

import SwiftUI

struct DeviceListView: View {
    @ObservedObject var udpAgent: UDPAgent

    var body: some View {
        VStack {
            HStack {
                Text("Device List")
                    .padding()
                    .font(.title)
                    .bold()
                Spacer()
            }
            SearchDevice(udpAgent: udpAgent)
        }
    }
}
