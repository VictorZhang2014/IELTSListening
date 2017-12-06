//
//  ZQPlayerCoverView.swift
//  IELTSListening
//
//  Created by Victor Zhang on 05/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

@objc public protocol ZQPlayerCoverViewDelegate : NSObjectProtocol {
    //@objc func backToLastVC()
    @objc func videoPlayerPlayOrPause()
    @objc func maximizeVideoPlayer()
}

public class ZQPlayerCoverView: UIView {
    
    public weak var playerCoverViewDelegate: ZQPlayerCoverViewDelegate?

    private var playerCoverOriginalFrame: CGRect = CGRect()        //播放层原始大小
    
    private var durationlab: UILabel?
    private var progress: UISlider?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerCoverOriginalFrame = frame
        
        /*
        // 返回按钮
        let backBtn = UIButton()
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.backgroundColor = UIColor.purple
        backBtn.setBackgroundImage(UIImage(named:"back_bar_normal"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(clickedBack), for: UIControlEvents.touchUpInside)
        self.addSubview(backBtn)
        let backmetrics: Dictionary = [ "margin": 20, "width": 20 ]
        let backview: Dictionary = [ "backBtn": backBtn ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(12)-[backBtn(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: backmetrics, views: backview))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(margin)-[backBtn(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: backmetrics, views: backview))
        */
        
        // 底部按钮的view
        let btmView = UIView()
        btmView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btmView)
        let btmViewHeight: CGFloat = 50
        let btmViewY: CGFloat = self.frame.size.height - btmViewHeight
        let metrics: Dictionary = [ "btmViewHeight": btmViewHeight, "btmViewY": btmViewY ]
        let views: Dictionary = [ "btmView": btmView ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[btmView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(btmViewY)-[btmView(==btmViewHeight)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // 播放与暂停
        let playBtn = UIButton()
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.setImage(UIImage(named: "zqvideoplayer_play"), for: .normal)
        playBtn.setImage(UIImage(named: "zqvideoplayer_pause"), for: .selected)
        playBtn.addTarget(self, action: #selector(clickedPlay(_:)), for: UIControlEvents.touchUpInside)
        btmView.addSubview(playBtn)
        
        // 当前时间:全部时长
        durationlab = UILabel()
        durationlab!.translatesAutoresizingMaskIntoConstraints = false
        durationlab!.textAlignment = .center
        durationlab!.font = UIFont.systemFont(ofSize: 10)
        durationlab!.text = "0:00:00/0:00:00"
        durationlab!.textColor = UIColor.white
        btmView.addSubview(durationlab!)
        
        // 进度条
        progress = UISlider()
        progress!.translatesAutoresizingMaskIntoConstraints = false
        progress!.value = 0.0
        progress!.minimumTrackTintColor = UIColor.red
        progress!.maximumTrackTintColor = UIColor.white
        progress!.setThumbImage(UIImage(named: "zq_audioplayer_slider_red_circle"), for: .normal)
        //progress.addTarget(self, action: #selector(slideChanged(_:)), for: .valueChanged)
        btmView.addSubview(progress!)
        
        // 视频最大化
        let maximumBtn = UIButton()
        maximumBtn.translatesAutoresizingMaskIntoConstraints = false
        maximumBtn.setImage(UIImage(named: "zqvideoplayer_full_screen"), for: UIControlState.normal)
        maximumBtn.addTarget(self, action: #selector(clickedVideoMaximum), for: UIControlEvents.touchUpInside)
        btmView.addSubview(maximumBtn)
        
        let marginBtm: CGFloat = 7
        let btnWidth: CGFloat = btmViewHeight - marginBtm
        let imetrics: Dictionary = [ "btnWidth": btnWidth, "marginBottom": marginBtm ]
        let iviews: Dictionary = [ "playBtn": playBtn, "durationlab": durationlab!, "progress": progress!, "maximumBtn" : maximumBtn ] as [String : Any]
        btmView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(3)-[playBtn(==btnWidth)]-(1)-[durationlab(==90)]-(4)-[progress]-(5)-[maximumBtn(==btnWidth)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: imetrics, views: iviews))
        btmView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[playBtn(==btnWidth)]-(marginBottom)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: imetrics, views: iviews))
        btmView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[durationlab(==btnWidth)]-(marginBottom)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: imetrics, views: iviews))
        btmView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[progress(==btnWidth)]-(marginBottom)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: imetrics, views: iviews))
        btmView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[maximumBtn(==btnWidth)]-(marginBottom)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: imetrics, views: iviews))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //最大化操作视图
    public func maximize() {
        
        //先移除所有的约束
        self.removeConstraints(self.constraints)
        
        return
        //然后重新布局
        let bounds = UIScreen.main.bounds
        let origFrame = playerCoverOriginalFrame
        
        //平移到整个视图的中间
        let y = (bounds.size.height - origFrame.size.height) / 2
        self.transform = CGAffineTransform(translationX: 0, y: y)
        
        //180度旋转
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 180 * 90))
        
        //改变播放操作层大小
        self.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        
        
        self.setNeedsLayout()
        UIApplication.shared.isStatusBarHidden = true
    }
    
    //最小化操作视图
    public func minimize() {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    public func updateValues(durationTxt: String, progressVal: Float) {
        durationlab?.text = durationTxt
        progress?.setValue(progressVal, animated: true)
    }
    
//    @objc func clickedBack() {
//        if (playerCoverViewDelegate?.responds(to: #selector(playerCoverViewDelegate?.backToLastVC)))! {
//            playerCoverViewDelegate?.backToLastVC()
//        }
//    }

    // 播放与暂停
    @objc func clickedPlay(_ button: UIButton) {
        if (playerCoverViewDelegate?.responds(to: #selector(playerCoverViewDelegate?.videoPlayerPlayOrPause)))! {
            if button.isSelected {
                button.isSelected = false
            } else {
                button.isSelected = true
            }
            playerCoverViewDelegate?.videoPlayerPlayOrPause()
        }
    }
    
    // 视频最大化
    @objc func clickedVideoMaximum() {
        if (playerCoverViewDelegate?.responds(to: #selector(playerCoverViewDelegate?.maximizeVideoPlayer)))! {
            playerCoverViewDelegate?.maximizeVideoPlayer()
        }
    }
    
}

