//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 10.02.2024.
//

import Foundation

struct Weather: Decodable {
    let fact: Fact
    let forecasts: [Forecast]
}

struct Fact: Codable {
    let temp: Int
    let feelsLike: Int
    let condition: String
    let icon: String
    let windSpeed: Double
    let windDirection: String
    let pressure: Int
    let humidity: Int

    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case condition
        case icon
        case windSpeed = "wind_speed"
        case windDirection = "wind_dir"
        case pressure = "pressure_mm"
        case humidity
    }
}

struct Forecast: Decodable {
    let date: String?
    let hours: [Hour]
    let parts: Parts

    enum CodingKeys: String, CodingKey {
        case date
        case parts, hours
    }
}

struct Hour: Decodable {
    let hour: String?
    let temp: Int?
    let icon: String?
    let condition: String?

    enum CodingKeys: String, CodingKey {
        case hour
        case temp 
        case icon
        case condition
    }
}

struct Parts: Decodable {
    let night: Day
    let day: Day

    enum CodingKeys: String, CodingKey {
        case night
        case day
    }
}

struct Day: Decodable {
    let tempMin: Int
    let tempMax: Int
    let condition: String

    private enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case condition
    }
}
