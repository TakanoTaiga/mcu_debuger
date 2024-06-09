import SwiftUI
import Network
import Charts
import Combine


class UIState : ObservableObject {
    @Published var show_view_id : Int = 0
}

struct ContentView: View {
    @ObservedObject var mcu_connection_handler = MCUConnectionHandler()
    @ObservedObject var param_mcu = ParamMCUConnection()
    @ObservedObject var joystick_value = JoystickValue()
    @ObservedObject var view_state = UIState()
        
    @State var SendingTimer : Timer!
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                if colorScheme == .light {
                    Color.white
                        .ignoresSafeArea()
                }else{
                    Color.black
                        .ignoresSafeArea()
                }
                
                switch view_state.show_view_id {
                case 0:
                    if geometry.size.width < geometry.size.height {
                        Text("What happen!?")
                    }else{
                        MultiStickView(mcu_connection_handler: mcu_connection_handler, param_mcu: param_mcu, joystickValue: joystick_value)
                    }
                case 1:
                    if geometry.size.width < geometry.size.height {
                        SingleStickView(udpAgent: mcu_connection_handler,param_mcu: param_mcu, joystickValue: joystick_value)
                    }else{
                        SingleStickViewForLandscape(udpAgent: mcu_connection_handler,param_mcu: param_mcu, joystickValue: joystick_value)
                    }
                case 2:
                    DeviceListView(udpAgent: mcu_connection_handler)
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
                                    mcu_connection_handler.send_data(item: String(joystick_value.YControllerPower).data(using: .utf8)!, key: param_mcu.target_device_id)
                                }else if (view_state.show_view_id == 0){
                                    
                                    let omniUtil = OmniUtil(power: joystick_value.XYControllerPower, angle: joystick_value.XYControllerDegree, rotation: Double(joystick_value.YControllerPower))
                                    let (fr,fl, rl, rr) = omniUtil.ConvertToMotorPower()
                                    
                                    mcu_connection_handler.send_data(item: String(Int(fr)).data(using: .utf8)!, key: param_mcu.target_motor_name_1)
                                    mcu_connection_handler.send_data(item: String(Int(fl)).data(using: .utf8)!, key: param_mcu.target_motor_name_2)
                                    mcu_connection_handler.send_data(item: String(Int(rl)).data(using: .utf8)!, key: param_mcu.target_motor_name_3)
                                    mcu_connection_handler.send_data(item: String(Int(rr)).data(using: .utf8)!, key: param_mcu.target_motor_name_4)
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
