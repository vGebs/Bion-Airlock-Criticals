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


import SwiftUI
import CoreBluetooth
import FirebaseFirestore
import FirebaseFirestoreSwift

class CriticalViewModel: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    @Published var controls: [Critical] = Controls
    @Published var gases: [Critical] = Gases
    
    let db = Firestore.firestore()
    
    func refreshData(){
        
    }
    
    func pressureSet(){
        
    }
    
    func tempSet(){
        
    }
    
    func doorSet(){
        //doorStatusPeripheral?.writeValue(<#T##data: Data##Data#>, for: <#T##CBDescriptor#>)
    }
    
//    func addData(critical: Bool, CriticalID: Int, data: Double){
//        if critical == true {
//            self.controls[CriticalID].data?.append(data)
//        } else if critical == false{
//            self.gases[CriticalID].data?.append(data)
//        }
//    }
    
    func addDataToRepo(data: Values){
        
        if let docID = data.id{
            if let timestamp = data.createdTime{
                
                let dataRep: [String: Any] = [
                    "data" : FieldValue.arrayUnion([data.value]),
                    "timeStamp" : FieldValue.arrayUnion([timestamp])
                ]
                
                db.collection("Critical Data").document(docID).updateData(dataRep){ error in
                    if let error = error {
                        print("Error writing docuemnt: \(error)" )
                    } else {
                        print("Writing to document successful")
                    }
                }
            } else {
                print("Unable to obtain timestamp")
            }
        } else {
            print("Unable to obtain document ID")
        }
    }
    
    func setupBLE(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    var centralManager: CBCentralManager!
    var arduinoPeripheral: CBPeripheral!
    
    let airlockCriticalsServiceCBUUID = CBUUID(string: "1000")
    
    let pressureLevelCharCBUUID = CBUUID(string: "1001")
    let doorStatusCharCBUUID = CBUUID(string: "1002")
    let tempLevelCharCBUUID = CBUUID(string: "1003")
    
    //let gas1CharCBUUID = CBUUID(string: "1004")
    //let gas2CharCBUUID = CBUUID(string: "1005")
    //let gas3CharCBUUID = CBUUID(string: "1006")
    
    var pressureLevelChar: CBCharacteristic?
    var doorStatusChar: CBCharacteristic?
    var tempLevelChar: CBCharacteristic?
    
    var pressureLevelPeripheral: CBPeripheral?
    var doorStatusPeripheral: CBPeripheral?
    var tempLevelPeripheral: CBPeripheral?

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
        if peripheral.name == "Arduino" {
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
        
        switch characteristic.uuid {
            case pressureLevelCharCBUUID:
                pressureLevelPeripheral = peripheral
                
            case doorStatusCharCBUUID:
                doorStatusPeripheral = peripheral
                
            case tempLevelCharCBUUID:
                tempLevelPeripheral = peripheral

        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")

        }
        
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
                
                //initialize pressure characteristic
                pressureLevelChar = characteristic
                
                let pressure = Values(id: "pressure", createdTime: Timestamp(date: Date()), value: value)
                controls[0].data?.append(pressure)
                addDataToRepo(data: pressure)
            }
        
        case doorStatusCharCBUUID:
            print("doorStatusCharCBUUID")
            
            if let data = characteristic.value {
                let nsdataToString = data.map { String(format: "%02x", $0) }.joined()
                let value = Double(nsdataToString.hexToFloat())
                print(value)
                
                //initialize door characteristic
                doorStatusChar = characteristic
                
                let door = Values(id: "doorStatus", createdTime: Timestamp(date: Date()), value: value)
                controls[1].data?.append(door)
                addDataToRepo(data: door)
            }
        
        case tempLevelCharCBUUID:
            print("tempLevelCharCBUUID")
            
            if let data = characteristic.value {
                let nsdataToString = data.map { String(format: "%02x", $0) }.joined()
                let value = Double(nsdataToString.hexToFloat())
                print(value)
                
                //initialize temp characteristic
                tempLevelChar = characteristic
                
                let temp = Values(id: "temperature", createdTime: Timestamp(date: Date()), value: value)
                controls[2].data?.append(temp)
                addDataToRepo(data: temp)
            }
        
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
      }
    }
    
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        <#code#>
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
//        <#code#>
//    }
//
//    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
//        <#code#>
//    }
}

public extension String{
    func hexToFloat() -> Float {
        Float32(bitPattern: UInt32(strtol(self, nil, 16)).byteSwapped)
    }
}


