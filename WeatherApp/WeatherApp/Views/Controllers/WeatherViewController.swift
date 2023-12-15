//
//  ViewController.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 8.12.23.
//

import UIKit
import RealmSwift

final class WeatherViewController: UIViewController {
    
    //MARK: - Variables
    
    private var viewModel: [WeatherViewModel] = []
    
    private var hourViewModel = [HourlyWeatherCollectionViewCellViewModel]()
    private var dailyViewModel = [DailyWeatherCollectionViewCellViewModel]()
    
    private var collectionView: UICollectionView?
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ConnectionManager.shared.isConnected {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(realm.objects(RealmWeather.self))
            }
        } else {
            loadOfflineMode()
        }
        
        getLocation()
        createCollectionView()
        configurateNavBar()
    }
    //MARK: - OfflineMode
    private func loadOfflineMode() {
        let currentDate = Date()

        let defaults = UserDefaults.standard
        let savedDate = defaults.object(forKey: "lastUpdatedDate")
        
        let timeInterval = currentDate.timeIntervalSince(savedDate as! Date)
        
        let formattedTimeInterval = formatTimeInterval(timeInterval)
        
        loadData(time: formattedTimeInterval)
    }
    
    private func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval / 60)
        let hours = Int(timeInterval / 3600)
        let days = Int(timeInterval / (3600 * 24))
        
        if minutes >= 1 && minutes <= 59 {
            return "\(minutes)min"
        } else if hours >= 1 && hours <= 23 {
            return "\(hours)h"
        } else if days >= 1 {
            return ">\(days)d"
        } else {
            return "<1min"
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }
    
    private var array = [RealmWeather]()
    
    //load data from realm offline
    func loadData(time: String) {
        let realm = try! Realm()
        let items = realm.objects(RealmWeather.self)
        array = Array(items)
        
        let resultOfDate = array.compactMap({$0.time})
        let resultArray = getOfflineDailyData(with: resultOfDate, and: array)
        
        let currentresult = CurrentWeatherCollectionViewCellViewModel(temperature: array[0].temperature, condition: array[0].condition, icon: removeBrackets(string: array[0].condition), time: Localization.offlineTime + time)
        hourViewModel = array[0...5].compactMap({
            HourlyWeatherCollectionViewCellViewModel(temperature: $0.temperature, time: $0.time, image: [self.removeBrackets(string: $0.condition)])
        })
        dailyViewModel = resultArray.compactMap({
            DailyWeatherCollectionViewCellViewModel(temperature: $0.temperature, time: $0.time, image: [self.removeBrackets(string: $0.condition)])
        })
        
        configure(with: [.current(viewModel: currentresult),
                         .hourly(viewModels: hourViewModel),
                         .daily(viewModels: dailyViewModel)
                        ])
    }
    
    //Remove unnesessary bracets from string
    private func removeBrackets(string: String) -> String {
        let startIndex = string.index(string.startIndex, offsetBy: 2)
        let stringWithoutStart = String(string[startIndex...])

        let endIndex = stringWithoutStart.index(stringWithoutStart.endIndex, offsetBy: -2)
        let stringWithoutEnd = String(stringWithoutStart[..<endIndex])

        return stringWithoutEnd
    }
    
    //MARK: - Get Info
    private func getLocation() {
        CoreLocationManager.shared.getCurrentLocation { [weak self] location in
            NetworkManager.fetchForecast(with: location) { [weak self] result in
                switch result {
                case .success(let weather):
                    
                    guard let self = self else { return }
                    
                    let realm = try! Realm()

                    for data in weather {
                        let weather = RealmWeather()
                        weather.temperature = data.main.temp.description
                        weather.condition = data.weather.compactMap({ $0.main }).description
                        weather.image = data.weather.description
                        weather.time = data.dtTxt

                        try! realm.write {
                            realm.add(weather)
                        }
                    }
                    
                    let resultOfDate = weather.compactMap({$0.dtTxt})
                    let sortedDate = self.getDailyData(with: resultOfDate, and: weather)
                    
                    let result = CurrentWeatherCollectionViewCellViewModel(temperature: weather[0].main.temp.description, condition: weather[0].weather[0].main, icon: weather[0].weather[0].main, time: "")
                    
                    self.hourViewModel = weather[0...5].compactMap({
                        HourlyWeatherCollectionViewCellViewModel(temperature: $0.main.temp.description, time: $0.dtTxt, image: $0.weather.compactMap({$0.main}))
                    })
                    
                    self.dailyViewModel = sortedDate.compactMap({
                        DailyWeatherCollectionViewCellViewModel(temperature: $0.main.temp.description, time: $0.dtTxt, image: $0.weather.compactMap({$0.main}))
                    })
                    
                    DispatchQueue.main.async {
                        self.configure(with: [
                            .current(viewModel: result),
                            .hourly(viewModels: self.hourViewModel),
                            .daily(viewModels: self.dailyViewModel)
                        ])
                    }
                    
                   setDateForUserDefaults()
                    
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    private func setDateForUserDefaults() {
        let defaults = UserDefaults.standard
        let currentDate = Date()
        defaults.setValue(currentDate, forKey: "lastUpdatedDate")
        defaults.synchronize()
    }
    
    //MARK: - Helpers
    //Removes unnecessary weather from the array and formats it on non-recurring days, but offline
    private func getOfflineDailyData(with list: [String], and articles: [RealmWeather]) -> [Dictionary<String, RealmWeather>.Values.Element] {

        var uniqueWeekdays: [String] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for dateString in list {
            if let date = dateFormatter.date(from: dateString) {
                let weekday = Calendar.current.component(.weekday, from: date)
                let weekdayName = dateFormatter.weekdaySymbols[weekday - 1]
                
                if !uniqueWeekdays.contains(weekdayName) {
                    uniqueWeekdays.append(weekdayName)
                }
            }
        }
        var dataList = [String: RealmWeather]()
        for listItem in articles {
            let date = listItem.time.prefix(10)
            dataList[String(date)] = listItem
        }
        let filteredListArray = Array(dataList.values)
        let sortedDate = filteredListArray.sorted { $0.time < $1.time }
        return sortedDate
    }
    
    //Removes unnecessary weather from the array and formats it on non-recurring days
    private func getDailyData(with list: [String], and articles: [List]) -> [Dictionary<String, List>.Values.Element] {

        var uniqueWeekdays: [String] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for dateString in list {
            if let date = dateFormatter.date(from: dateString) {
                let weekday = Calendar.current.component(.weekday, from: date)
                let weekdayName = dateFormatter.weekdaySymbols[weekday - 1]
                
                if !uniqueWeekdays.contains(weekdayName) {
                    uniqueWeekdays.append(weekdayName)
                }
            }
        }
        
        var dataList = [String: List]()
        for listItem in articles {
            let date = listItem.dtTxt.prefix(10)
            dataList[String(date)] = listItem
        }
        let filteredListArray = Array(dataList.values)
        let sortedDate = filteredListArray.sorted {$0.dtTxt < $1.dtTxt}
        return sortedDate
    }
    
    //MARK: - SetUp CollectionView
    public func configure(with viewModel: [WeatherViewModel]) {
        self.viewModel = viewModel
        collectionView?.reloadData()
    }
    
    private func createCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.layout(for: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(CurrentWeatherCollectionViewCell.self, 
                                forCellWithReuseIdentifier: CurrentWeatherCollectionViewCell.key)
        collectionView.register(HourlyWeatherCollectionViewCell.self, 
                                forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.key)
        collectionView.register(DailyWeatherCollectionViewCell.self, 
                                forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.key)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.collectionView = collectionView
    }
    
    private func configurateNavBar() {
        navigationController?.title = Localization.controllerTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass.circle.fill"), style: .done, target: self, action: #selector(searchInfo))
    }
    
    @objc func searchInfo() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //MARK: - Layout for CollectionView Sections
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let section = CurrentWeatherSection.allCases[section]
        
        switch section {
        case .current:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                heightDimension: .fractionalHeight(1.0)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0 ),
                                                                           heightDimension: .fractionalWidth(0.7)),
                                                         subitems: [item])
            group.contentInsets = .init(top: 1, 
                                        leading: 2,
                                        bottom: 1,
                                        trailing: 2)
            return NSCollectionLayoutSection(group: group)
        case .hourly:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                heightDimension: .fractionalHeight(1.0)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.23),
                                                                             heightDimension: .absolute(150)),
                                                           subitems: [item])
            group.contentInsets = .init(top: 1, 
                                        leading: 2,
                                        bottom: 1,
                                        trailing: 2)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .daily:
            let item = NSCollectionLayoutItem(layoutSize: 
                    .init(widthDimension: .fractionalWidth(1.0),
                          heightDimension: .fractionalHeight(1.0)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0 ),
                                                                             heightDimension: .absolute(100)),
                                                           subitems: [item])
            group.contentInsets = .init(top: 2, 
                                        leading: 2,
                                        bottom: 2,
                                        trailing: 2)
            return NSCollectionLayoutSection(group: group)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel[section] {
        case .current:
            return 1
        case .hourly(let viewModels):
            return viewModels.count
        case .daily(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel[indexPath.section] {
        case .current(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCollectionViewCell.key, 
                                                                for: indexPath) as? CurrentWeatherCollectionViewCell else { fatalError() }
            cell.configure(with: viewModel)
            return cell
        case .hourly(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.key, 
                                                                for: indexPath) as? HourlyWeatherCollectionViewCell else { fatalError() }
            cell.configute(with: viewModels[indexPath.row])
            return cell
        case .daily(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.key, 
                                                                for: indexPath) as? DailyWeatherCollectionViewCell else { fatalError() }
            cell.configute(with: viewModels[indexPath.row])
            return cell
        }
    }
}
