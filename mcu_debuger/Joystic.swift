//
//  Joystic.swift
//  mcu_debuger
//
//  Created by TaigaTakano on 2024/03/09.
//

import Foundation
import SwiftUI

class JoystickValue : ObservableObject {    
    @Published var rotation_power : Double = 0
    @Published var move_x_power : Double = 0
    @Published var move_y_power : Double = 0
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
                        
                        JV.move_x_power = dragValue.height
                        JV.move_y_power = dragValue.width
                    }
                        .onEnded { value in
                            self.dragValue = .zero
                            self.isDragging = false
                            JV.move_x_power = 0
                            JV.move_y_power = 0
                        }
                )
                .animation(.spring(response: 0.2, dampingFraction: 0.6, blendDuration: 0), value: self.dragValue)
            
        }
    }
}

struct XYStick: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 130, height: 130, alignment: .center)
                .foregroundColor(.gray.opacity(0.5))
            Circle()
                .frame(width: 115, height: 115, alignment: .center)
                .foregroundColor(colorScheme == .light ? .white : .black)
        }
    }
}
