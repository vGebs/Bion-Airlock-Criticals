//
//  CriticalData.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-07-31.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI
//import Combine

class CriticalViewModel: ObservableObject{
    @Published var controls: [Critical] = Controls
    @Published var gases: [Critical] = Gases
}

struct Critical: Identifiable {
    var id = UUID()
    var uid: Int
    var title: String       //ie Cabin Pressure
    var indicator: String   //ie Pressure Level
    var units: String       //ie PSI
    var image: String       //SF symbols only. ie "rectangle.compress.vertical"
    var data: [Double]?
    
    func getCurrentReading() -> Double?{
        if let data = data?.last{
            return data
        }
        return 0
    }
    
    func getColor() -> Color{
        if title == "Cabin Pressure"{
            return getCabinPressureColor()
        } else if title == "Door Locks"{
            if data?.last == 1{
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
            if data?.last == 1{
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
    
    func getLastFifteen() -> [Double]{
        return [0,1]
    }
}

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

var Controls = [
    Critical(
        uid: 0,
        title: "Cabin Pressure",
        indicator: "Pressure Level",
        units: "PSI",
        image: "rectangle.compress.vertical",
        data: [7]
    ),
    Critical(
        uid: 1,
        title: "Door Locks",
        indicator: "Activated",
        units: "i/o",
        image: "lock.circle",
        data: [1.1, 4.7, 10.2]
    ),
    Critical(
        uid: 2,
        title: "Cabin Temperature",
        indicator: "Temp",
        units: "c",
        image: "thermometer",
        data: [1.1, 4.7, 10.2]
    )
]

var Gases = [
    Critical(
        uid: 3,
        title: "CO Level",
        indicator: "Conc.",
        units: "ppm",
        image: "leaf.arrow.circlepath",
        data: [1.1, 4.7, 10.2]
    ),
    Critical(
        uid: 4,
        title: "CO2 Level",
        indicator: "Conc.",
        units: "ppm",
        image: "leaf.arrow.circlepath",
        data: [1.1, 4.7, 10.2]
    ),
    Critical(
        uid: 5,
        title: "NO Level",
        indicator: "Conc.",
        units: "ppm",
        image: "leaf.arrow.circlepath",
        data: [1.1, 4.7, 10.2]
    )
]
