import SwiftUI

struct ViewDock: View {
    @ObservedObject var uistate : UIState

    let paramHeight: CGFloat = 50
    
    @State private var selectedIndex = 0
    @State private var impactFlexibilitySoft = false

    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: paramHeight)
                .foregroundColor(.white)
            HStack {
                ForEach(0..<3) { index in
                    NavButton(iconName: iconName(for: index))
                        .frame(height: paramHeight)
                        .opacity(selectedIndex == index ? 1.0 : 0.4)
                        .onTapGesture {
                            selectedIndex = index
                            impactFlexibilitySoft.toggle()
                            uistate.show_view_id = index
                        }
                        .animation(.easeOut(duration: 0.2), value: selectedIndex)
                }
            }
        }
        .cornerRadius(paramHeight / 2)
        .shadow(color: .gray.opacity(0.5) ,radius: 5)
        .padding(.all)
        .sensoryFeedback(.impact(weight: .light), trigger: impactFlexibilitySoft)
    }
    
    private func iconName(for index: Int) -> String {
        switch index {
        case 0: return "steeringwheel"
        case 1: return "arcade.stick"
        case 2: return "magnifyingglass"
        default: return ""
        }
    }
}

struct NavButton: View {
    let iconName: String
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 100)
            Image(systemName: iconName)
                .font(.title3)
        }
    }
}
