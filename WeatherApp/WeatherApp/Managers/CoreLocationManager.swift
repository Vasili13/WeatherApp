//
//  CoreLocationManager.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 8.12.23.
//

import Foundation
import CoreLocation

final class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = CoreLocationManager()
    
    private let manager = CLLocationManager()
    
    private var locationFetchComletion: ((CLLocation) -> Void)?
    
    private var location: CLLocation? {
        didSet {
            guard let location else { return }
            locationFetchComletion?(location)
        }
    }
    
    public func getCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        
        self.locationFetchComletion = completion
        
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
        manager.stopUpdatingLocation()
    }
}
