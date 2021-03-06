//
//  AppDelegate.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//  Hello, World

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class ZQAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: 接收远程控制事件，例如：1.锁屏时控制事件；2.从屏幕下拉上来的快速工具栏事件；3.耳机事件
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == .remoteControl {
            switch event!.subtype {
            case .remoteControlPlay:
                NotificationCenter.default.post(name: NSNotification.Name.kUIEventSubtypeRemoteControlPlay, object: nil)
                break
            case .remoteControlPause:
                NotificationCenter.default.post(name: NSNotification.Name.kUIEventSubtypeRemoteControlPause, object: nil)
                break
            case .remoteControlPreviousTrack:
                NotificationCenter.default.post(name: NSNotification.Name.kUIEventSubtypeRemoteControlPreviousTrack, object: nil)
                break
            case .remoteControlNextTrack:
                NotificationCenter.default.post(name: NSNotification.Name.kUIEventSubtypeRemoteControlNextTrack, object: nil)
                break
            default:
                break
            }
        }
    }


}

