import CoreBluetooth
import Foundation

public class Wand: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    public static let shared = Wand()
    
    var centralManager : CBCentralManager!
    var wandPeripheral : CBPeripheral!
    let sensorUUID = CBUUID(string: "64A70002-F691-4B93-A6F4-0968F5B648F8")
    let buttonUUID = CBUUID(string: "64A7000D-F691-4B93-A6F4-0968F5B648F8")
    public var delegates : [WandDelegate] = []
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    private func sensor (from characteristic: CBCharacteristic) {
        guard let characteristicData = characteristic.value else { return }
        let byteArray = [UInt8](characteristicData)
        let point = Point(x: byteArray[2], y: byteArray[0])
        print("WANDKIT DEBUG: \(point)")
        for delegate in delegates {
            delegate.location(point)
        }
    }
    
    private func buttonPress (from characteristic: CBCharacteristic) {
        guard let characteristicData = characteristic.value else { return }
        let byteArray = [UInt8](characteristicData)
        
        print("WANDKIT DEBUG: BUTTON PRESS")
        // It sometimes gives us both 1 & 0 so we can't use the value and instead check if its true then toggle.
        if byteArray[0] == 1 {
            // Toggle button
            for delegate in delegates {
                delegate.buttonPress()
            }
        }
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .unknown:
                print("central.state is .unknown")
            case .resetting:
                print("central.state is .resetting")
            case .unsupported:
                print("central.state is .unsupported")
            case .unauthorized:
                print("central.state is .unauthorized")
            case .poweredOff:
                print("central.state is .poweredOff")
            case .poweredOn:
                print("central.state is .poweredOn")
                centralManager.scanForPeripherals(withServices: nil)
            @unknown default:
                print("what ?????")
        }
    }
    
    public func centralManager (_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if ((peripheral.name?.contains("Kano-Wand")) == true) {
            for delegate in delegates {
                delegate.deviceFound()
            }
            wandPeripheral = peripheral
            wandPeripheral.delegate = self
            centralManager.stopScan()
            centralManager.connect(wandPeripheral)
        }
    }
    
    public func centralManager (_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        for delegate in delegates {
            delegate.connected()
        }
        wandPeripheral.discoverServices(nil)
    }
    
    public func centralManager (_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        for delegate in delegates {
            delegate.failToConnect()
        }
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    public func centralManager (_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        for delegate in delegates {
            delegate.disconnect()
        }
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    public func peripheral (_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral (_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            
//            if characteristic.properties.contains(.read) {
//            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    public func peripheral (_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
            case sensorUUID:
                sensor(from: characteristic)
            case buttonUUID:
                buttonPress(from: characteristic)
            default:
                break
        }
    }
    
}
