import SwiftUI
import Network
import Charts
import Combine


class UIState : ObservableObject {
    @Published var show_view_id : Int = 0
}

struct ContentView: View {
    @ObservedObject var udp_agent = UDPAgent()
    @ObservedObject var joystick_value = JoystickValue()
    @ObservedObject var view_state = UIState()
        
    @State var SendingTimer : Timer!

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color.white
                    .ignoresSafeArea()
                switch view_state.show_view_id {
                case 0:
                    if geometry.size.width < geometry.size.height {
                        Text("What happen!?")
                    }else{
                        MultiStickView(udpAgent: udp_agent, joystickValue: joystick_value)
                    }
                case 1:
                    SingleStickView(udpAgent: udp_agent, joystickValue: joystick_value)
                case 2:
                    DeviceListView(udpAgent: udp_agent)
                default:
                    ErrorView()
                }

                VStack{
                    Spacer()
                    ViewDock(uistate: view_state)
                        .frame(width: geometry.size.width < geometry.size.height ? nil : 200)
                        .animation(.easeOut(duration: 0.2), value: geometry.size)
                        .onAppear(){
                            SendingTimer?.invalidate()
                            SendingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){
                                _ in
                                if(view_state.show_view_id == 1){
                                    NSLog("WowWowSingle!!")
                                    udp_agent.send_data(item: String(joystick_value.YControllerPower).data(using: .utf8)!, key: udp_agent.target_device_id)
                                }else if (view_state.show_view_id == 0){
                                    
                                    let omniUtil = OmniUtil(power: joystick_value.XYControllerPower, angle: joystick_value.XYControllerDegree, rotation: Double(joystick_value.YControllerPower))
                                    let (fr,fl, rl, rr) = omniUtil.ConvertToMotorPower()
                                    
                                    udp_agent.send_data(item: String(Int(fr)).data(using: .utf8)!, key: udp_agent.target_motor_name_1)
                                    udp_agent.send_data(item: String(Int(fl)).data(using: .utf8)!, key: udp_agent.target_motor_name_2)
                                    udp_agent.send_data(item: String(Int(rl)).data(using: .utf8)!, key: udp_agent.target_motor_name_3)
                                    udp_agent.send_data(item: String(Int(rr)).data(using: .utf8)!, key: udp_agent.target_motor_name_4)
                                }

                            }
                        }
                        .onDisappear(){
                            SendingTimer?.invalidate()
                            SendingTimer = nil
                        }
                }
            }
        }
    }
}



extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Additional views and previews
#Preview {
    ContentView()
}
