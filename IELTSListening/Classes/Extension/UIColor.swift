//
//  UIColor.swift
//  IELTSListening
//
//  Created by Victor Zhang on 04/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

extension UIColor {
    
    public static var defaultLightGray: UIColor {
        get {
            return getColorByRed(242, green: 242, blue: 242)
        }
    }
    
    public static var lightBlue: UIColor {
        get {
            return getColorByRed(69, green: 182, blue: 251)
        }
    }
    
    public static var lightRed: UIColor {
        get {
            return getColorByRed(224, green: 44, blue: 107)
        }
    }
    
    public static func getColorByRed(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    // MARK: 根据十六进制字符串获取颜色
    public static func colorWithHexString(hexString: String) -> UIColor {
    
        var trimmStr = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmStr.characters.count < 6 {
            return UIColor.black
        }
        
        let redStr: String = String(trimmStr[String.Index.init(encodedOffset: 0)..<String.Index.init(encodedOffset: 2)])
        let greenStr: String = String(trimmStr[String.Index.init(encodedOffset: 3)..<String.Index.init(encodedOffset: 4)])
        let blueStr: String = String(trimmStr[String.Index.init(encodedOffset: 5)..<String.Index.init(encodedOffset: 6)])
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: redStr).scanHexInt32(&r)
        Scanner(string: greenStr).scanHexInt32(&g)
        Scanner(string: blueStr).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1.0))
    }
    
    // MARK: 获取渐变色的Layer层
    public static func getGradientRampLayer(viewBounds: CGRect, colors: [String]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = viewBounds
        var _tmpColors = Array<CGColor>()
        for color in colors {
            _tmpColors.append(UIColor.colorWithHexString(hexString: color).cgColor)
        }
        gradient.colors = _tmpColors
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        //gradient.drawsAsynchronously = true
        return gradient
    }
    
}
