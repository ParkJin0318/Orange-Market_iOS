//
//  TabbarController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit

class TabBarController: ASTabBarController {
    
    private lazy var homeViewController = HomeViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
    }
    
    private lazy var cityViewController = CityViewContoller().then {
        $0.tabBarItem = UITabBarItem(
            title: "지역생활",
            image: UIImage(systemName: "doc.plaintext"),
            selectedImage: UIImage(systemName: "doc.plaintext.fill")
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.do {
            $0.isTranslucent = false
            $0.tintColor = .label
        }
        self.setNavigationController()
    }
    
    private func setNavigationController() {
        let navigationController1 = ASNavigationController(rootViewController: homeViewController).then {
            $0.navigationBar.isTranslucent = false
        }
        let navigationController2 = ASNavigationController(rootViewController: cityViewController).then {
            $0.navigationBar.isTranslucent = false
        }
        
        viewControllers = [
            navigationController1,
            navigationController2
        ]
        selectedViewController = navigationController1
    }
}
