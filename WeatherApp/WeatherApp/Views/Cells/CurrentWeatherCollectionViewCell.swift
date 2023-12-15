//
//  CurrentWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 8.12.23.
//

import UIKit

final class CurrentWeatherCollectionViewCell: UICollectionViewCell {   
    
    static let key = "CurrentWeatherCollectionViewCell"
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "My Location"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constants.Fonts.middleFont, weight: .medium)
        return label
    }()
    
    private let tempretureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constants.Fonts.largeFont, weight: .medium)
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constants.Fonts.middleFont, weight: .medium)
        return label
    }()
    
    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constants.Fonts.hourFont, weight: .light)
        return label
    }()
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        addConstraints()
        configurateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        contentView.addSubview(locationLabel)
        contentView.addSubview(tempretureLabel)
        contentView.addSubview(conditionLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(timeLabel)
    }
    
    private func configurateView() {
        contentView.layer.cornerRadius = Constants.Radius.basicRadius
        contentView.layer.borderWidth = Constants.BorderWidth.basicBorderWidth
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.backgroundColor = .systemBlue.withAlphaComponent(0.7)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            tempretureLabel.topAnchor.constraint(equalTo: locationLabel.topAnchor),
            tempretureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tempretureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            weatherIcon.heightAnchor.constraint(equalToConstant: 55),
            weatherIcon.widthAnchor.constraint(equalToConstant: 55),
            weatherIcon.topAnchor.constraint(equalTo: tempretureLabel.bottomAnchor),
            weatherIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),

            conditionLabel.leftAnchor.constraint(equalTo: weatherIcon.rightAnchor, constant: 10),
            conditionLabel.topAnchor.constraint(equalTo: tempretureLabel.bottomAnchor),
            conditionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 15),
            conditionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            timeLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tempretureLabel.text = nil
        conditionLabel.text = nil
        weatherIcon.image = nil
    }
    
    public func configure(with model: CurrentWeatherCollectionViewCellViewModel) {
        tempretureLabel.text = changer(double: Double(model.temperature) ?? 0).description + "˚"
        conditionLabel.text = Localization.getCondition(with: model.condition)
        let result = model.icon.description
        weatherIcon.image = UIImage(named: self.imageForIcon(withName: result))
        timeLabel.text = model.time
    }
    
    
    private func changer(double: Double) -> Int {
        if UserDefaults.standard.bool(forKey: "isFahrenheit") {
            return Int((double * 9/5) + 32)
        } else {
            return Int(double)
        }
    }
    
    private func imageForIcon(withName name: String) -> String {
        switch name {
        case "Clear":
            return "clear"
        case "Drizzle":
            return "drizzle"
        case "Snow":
            return "snow"
        case "Clouds":
            return "cloud"
        case "Rain":
            return "rain"
        case "Thunderstorm":
            return "thunderstorm"
        default:
            return "atmosphere"
        }
    }
}
