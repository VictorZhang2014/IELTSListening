//
//  ZQAudioPlayerView.swift
//  TOEIC
//
//  Created by Victor Zhang on 02/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit
import AVFoundation

public enum ZQAudioPlayerStatus: Int {
    case none
    case preparedToPlay
    case playing
    case paused
    case stopped
}

@objc public protocol ZQAudioPlayerViewDelegate : NSObjectProtocol {
    @objc optional func audioPlayerisPlaying(player: AVAudioPlayer)
    @objc optional func audioPlayerisPlayingWithProgress(player: AVAudioPlayer, progress: Double)
    @objc optional func audioPlayerPaused(player: AVAudioPlayer)
    @objc optional func audioPlayerStopped(player: AVAudioPlayer)
}

public class ZQAudioPlayerView: UIView, AVAudioPlayerDelegate {

    public weak var audioPlayerDelegate: ZQAudioPlayerViewDelegate?
    
    //播放状态
    public var audioPlayerStatus: ZQAudioPlayerStatus = .none
    
    private weak var parentViewController: UIViewController?
    private var audioPlayer: AVAudioPlayer?
    private var slider: UISlider?
    private var timer: Timer?
    private var isPlaying: Bool = false
    
    private var playButton: UIButton?
    private var currentLabel: UILabel?
    private var totalLabel: UILabel?
    
    //播放总时长
    public var totolTimeDuration: Double = 0.0
    
    public override init(frame: CGRect) {
        let width: CGFloat = frame.size.width
        let height: CGFloat = 120
        let x_axis: CGFloat = 0
        let y_axis: CGFloat = frame.size.height - height
        let frame = CGRect(x: x_axis, y: y_axis, width: width, height: height)
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.white
        
//        let bgView: UIImageView = UIImageView(image: UIImage(named: "ZQBlurBackgroundImage"))
//        bgView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
//        self.addSubview(bgView)
//        let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
//        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = bgView.frame
//        self.addSubview(blurView)
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0.5))
        topLine.backgroundColor = UIColor.lightGray
        self.addSubview(topLine)
        
        //已播放的长度
        let playW: CGFloat = 30
        let playH: CGFloat = 20
        let playX: CGFloat = 7
        let playY: CGFloat = 14
        let playlabel = UILabel(frame: CGRect(x: playX, y: playY, width: playW, height: playH))
        playlabel.text = "00:00"
        playlabel.textColor = UIColor.white
        playlabel.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(playlabel)
        self.currentLabel = playlabel
        
        //进度条
        let progressX: CGFloat = playW + playX
        let progressW: CGFloat = frame.size.width - progressX * 2
        let progressH: CGFloat = 30  //这个值如果设置小了，触摸滑动时，很难，很难
        let progressY: CGFloat = 9
        let progress = UISlider(frame: CGRect(x: progressX, y: progressY, width: progressW, height: progressH))
        progress.value = 0.0
        progress.minimumTrackTintColor = UIColor.red
        progress.maximumTrackTintColor = UIColor.white
        progress.setThumbImage(UIImage(named: "zq_audioplayer_slider_red_circle"), for: .normal)
        progress.addTarget(self, action: #selector(slideChanged(_:)), for: .valueChanged)
        self.addSubview(progress)
        self.slider = progress
        
        //总长度
        let totalW = playW
        let totalH = playH
        let totalX: CGFloat = frame.size.width - progressX
        let totalabel = UILabel(frame: CGRect(x: totalX, y: playY, width: totalW, height: totalH))
        totalabel.text = "04:32"
        totalabel.textColor = UIColor.white
        totalabel.font = UIFont.systemFont(ofSize: 10)
        totalabel.textAlignment = .right
        self.addSubview(totalabel)
        self.totalLabel = totalabel
     
        //底部操作按钮
        let bW: CGFloat = 185
        let bH: CGFloat = height - totalH - 10
        let bX: CGFloat = (width - bW) / 2
        let operateBtns = UIView(frame: CGRect(x: bX, y: totalH + 27, width: bW, height: bH))
        self.addSubview(operateBtns)
        
        //后退
        let btnMargin: CGFloat = 10
        let btnBackwardW: CGFloat = 50
        let btnBackwardH: CGFloat = btnBackwardW
        let btnBackwardY: CGFloat = 5
        let backwardBtn = UIButton(frame: CGRect(x: 0, y: btnBackwardY, width: btnBackwardW, height: btnBackwardH))
        backwardBtn.setBackgroundImage(UIImage.flipHorizontal(named: "zq_audioplayer_btn_forward"), for: .normal)
        backwardBtn.setBackgroundImage(UIImage.flipHorizontal(named: "zq_audioplayer_btn_forward_prs"), for: .highlighted)
        backwardBtn.addTarget(self, action: #selector(clickedBackward), for: .touchUpInside)
        operateBtns.addSubview(backwardBtn)
        
        //播放或暂停
        let pauseX = btnBackwardW + btnMargin
        let pauseW = btnBackwardW + 10
        let pauseBtn = UIButton(frame: CGRect(x: pauseX, y: 0, width: pauseW, height: pauseW))
        pauseBtn.setBackgroundImage(UIImage(named: "zq_audioplayer_btn_play"), for: .normal)
        pauseBtn.setBackgroundImage(UIImage(named: "zq_audioplayer_btn_play_prs"), for: .highlighted)
        pauseBtn.addTarget(self, action: #selector(clickedPlay), for: .touchUpInside)
        operateBtns.addSubview(pauseBtn)
        self.playButton = pauseBtn
        
        //前进
        let forewardX = btnBackwardW + pauseW + btnMargin * 2
        let forewardBtn = UIButton(frame: CGRect(x: forewardX, y: btnBackwardY, width: btnBackwardW, height: btnBackwardH))
        forewardBtn.setBackgroundImage(UIImage(named: "zq_audioplayer_btn_forward"), for: .normal)
        forewardBtn.setBackgroundImage(UIImage(named: "zq_audioplayer_btn_forward_prs"), for: .highlighted)
        forewardBtn.addTarget(self, action: #selector(clickedForward), for: .touchUpInside)
        operateBtns.addSubview(forewardBtn)
        
        //设置
        let setW: CGFloat = btnBackwardW - 5
        let setH: CGFloat = setW
        let setX: CGFloat = frame.size.width - setW - 5
        let setY: CGFloat = operateBtns.frame.origin.y + btnBackwardY + 2
        let setBtn = UIButton(frame: CGRect(x: setX, y: setY, width: setW, height: setH))
        setBtn.setBackgroundImage(UIImage(named: "zq_audioplayer_settings"), for: .normal)
        setBtn.setBackgroundImage(UIImage(named: "zq_audioplayer_settings_prs"), for: .highlighted)
        setBtn.addTarget(self, action: #selector(openSetting), for: .touchUpInside)
        self.addSubview(setBtn)

    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("ZQOfficialListeningContent init(coder:) has not been implemented")
    }
    
    @objc func openSetting() {
        let setting = ZQAudioSettingViewController()
        parentViewController?.navigationController?.pushViewController(setting, animated: true)
    }
    
    // MARK: 后退
    @objc func clickedBackward() {
        // 正在播放时，或者已经暂停了，都可以后退
        if audioPlayerStatus == .playing || audioPlayerStatus == .paused {
            
            // 获取后退秒数
            let seconds: Int = ZQAudioSettingViewController.getBackwardSeconds()
            
            let curtime = Float(((audioPlayer?.currentTime)! - Double(seconds)) / (audioPlayer?.duration)!)
            self.slider?.setValue(curtime, animated: true)
            audioPlayer?.currentTime = Double((self.slider?.value)!) * (audioPlayer?.duration)!
        }
    }
    
    // MARK: 播放或暂停
    @objc func clickedPlay() {
        if isPlaying {
            playButtonToBePrepared()
            pause()
        } else {
            isPlaying = true
            play()
            self.playButton?.setBackgroundImage(UIImage(named: "zq_audioplayer_btn_pause"), for: .normal)
            self.playButton?.setBackgroundImage(UIImage(named: "zq_audioplayer_btn_pause_prs"), for: .highlighted)
        }
    }
    
    func playButtonToBePrepared() {
        isPlaying = false
        self.playButton?.setBackgroundImage(UIImage(named: "zq_audioplayer_btn_play"), for: .normal)
        self.playButton?.setBackgroundImage(UIImage(named: "zq_audioplayer_btn_play_prs"), for: .highlighted)
    }
    
    // MARK: 前进
    @objc func clickedForward() {
        // 正在播放时，或者已经暂停了，都可以前进
        if audioPlayerStatus == .playing || audioPlayerStatus == .paused {
            
            // 获取前进秒数
            let seconds: Int = ZQAudioSettingViewController.getForwardSeconds()
            
            let curtime = Float(((audioPlayer?.currentTime)! + Double(seconds)) / (audioPlayer?.duration)!)
            self.slider?.setValue(curtime, animated: true)
            audioPlayer?.currentTime = Double((self.slider?.value)!) * (audioPlayer?.duration)!
        }
    }
    
    public func playAudio(audioPath: String, parentController: UIViewController)  {
        parentViewController = parentController
        let url = URL(fileURLWithPath: audioPath)
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
        audioPlayerStatus = .preparedToPlay
        
        if audioPlayer == nil {
            let alert = UIAlertController(title: nil, message: "打开的文件发生了一点问题，请联系本软件作者，给您带来的不便，请谅解！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "我知道了", style: .cancel, handler:{ (action) in
                parentController.navigationController?.popViewController(animated: true)
            }))
            parentController.present(alert, animated: true, completion: nil)
            return
        }
        
        //该音频文件的分秒
        self.totolTimeDuration = (audioPlayer?.duration)!
        totalLabel?.text = String(format: "%02d:%02d", ((Int)((audioPlayer?.duration)!)) / 60, ((Int)((audioPlayer?.duration)!)) % 60)
    }
    
    func createTimer() {
        //使用计时器每1秒钟就循环一次，检查当前播放进度
        timer = Timer(timeInterval: 0.1, target: self, selector: #selector(playProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    public func play()  {
        if timer == nil || !((timer?.isValid)!) {
            createTimer()
        }
        
        timer?.fire()
        audioPlayer?.play()
        audioPlayerStatus = .playing
        
        if (self.audioPlayerDelegate?.responds(to: #selector(audioPlayerDelegate?.audioPlayerisPlaying(player:))))! {
            self.audioPlayerDelegate?.audioPlayerisPlaying!(player: audioPlayer!)
        }
    }
    
    public func pause() {
        audioPlayer?.pause()
        audioPlayerStatus = .paused
        
        playButtonToBePrepared()
        
        if (self.audioPlayerDelegate?.responds(to: #selector(audioPlayerDelegate?.audioPlayerPaused(player:))))! {
            self.audioPlayerDelegate?.audioPlayerPaused!(player:audioPlayer!)
        }
    }
    
    public func stop() {
        timer?.invalidate()
        audioPlayer?.stop()
        audioPlayerStatus = .stopped
        
        self.currentLabel?.text = "00:00"
        self.slider?.setValue(0, animated: true)
        
        if self.audioPlayerDelegate != nil && (self.audioPlayerDelegate?.responds(to: #selector(audioPlayerDelegate?.audioPlayerStopped(player:))))! {
            self.audioPlayerDelegate?.audioPlayerStopped?(player: audioPlayer!)
        }
    }
    
    // MARK: UISlider 拖动时
    @objc func slideChanged(_ valueChanged: UISlider) {
        audioPlayer?.currentTime = Double(valueChanged.value) * (audioPlayer?.duration)!
    }
    
    // MARK: 计时器检测进度
    @objc func playProgress() {
        let curtime = Float((audioPlayer?.currentTime)! / (audioPlayer?.duration)!)
        self.slider?.setValue(curtime, animated: true)
        
        //当前播放的进度显示
        let currentElapsedTime = (audioPlayer?.currentTime)!
        self.currentLabel?.text = String(format: "%02d:%02d", ((Int)((audioPlayer?.currentTime)!)) / 60, ((Int)((audioPlayer?.currentTime)!)) % 60)
        
        if self.audioPlayerDelegate != nil && (self.audioPlayerDelegate?.responds(to: #selector(audioPlayerDelegate?.audioPlayerisPlayingWithProgress(player:progress:))))! {
            self.audioPlayerDelegate?.audioPlayerisPlayingWithProgress?(player: audioPlayer!, progress: currentElapsedTime)
        }
    }

    // MARK: AVAudioPlayerDelegate
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButtonToBePrepared()
        stop()
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        playButtonToBePrepared()
        stop()
    }
    
    deinit {
        stop()
    }
    
}
