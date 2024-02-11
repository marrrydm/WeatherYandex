//
//  Builder.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 11.02.2024.
//

import UIKit

class Builder {
    static func build() -> UINavigationController {
        let weatherViewModel = WeatherViewModel()
        let homeController = HomeController(weatherViewModel: weatherViewModel)
        let navigationController = UINavigationController(rootViewController: homeController)
        return navigationController
    }
}
