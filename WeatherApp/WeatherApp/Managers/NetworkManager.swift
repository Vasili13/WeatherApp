//
//  NetworkMAnager.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 10.12.23.
//

import Foundation
import CoreLocation

final class NetworkManager {
    
    //fetch 5-day forecast
    static func fetchForecast(with loc: CLLocation, completion: @escaping (Result<[List], Error>) -> Void) {
        
        let url = URL(string: EndPoint.serverForecastPath + "lat=\(loc.coordinate.latitude)&lon=\(loc.coordinate.longitude)" + EndPoint.apiKey)
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result =  try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(result.list))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    //fetch the current weather
    static func searchWeather(with query: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let url = URL(string: EndPoint.serverWeatherPath + "q=\(query)" + EndPoint.apiKey)
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
