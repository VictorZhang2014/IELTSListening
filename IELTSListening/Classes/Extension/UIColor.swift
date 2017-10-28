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
            return getColorByRed(239, green: 239, blue: 244)
        }
    }
    
    public static var lightBlue: UIColor {
        get {
            return getColorByRed(69, green: 182, blue: 251)
        }
    }
    
    public static func getColorByRed(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}
