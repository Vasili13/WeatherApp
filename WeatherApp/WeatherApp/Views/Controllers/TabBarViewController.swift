//
//  TabBarViewController.swift
//  WeatherApp
//
//  Created by Василий Вырвич on 8.12.23.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        
        let titleTab1 = Localization.controllerTitle
        let titleTab2 = Localization.settingsTitle
        
        let tab1 = WeatherViewController()
        tab1.title = titleTab1
        let tab2 = SettingsViewController()
        tab2.title = titleTab2
        
        let navigation1 = UINavigationController(rootViewController: tab1)
        let navigation2 = UINavigationController(rootViewController: tab2)
        
        navigation1.tabBarItem = UITabBarItem(title: titleTab1, image: UIImage(systemName: "cloud.sun.circle"), tag: 1)
        navigation2.tabBarItem = UITabBarItem(title: titleTab2, image: UIImage(systemName: "gear"), tag: 2)
        
        setViewControllers([navigation1, navigation2], animated: true)
    }
}
