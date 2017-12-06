//
//  ZQVideoPlayerViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 05/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//  根据视频地址直接播放

import UIKit
import AVFoundation

class ZQVideoPlayerViewController: ZQViewController /*, ZQPlayerCoverViewDelegate*/ {

    private var videoPlayer: AVPlayer?               //视频播放基础对象
    private var videoPlayerLayer: AVPlayerLayer?     //视频播放显示层
    private var videoPlayerLayerOriginalFrame: CGRect = CGRect() //视频播放显示层原始大小
    private var urlStr: String?
    
    private var playerCoverView: ZQPlayerCoverView?  //视频上操作按钮的view
    private var isPaused: Bool = true
    private var videoTotalDuration: Float64 = 0.0   //视频总长度 单位：秒
    private var videoBufferTotalDuration: Float64 = 0.0   //视频缓冲总长度 单位：秒
    
    private let VideoPlayerStatus: String = "status"
    private let VideoPlayerLoadedTimeRanges: String = "loadedTimeRanges"
    
    //是否是直播
    public var isLiveStreaming: Bool = false
    //直播的userId
    public var hostUserId: String?
    //获取的用户模型数据
    private var userInfoModel: ZQLiveMeVideoHostInfoModel?
    
    //数据加载提示层
    private var loadingView: ZQLoadingBackgroundView?
    
    
    
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
        setPlayer()
        
        /*
        if isLiveStreaming {
            addOperationViewsForLiveStreaming()
        } else {
            addOperateViews()
        }
         */
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
        var height: CGFloat = screenBounds.size.height / 3
        if isLiveStreaming {
            height = screenBounds.size.height
        }
        videoPlayerLayer!.frame = CGRect(x: 0, y: 0, width: width, height: height)
        //playerLayer.contentsScale = UIScreen.main.scale
        videoPlayerLayer?.backgroundColor = UIColor.black.cgColor
        self.view.layer.addSublayer(videoPlayerLayer!)
        videoPlayerLayerOriginalFrame = videoPlayerLayer!.frame
        
        /*
        observePlayerItems()
        addPlayerProgressObserver()
        NotificationCenter.default.addObserver(self, selector: #selector(playbackFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem)
         */
 
        //视频配置完毕后，直接播放
        videoPlayer!.play()
    }
    
    /*
    @objc func playbackFinished(_ notification: Notification) {
        print("视频播放完成.")
        self.videoPlayer?.currentItem?.seek(to: kCMTimeZero)
    }
    
    // MARK: 添加短视频界面上操作的视图
    func addOperateViews() {
        playerCoverView = ZQPlayerCoverView(frame: (videoPlayerLayer?.frame)!)
        playerCoverView!.playerCoverViewDelegate = self
        self.view.addSubview(playerCoverView!)
    }
    
    // MARK: 添加直播视频界面上的视图
    func addOperationViewsForLiveStreaming() {
        let hostInfoView = ZQLiveHostInfoView()
        self.view.addSubview(hostInfoView)
    }
    
    // MARK: ZQPlayerCoverViewDelegate的代理事件
    // 视频播放与暂停
    func videoPlayerPlayOrPause() {
        if isPaused {
            self.videoPlayer?.play()
            isPaused = false
        } else {
            self.videoPlayer?.pause()
            isPaused = true
        }
    }
    
    // 最大化视频
    func maximizeVideoPlayer() {
        
        let bounds = UIScreen.main.bounds
        let origFrame = videoPlayerLayerOriginalFrame
        
        //平移到整个视图的中间
        let y = (bounds.size.height - origFrame.size.height) / 2
        videoPlayerLayer?.transform = CATransform3DMakeTranslation(0, y, 0)
        
        //180度旋转
        var myTransform = videoPlayerLayer?.transform
        myTransform = CATransform3DRotate(myTransform!, CGFloat(Double.pi / 180 * 90), 0, 0, 1);
        videoPlayerLayer?.transform = myTransform!
        
        //改变视频播放层大小
        videoPlayerLayer?.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        
        //最大化播放层操作按钮的视图
        playerCoverView?.maximize()
    }
    
    func observePlayerItems() {
        self.videoPlayer?.currentItem?.addObserver(self, forKeyPath: VideoPlayerStatus, options: NSKeyValueObservingOptions.new, context: nil)
        self.videoPlayer?.currentItem?.addObserver(self, forKeyPath: VideoPlayerLoadedTimeRanges, options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func removeObservers() {
        self.videoPlayer?.currentItem?.removeObserver(self, forKeyPath: VideoPlayerStatus)
        self.videoPlayer?.currentItem?.removeObserver(self, forKeyPath: VideoPlayerLoadedTimeRanges)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let playerItem = object as! AVPlayerItem
        if keyPath == VideoPlayerStatus {
            let status = change![NSKeyValueChangeKey.newKey] as! Int
            if AVPlayerStatus(rawValue: status) == .readyToPlay {
                //print("视频总长度：\(CMTimeGetSeconds(playerItem.duration))")
                
                videoTotalDuration = CMTimeGetSeconds(playerItem.duration)
                let durationtext = "0:00:00/" + getDetailsTime(duration: videoTotalDuration)
                self.playerCoverView?.updateValues(durationTxt: durationtext, progressVal: 0.0)
            }
        } else {
            //视频缓冲完毕后，就不用在计算了
            if videoTotalDuration == videoBufferTotalDuration {
                return
            }
            if keyPath == VideoPlayerLoadedTimeRanges {
                let timeArray = playerItem.loadedTimeRanges
                let timeRange = timeArray.first as! CMTimeRange //本次缓冲时间
                let startSeconds = CMTimeGetSeconds(timeRange.start)
                let durationSeconds = CMTimeGetSeconds(timeRange.duration)
                let totalBuffer = startSeconds + durationSeconds //缓冲总长度
                //print("视频共缓冲：\(totalBuffer)")
                videoBufferTotalDuration += totalBuffer
            }
        }
    }
    
    // 给播放器添加进度更新
    func addPlayerProgressObserver() {
        self.videoPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(Int64(1.0), Int32(1.0)), queue: DispatchQueue.main, using: { [weak self] (time) in
            if self == nil {
                return
            }
            let total = CMTimeGetSeconds((self?.videoPlayer?.currentItem?.duration)!)
            let current = CMTimeGetSeconds(time)
            let ratio: Float = Float(current / total)
            //print("当前已经播放：\(current)s 播放比例：\(ratio)s.")
            
            if current > 0 && !(total.isNaN) {
                //更新进度条UI
                
                let durationText = (self?.getDetailsTime(duration: current))! + "/" + (self?.getDetailsTime(duration: total))!
                self?.playerCoverView?.updateValues(durationTxt: durationText, progressVal: ratio)
            }
        })
    }
    
    // MARK: 根据秒数，获取 时:分:秒
    func getDetailsTime(duration: Float64) -> String {
        let standardNum: Float64 = 60.0
        var standardHourNum: Float64 = standardNum
        
        var totalHour = 0
        var totalMinute = 0
        var totalSeconds = 0
        
        //如果超过了一小时
        if duration > (60 * 60) {
            standardHourNum = standardNum * standardNum
            
            totalHour = Int(duration / standardHourNum)
            totalMinute = Int(duration.truncatingRemainder(dividingBy: standardHourNum) / 60)
            totalSeconds = Int(duration.truncatingRemainder(dividingBy: standardHourNum).truncatingRemainder(dividingBy: 60))
        } else if duration > 60 {  //如果超过了一分钟
            totalMinute = Int(duration / 60)
            totalSeconds = Int(duration.truncatingRemainder(dividingBy: 60))
        } else {    //在一分钟之内
            if !(duration.isNaN) {
                totalSeconds = Int(duration)
            }
        }

        let durationTxt = String(format:"%.01d:%.02d:%.02d", totalHour, totalMinute, totalSeconds)
        return durationTxt
    }
    */
    
    deinit {
        self.videoPlayer?.pause()
        
        /*
        removeObservers()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem)
        */
        print("ZQVideoPlayerViewController has been deallocated!")
    }
}
