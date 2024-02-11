//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 10.02.2024.
//

import Foundation

// MARK: - WeatherServiceProtocol
protocol WeatherServiceProtocol {
    func getWeather(forCities cities: [City], completion: @escaping (Result<[Weather?], Error>) -> Void)
}

// MARK: - WeatherService
class WeatherService: WeatherServiceProtocol {
    func getWeather(forCities cities: [City], completion: @escaping (Result<[Weather?], Error>) -> Void) {
        NetworkManager.shared.getWeather(forCities: cities, completion: completion)
    }
}

// MARK: - WeatherViewModelProtocol
protocol WeatherViewModelProtocol {
    var cities: [City] { get }
    var validWeathers: [Weather] { get }
    var hourWeathers: [[Hour]] { get }
    var hours: [String] { get }

    func getWeather(completion: @escaping (Result<Void, Error>) -> Void)
    func formatWeatherDate(_ dateString: String, minTemp: Int, maxTemp: Int) -> String
    func getHours() -> [String]
}

// MARK: - WeatherViewModel
class WeatherViewModel: WeatherViewModelProtocol {
    // MARK: - Properties
    private let weatherService: WeatherServiceProtocol

    let cities: [City] = [
        City(name: "Moscow", latitude: 55.75396, longitude: 37.620393),
        City(name: "Samara", latitude: 53.241505, longitude: 50.221245),
        City(name: "Kazan", latitude: 55.796391, longitude: 49.108891),
        City(name: "Vladivostok", latitude: 43.119809, longitude: 131.886924),
        City(name: "Tyumen", latitude: 57.161297, longitude: 65.525017),
        City(name: "Krasnoyarsk", latitude: 56.015283, longitude: 92.893248),
        City(name: "Sochi", latitude: 43.588348, longitude: 39.729996),
        City(name: "Ufa", latitude: 54.733334, longitude: 55.972055),
        City(name: "Krasnodar", latitude: 45.039268, longitude: 38.987221),
        City(name: "Voronezh", latitude: 51.675497, longitude: 39.208882)
    ]

    private(set) var validWeathers = [Weather]()
    private(set) var hourWeathers = [[Hour]]()
    private(set) var hours = [String]()

    // MARK: - Init
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
        calculateHours()
    }

    // MARK: - Public Methods
    func getWeather(completion: @escaping (Result<Void, Error>) -> Void) {
        weatherService.getWeather(forCities: cities) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weathers):
                self.validWeathers = weathers.compactMap { $0 }
                self.hourWeathers = self.validWeathers.map { $0.forecasts[0].hours }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getHours() -> [String] {
        return hours
    }

    func formatWeatherDate(_ dateString: String, minTemp: Int, maxTemp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Constants.localId)
        dateFormatter.dateFormat = Constants.dateFormat

        if let date = dateFormatter.date(from: dateString) {

            let formattedDate = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            let temperature = "\(minTemp)\(Constants.celsius)/\(maxTemp)\(Constants.celsius)"

            return "\(formattedDate) \(temperature)"
        }
        return ""
    }
}

// MARK: - Private Methods
private extension WeatherViewModel {
    func calculateHours() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:00 a"

        hours = ["Now"] + (1...24).compactMap { hour in
            Calendar.current.date(byAdding: .hour, value: hour, to: Date()).map {
                formatter.string(from: $0)
            }
        }
    }
}