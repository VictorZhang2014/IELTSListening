//
//  ZQMainNavigationController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class ZQNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSettings()
    }
    
    // MARK: navigation bar
    func navigationBarSettings() {
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.setBackgroundImage(UIImage(named: "ZQNavBarBlurBackgroundImage"), for: .default)
    }

}
