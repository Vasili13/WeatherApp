//
//  Weather.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 12.12.23.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: MainWeather
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

struct MainWeather: Codable {
    let temp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
    }
}
