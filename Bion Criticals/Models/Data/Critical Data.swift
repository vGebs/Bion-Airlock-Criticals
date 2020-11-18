//
//  Critical Data.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-09-30.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import Foundation

var Controls = [
    Critical(
        uid: 0,
        title: "Cabin Pressure",
        indicator: "Pressure Level",
        units: "PSI",
        image: "rectangle.compress.vertical",
        data: []
    ),
    Critical(
        uid: 1,
        title: "Door Locks",
        indicator: "Activated",
        units: "i/o",
        image: "lock.circle",
        data: []
    ),
    Critical(
        uid: 2,
        title: "Cabin Temperature",
        indicator: "Temp",
        units: "c",
        image: "thermometer",
        data: []
    )
]

var Gases = [
    Critical(
        uid: 3,
        title: "CO Level",
        indicator: "Conc.",
        units: "ppm",
        image: "leaf.arrow.circlepath",
        data: []
    ),
    Critical(
        uid: 4,
        title: "CO2 Level",
        indicator: "Conc.",
        units: "ppm",
        image: "leaf.arrow.circlepath",
        data: []
    ),
    Critical(
        uid: 5,
        title: "NO Level",
        indicator: "Conc.",
        units: "ppm",
        image: "leaf.arrow.circlepath",
        data: []
    )
]
