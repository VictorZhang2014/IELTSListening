//
//  UIImage.swift
//  IELTSListening
//
//  Created by Victor Zhang on 04/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

extension UIImage {
    
    // MARK: 水平翻转图片
    static func flipHorizontal(named: String) -> UIImage  {
        let img = UIImage(named: named)
        let flipImageOrientation = ((img?.imageOrientation.rawValue)! + 4) % 8
        let tarImg = UIImage(cgImage: (img?.cgImage)!, scale: (img?.scale)!, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
        return tarImg
    }
    
    // MARK: 垂直翻转图片
    static func flipVertical(named: String) -> UIImage {
        let img = UIImage(named: named)
        var flipImageOrientation = ((img?.imageOrientation.rawValue)! + 4) % 8
        flipImageOrientation += flipImageOrientation % 2 == 0 ? 1 : -1
        let tarImg = UIImage(cgImage: (img?.cgImage)!, scale: (img?.scale)!, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
        return tarImg
    }
    
}
