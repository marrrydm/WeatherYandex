//
//  UIView.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 09.02.2024.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
