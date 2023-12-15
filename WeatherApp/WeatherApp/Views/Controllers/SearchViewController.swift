//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 8.12.23.
//

import UIKit

final class SearchViewController: UIViewController, UISearchBarDelegate {
    
    private let search = UISearchController(searchResultsController: nil)
    
    private let weatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.Radius.basicRadius
        view.layer.borderWidth = Constants.BorderWidth.basicBorderWidth
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        return view
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
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
    
    private var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        createSearchBar()
        addConstraints()
    }
    
    private func setUpView() {
        title = Localization.searchTitle
        view.backgroundColor = .systemBackground
        view.addSubview(weatherView)
        weatherView.addSubview(cityLabel)
        weatherView.addSubview(tempretureLabel)
        weatherView.addSubview(conditionLabel)
        weatherView.addSubview(weatherIcon)
        weatherView.isHidden = true
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            tempretureLabel.topAnchor.constraint(equalTo: cityLabel.topAnchor),
            tempretureLabel.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor),
            tempretureLabel.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor),
            
            weatherIcon.heightAnchor.constraint(equalToConstant: 55),
            weatherIcon.widthAnchor.constraint(equalToConstant: 55),
            weatherIcon.topAnchor.constraint(equalTo: tempretureLabel.bottomAnchor),
            weatherIcon.bottomAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: -20),

            conditionLabel.leftAnchor.constraint(equalTo: weatherIcon.rightAnchor, constant: 10),
            conditionLabel.topAnchor.constraint(equalTo: tempretureLabel.bottomAnchor),
            conditionLabel.heightAnchor.constraint(equalToConstant: 80),
            conditionLabel.centerXAnchor.constraint(equalTo: weatherView.centerXAnchor, constant: 15),
            conditionLabel.bottomAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: -20),
            
            cityLabel.topAnchor.constraint(equalTo: weatherView.topAnchor, constant: 20),
            cityLabel.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor),
            
            weatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func createSearchBar() {
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        search.searchBar.delegate = self
    }
    
    //search Weather by query
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }

        NetworkManager.searchWeather(with: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.weatherView.isHidden = false
                    self.cityLabel.text = text
                    self.tempretureLabel.text = self.changer(double: weather.main.temp).description + "˚"
                    self.conditionLabel.text = Localization.getCondition(with: weather.weather[0].main)
                    self.weatherIcon.image = UIImage(named: self.imageForIcon(withName: weather.weather[0].main))
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.showAlert()
                }
                print(failure.localizedDescription)
            }
        }
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
    
    private func showAlert() {
        let alert = UIAlertController(title: "Nothing found :(", message: "Did not match any query", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}
