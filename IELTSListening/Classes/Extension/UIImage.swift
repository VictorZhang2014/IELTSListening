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
    
    // MARK: 将文字和图片合成
    func combineTextInImage(text: String, textInRect: CGRect, withTextAttributes: [NSAttributedStringKey : Any]?) -> UIImage? {
        //绘制图片上下文
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        //将文字绘制到图片上指定的位置和大小
        text.draw(in: textInRect, withAttributes: withTextAttributes)

        let newimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newimage
    }
    
    // MARK: 根据颜色获取UIImage
    static func getImageByColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
    
    // MARK: 根据提供的UIImage的size来重绘大小，最后返回UIImage
    static func resizeImage(origImage: UIImage, imgFrameSize: CGSize, targetImgSize: CGSize) -> UIImage {
        //http://www.jikexueyuan.com/course/492.html  说：高度 / 宽度 = 等压缩后的高度和宽度 * 目标大小的宽度
        let newHeight = imgFrameSize.height / imgFrameSize.width * targetImgSize.width
        
        //不管UIImageView的frame.size比目标的size大，还是平等，还是小，它们计算时，都是先计算出（宽和高的比例），然后再做乘法即可
//        let newHeight: CGFloat = imgFrameSize.width / targetImgSize.width
        
        let tarWidth: CGFloat = targetImgSize.width * newHeight
        let tarHeight: CGFloat = targetImgSize.height * newHeight
        let tarImage = origImage.resizeImage(size: CGSize(width: tarWidth, height: tarHeight))
        return tarImage
    }
    
    // MARK: 根据CGSize重绘图片
    func resizeImage(size reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
}


