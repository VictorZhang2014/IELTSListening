//
//  ZQLiveVideoPlayerViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 2017/12/4.
//  Copyright © 2017年 Victor Studio. All rights reserved.
//  直播控制器

import UIKit
import AVFoundation

class ZQLiveVideoPlayerViewController: ZQViewController {

    private var videoPlayer: AVPlayer?               //视频播放基础对象
    private var videoPlayerLayer: AVPlayerLayer?     //视频播放显示层
    private var urlStr: String?

    //直播的userId
    public var hostUserId: String?
    //获取的用户模型数据
    private var userInfoModel: ZQLiveMeVideoHostInfoModel?
    
    //数据加载提示层
    private var loadingView: ZQLoadingBackgroundView?
    
    private let colorsArray: Array<UIColor> = [ UIColor.brown, UIColor.black, UIColor.green, UIColor.blue, UIColor.orange, UIColor.red, UIColor.purple, UIColor.cyan ]
    
    
    init(url: String) {
        urlStr = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.showNaviAnimation = false
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.defaultLightGray
        
        setLoadinView()
        loadHostInfo()
        setPlayer()
    }
    
    // MARK: 添加标签
    func addTags() {
        var subviewY: CGFloat = 0

        for index in 1...5 {
            subviewY = CGFloat((15 + 2) * index + 20)
            let implabel = UILabel(frame: CGRect(x: 0, y: subviewY, width: 50, height: 15))
            let tempIndex = Int(arc4random()%7)+1
            implabel.backgroundColor = colorsArray[tempIndex]
            implabel.textColor = UIColor.white
            implabel.alpha = 0.5
            implabel.layer.cornerRadius = 5
            implabel.layer.masksToBounds = true
            implabel.font = UIFont.systemFont(ofSize: 10)
            implabel.textAlignment = .center
            
            switch index {
            case 1:
                implabel.text = "关注我的：\(String(format: (userInfoModel?.count_info?.follower_count)!))"
                break
            case 2:
                implabel.text = "我关注的：\(String(format: (userInfoModel?.count_info?.following_count)!))"
                break
            case 3:
                implabel.text = "朋友：\(String(format: (userInfoModel?.count_info?.friends_count)!))"
                break
            case 4:
                implabel.text = "直播：\(String(format: (userInfoModel?.count_info?.live_count)!))"
                break
            case 5:
                implabel.text = "视频：\(String(format: (userInfoModel?.count_info?.video_count)!))"
                break
            default:
                break
            }
            
            implabel.layer.masksToBounds = true
            videoPlayerLayer?.addSublayer(implabel.layer)
        }
    }
    
    func alert(withMessage: String) {
        let alert = UIAlertController(title: nil, message: withMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "好吧", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setLoadinView() {
        var rect = self.view.frame
        rect.origin.x = 0
        rect.origin.y = 0
        loadingView = ZQLoadingBackgroundView(frame: rect)
        self.view.addSubview(loadingView!)
    }
    
    
    // MARK: 加载主播信息
    func loadHostInfo() {
        loadingView?.show()
        ZQLiveDataDownload().downloadLiveHostInfo(userId: hostUserId!) { (userModel, errorMessage) in
            self.loadingView?.hide()
            
            if let model = userModel {
                self.userInfoModel = model
                //self.addTags()
            } else {
                self.alert(withMessage: errorMessage!)
            }
        }
    }
    
    // MARK: 设置播放器
    func setPlayer() {
        var playerItem: AVPlayerItem? = nil
        if (urlStr?.hasPrefix("http://"))! || (urlStr?.hasPrefix("https://"))! {
            playerItem = AVPlayerItem(url: URL(string: urlStr!)!)
        } else {
            playerItem = AVPlayerItem(url: URL(fileURLWithPath: urlStr!))
        }
        videoPlayer = AVPlayer(playerItem: playerItem)
        videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
        videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
        
        let screenBounds = UIScreen.main.bounds
        let width: CGFloat = screenBounds.size.width
        let height: CGFloat = screenBounds.size.height
        videoPlayerLayer!.frame = CGRect(x: 0, y: 0, width: width, height: height)
        //playerLayer.contentsScale = UIScreen.main.scale
        videoPlayerLayer?.backgroundColor = UIColor.black.cgColor
        self.view.layer.addSublayer(videoPlayerLayer!)
        
        //视频配置完毕后，直接播放
        videoPlayer!.play()
    }
    
    deinit {
        self.videoPlayer?.pause()
        
        /*
         removeObservers()
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem)
         */
        print("ZQVideoPlayerViewController has been deallocated!")
    }

}
