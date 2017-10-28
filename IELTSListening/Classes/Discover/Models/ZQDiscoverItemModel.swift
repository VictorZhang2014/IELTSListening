//
//  ZQDiscoverItemModel.swift
//  IELTSListening
//
//  Created by Victor Zhang on 11/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

/*
 第一版规则是：
 正文：99字，不分中英文
 图片：一次允许1到9张
 视频：一次允许一个
 */

import Foundation

public class ZQDiscoverItemModel: NSObject {

    // 用户头像
    var avatarImagePath: String?
    
    // 用户名称
    var name: String?
    
    // 发布时间
    var time: String?
    
    // 正文
    var detailsText: String?
    
    // 附带图片地址集
    var attachedPics: Array<String>?
    
    // 附带视频地址
    var attachedVideo: String?
    
    // 点赞数
    var praisedCounts: Int = 0
    
}
