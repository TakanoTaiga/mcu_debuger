//
//  SmallXController.swift
//  mcu_debuger
//
//  Created by Taiga Takano on 2024/08/29.
//

import SwiftUI

struct YSTICK: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundColor(.gray.opacity(0.5))
            Circle()
                .frame(width: 40, height: 40, alignment: .center)
                .foregroundColor(colorScheme == .light ? .white : .black)
        }
    }
}

struct SmallXController: View {
    @ObservedObject var JV : JoystickValue
    @State var dragValue = CGSize.zero
    @State var isDragging = false
    @State var firstFlag = true
    
    var body: some View {
        HStack {
            Text("とじる")
            YSTICK()
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
                        self.dragValue = CGSize(width: value.translation.width * factor , height: 0)
                        self.isDragging = true
                        JV.valve_power = dragValue.width
                    }
                        .onEnded { value in
                            self.dragValue = .zero
                            self.isDragging = false
                            JV.rotation_power = dragValue.width
                        }
                )
                .animation(.spring(response: 0.2, dampingFraction: 0.6, blendDuration: 0), value: self.dragValue)
            
            Text("あける")
        }
    }
}

//#Preview {
//    SmallXController()
//}
