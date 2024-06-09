//
//  SearchDevice.swift
//  mcu_debuger
//
//  Created by Taiga on 2024/05/27.
//

import SwiftUI

struct SearchDevice: View {
    @ObservedObject var udpAgent : MCUConnectionHandler
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            ForEach(Array(udpAgent.devices.keys), id: \.self) { key in
                if let device = udpAgent.devices[key] {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.gray)
                            .opacity(colorScheme == .light ? 0.1: 0.2)
                        
                        
                        HStack {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.6))
                                .frame(width: 20)
                            
                            Spacer()
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(device.name)
                                    .font(.title3)
                                    .bold()
                                    .padding(.leading, 40.0)
                                
                                Text(device.ip)
                                    .font(.headline)
                                    .padding(.leading, 40.0)
                                    .opacity(0.5)
                            }
                            Spacer()
                        }
                    }
                    .frame(height: 70)
                    .cornerRadius(20.0)
                    .padding(.bottom)
                    .padding(.horizontal)
                    
                }
            }
        }
    }
}
