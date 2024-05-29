import Foundation
import Network
import Combine

struct MWData: Identifiable {
    var id = UUID()
    var power: Int
    var time: Date
}

struct Device: Identifiable {
    var id: String { ip }
    var ip: String
    var name: String
    var talker: NWConnection?
}

class UDPAgent: ObservableObject {
    private let queue = DispatchQueue(label: "timer", qos: .userInteractive)
    private var listener = try! NWListener(using: .udp, on: 64201)
    private var listener_device_search = try! NWListener(using: .udp, on: 64203)
    private var hoge_count = 0
    
    @Published var charts_data: [MWData] = []
    @Published var sensor_data = 0

    @Published var ip: String {
        didSet {
            UserDefaults.standard.set(ip, forKey: "UserIP")
        }
    }
    @Published var port: String {
        didSet {
            UserDefaults.standard.set(port, forKey: "UserPort")
        }
    }
    @Published var IsSending: Bool = false
        
    @Published var devices: [String: Device] = [:]
    
    @Published var target_device_id: String = ""
    
    @Published var target_motor_name_1: String = ""
    @Published var target_motor_name_2: String = ""
    @Published var target_motor_name_3: String = ""
    @Published var target_motor_name_4: String = ""
    
    private var now_target_ip: String = ""
    
    func addDevice(from input: String) {
        let components = input.split(separator: ",")
        if components.count == 2 {
            let ip = String(components[0])
            let name = String(components[1])
            var device = Device(ip: ip, name: name)
            
            device.talker?.cancel()
            let nwip = NWEndpoint.Host(ip)
            device.talker = NWConnection(host: nwip,
                                                   port: 64202,
                                                   using: .udp)
            device.talker?.start(queue: self.queue)
            
            devices[name] = device
        }
    }
    
    public func send_data(item: Data, key: String){
        guard let connection = devices[key]?.talker, connection.state == .ready else {
            return
        }
        
        connection.send(content: item, completion: NWConnection.SendCompletion.contentProcessed { error in
            if let error = error {
                NSLog("\(error)")
            }
        })
    }
    
    init() {
        ip = UserDefaults.standard.string(forKey: "UserIP") ?? ""
        port = UserDefaults.standard.string(forKey: "UserPort") ?? ""
        self.listener.newConnectionHandler = { newConnection in
            newConnection.start(queue: self.queue)
            newConnection.receive(minimumIncompleteLength: 1, maximumLength: 256, completion: { (data, context, flag, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        let str = String(data: data, encoding: .utf8) ?? ""
                        self.hoge_count += 1
                        let mwdata = MWData(power: (Int(str) ?? 0) / 19, time: Date())
                        self.charts_data.append(mwdata)
                        
                        if self.charts_data.count > 100 {
                            self.charts_data.removeFirst()
                        }
                        
                        self.sensor_data = (Int(str) ?? 0) / 19
                    }
                }
                newConnection.cancel()
            })
        }
        
        self.listener_device_search.newConnectionHandler = { newConnection in
            newConnection.start(queue: self.queue)
            newConnection.receive(minimumIncompleteLength: 1, maximumLength: 256, completion: { (data, context, flag, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        let str = String(data: data, encoding: .utf8) ?? ""
                        self.addDevice(from: str)
                    }
                }
                newConnection.cancel()
            })
        }
        
        self.listener.start(queue: self.queue)
        self.listener_device_search.start(queue: self.queue)
        
        self.charts_data.append(MWData(power: 0, time: Date()))
    }
}
