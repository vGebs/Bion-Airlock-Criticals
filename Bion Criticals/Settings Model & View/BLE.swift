//
//  BLE.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-07-06.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

//Link for tutorial: https://www.raywenderlich.com/231-core-bluetooth-tutorial-for-ios-heart-rate-monitor#toc-anchor-012

import CoreBluetooth

class BLE: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var arduinoPeripheral: CBPeripheral!
    
    let airlockCriticalsServiceCBUUID = CBUUID(string: "1000")
    
    let pressureLevelCharCBUUID = CBUUID(string: "1001")
    let doorStatusCharCBUUID = CBUUID(string: "1002")
    let tempLevelCharCBUUID = CBUUID(string: "1003")
    
    func setupBLE(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
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
                return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if peripheral.name == "Arduino"{
            arduinoPeripheral = peripheral
            arduinoPeripheral.delegate = self
            centralManager.stopScan()
            centralManager.connect(arduinoPeripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        arduinoPeripheral.discoverServices([airlockCriticalsServiceCBUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
          print(service)
          peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
      guard let characteristics = service.characteristics else { return }

      for characteristic in characteristics {
        print(characteristic)
        
        if characteristic.properties.contains(.read) {
            print("\(characteristic.uuid): properties contains .read")
          
            peripheral.readValue(for: characteristic)
        }
        if characteristic.properties.contains(.notify) {
            print("\(characteristic.uuid): properties contains .notify")
            
            peripheral.setNotifyValue(true, for: characteristic)
        }
      }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
      switch characteristic.uuid {
        case pressureLevelCharCBUUID:
            print("pressureLevelCharCBUUID")
            
            if let data = characteristic.value {
                let nsdataToString = data.map { String(format: "%02x", $0) }.joined()
                print(nsdataToString.hexToFloat())
            }
        
        case doorStatusCharCBUUID:
            print("doorStatusCharCBUUID")
            
            if let data = characteristic.value {
                let nsdataToString = data.map { String(format: "%02x", $0) }.joined()
                print(nsdataToString.hexToFloat())
            }
        
        case tempLevelCharCBUUID:
            print("tempLevelCharCBUUID")
            
            if let data = characteristic.value {
                let nsdataToString = data.map { String(format: "%02x", $0) }.joined()
                print(nsdataToString.hexToFloat())
            }
        
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
      }
    }
    
}

public extension String{
    func hexToFloat() -> Float {
        Float32(bitPattern: UInt32(strtol(self, nil, 16)).byteSwapped)
    }
}

