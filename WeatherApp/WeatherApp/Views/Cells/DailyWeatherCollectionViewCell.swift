//
//  DailyWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 8.12.23.
//

import UIKit

final class DailyWeatherCollectionViewCell: UICollectionViewCell {
    
    static let key = "DailyWeatherCollectionViewCell"
    
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
        label.font = .systemFont(ofSize: Constants.Fonts.dayOfWeekFont, weight: .bold)
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
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            timeLabel.heightAnchor.constraint(equalToConstant: 40),

            weatherIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 32),
            weatherIcon.rightAnchor.constraint(equalTo: tempretureLabel.leftAnchor,constant: -30),
            weatherIcon.widthAnchor.constraint(equalToConstant: 32),

            tempretureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tempretureLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 16),
            tempretureLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        tempretureLabel.text = nil
        timeLabel.text = nil
        weatherIcon.image = nil
    }
    
    public func configute(with model: DailyWeatherCollectionViewCellViewModel) {
        self.tempretureLabel.text = changer(double: Double(model.temperature) ?? 0).description + "˚"
        self.timeLabel.text = convert(date: model.time)
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
    
    private func convert(date: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: date) {
            let dayOfWeekFormatter = DateFormatter()
            dayOfWeekFormatter.dateFormat = "EEEE"
            
            let dayOfWeek = dayOfWeekFormatter.string(from: date)
            return dayOfWeek.capitalized
        }
        
        return ""
    }
}
