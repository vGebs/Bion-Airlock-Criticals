//
//  Critical.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-09-30.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Values: Encodable, Decodable, Identifiable{
    @DocumentID var id: String?
    @ServerTimestamp var createdTime: Timestamp?
    var value: Double
}

struct Critical: Identifiable {
    var id = UUID()
    var uid: Int
    var title: String       //ie Cabin Pressure
    var indicator: String   //ie Pressure Level
    var units: String       //ie PSI
    var image: String       //SF symbols only. ie "rectangle.compress.vertical"
    var data: [Values]?
    
    
    func getCurrentReading() -> Double?{
        
        if let data = data?.last?.value{
            return data
        }
        return 0
    }
    
    
    func getColor() -> Color{
        if title == "Cabin Pressure"{
            return getCabinPressureColor()
        } else if title == "Door Locks"{
            if data?.last?.value == 1{
                return .green
            } else{
                return .red
            }
        } else if title == "Cabin Temperature"{
            return getCabinTempColor()
        } else if title == "CO Level"{
            return getCoColor()
        } else if title == "CO2 Level"{
            return getCo2Color()
        } else if title == "NO Level"{
            return getNoColor()
        }
        return .purple
    }
    
    func getStatus() -> String {
        if title == "Cabin Pressure"{
            return getPressureStatus()
        } else if title == "Door Locks"{
            if data?.last?.value == 1{
                return "Activated"
            } else{
                return "Deactivated"
            }
        } else if title == "Cabin Temperature"{
            return getTempStatus()
        } else if title == "CO Level"{
            return getCoStatus()
        } else if title == "CO2 Level"{
            return getCo2Status()
        } else if title == "NO Level"{
            return getNoStatus()
        }
        return "error"
    }
    
//    let array = [1, 2, 3, 4]
//    let arraySlice = array.suffix(2)
//    let newArray = Array(arraySlice)
//    print(newArray) // prints: [3, 4]
    func getLastFifteen() -> [Double]{
        var arr = [Double]()
        if let data = data{
            for values in data{
                arr.append(values.value)
            }
            return arr
        } else {
            return arr
        }
//        var arr = [Double]()
//
//        if let count = self.data?.count{
//            if count >= 30{
//                let arraySlice = self.data?.suffix(15)
//                arr = Array(arraySlice!)
//            } else{
//                arr = (self.data)!
//            }
//        }
        //return (self.data)!
    }
}

///-------------------- Get Colors----------------------------------------------------------------
extension Critical{
    private func getCabinPressureColor() -> Color{
        if let currentReading = getCurrentReading(){
            if currentReading < 5{
                return .red
            } else if currentReading > 4 && currentReading < 8{
                return .yellow
            } else if currentReading > 7 && currentReading < 12 {
                return .green
            } else if currentReading > 11{
                return .red
            }
        }
        return .purple
    }
    
    private func getCabinTempColor() -> Color{
        if let currentReading = getCurrentReading(){
            if currentReading < -10 {
                return .blue
            } else if currentReading > -9 && currentReading < 10{
                return .yellow
            } else if currentReading > 9 {
                return .red
            }
        }
        return .purple
    }
    
    private func getCoColor() -> Color {
        if let currentReading = getCurrentReading(){
            if currentReading >= 75 {
                return .red
            } else if currentReading >= 30 && currentReading < 75 {
                return .yellow
            } else if currentReading < 30 {
                return .green
            }
        }
        return .purple
    }
    
    private func getCo2Color() -> Color {
        if let currentReading = getCurrentReading(){
            if currentReading >= 3000{
                return .red
            } else if currentReading >= 1000 && currentReading < 3000 {
                return .yellow
            } else if currentReading < 1000 {
                return .green
            }
        }
        return .purple
    }
    
    private func getNoColor() -> Color {
        if let currentReading = getCurrentReading(){
            if currentReading >= 10{
                return .red
            } else if currentReading >= 5 && currentReading < 10{
                return .yellow
            } else if currentReading < 5 {
                return .green
            }
        }
        return .green
    }
}

///----------------------------------Status Updates -------------------------------------------------------
extension Critical{
    private func getPressureStatus() -> String {
        return "pressurized"
    }
    
    private func getTempStatus() -> String {
        return "Hello"
    }
    
    private func getCoStatus() -> String {
        return "Hello"
    }
    
    private func getCo2Status() -> String {
        return "Hello"
    }
    
    private func getNoStatus() -> String {
        return "Hello"
    }
}
