//
//  CriticalData.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-07-31.
//  Copyright © 2020 Brick Squad. All rights reserved.
//


//MVVM Programming w/ ObservableObject, @Pushlished, and @ObservedObject https://www.youtube.com/watch?v=1IlUBHvgY8Q

//Reactive Environment Object Application State https://www.youtube.com/watch?v=gxAl4gpyGwY

//CoreBluetooth Tutorial https://www.raywenderlich.com/231-core-bluetooth-tutorial-for-ios-heart-rate-monitor#toc-anchor-012

//Quick thoughts,
//      Because we are using this data throughout the app, we should be using an environment object.
//      With that being said, we are going to make the BLE class the viewmodel because it doing the fetching for us.
//      It will also allow us to send and recieve data. So w that being said, we are going to rename the BLE class and make it into a viewmodel class that fetches the data continuously and place it in the right location, when this data changes, it should automatically update ui.

import SwiftUI
import CoreBluetooth

class CriticalViewModel: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    @Published var controls: [Critical] = Controls
    @Published var gases: [Critical] = Gases
    
    func refreshData(){
        
    }
    
    func pressureSet(){
        
    }
    
    func tempSet(){
        
    }
    
    func doorSet(){
        
    }
    
//    func addData(critical: Bool, CriticalID: Int, data: Double){
//        if critical == true {
//            self.controls[CriticalID].data?.append(data)
//        } else if critical == false{
//            self.gases[CriticalID].data?.append(data)
//        }
//    }
    
    func setupBLE(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    var centralManager: CBCentralManager!
    var arduinoPeripheral: CBPeripheral!
    
    let airlockCriticalsServiceCBUUID = CBUUID(string: "1000")
    
    let pressureLevelCharCBUUID = CBUUID(string: "1001")
    let doorStatusCharCBUUID = CBUUID(string: "1002")
    let tempLevelCharCBUUID = CBUUID(string: "1003")
}

extension CriticalViewModel {
    
    
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
                let value = Double(nsdataToString.hexToFloat())
                print(value)
                
                controls[0].data?.append(value)
            }
        
        case doorStatusCharCBUUID:
            print("doorStatusCharCBUUID")
            
            if let data = characteristic.value {
                let nsdataToString = data.map { String(format: "%02x", $0) }.joined()
                let value = Double(nsdataToString.hexToFloat())
                print(value)
                
                controls[1].data?.append(value)
            }
        
        case tempLevelCharCBUUID:
            print("tempLevelCharCBUUID")
            
            if let data = characteristic.value {
                let nsdataToString = data.map { String(format: "%02x", $0) }.joined()
                let value = Double(nsdataToString.hexToFloat())
                print(value)
                
                controls[2].data?.append(value)
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


