//
//  ZQMainNavigationController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class ZQNavigationController: UINavigationController {
    
    //是否显示正常的导航栏
    public var showNormalNavigationBar: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showNormalNavigationBar {
            navigationBarSettings()
        }
    }
    
    // MARK: navigation bar
    public func navigationBarSettings() {
        self.navigationBar.tintColor = UIColor.white
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }

}
