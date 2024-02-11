//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 10.02.2024.
//

import Foundation

// MARK: - WeatherDataHandler Protocol
protocol WeatherDataHandler {
    func handleWeatherData(data: Data) throws -> Weather
}

// MARK: - JSONWeatherDataHandler
class JSONWeatherDataHandler: WeatherDataHandler {
    func handleWeatherData(data: Data) throws -> Weather {
        return try JSONDecoder().decode(Weather.self, from: data)
    }
}

// MARK: - NetworkManager
final class NetworkManager {
    // MARK: - Properties
    static let shared = NetworkManager()

    private(set) var weatherArray: [Weather?] = Array(repeating: nil, count: 10)
    private let weatherDataHandler: WeatherDataHandler

    // MARK: - Init
    init(weatherDataHandler: WeatherDataHandler = JSONWeatherDataHandler()) {
        self.weatherDataHandler = weatherDataHandler
    }

    // MARK: - Public Methods
    func getWeather(forCities cities: [City], completion: @escaping (Result<[Weather?], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()

        cities.forEach { city in
            dispatchGroup.enter()

            guard let url = URL(string: "\(Constants.baseURL)lat=\(city.latitude)&lon=\(city.longitude)&limit=1&hours=true") else {
                completion(.failure(APIError.invalidURL))
                return
            }

            var request = URLRequest(url: url)
            request.setValue(Constants.API_KEY, forHTTPHeaderField: "X-Yandex-API-Key")
            request.timeoutInterval = 60

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                defer {
                    dispatchGroup.leave()
                }

                guard let data = data, error == nil else {
                    completion(.failure(APIError.dataFetchingFailed))
                    return
                }

                do {
                    let result = try self.weatherDataHandler.handleWeatherData(data: data)
                    if let index = cities.firstIndex(where: { $0.name == city.name }) {
                        self.weatherArray[index] = result
                    }
                } catch {
                    completion(.failure(APIError.dataDecodingFailed))
                }
            }
            task.resume()
        }

        dispatchGroup.notify(queue: .main) {
            completion(.success(self.weatherArray.compactMap { $0 }))
        }
    }
}
