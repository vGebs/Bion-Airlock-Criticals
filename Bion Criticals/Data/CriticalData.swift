//
//  CriticalData.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-07-31.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

var pressureData = [1.1, 4.7, 10.2]
var doorStatus: Double = 1
var cabinTempData = [-45, -41.5, -22.4]

func getLastDatum(data: [Double]) -> Double{
    if let last = data.last{
        return last
    } else {
        return 0
    }
}

struct Critical: Identifiable{
    var id = UUID()
    var title: String       //ie Cabin Pressure
    var indicator: String   //ie Pressure Level
    var reading: Double     //ie 11
    var units: String       //ie PSI
    var status: String      //ie Pressurizing
    var color: Color        //ie (good == .green, decent == .yellow, bad == .red)
    var image: String       //SF symbols only. ie "rectangle.compress.vertical"
    var chartType: String   //ie chart(pressure/gas), switch (door), ringview(temp)
}

var Controls = [
    Critical(
        title: "Cabin Pressure",
        indicator: "Pressure Level",
        reading: getLastDatum(data: pressureData),
        units: "PSI",
        status: "Pressurizing",
        color: .green,
        image: "rectangle.compress.vertical",
        chartType: "chart"
    ),
    Critical(
        title: "Door Locks",
        indicator: "Activated",
        reading: doorStatus,
        units: "Binary",
        status: "Locked",
        color: .green,
        image: "lock.circle",
        chartType: "switch"
    ),
    Critical(
        title: "Cabin Temperature",
        indicator: "Temp",
        reading: -40,
        units: "c",
        status: "Heat activated",
        color: .yellow,
        image: "thermometer",
        chartType: "ringview"
    )
]

var Gases = [
    Critical(
        title: "CO Level",
        indicator: "Conc.",
        reading: 22,
        units: "ppm",
        status: "Acceptable",
        color: .yellow,
        image: "leaf.arrow.circlepath",
        chartType: "chart"
    ),
    Critical(
        title: "CO2 Level",
        indicator: "Conc.",
        reading: 44,
        units: "ppm",
        status: "Unacceptable",
        color: .red,
        image: "leaf.arrow.circlepath",
        chartType: "chart"
    ),
    Critical(
        title: "NO Level",
        indicator: "Conc.",
        reading: 22,
        units: "ppm",
        status: "Safe",
        color: .green,
        image: "leaf.arrow.circlepath",
        chartType: "chart"
    )
]
