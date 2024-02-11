//
//  ModalController.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 10.02.2024.
//

import UIKit

class ModalController: UIViewController {
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Hello World".localize()
        view.textColor = .white
        view.font = UIFont(name: "Poppins-SemiBold", size: 28)
        view.numberOfLines = 0

        return view
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.263, green: 0.063, blue: 0.596, alpha: 0.7)
        setupViews()
    }
}

// MARK: - UI
private extension ModalController {
    func setupViews() {
        view.addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
