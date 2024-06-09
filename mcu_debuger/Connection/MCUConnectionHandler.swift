import Foundation
import Network

struct MCUDevice: Identifiable {
    var id: String { ip }
    var ip: String
    var name: String
    var talker: NWConnection?
    var timer: Timer?
}

class ParamMCUConnection: ObservableObject {
    // Use for Single Control
    @Published var target_device_id: String = ""

    // This field use for Omniwheel
    @Published var target_motor_name_1: String = "mcu-rm-01"
    @Published var target_motor_name_2: String = "mcu-rm-02"
    @Published var target_motor_name_3: String = "mcu-rm-03"
    @Published var target_motor_name_4: String = "mcu-rm-04"
}

class MCUConnectionHandler: ObservableObject {
    @Published private(set) public var devices: [String: MCUDevice] = [:]
    
    private let queue = DispatchQueue(label: "timer", qos: .userInteractive)
    private var listener_device_search: NWListener?
    private let deviceTimeout: TimeInterval = 10

    public func addDevice(from input: String) {
        let components = input.split(separator: ",")
        guard components.count == 2 else {
            NSLog("Invalid input: \(input)")
            return
        }
        
        let ip = String(components[0])
        let name = String(components[1])
        
        for device in devices.values {
            if device.ip == ip && device.name == name {
                resetTimer(for: name)
                return
            }
        }
        
        let nwip = NWEndpoint.Host(ip)
        
        var device = MCUDevice(ip: ip, name: name)
        device.talker?.cancel()
        device.talker = NWConnection(host: nwip, port: 64202, using: .udp)
        device.talker?.start(queue: self.queue)
        
        devices[name] = device
        resetTimer(for: name)
    }

    public func send_data(item: Data, key: String) {
        if key == "" { return }
        
        guard let connection = devices[key]?.talker, connection.state == .ready else {
            NSLog("Connection not ready for device: \(key)")
            return
        }
        
        connection.send(content: item, completion: .contentProcessed { error in
            if let error = error {
                NSLog("Send error: \(error)")
            }
        })
    }
    
    private func resetTimer(for name: String) {
        devices[name]?.timer?.invalidate()
        devices[name]?.timer = Timer.scheduledTimer(withTimeInterval: deviceTimeout, repeats: false) { [weak self] _ in
            self?.removeDevice(named: name)
        }
    }

    private func removeDevice(named name: String) {
        devices[name]?.talker?.cancel()
        devices.removeValue(forKey: name)
    }
    
    init() {
        do {
            self.listener_device_search = try NWListener(using: .udp, on: 64203)
        } catch {
            NSLog("Failed to create listener: \(error)")
            return
        }
        
        self.listener_device_search?.newConnectionHandler = { newConnection in
            newConnection.start(queue: self.queue)
            newConnection.receive(minimumIncompleteLength: 1, maximumLength: 256) { (data, context, flag, error) in
                if let error = error {
                    NSLog("Receive error: \(error)")
                    newConnection.cancel()
                    return
                }
                
                if let data = data {
                    DispatchQueue.main.async {
                        let str = String(data: data, encoding: .utf8) ?? ""
                        self.addDevice(from: str)
                    }
                }
                newConnection.cancel()
            }
        }
        
        self.listener_device_search?.start(queue: self.queue)
    }
}
