//
//  ZQAboutAppViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 05/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class ZQAboutAppViewController: ZQViewController {
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.defaultLightGray
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = "关于 - 雅思精听"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
        
        let frame = self.view.frame
        
        let logoW: CGFloat = 100
        let logoH: CGFloat = logoW
        let logoX: CGFloat = (frame.size.width - logoW) / 2
        let logoY: CGFloat = 90
        let logoImg = UIImageView(frame: CGRect(x: logoX, y: logoY, width: logoW, height: logoH))
        logoImg.image = UIImage(named: "Icon")
        logoImg.layer.cornerRadius = 8
        logoImg.layer.masksToBounds = true
        logoImg.layer.borderWidth = 1
        logoImg.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(logoImg)
        
        let vW: CGFloat = 100
        let vH: CGFloat = 25
        let vX: CGFloat = (frame.size.width - vW) / 2
        let vY: CGFloat = logoH + logoY
        let versionLab = UILabel(frame: CGRect(x: vX, y: vY, width: vW, height: vH))
        versionLab.text = "当前版本 1.0"
        versionLab.textColor = UIColor.gray
        versionLab.textAlignment = .center
        versionLab.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(versionLab)
        
        let cX: CGFloat = 20
        let cW: CGFloat = frame.size.width - cX * 2
        let cH: CGFloat = 21
        let cY: CGFloat = frame.size.height - cH - 64
        let copyrightLab = UILabel(frame: CGRect(x: cX, y: cY, width: cW, height: cH))
        copyrightLab.text = "All Copyright , Victor Studio has.    © 2017"
        copyrightLab.textColor = UIColor.gray
        copyrightLab.font = UIFont.systemFont(ofSize: 11)
        copyrightLab.textAlignment = .center
        self.view.addSubview(copyrightLab)
        
    }

}
