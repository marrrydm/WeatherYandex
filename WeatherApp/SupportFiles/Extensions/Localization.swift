//
//  Localization.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 09.02.2024.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
