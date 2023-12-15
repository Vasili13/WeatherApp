//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 10.12.23.
//

import Foundation

struct Response: Codable {
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let dt: TimeInterval
    let main: Main
    let weather: [Forecast]
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - MainClass
struct Main: Codable {
    let temp: Double

    enum CodingKeys: String, CodingKey {
        case temp
    }
}

// MARK: - Weather
struct Forecast: Codable {
    let id: Int
    let main: String
    let icon: String
}
