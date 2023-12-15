//
//  EndPoint.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 13.12.23.
//

import Foundation

struct EndPoint {
    
    static var serverForecastPath: String {
        return "https://api.openweathermap.org/data/2.5/forecast?&"
    }
    
    static var serverWeatherPath: String {
        return "https://api.openweathermap.org/data/2.5/weather?"
    }
    
    static var apiKey: String {
        return "&appid=46601a418ab6bc2a61f168601779f458&units=metric"
    }
}
