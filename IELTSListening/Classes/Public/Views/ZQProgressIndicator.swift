//
//  ZQProgressIndicator.swift
//  TOEIC
//
//  Created by Victor Zhang on 01/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

public class ZQProgressIndicator: UIView {
    
    private var uploadLabel: UILabel?
    
    init() {
        super.init(frame: UIScreen.main.bounds)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("ZQProgressIndicator init(coder:) has not been implemented")
    }
    
    public func showWithCaption(text: String) {
        self.createSubViews()
        self.uploadLabel?.text = text
    }
    
    public func dismiss() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    private func createSubViews()  {
        let bounds = UIScreen.main.bounds
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
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[rectangleView(==140)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: rectangleDic))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[rectangleView(==90)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: rectangleDic))
        self.addConstraint(NSLayoutConstraint(item: rectangleView, attribute: .centerX, relatedBy:.equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: rectangleView, attribute: .centerY, relatedBy:.equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        let uploadView = UILabel()
        uploadView.translatesAutoresizingMaskIntoConstraints = false
        uploadView.textAlignment = .center
        uploadView.backgroundColor = UIColor.clear
        uploadView.text = "Loading"
        uploadView.textColor = UIColor.white
        uploadView.font = UIFont.systemFont(ofSize: 11)
        self.addSubview(uploadView)
        self.uploadLabel = uploadView
        let uploadDic: [String : Any ] = [ "uploadView" : uploadView ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[uploadView(==125)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: uploadDic))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[uploadView(==22)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: uploadDic))
        self.addConstraint(NSLayoutConstraint(item: uploadView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: uploadView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 33.0))
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicator)
        indicator.startAnimating()
        let indicatorDic: [String : Any] = [ "indicator" : indicator ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[indicator(==60)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: indicatorDic))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[indicator(==60)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: indicatorDic))
        self.addConstraint(NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
    }
    
}
