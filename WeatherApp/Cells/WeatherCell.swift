//
//  CityCell.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 09.02.2024.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    // MARK: - UI Elements
    private let buttonBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.383, green: 0.183, blue: 0.708, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()

    private let weatherIconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let temperatureLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-Medium", size: 15)
        view.textColor = .white
        return view
    }()

    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-Semibold", size: 15)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupViews() {
        contentView.addSubviews(buttonBackgroundView, descriptionLabel)
        buttonBackgroundView.addSubviews(weatherIconImageView, temperatureLabel)

        buttonBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-3)
            make.top.equalTo(weatherIconImageView.snp.top).offset(-12)
        }

        weatherIconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(temperatureLabel.snp.top).offset(-3)
            make.height.width.equalTo(30)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(buttonBackgroundView.snp.bottom).offset(-12)
            make.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
        }
    }
}

// MARK: - Configuration
extension WeatherCell: ConfigurableCell {
    func configure(with data: CellData) {
        if let temp = data.temp, let description = data.description, let icon = data.icon, let iconImage = WeatherIconHelper.image(forIcon: icon) {
            temperatureLabel.text = temp + Constants.celsius
            descriptionLabel.text = description
            weatherIconImageView.image = iconImage
        }
    }
}
