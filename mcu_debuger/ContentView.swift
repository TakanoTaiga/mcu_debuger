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
    @ObservedObject var gamepad_service = GamePadSerivce()
        
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
                        ZStack{
                            MultiStickView(mcu_connection_handler: mcu_connection_handler, param_mcu: param_mcu, joystickValue: joystick_value)
                            
                            if gamepad_service.info.connected {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 40)
                                        .frame(width: 100, height: 40)
                                        .foregroundStyle(.white)
                                    HStack{
                                        Spacer()
                                        Image(systemName: "gamecontroller")
                                            .foregroundStyle(.black)
                                        
                                        if gamepad_service.info.battery > 0.75 {
                                            Image(systemName: "battery.100percent")
                                                .foregroundStyle(.black)
                                        }else if gamepad_service.info.battery > 0.5 {
                                            Image(systemName: "battery.75percent")
                                                .foregroundStyle(.black)
                                        }else if gamepad_service.info.battery > 0.25 {
                                            Image(systemName: "battery.50percent")
                                                .foregroundStyle(.black)
                                        }else{
                                            Image(systemName: "battery.25percent")
                                                .foregroundStyle(.black)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                case 1:
                    if geometry.size.width < geometry.size.height {
                        SingleStickView(udpAgent: mcu_connection_handler,param_mcu: param_mcu, joystickValue: joystick_value)
                    }else{
                        SingleStickViewForLandscape(udpAgent: mcu_connection_handler,param_mcu: param_mcu, joystickValue: joystick_value)
                    }
                case 2:
                    DeviceListView(udpAgent: mcu_connection_handler)
                case 3:
                    SettingView()
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
                            SendingTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true){
                                _ in
                                
                                NSLog("ISCONN: \(gamepad_service.info.connected)")
                                NSLog("BATT: \(gamepad_service.info.battery)")
                                
                                if(view_state.show_view_id == 1){
                                    mcu_connection_handler.send_data(item: String(joystick_value.rotation_power).data(using: .utf8)!, key: param_mcu.target_device_id)
                                }else if (view_state.show_view_id == 0){
                                    let (fr,fl, rl, rr) =  gamepad_service.info.connected ?
                                    OmniUtil(
                                        x_power_: Double(gamepad_service.gamepadValue.leftJoystic.y) * -1.0,
                                        y_power_: Double(gamepad_service.gamepadValue.leftJoystic.x),
                                        rotation_power_: Double(gamepad_service.gamepadValue.rightJoystic.x)
                                    ).ConvertToMotorPower()
                                    :
                                    OmniUtil(
                                        x_power_: joystick_value.move_x_power,
                                        y_power_: joystick_value.move_y_power,
                                        rotation_power_: joystick_value.rotation_power
                                    ).ConvertToMotorPower()
                                    
                                    let power_scaler: Double = 1
                                    
                                    NSLog("GG_LEFT_TRIGGER: \(joystick_value.move_x_power)")
                                    
                                    NSLog("MPWR \(Int(fr * power_scaler)),\(Int(fl * power_scaler)),\(Int(rl * power_scaler)),\(Int(rr * power_scaler)),")
                                    
                                    mcu_connection_handler.send_data(
                                        item: String(Int(fr * power_scaler)).data(using: .utf8)!,
                                        key: param_mcu.target_motor_name_1)
                                    
                                    mcu_connection_handler.send_data(
                                        item: String(Int(fl * power_scaler)).data(using: .utf8)!,
                                        key: param_mcu.target_motor_name_2)
                                    
                                    mcu_connection_handler.send_data(
                                        item: String(Int(rl * power_scaler)).data(using: .utf8)!,
                                        key: param_mcu.target_motor_name_3)
                                    
                                    mcu_connection_handler.send_data(
                                        item: String(Int(rr * power_scaler)).data(using: .utf8)!,
                                        key: param_mcu.target_motor_name_4)
                                    
                                    mcu_connection_handler.send_data(
                                        item: String(Int(joystick_value.valve_power) * 3).data(using: .utf8)!,
                                        key: param_mcu.target_valve_1)

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
