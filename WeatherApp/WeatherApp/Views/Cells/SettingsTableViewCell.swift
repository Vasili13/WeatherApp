//
//  SettingsTableViewCell.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 14.12.23.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let key = "SettingsTableViewCell"
    
    private let labelType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Imperial"
        return label
    }()
    
    let toggleSwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        toggleSwitch.isOn = UserDefaults.standard.bool(forKey: "isFahrenheit")
        
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(labelType)
        contentView.addSubview(toggleSwitch)
                
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            labelType.topAnchor.constraint(equalTo: self.topAnchor),
            labelType.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelType.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labelType.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
}
