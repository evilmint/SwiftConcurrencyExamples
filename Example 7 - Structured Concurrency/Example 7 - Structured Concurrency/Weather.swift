//
//  Weather.swift
//  Example 7 - Structured Concurrency
//
//  Created by Aleksander Lorenc on 10/06/2021.
//

import Foundation

struct Weather: Decodable, Sendable {
    struct Main: Decodable, Sendable {
        let temp: Float
    }

    let name: String
    let main: Main

    var degreesCelsius: Float {
        (main.temp - 273.15)
    }
}
