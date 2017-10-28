//
//  ZQLanguageSwitchViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 09/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class ZQLanguageSwitchViewController: ZQViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleLabel()

        // Do any additional setup after loading the view.
    }

    func setTitleLabel() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = "语言切换"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
    }

}
