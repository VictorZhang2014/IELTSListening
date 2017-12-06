//
//  ZQViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 06/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//  所有UIViewController的基类

import UIKit

public class ZQViewController: UIViewController, CAAnimationDelegate {
    
    //背景视图
    public var backgroundView: UIView?
    
    //默认展示导航栏动画
    public var showNaviAnimation: Bool = true
    //默认背景view是有圆角的
    public var showCornerRadius: Bool = true
    
    //渐变层对象
    private var gradientLayer: CAGradientLayer?
    //渐变颜色数组
    private var animatableColors = [[CGColor]]()
    private var gradientAnimation: CABasicAnimation?
    
    public var viewframe: CGRect {
        get {
            return self.backgroundView!.frame
        }
    }
    

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.defaultLightGray

        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        app.isStatusBarHidden = false
        
        if showNaviAnimation {
            animationNavigationBar()
            addBackgroundView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func appDidBecomeActive() {
        toggleBasicAnimation()
    }
    
    // MARK: 动画导航栏
    func animationNavigationBar() {
        var frame = UIScreen.main.bounds
        frame.size.height = 74
        let bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        //顶部的背景视图
        let navView = UIView(frame: frame)
        gradientLayer = UIColor.getGradientRampLayer(viewBounds: bounds, colors: [ "f83fdc", "b53ff8"])
        navView.layer.addSublayer(gradientLayer!)
        self.view.addSubview(navView)
        
        //顶部的背景视图的动画
        gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation!.duration = 5.0
        gradientAnimation!.fillMode = kCAFillModeForwards;
        gradientAnimation!.isRemovedOnCompletion = false
        gradientAnimation!.delegate = self
        
        //颜色组
        animatableColors.append([ UIColor.red.cgColor, UIColor.orange.cgColor])
        animatableColors.append([ UIColor.orange.cgColor, UIColor.yellow.cgColor])
        animatableColors.append([ UIColor.yellow.cgColor, UIColor.green.cgColor])
        animatableColors.append([ UIColor.green.cgColor, UIColor.cyan.cgColor])
        animatableColors.append([ UIColor.cyan.cgColor, UIColor.blue.cgColor])
        animatableColors.append([ UIColor.blue.cgColor, UIColor.purple.cgColor])
        animatableColors.append([ UIColor.purple.cgColor, UIColor.red.cgColor])
        
        //开始动画
        toggleBasicAnimation()
    }
    
    func toggleBasicAnimation() {
        let randNum = Int(arc4random() % 7)
        gradientAnimation!.toValue = animatableColors[randNum]
        gradientLayer!.add(gradientAnimation!, forKey: "colorChange")
        print("当前渐变颜色索引：\(randNum)")
    }
    
    // MARK: CAAnimationDelegate
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            toggleBasicAnimation()
        }
    }
    
    // MARK: 添加一个背景视图
    private func addBackgroundView() {
        var frame = UIScreen.main.bounds
        frame.origin.y = 64
        frame.origin.x = 0
        frame.size.height = frame.size.height - frame.origin.y //- 44
        
        backgroundView = UIView(frame: frame)
        backgroundView!.backgroundColor = UIColor.defaultLightGray
        if showCornerRadius {
            backgroundView!.layer.cornerRadius = 12
        }
        self.view.addSubview(backgroundView!)
    }
    
    // MARK: 添加子视图
    public func addSubview(_ subview: UIView) {
        //由上面的半圆角，需要减去
        var subviewFrame = subview.frame
        subviewFrame.origin.y = 6
        subviewFrame.size.height -= subviewFrame.origin.y
        subview.frame = subviewFrame
        
        backgroundView!.addSubview(subview)
    }
    
    //模糊背景 暂时先不需要用
    public func blurBackgroundImgView() {
        let frame = self.viewframe
        let bgBlurImg = UIImageView(frame: frame)
        bgBlurImg.image = UIImage(named: "ielts12academicbookBlur")
        self.addSubview(bgBlurImg)
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bgBlurImg.frame
        self.addSubview(blurView)
    }
    
}
