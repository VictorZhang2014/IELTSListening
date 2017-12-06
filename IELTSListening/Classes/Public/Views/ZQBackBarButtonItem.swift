//
//  ZQBackBarButtonItem.swift
//  IELTSListening
//
//  Created by Victor Zhang on 04/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

public class ZQBackBarButtonItem: UIButton {

    private var title: UILabel?
    
    init(target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        let frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        super.init(frame: frame)
        
        let arrow = UIImageView(frame: CGRect(x: -5, y: 4, width: 14, height: 22))
        arrow.image = UIImage(named: "back_bar_normal")
        self.addSubview(arrow)
        
        let tW: CGFloat = 21
        let tY: CGFloat = (frame.size.height - tW) / 2 - 1
        title = UILabel(frame: CGRect(x: 12, y: tY, width: 38, height: tW))
        title!.text = "返回"
        title!.textColor = UIColor.white
        title!.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(title!)
        
        self.addTarget(target, action: action, for: controlEvents)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("ZQBackBarButtonItem init(coder:) has not been implemented")
    }
    
    public func showBackText(isShow: Bool) {
        title?.isHidden = !isShow
    }
    
}
