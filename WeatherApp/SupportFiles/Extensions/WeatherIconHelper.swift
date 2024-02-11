//
//  WeatherIconHelper.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 10.02.2024.
//

import UIKit

enum WeatherIconHelper {
    static func image(forIcon icon: String) -> UIImage? {
        switch icon {
        case "clear", "partly-cloudy":
            return UIImage(named: "clear")
        case "cloudy":
            return UIImage(named: "sun")
        case "overcast", "light-rain":
            return UIImage(named: "little Rain")
        case "rain", "heavy-rain", "showers":
            return UIImage(named: "rain")
        case "wet-snow", "light-snow":
            return UIImage(named: "light-snow")
        case "snow", "snow-showers":
            return UIImage(named: "rain")
        case "hail", "thunderstorm-with-rain", "thunderstorm-with-hail", "thunderstorm":
            return UIImage(named: "clear")
        default:
            return UIImage(named: "clear")
        }
    }
}
