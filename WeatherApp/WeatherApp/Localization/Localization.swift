//
//  L10n.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 14.12.23.
//

import Foundation

class Localization {
    static let controllerTitle = NSLocalizedString("weatherController.title", comment: "")
    static let settingsTitle = NSLocalizedString("settingsController.title", comment: "")
    static let searchTitle = NSLocalizedString("searchController.title", comment: "")
    static let offlineTime = NSLocalizedString("offlineTime", comment: "")
    
    static func getCondition(with condition: String) -> String {
        switch condition {
        case "Clear":
            return NSLocalizedString("clear", comment: "")
        case "Drizzle":
            return NSLocalizedString("drizzle", comment: "")
        case "Snow":
            return NSLocalizedString("snow", comment: "")
        case "Clouds":
            return NSLocalizedString("clouds", comment: "")
        case "Rain":
            return NSLocalizedString("rain", comment: "")
        case "Thunderstorm":
            return NSLocalizedString("thunderstorm", comment: "")
        default:
            return NSLocalizedString("dust", comment: "")
        }
    }
}
