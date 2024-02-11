//
//  ViewController.swift
//  WeatherApp
//
//  Created by Мария Ганеева on 09.02.2024.
//

import SnapKit
import UIKit

class HomeController: UIViewController {

    // MARK: - Properties
    private let weatherViewModel: WeatherViewModelProtocol
    private var cityIndex = 0

    // MARK: - UI Elements
    private let nightImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "night"))
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true

        return view
    }()

    private lazy var accountImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "account"))
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAccount)))

        return view
    }()

    private lazy var optionImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "option"))
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOption)))

        return view
    }()

    private let cityLabel: UILabel = {
        let view = UILabel()
        view.text = "Moscow"
        view.textColor = .white
        view.font = UIFont(name: "Poppins-SemiBold", size: 28)
        view.numberOfLines = 0

        return view
    }()

    private let infoLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont(name: "Poppins-Regular", size: 12.91)
        view.numberOfLines = 0

        return view
    }()

    private let currentTempLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont(name: "Poppins-SemiBold", size: 36)
        view.numberOfLines = 0

        return view
    }()

    private let currentStateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont(name: "Poppins-Regular", size: 21.33)
        view.numberOfLines = 0

        return view
    }()

    private let todayLabel: UILabel = {
        let view = UILabel()
        view.text = "Today".localize()
        view.textColor = .white
        view.font = UIFont(name: "Poppins-Medium", size: 20)
        view.numberOfLines = 0

        return view
    }()

    private let swipeLabel: UILabel = {
        let view = UILabel()
        view.text = "swipeTitle".localize()
        view.textColor = .white
        view.font = UIFont(name: "Roboto-Regular", size: 12)
        view.numberOfLines = 0

        return view
    }()

    private lazy var swipeImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "down"))
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDown)))

        return view
    }()

    private lazy var collectionViewCity: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(CityCell.self, forCellWithReuseIdentifier: "CityCell")
        view.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false

        return view
    }()

    private lazy var collectionViewWeather: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(WeatherCell.self, forCellWithReuseIdentifier: "WeatherCell")
        view.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false

        return view
    }()

    // MARK: - Init
    init(weatherViewModel: WeatherViewModelProtocol) {
        self.weatherViewModel = weatherViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.263, green: 0.063, blue: 0.596, alpha: 1)
        setupViews()
        fetchWeatherData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - UI
private extension HomeController {
    func setupViews() {
        view.addSubviews(
            nightImageView,
            collectionViewCity,
            todayLabel,
            collectionViewWeather
        )

        nightImageView.addSubviews(
            accountImageView,
            optionImageView,
            cityLabel,
            infoLabel,
            currentTempLabel,
            currentStateLabel,
            swipeLabel,
            swipeImageView
        )

        accountImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(25)
            make.height.width.equalTo(34)
        }

        optionImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(27)
            make.width.equalTo(34)
            make.height.equalTo(17)
        }

        cityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
        }

        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(25)
        }

        currentTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cityLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(25)
        }

        currentStateLabel.snp.makeConstraints { make in
            make.top.equalTo(currentTempLabel.snp.bottom).offset(7)
            make.trailing.equalToSuperview().inset(25)
        }

        swipeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(swipeImageView.snp.top).offset(-9)
            make.centerX.equalToSuperview()
        }

        swipeImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-11)
            make.centerX.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(10)
        }

        nightImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(collectionViewCity.snp.top).offset(-30)
        }

        collectionViewCity.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(todayLabel.snp.top).offset(-27)
            make.height.equalTo(217)
        }

        todayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.bottom.equalTo(collectionViewWeather.snp.top).offset(-6)
        }

        collectionViewWeather.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
            make.height.equalTo(150)
        }
    }

    func setupCollection() {
        self.collectionViewCity.delegate = self
        self.collectionViewCity.dataSource = self
        self.collectionViewWeather.delegate = self
        self.collectionViewWeather.dataSource = self
    }
}

// MARK: - Selector Methods
private extension HomeController {
    @objc func tapAccount() {
        let vc = ModalController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }

    @objc func tapOption() {
        let vc = OptionController()
        navigationController?.pushViewController(vc, animated: false)
    }

    @objc func tapDown() {
        //
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == collectionViewWeather ?
        weatherViewModel.getHours().count - 1 :
        weatherViewModel.cities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView == collectionViewCity ?
        configureCityCell(collectionView: collectionView, indexPath: indexPath) :
        configureWeatherCell(collectionView: collectionView, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collectionViewCity:
            let width = (collectionView.frame.width - 20.0) / 2.2
            return CGSize(width: width, height: 217)
        default:
            return CGSize(width: 76, height: 76)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == collectionViewCity else { return }
        let cityWeather = weatherViewModel.validWeathers[indexPath.row]
        cityIndex = indexPath.row
        updateUIWithWeatherData(city: weatherViewModel.cities[indexPath.row].name, cityWeather)
    }
}

// MARK: - Fetching Data
private extension HomeController {
    func fetchWeatherData() {
        weatherViewModel.getWeather { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.handleWeatherData()
                    self.setupCollection()
                }
            case .failure(let error):
                self.handleError(error)
            }
        }
    }

    func handleWeatherData() {
        if let firstWeather = weatherViewModel.validWeathers.first {
            updateUIWithWeatherData(city: "Moscow", firstWeather)
        }
    }

    func handleError(_ error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Update UI
private extension HomeController {
    func updateUIWithWeatherData(city: String, _ cityWeather: Weather) {
        cityLabel.text = city
        infoLabel.text = weatherViewModel.formatWeatherDate(cityWeather.forecasts.first?.date ?? Constants.date, minTemp: cityWeather.forecasts.first?.parts.day.tempMin ?? 0, maxTemp: cityWeather.forecasts.first?.parts.day.tempMax ?? 0)
        currentTempLabel.text = "\(cityWeather.fact.temp)\(Constants.celsius)"
        currentStateLabel.text = "\(cityWeather.fact.condition.prefix(1).uppercased())\(cityWeather.fact.condition.dropFirst())"

        collectionViewWeather.reloadData()
    }

    private func configureCityCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as? CityCell else {
            fatalError("Unable to dequeue CityCell")
        }
        let cityName = weatherViewModel.cities[indexPath.row].name
        let temp = String(weatherViewModel.validWeathers[indexPath.row].fact.temp)
        let img = indexPath.row % 2 == 0
        cell.configure(with: CellData(city: cityName, temp: temp, img: img, icon: nil, description: nil))
        return cell
    }

    private func configureWeatherCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell else {
            fatalError("Unable to dequeue WeatherCell")
        }
        let temp = String(weatherViewModel.hourWeathers[cityIndex][indexPath.row].temp ?? 0)
        let description = weatherViewModel.getHours()[indexPath.item]
        let icon = weatherViewModel.hourWeathers[cityIndex][indexPath.row].condition ?? ""
        cell.configure(with: CellData(city: nil, temp: temp, img: nil, icon: icon, description: description))
        return cell
    }
}
