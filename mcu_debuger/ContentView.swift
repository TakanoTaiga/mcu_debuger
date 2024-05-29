import SwiftUI
import Network
import Charts
import Combine


class UIState : ObservableObject {
    @Published var show_view_id : Int = 0
}


struct error: View {
    var body: some View {
        VStack{
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title)
                .foregroundColor(.yellow)
            Text("Oops!?")
        }
    }
}

struct ContentView: View {
    @ObservedObject var udp_agent = UDPAgent()
    @ObservedObject var joystick_value = JoystickValue()
    @ObservedObject var view_state = UIState()
    
    @State var bounds = UIScreen.main.bounds
    @State var selction_color : Color = .red
    
    @State var SendingTimer : Timer!

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color.white
                    .opacity(0.1)
                    .ignoresSafeArea()
                switch view_state.show_view_id {
                case 0:
                    if geometry.size.width < geometry.size.height {
                        Text("What happen!?")
                    }else{
                        ZStack{
                            HStack{
                                XYControllerView(JV: joystick_value)
                                    .padding(.bottom, 50.0)
                                Spacer()
                            }
                            
                            HStack{
                                Spacer()
                                YControllerView(JV: joystick_value)
                                    .padding(.bottom, 50.0)
                            }
                            
                            VStack{
                                Picker("motor-1", selection: $udp_agent.target_motor_name_1) {
                                    ForEach(Array(udp_agent.devices.keys), id: \.self) { key in
                                        if let device = udp_agent.devices[key] {
                                            Text(device.name).tag(device.name)
                                        }
                                    }
                                }
                                Picker("motor-2", selection: $udp_agent.target_motor_name_2) {
                                    ForEach(Array(udp_agent.devices.keys), id: \.self) { key in
                                        if let device = udp_agent.devices[key] {
                                            Text(device.name).tag(device.name)
                                        }
                                    }
                                }
                                Picker("motor-3", selection: $udp_agent.target_motor_name_3) {
                                    ForEach(Array(udp_agent.devices.keys), id: \.self) { key in
                                        if let device = udp_agent.devices[key] {
                                            Text(device.name).tag(device.name)
                                        }
                                    }
                                }
                                Picker("motor-4", selection: $udp_agent.target_motor_name_4) {
                                    ForEach(Array(udp_agent.devices.keys), id: \.self) { key in
                                        if let device = udp_agent.devices[key] {
                                            Text(device.name).tag(device.name)
                                        }
                                    }
                                }
                            }
                  
                        }
                    }
                case 1:
                    ZStack{
                        VStack{
                            Menu {
                                Picker(selection: $udp_agent.target_device_id) {
                                    ForEach(Array(udp_agent.devices.keys), id: \.self) { key in
                                        if let device = udp_agent.devices[key] {
                                            Text(device.name).tag(device.name)
                                        }
                                    }
                                } label: {}
                            } label: {
                                ZStack{
                                    Rectangle()
                                        .frame(height: 60)
                                        .foregroundColor(.white)
                                    HStack{
                                        Text("Device:")
                                            .font(.title3)
                                            .foregroundStyle(.black)
                                            .bold()
                                            .opacity(0.5)
                                            
                                        Text(udp_agent.target_device_id)
                                            .font(.title2)
                                            .foregroundStyle(.black)
                                            .bold()
                                    }
                                }
                            }.id(udp_agent.target_device_id)
                            
                            Spacer()
                        }
            
                        VStack{
                            YControllerView(JV: joystick_value)
                        }
                    }
             
                case 2:
                    VStack {
                        HStack{
                            Text("Device List")
                                .padding(.all)
                                .font(.title)
                                .bold()
                            
                            Spacer()
                        }
                        SearchDevice(udp_agent: udp_agent)
                    }
                default: error()
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
                                    let x = cos(joystick_value.XYControllerDegree) * -1.0
                                    let y = sin(joystick_value.XYControllerDegree)
                                    let z = Double(joystick_value.YControllerPower)
                                    var pwr = joystick_value.XYControllerPower
                                    
                                    if(pwr < 3.0){
                                        pwr = 0.0
                                    }
                                    let vec_fr =  pwr * ( 0.707106781 * x - 0.707106781 * y) + z * 0.5;
                                    let vec_fl =  pwr * (-0.707106781 * x - 0.707106781 * y) + z * 0.5;
                                    let vec_rl =  pwr * (-0.707106781 * x + 0.707106781 * y) + z * 0.5;
                                    let vec_rr =  pwr * ( 0.707106781 * x + 0.707106781 * y) + z * 0.5;
                                    
                                    udp_agent.send_data(item: String(Int(vec_fr)).data(using: .utf8)!, key: udp_agent.target_motor_name_1)
                                    
                                    udp_agent.send_data(item: String(Int(vec_fl)).data(using: .utf8)!, key: udp_agent.target_motor_name_2)
                                    
                                    udp_agent.send_data(item: String(Int(vec_rl)).data(using: .utf8)!, key: udp_agent.target_motor_name_3)
                                    
                                    udp_agent.send_data(item: String(Int(vec_rr)).data(using: .utf8)!, key: udp_agent.target_motor_name_4)
                                    

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
