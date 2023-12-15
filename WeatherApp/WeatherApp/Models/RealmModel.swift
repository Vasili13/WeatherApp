//
//  RealmModel.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 15.12.23.
//

import Foundation
import RealmSwift

class RealmWeather: Object {
    @objc dynamic var temperature = ""
    @objc dynamic var condition = ""
    @objc dynamic var image = ""
    @objc dynamic var time = ""
}
