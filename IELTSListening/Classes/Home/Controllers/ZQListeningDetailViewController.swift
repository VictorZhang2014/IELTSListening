//
//  ZQListeningDetailViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation
import MediaPlayer

class ZQListeningDetailViewController: ZQViewController, ZQAudioPlayerViewDelegate {
    
    //音频播放器
    private var audioPlayerView: ZQAudioPlayerView?
    
    private var ieltsIndex: Int = 0  // 范围 11-12
    private var listeningFileName: String?
    
    private var playerAnimation: CABasicAnimation?
    private var blackCircleDisc: UIImageView?
    
    //从后台播放恢复到前台
    private var playingRecoveryFromBackground: Bool = false

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(index: Int, fileName: String) {
        super.init(nibName: nil, bundle: nil)
        ieltsIndex = index
        listeningFileName = fileName
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("ZQListeningDetailsViewController init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleLabel()
        blurBackgroundImgView(frame: self.view.frame)
        playDisc()
        layoutAudioPlayer()
 
        let notiCenter = NotificationCenter.default
        notiCenter.addObserver(self, selector: #selector(didBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        notiCenter.addObserver(self, selector: #selector(willResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notiCenter.addObserver(self, selector: #selector(audioSessionIsInterrupted), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        notiCenter.addObserver(self, selector: #selector(playerItemDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        notiCenter.addObserver(self, selector: #selector(didReceiveRemoteControlEventPlay), name: NSNotification.Name.kUIEventSubtypeRemoteControlPlay, object: nil)
        notiCenter.addObserver(self, selector: #selector(didReceiveRemoteControlEventPause), name: NSNotification.Name.kUIEventSubtypeRemoteControlPause, object: nil)
        notiCenter.addObserver(self, selector: #selector(didReceiveRemoteControlEventPreviousTrack), name: NSNotification.Name.kUIEventSubtypeRemoteControlPreviousTrack, object: nil)
        notiCenter.addObserver(self, selector: #selector(didReceiveRemoteControlEventNextTrack), name: NSNotification.Name.kUIEventSubtypeRemoteControlNextTrack, object: nil)
   
    }

    // MARK: 应用从后台恢复到前台
    @objc func didBecomeActive() {
        //结束后台处理多媒体事件
        UIApplication.shared.endReceivingRemoteControlEvents()
        
        if self.audioPlayerView?.audioPlayerStatus == .playing {
            if self.playingRecoveryFromBackground {
                self.startAnimation()
            }
            self.playingRecoveryFromBackground = false
        } else if self.audioPlayerView?.audioPlayerStatus == .paused {
            self.audioPlayerView?.pause()
            self.playingRecoveryFromBackground = false
        }
    }
    
    // MARK: 应用从前台切换到后台
    @objc func willResignActive() {
        //暂停中间的播放盘动画
        self.disposeAnimation()
        
        //开始后台处理多媒体事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        DispatchQueue.global().async {
            do {
                //设置可以在后台播放
                let audioSession = AVAudioSession.sharedInstance();
                try audioSession.setActive(true)
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                print("\(error)")
                DispatchQueue.main.async {
                    self.disposeAnimation()
                    self.audioPlayerView?.pause()
                }
            }
            
            self.playingRecoveryFromBackground = true
            
            self.setNowPlayingInInfoCenter()
        }
    }
    
    // MARK: 后台音乐被打断，比如：电话，闹铃等
    @objc func audioSessionIsInterrupted() {
        if self.audioPlayerView?.audioPlayerStatus == .playing {
            self.audioPlayerView?.pause()
        }
    }
    
    // MARK: 该音频播放完毕
    @objc func playerItemDidEnd() {
        self.disposeAnimation()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // MARK: 接收远程控制 播放
    @objc func didReceiveRemoteControlEventPlay() {
        if self.audioPlayerView?.audioPlayerStatus == .paused {
            self.audioPlayerView?.play()
        }
    }
    
    // MARK: 接收远程控制 暂停
    @objc func didReceiveRemoteControlEventPause() {
        if self.audioPlayerView?.audioPlayerStatus == .playing {
            self.audioPlayerView?.pause()
        }
    }
    
    // MARK: 接收远程控制 后退
    @objc func didReceiveRemoteControlEventPreviousTrack() {
        self.audioPlayerView?.clickedBackward()
    }
    
    // MARK: 接收远程控制 快进
    @objc func didReceiveRemoteControlEventNextTrack() {
        self.audioPlayerView?.clickedForward()
    }
    
    // MARK: 设置当前控制器的title
    func setTitleLabel() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = "\(listeningFileName!)"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ZQBackBarButtonItem(target: self, action: #selector(getBack), for: .touchUpInside))
    }
    
    @objc func getBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //模糊背景
    func blurBackgroundImgView(frame: CGRect) {
        let bgBlurImg = UIImageView(frame: frame)
        let randNum = Int(arc4random()%7)+1
        bgBlurImg.image = UIImage(named: "zq_audioplayer_background_\(randNum)")
        self.view.addSubview(bgBlurImg)
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bgBlurImg.frame
        self.view.addSubview(blurView)
    }
    
    func getRealViewFrame() -> CGRect {
        let topMargin: CGFloat = 64
        var vframe = self.view.frame
        vframe.size.height -= topMargin
        return vframe
    }
    
    // MARK: 播放盘
    func playDisc()  {
        let vframe = getRealViewFrame()
        
        //播放盘
        let discX: CGFloat = 50
        let discW: CGFloat = vframe.size.width - discX * 2
        let discH: CGFloat = discW
        let discY: CGFloat = (vframe.size.height - discH) / 2 - 64
        blackCircleDisc = UIImageView(frame: CGRect(x: discX, y: discY, width: discW, height: discH))
        blackCircleDisc!.image = UIImage(named: "zq_audioplayer_black_player_disc")
        self.view.addSubview(blackCircleDisc!)
        
        let contentW: CGFloat = discW * 0.5
        let contentH: CGFloat = contentW
        let contentX: CGFloat = (discW - contentW) / 2
        let contentY: CGFloat = contentX
        let content = UILabel(frame: CGRect(x: contentX, y: contentY, width: contentW, height: contentH))
        if ieltsIndex == 12 {
            let names = listeningFileName?.components(separatedBy: " ")
            content.text = (names?[(names?.count)! - 2])! + " " + (names?.last)!
        } else {
            let names = listeningFileName?.components(separatedBy: "_")
            content.text = names?.last
        }
        content.textColor = UIColor.white
        content.font = UIFont.boldSystemFont(ofSize: 19)
        content.textAlignment = .center
        blackCircleDisc!.addSubview(content)
        
        //播放盘针
//        let needleW: CGFloat = 80
//        let needleX: CGFloat = (self.view.frame.size.width - needleW) / 2 +  (needleW * 0.3)
//        var needleY: CGFloat = -22
//        if NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_9_0 {
//            needleY = 42
//        }
//        let needleH: CGFloat = discY
//        let needleDisc = UIImageView(frame: CGRect(x: needleX, y: needleY, width: needleW, height: needleH))
//        needleDisc.image = UIImage(named: "zq_audioplayer_play_needle")
//        self.view.addSubview(needleDisc)
        
//        needleDisc.layer.center = CGPoint(x: 0.5, y: 0)
        

    }

    func startAnimation() {
        disposeAnimation()
        playerAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        playerAnimation!.fromValue = 0
        playerAnimation!.toValue = Double.pi * 2
        playerAnimation!.duration = 10
        playerAnimation!.autoreverses = false
        playerAnimation!.fillMode = kCAFillModeForwards
        playerAnimation!.repeatCount = MAXFLOAT
        blackCircleDisc?.layer.add(playerAnimation!, forKey: nil)
    }
    
    func disposeAnimation() {
        blackCircleDisc?.layer.removeAllAnimations()
        playerAnimation = nil
    }
    
    // MARK: ZQAudioPlayerViewDelegate
    func audioPlayerisPlaying(player: AVAudioPlayer) {
        startAnimation()
    }
    
    func audioPlayerisPlayingWithProgress(player: AVAudioPlayer, progress: Double) {
        updateNowPlayingInfoCenter(progress: progress)
    }
    
    func audioPlayerPaused(player: AVAudioPlayer) {
        disposeAnimation()
    }
    
    func audioPlayerStopped(player: AVAudioPlayer) {
        disposeAnimation()
    }

    func layoutAudioPlayer() {
        let vframe = self.getRealViewFrame()
        self.audioPlayerView = ZQAudioPlayerView(frame: vframe)
        
        self.audioPlayerView?.audioPlayerDelegate = self
        self.view.addSubview(self.audioPlayerView!)
        self.audioPlayerView?.playAudio(audioPath: getAudioFilepath(), parentController: self)
    }
    
    func getAudioFilepath() -> String {
        var audioFile = NSHomeDirectory() + "/Documents/res/audio/"
        if ieltsIndex == 12 {
            audioFile += "IELTS12/" + listeningFileName! + ".mp3"
        } else if ieltsIndex == 11 {
            audioFile += "IELTS11/" + listeningFileName! + ".mp3"
        }
        return audioFile
    }
    
    // MARK: 锁屏时，在中间显示音频信息
    func setNowPlayingInInfoCenter() {
        let randNum = Int(arc4random()%7)+1
        let mediaArtwork = MPMediaItemArtwork(image: UIImage(named: "zq_audioplayer_background_\(randNum)")!)
        let totalDuration: Double = (self.audioPlayerView?.totolTimeDuration)!
        
        let songInfo: Dictionary<String, Any> = [
            MPMediaItemPropertyTitle : "雅思听力 - \(listeningFileName!)",
            MPMediaItemPropertyArtist : "剑桥大学出版社",
            MPMediaItemPropertyPlaybackDuration : totalDuration,
            MPMediaItemPropertyArtwork : mediaArtwork
        ]
        
        //设置控制中心显示歌曲信息
        MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
    }
    
    // MARK: 锁屏时，更新中间的音频信息，一般就是进度和歌词
    func updateNowPlayingInfoCenter(progress: Double) {
        let songInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        if songInfo == nil {
            return
        }
        var songDict: Dictionary<String, Any> = Dictionary<String, Any>()
        for (k, v) in songInfo! {
            songDict.updateValue(v, forKey: k)
        }
        songDict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = progress
        
        //如果需要更新歌词，那么每次更新时，需要把字幕和背景图片合并，并赋值给该属性
        //songDict[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: UIImage(named: "")!)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = songDict
    }
    
    deinit {
        self.audioPlayerView?.stop()
        
        let notiCenter = NotificationCenter.default
        notiCenter.removeObserver(self, name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        notiCenter.removeObserver(self, name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notiCenter.removeObserver(self, name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        notiCenter.removeObserver(self, name: Notification.Name.kUIEventSubtypeRemoteControlPlay, object: nil)
        notiCenter.removeObserver(self, name: Notification.Name.kUIEventSubtypeRemoteControlPause, object: nil)
        notiCenter.removeObserver(self, name: NSNotification.Name.kUIEventSubtypeRemoteControlPreviousTrack, object: nil)
        notiCenter.removeObserver(self, name: NSNotification.Name.kUIEventSubtypeRemoteControlNextTrack, object: nil)
    }

}
