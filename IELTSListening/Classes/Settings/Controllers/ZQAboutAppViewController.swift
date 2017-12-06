//
//  ZQAboutAppViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 05/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class ZQAboutAppViewController: ZQViewController {

    public var titleStr: String?
    
    override func viewDidLoad() {
        self.showCornerRadius = false
        super.viewDidLoad()
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = titleStr!
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
        
        let logoW: CGFloat = 100
        let logoY: CGFloat = 90
        let logoImg = UIImageView()
        logoImg.translatesAutoresizingMaskIntoConstraints = false
        logoImg.image = UIImage(named: "Icon")
        logoImg.layer.cornerRadius = 8
        logoImg.layer.masksToBounds = true
        logoImg.layer.borderWidth = 1
        logoImg.layer.borderColor = UIColor.gray.cgColor
        self.addSubview(logoImg)
        
        let versionLabX: CGFloat = 20
        let versionLabHeight: CGFloat = 25
        let versionLab = UILabel()
        versionLab.translatesAutoresizingMaskIntoConstraints = false
        versionLab.text = "当前版本 1.0.1"
        versionLab.textColor = UIColor.gray
        versionLab.textAlignment = .center
        versionLab.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(versionLab)
        
        let logoViews = [ "logoImg" : logoImg, "versionLab" : versionLab ]
        let logoMetrics = [ "logoW" : logoW, "logoY" : logoY, "versionLabHeight" : versionLabHeight, "versionLabX" : versionLabX ]
        self.backgroundView!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(versionLabX)-[versionLab]-(versionLabX)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: logoMetrics, views: logoViews))
        self.backgroundView!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[logoImg(==logoW)]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: logoMetrics, views: logoViews))
        self.backgroundView!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(logoY)-[logoImg(==logoW)]-(8)-[versionLab(==versionLabHeight)]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: logoMetrics, views: logoViews))
        self.backgroundView!.addConstraint(NSLayoutConstraint.init(item: self.backgroundView!, attribute: .centerX, relatedBy: NSLayoutRelation.equal, toItem: logoImg, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        
        let copyrightMargin: CGFloat = 20
        let copyrightLab = UILabel()
        copyrightLab.translatesAutoresizingMaskIntoConstraints = false
        copyrightLab.text = "All Copyright  © 2017 - Victor Studio. "
        copyrightLab.textColor = UIColor.gray
        copyrightLab.font = UIFont.systemFont(ofSize: 11)
        copyrightLab.textAlignment = .center
        self.addSubview(copyrightLab)
        
        let copyViews = [ "copyrightLab" : copyrightLab ]
        let copyMetrics = [ "copyrightMargin" : copyrightMargin ]
        self.backgroundView!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(copyrightMargin)-[copyrightLab]-(copyrightMargin)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: copyMetrics, views: copyViews))
        self.backgroundView!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[copyrightLab(==21)]-(copyrightMargin)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: copyMetrics, views: copyViews))
        
    }

}
