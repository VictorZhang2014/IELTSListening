//
//  ZQLoadingBackgroundView.swift
//  IELTSListening
//
//  Created by Victor Zhang on 19/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//  背景加载视图

import UIKit

public class ZQLoadingBackgroundView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgTranslucentView = UIView(frame: frame)
        bgTranslucentView.backgroundColor = UIColor.black
        bgTranslucentView.alpha = 0.1
        self.addSubview(bgTranslucentView)
        
        let bgViewWidth: CGFloat = 120
        let bgViewHeight: CGFloat = 90
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor.clear
        self.addSubview(bgView)
        
        let bgAlphaView = UIView()
        bgAlphaView.translatesAutoresizingMaskIntoConstraints = false
        bgAlphaView.backgroundColor = UIColor.black
        bgAlphaView.alpha = 0.5
        bgAlphaView.layer.cornerRadius = 6
        bgView.addSubview(bgAlphaView)
        
        let activityIndicatorHeight: CGFloat = bgViewHeight / 5 * 3 - 5
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        bgView.addSubview(activityIndicator)
        
        let loadingTipHeight: CGFloat = bgViewHeight / 5 * 2 - 5
        let loadingTip = UILabel()
        loadingTip.translatesAutoresizingMaskIntoConstraints = false
        loadingTip.text = "玩儿命加载中..."
        loadingTip.textColor = UIColor.white
        loadingTip.font = UIFont.systemFont(ofSize: 13)
        loadingTip.textAlignment = .center
        bgView.addSubview(loadingTip)
        
        let views = [ "bgView" : bgView, "activityIndicator" : activityIndicator, "loadingTip" : loadingTip, "bgAlphaView" : bgAlphaView ]
        let metrics = [ "bgViewWidth" : bgViewWidth, "bgViewHeight" : bgViewHeight, "activityIndicatorHeight" : activityIndicatorHeight, "loadingTipHeight" : loadingTipHeight ]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[bgView(==bgViewWidth)]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bgView(==bgViewHeight)]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: bgView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: bgView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
        
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bgAlphaView]-(0)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[bgAlphaView]-(0)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[activityIndicator]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[activityIndicator(==activityIndicatorHeight)][loadingTip(==loadingTipHeight)]-(5)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        bgView.addConstraint(NSLayoutConstraint.init(item: bgView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: activityIndicator, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
        bgView.addConstraint(NSLayoutConstraint.init(item: bgView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: loadingTip, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("ZQLoadingBackgroundView init(coder:) has not been implemented")
    }
    
    public func show() {
        self.isHidden = false
    }
    
    public func hide() {
        self.isHidden = true
    }

}
