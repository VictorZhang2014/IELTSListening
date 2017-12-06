//
//  ZQYouTubePlayerViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 06/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//  YouTube 视频播放器

import UIKit
import youtube_ios_player_helper

class ZQYouTubePlayerViewController: ZQViewController, YTPlayerViewDelegate {

    private var ytPlayer: YTPlayerView?
    private var ytVideoId: String?
    
    init(videoId: String) {
        super.init(nibName: nil, bundle: nil)
        ytVideoId = videoId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.defaultLightGray
        UIApplication.shared.isStatusBarHidden = false
        
        setPlayer()
    }
    
    func setPlayer() {
        //初始化YouTube视频播放器
        let frame = self.view.frame
        let ytW: CGFloat = frame.size.width
        let ytH: CGFloat = frame.size.height / 2.5
        let playerFrame = CGRect(x: 0, y: 0, width: ytW, height: ytH)
        
        //YouTube播放层
        ytPlayer = YTPlayerView()
        ytPlayer!.frame = playerFrame
        ytPlayer!.delegate = self
        self.view.addSubview(ytPlayer!)
        
        //加载视频
        let playerVars = [ "playsinline": 1 ] //参数的意思是，在指定是view中播放
        ytPlayer!.load(withVideoId: ytVideoId!, playerVars: playerVars)
    }
    
    // MARK: YTPlayerViewDelegate
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .unstarted:
            break
        case .buffering:
            break
        case .playing:
            break
        case .paused:
            break
        case .ended:
            break
        case .queued:
            break
        default:
            alertWith(message: "YouTube happened an unknown Error!")
            break
        }
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        alertWith(message: "YouTube happened an unknown Error! error code = \(error)")
    }
    
    func alertWith(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
