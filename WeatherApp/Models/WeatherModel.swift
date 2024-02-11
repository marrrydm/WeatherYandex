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
    let condition: String
    let icon: String

    private enum CodingKeys: String, CodingKey {
        case temp
        case condition
        case icon
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
    var temp: Int?
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
