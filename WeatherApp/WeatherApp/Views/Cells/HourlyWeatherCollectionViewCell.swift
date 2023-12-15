//
//  HourlyWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 8.12.23.
//

import UIKit

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    static let key = "HourlyWeatherCollectionViewCell"
     
    private let tempretureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constants.Fonts.smallFont, weight: .regular)
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constants.Fonts.hourFont, weight: .regular)
        return label
    }()

    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(tempretureLabel)
    }
    
    private func configurateView() {
        contentView.layer.cornerRadius = Constants.Radius.basicRadius
        contentView.layer.borderWidth = Constants.BorderWidth.basicBorderWidth
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.backgroundColor = .systemBlue.withAlphaComponent(0.7)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            timeLabel.heightAnchor.constraint(equalToConstant: 40),
            timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            weatherIcon.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            weatherIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 32),
            weatherIcon.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            tempretureLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor),
            tempretureLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            tempretureLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            tempretureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tempretureLabel.text = nil
        timeLabel.text = nil
        weatherIcon.image = nil
    }

    
    public func configute(with model: HourlyWeatherCollectionViewCellViewModel) {
        tempretureLabel.text = changer(double: Double(model.temperature) ?? 0).description + "˚"
        timeLabel.text = convert(data: model.time)
        let result = model.image[0].description
        weatherIcon.image = UIImage(named: self.imageForIcon(withName: result))
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
    
    private func convert(data: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: data) {
            dateFormatter.dateFormat = "HH:mm"
            let timeString = dateFormatter.string(from: date)
            return timeString
        }
        
        return ""
    }
}
