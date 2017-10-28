//
//  ZQCircleProgress.swift
//  TOEIC
//
//  Created by Victor Zhang on 01/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//  圆形进度条

import UIKit

class ZQProgressView: UIView {
    
    private var spLayer: CAShapeLayer?
    private var progress: CGFloat = 0
    private var progressNum: UILabel?
    private var uploadLabel: UILabel?
    
    init() {
        let bounds = UIScreen.main.bounds
        super.init(frame: bounds)
        
        self.frame = bounds
        self.backgroundColor = UIColor.clear
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.2
        self.addSubview(backgroundView)
        let bgDic: [String : Any] = [ "backgroundView" : backgroundView ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[backgroundView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bgDic))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[backgroundView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bgDic))
        
        let rectangleView = UIView()
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        rectangleView.backgroundColor = UIColor.black
        rectangleView.alpha = 0.7
        rectangleView.layer.cornerRadius = 10
        self.addSubview(rectangleView)
        let rectangleDic: [String : Any] = [ "rectangleView" : rectangleView ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[rectangleView(==100)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: rectangleDic))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[rectangleView(==90)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: rectangleDic))
        self.addConstraint(NSLayoutConstraint(item: rectangleView, attribute: .centerX, relatedBy:.equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: rectangleView, attribute: .centerY, relatedBy:.equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        let uploadView = UILabel()
        uploadView.translatesAutoresizingMaskIntoConstraints = false
        uploadView.textAlignment = .center
        uploadView.backgroundColor = UIColor.clear
        uploadView.text = "Wait Please"
        uploadView.textColor = UIColor.white
        uploadView.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(uploadView)
        self.uploadLabel = uploadView
        let uploadDic: [String : Any ] = [ "uploadView" : uploadView ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[uploadView(==100)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: uploadDic))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[uploadView(==22)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: uploadDic))
        self.addConstraint(NSLayoutConstraint(item: uploadView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: uploadView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 33.0))
        
        let uploadLabNum = UILabel()
        uploadLabNum.translatesAutoresizingMaskIntoConstraints = false
        uploadLabNum.textAlignment = .center
        uploadLabNum.backgroundColor = UIColor.clear
        uploadLabNum.text = "0%"
        uploadLabNum.textColor = UIColor.white
        uploadLabNum.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(uploadLabNum)
        self.progressNum = uploadLabNum
        let uploadNumDic: [String : Any] = [ "uploadLabNum" : uploadLabNum ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[uploadLabNum(==60)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: uploadNumDic))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[uploadLabNum(==60)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: uploadNumDic))
        self.addConstraint(NSLayoutConstraint(item: uploadLabNum, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: uploadLabNum, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        
        self.alpha = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ZQProgressView init(coder:) has not been implemented")
    }
    
    // MARK: 设置提示文字
    func setHintText(text: String) {
        self.uploadLabel?.text = text
    }
    
    // MARK: 设置进度条的进度
    func processing(progressNumber: CGFloat) {
        if self.alpha == 0.0 {
            self.alpha = 1.0
        }
        
        self.progress = progressNumber
        self.setNeedsDisplay()
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    override func draw(_ rect: CGRect) {
        let circleWidth: CGFloat = 45
        let circleRect = CGRect(x: 0, y: 0, width: circleWidth, height: circleWidth)
        
        let center: CGPoint = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        let circleBezier = UIBezierPath(ovalIn: circleRect)
        
        if self.progress == 0.0 {
            self.spLayer?.removeFromSuperlayer()
            self.spLayer = nil
        } else {
            if self.spLayer == nil {
                self.spLayer = CAShapeLayer()
                self.layer.addSublayer(self.spLayer!)
                
                self.spLayer?.frame = circleRect;
                self.spLayer?.position = center;
                self.spLayer?.strokeStart = 0.0;//路径开始位置
                self.spLayer?.fillColor = UIColor.clear.cgColor;//填充颜色
                self.spLayer?.strokeColor = UIColor.white.cgColor;//绘制线条颜色
                self.spLayer?.lineWidth = 2.0;
                self.spLayer?.lineCap = kCALineCapRound;
                self.spLayer?.path = circleBezier.cgPath;
            }
            
            if !self.progress.isNaN {
                self.spLayer?.strokeEnd = self.progress / 100;//路径结束位置
                
                //百分比
                self.progressNum?.text = "\(String(format: "%.2f", self.progress))%"
            }
        }
    }
    
    deinit {
        
    }
    
}

