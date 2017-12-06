//
//  NSNotification.swift
//  IELTSListening
//
//  Created by Victor Zhang on 28/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    
    // MARK: 直播，切换国家的通知
    public static var kUIEventLiveInCountrySwitchover: NSNotification.Name {
        return NSNotification.Name("kUIEventLiveInCountrySwitchover")
    }
    
 
    // MARK: 远程控制事件相关
    
    public static var kUIEventSubtypeRemoteControlPlay: NSNotification.Name {
        return NSNotification.Name("kUIEventSubtypeRemoteControlPlay")
    }
     
    public static var kUIEventSubtypeRemoteControlPause: NSNotification.Name {
        return NSNotification.Name("kUIEventSubtypeRemoteControlPause")
    }
     
    public static var kUIEventSubtypeRemoteControlPreviousTrack: NSNotification.Name {
        return NSNotification.Name("kUIEventSubtypeRemoteControlPreviousTrack")
    }
     
    public static var kUIEventSubtypeRemoteControlNextTrack: NSNotification.Name {
        return NSNotification.Name("kUIEventSubtypeRemoteControlNextTrack")
    }
    
}
