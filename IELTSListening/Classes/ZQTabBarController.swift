//
//  ZQTabBarController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 06/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class ZQTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationBarSettings()
        tabBarSettings()
    }
    
    // MARK: navigation bar
    func navigationBarSettings() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = UIColor.white
        navigationBar.setBackgroundImage(UIImage(named: "ZQNavBarBlurBackgroundImage"), for: .default)
    }
    
    // MARK: tab bar 设置文字和图片
    func tabBarSettings() {
        
        let tabBarHomeVC = ZQNavigationController(rootViewController: ZQHomeListViewController())
        tabBarHomeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "zq_default_icn_music"), selectedImage: UIImage(named: "zq_default_icn_music_prs"))
        tabBarHomeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0) // 使图片垂直居中
        
        let tabBarListeningVC = ZQNavigationController(rootViewController: ZQDiscoverViewController())
        tabBarListeningVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "zq_default_icn_discovery"), selectedImage: UIImage(named: "zq_default_icn_discovery_prs"))
        tabBarListeningVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0) // 使图片垂直居中
        
        let tabBarMoreVC = ZQNavigationController(rootViewController: ZQSettingsViewController())
        tabBarMoreVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "zq_default_icn_account"), selectedImage: UIImage(named: "zq_default_icn_account_prs"))
        tabBarMoreVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0) // 使图片垂直居中
    
        setViewControllers([ tabBarHomeVC, tabBarListeningVC, tabBarMoreVC ], animated: true)
     
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barStyle = .black
        
        
//        tabBarHome.title = "Home"
//        let attributes = [ NSAttributedStringKey.foregroundColor: UIColor.white,
//                           NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
//        tabBarHome.setTitleTextAttributes(attributes, for: .normal)
//        let attributes1 = [ NSAttributedStringKey.foregroundColor: UIColor.unifiedColor,
//                            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)]
//        tabBarHome.setTitleTextAttributes(attributes1, for: .selected)
//
//        tabBarListening.title = "Listening"
//        let attributesListening = [ NSAttributedStringKey.foregroundColor: UIColor.white,
//                                    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
//        tabBarListening.setTitleTextAttributes(attributesListening, for: .normal)
//        let attributesListening1 = [ NSAttributedStringKey.foregroundColor: UIColor.unifiedColor,
//                                     NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)]
//        tabBarListening.setTitleTextAttributes(attributesListening1, for: .selected)
//
//        tabBarMore.title = "More"
//        let attributesMore = [ NSAttributedStringKey.foregroundColor: UIColor.white,
//                               NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
//        tabBarMore.setTitleTextAttributes(attributesMore, for: .normal)
//        let attributesMore1 = [ NSAttributedStringKey.foregroundColor: UIColor.unifiedColor,
//                                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)]
//        tabBarMore.setTitleTextAttributes(attributesMore1, for: .selected)
    }


}
