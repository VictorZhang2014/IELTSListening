//
//  ZQPlistCommonModel.swift
//  IELTSListening
//
//  Created by Victor Zhang on 10/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

public enum ZQCommonModelCellType: Int {
    case cellTypeNone = 0
    case halfLengCell = 1   //半宽度cell
    case customHeightCell = 2     //自定义高度cell
    case soloTextCell = 3     //只有文字的cell
}

public enum ZQCommonModelCellEventType: Int {
    case cellEventNone = 0
    case cellEventExamSpots = 1   //雅思考点信息
}

public class ZQPlistCommonModel: NSObject {

    public var title: String?
    
    //缩略图
    public var thumbnail: String?
    
    //视频地址
    public var videoURL: String?
    
    //视频创作时间
    public var createTime: String?
    
    //单元格类型
    public var cellType: ZQCommonModelCellType = .cellTypeNone
    
    //单元格点击事件
    public var eventType: ZQCommonModelCellEventType = .cellEventNone
    
    //详细文本
    public var detailedText: String?
    
    
    public override init() {
        
    }
    
    public init(dict: Dictionary<String, String>) {
        title = dict["title"]
        thumbnail = dict["thumbnail"]
        videoURL = dict["videoURL"]
        createTime = dict["createTime"]
        cellType = .halfLengCell
        super.init()
    }
    
}
