//
//  CityCell.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 09.02.2024.
//

import UIKit

protocol ConfigurableCell {
    func configure(with data: CellData)
}

class CityCell: UICollectionViewCell {
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "town1"))
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.clipsToBounds = true

        return view
    }()

    private let cityLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-SemiBold", size: 20)
        view.textColor = .white

        return view
    }()

    private let tempLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-SemiBold", size: 18.8)
        view.textColor = .white

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
        contentView.addSubviews(imageView)
        imageView.addSubviews(cityLabel, tempLabel)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalToSuperview().offset(20)
        }

        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
        }
    }
}

// MARK: - Configuration
extension CityCell: ConfigurableCell {
    func configure(with data: CellData) {
        contentView.backgroundColor = .clear
        if let city = data.city, let temp = data.temp, let img = data.img {
            cityLabel.text = city
            tempLabel.text = temp + Constants.celsius
            imageView.image = img ? UIImage(named: "town1") : UIImage(named: "town2")
        }
    }
}
