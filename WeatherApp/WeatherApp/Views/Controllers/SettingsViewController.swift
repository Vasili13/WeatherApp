//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 14.12.23.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let settingsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.key)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        navigationController?.title = Localization.settingsTitle
        view.addSubview(settingsTableView)
        settingsTableView.frame = view.bounds
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Temperature"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.key, for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.toggleSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return cell
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isFahrenheit")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
}
