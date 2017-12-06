//
//  UIView.swift
//  IELTSListening
//
//  Created by Victor Zhang on 09/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: 指定UIView的某几个角圆角
    func cornerRadiiWith(isTopLeft: Bool = false, isTopRight: Bool = false, isBottomLeft: Bool = false, isBottomRight: Bool = false, viewBounds: CGRect, cornerRadius: CGFloat) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = viewBounds
        var rectCorner = UIRectCorner()
        if isTopLeft {
            rectCorner.insert(.topLeft)
        }
        if isTopRight {
            rectCorner.insert(.topRight)
        }
        if isBottomLeft {
            rectCorner.insert(.bottomLeft)
        }
        if isBottomRight {
            rectCorner.insert(.bottomRight)
        }
        shapeLayer.path = UIBezierPath(roundedRect: viewBounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        self.layer.mask = shapeLayer
    }
}
