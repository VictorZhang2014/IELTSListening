//
//  ZQViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 06/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class ZQViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.defaultLightGray

        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        app.isStatusBarHidden = false
    }

}
