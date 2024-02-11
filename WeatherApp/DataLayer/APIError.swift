//
//  APIError.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 10.02.2024.
//

import Foundation

enum APIError: Error {
    case dataFetchingFailed
    case invalidURL
    case dataDecodingFailed
    case invalidCoordinates
    case invalidImageData
    case invalidIcon
}
