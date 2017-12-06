//
//  ZQLiveMeDataModel.swift
//  IELTSListening
//
//  Created by Victor Zhang on 18/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//  liveme.com的视频模型数据

import UIKit
import HandyJSON

//直播主播列表的信息模型
public class ZQLiveMeVideoInfoModel: NSObject {
    
    public var chatSystem: String?
    public var isParticipant: String?
    public var sex: String?
    public var videos_flv: String?
    public var videosource: String?
    public var msgfile: String?
    public var shopEntryDec: String?
    public var is_verified: String?
    public var status: String?
    public var gzip_msgfile: String?
    public var watchnumber: String?
    public var shareurl: String?
    public var announcement_shop: String?
    public var videocapture: String?
    public var shareuv: String?
    public var likenum: String?
    public var level: String?
    public var roomstate: String?
    public var area: String?
    public var topic: String?
    public var worn_badge: String?
    public var rotate: String?
    public var gscreen: String?
    public var videosize: String?
    public var countryCode: String?
    public var videos_hls: String?
    public var vdoid: String?
    public var istop: String?
    public var addr: String?
    public var hlsvideosource: String?
    public var isOfficalLive: String?
    public var anchor_level: String?
    public var is_seller: String?
    public var lat: String?
    public var shopMsgInterval: String?
    public var playnumber: String?
    public var uface: String?
    public var userid: String?
    public var impression: Array<ZQLiveMeVideoInfoImpressionModel>?
    public var isTCLine: String?
    public var server_agent: String?
    public var videolength: String?
    public var charades: String?
    public var announcement: Array<ZQLiveMeVideoInfoAnnouncementModel>?
    public var is_vidcon: String?
    public var supportLine: String?
    public var lnt: String?
    public var isaddr: String?
    public var homepage: String?
    public var title: String?
    public var vid: String?
    public var is_forbid: String?
    public var vtype: String?
    public var is_shelf: String?
    public var vtime: String?
    public var sharenum: String?
    public var uname: String?
    public var topicid: String?
    public var online: String?
    public var smallcover: String?
    public var hot_label_new: String?
    public var hot_label_v2: String?
    
    
    func setModel(by dict: Dictionary<String, Any>) {
        chatSystem = dict["chatSystem"] as? String
        isParticipant = dict["isParticipant"] as? String
        sex = dict["sex"] as? String
        videos_flv = dict["videos_flv"] as? String
        videosource = dict["videosource"] as? String
        msgfile = dict["msgfile"] as? String
        shopEntryDec = dict["shopEntryDec"] as? String
        is_verified = dict["is_verified"] as? String
        status = dict["status"] as? String
        gzip_msgfile = dict["gzip_msgfile"] as? String
        watchnumber = dict["watchnumber"] as? String
        shareurl = dict["shareurl"] as? String
        announcement_shop = dict["announcement_shop"] as? String
        videocapture = dict["videocapture"] as? String
        shareuv = dict["shareuv"] as? String
        likenum = dict["likenum"] as? String
        level = dict["level"] as? String
        roomstate = dict["roomstate"] as? String
        area = dict["area"] as? String
        topic = dict["topic"] as? String
        worn_badge = dict["worn_badge"] as? String
        rotate = dict["rotate"] as? String
        gscreen = dict["gscreen"] as? String
        videosize = dict["videosize"] as? String
        countryCode = dict["countryCode"] as? String
        videos_hls = dict["videos_hls"] as? String
        vdoid = dict["vdoid"] as? String
        istop = dict["istop"] as? String
        addr = dict["addr"] as? String
        hlsvideosource = dict["hlsvideosource"] as? String
        isOfficalLive = dict["isOfficalLive"] as? String
        anchor_level = dict["anchor_level"] as? String
        is_seller = dict["is_seller"] as? String
        lat = dict["lat"] as? String
        shopMsgInterval = dict["shopMsgInterval"] as? String
        playnumber = dict["playnumber"] as? String
        uface = dict["uface"] as? String
        userid = dict["userid"] as? String
        
        if let impressionJsonStr = dict["impression"] as? String {
            if let imprObj = ZQCommonUtility.getDictByConverting(jsonStr: impressionJsonStr) {
                let impressionList = imprObj as? Array<Dictionary<String, Any>>
                if impressionList != nil {
                    var impressionArr = Array<ZQLiveMeVideoInfoImpressionModel>()
                    for impr: Dictionary in impressionList! {
                        let imprModel = ZQLiveMeVideoInfoImpressionModel()
                        imprModel.tag_id = impr["tag_id"] as? String
                        imprModel.tag_name = impr["tag_name"] as? String
                        imprModel.tag_color = impr["tag_color"] as? String
                        imprModel.num = impr["num"] as! Int
                        impressionArr.append(imprModel)
                    }
                    impression = impressionArr
                }
            }
        }
        
        isTCLine = dict["isTCLine"] as? String
        server_agent = dict["server_agent"] as? String
        videolength = dict["videolength"] as? String
        charades = dict["charades"] as? String
        
        if let announcementJSONStr = dict["announcement"] as? String {
            if let announceObj = ZQCommonUtility.getDictByConverting(jsonStr: announcementJSONStr) {
                let announcementList = announceObj as? Array<Dictionary<String, Any>>
                if announcementList != nil {
                    var announcementArr = Array<ZQLiveMeVideoInfoAnnouncementModel>()
                    for announce: Dictionary in announcementList! {
                        let announceModel = ZQLiveMeVideoInfoAnnouncementModel()
                        announceModel.announcement_id = announce["announcement_id"] as? String
                        announceModel.name = announce["name"] as? String
                        announceModel.icon_new = announce["icon_new"] as? String
                        announceModel.videoid = announce["videoid"] as? String
                        announceModel.content = announce["content"] as? String
                        announceModel.x_coordinate = announce["x_coordinate"] as? String
                        announceModel.y_coordinate = announce["y_coordinate"] as? String
                        announcementArr.append(announceModel)
                    }
                    announcement = announcementArr
                }
            }
        }
        
        is_vidcon = dict["is_vidcon"] as? String
        supportLine = dict["supportLine"] as? String
        lnt = dict["lnt"] as? String
        isaddr = dict["isaddr"] as? String
        homepage = dict["homepage"] as? String
        title = dict["title"] as? String
        vid = dict["vid"] as? String
        is_forbid = dict["is_forbid"] as? String
        vtype = dict["vtype"] as? String
        is_shelf = dict["is_shelf"] as? String
        vtime = dict["vtime"] as? String
        sharenum = dict["sharenum"] as? String
        uname = dict["uname"] as? String
        topicid = dict["topicid"] as? String
        online = dict["online"] as? String
        smallcover = dict["smallcover"] as? String
        hot_label_new = dict["hot_label_new"] as? String
        hot_label_v2 = dict["hot_label_v2"] as? String
    }
    
}

public class ZQLiveMeVideoInfoImpressionModel {
    public var tag_id: String?
    public var tag_name: String?
    public var tag_color: String?
    public var num: Int = 0
}

public class ZQLiveMeVideoInfoAnnouncementModel {
    public var announcement_id: String?
    public var name: String?
    public var icon_new: String?
    public var videoid: String?
    public var content: String?
    public var x_coordinate: String?
    public var y_coordinate: String?
}




//直播主播的个人信息模型
public class ZQLiveMeVideoHostInfoModel: HandyJSON {
    
    public var time: String?
    public var user_info: ZQLiveMeVideoUserInfoModel?
    public var following_list: String?
    public var follower_list: String?
    public var video_list: String?
    public var count_info: ZQLiveMeVideoUserInfo2Model?

    required public init() {}
}

public class ZQLiveMeVideoUserInfoModel: HandyJSON {
    
    public var uid: String?
    public var uname: String?
    public var nickname: String?
    public var usign: String?
    public var sex: String?
    public var birthday: String?
    public var face: String?
    public var big_face: String?
    public var email: String?
    public var mobile: String?
    public var reg_time: String?
    public var status: String?
    public var model: String?
    public var is_verified: String?
    public var verified_info: String?
    public var cm_openid: String?
    public var score: String?
    public var suggest_name: String?
    public var is_seller: String?
    public var shop_msg_interval: String?
    public var countryCode: String?
    public var short_id: String?
    public var gold: String?
    public var star: String?
    public var currency: String?
    public var dollar: String?
    public var money: String?
    public var praise: String?
    public var msgnum: String?
    public var level: String?
    public var level_start_exp: String?
    public var cur_exp: String?
    public var next_exp: String?
    public var anchor_level: String?
    public var current_anchor_exp: String?
    public var anchor_exp: String?
    public var isbindthird: String?
    public var gamecover_type: String?
    public var cover: String?
    public var big_cover: String?
    public var game_cover: String?
    public var big_game_cover: String?
    public var isAdmin: String?
    public var forbid_admin: String?
    public var is_star: String?
    public var star_is_verified: String?
    public var isVIP: String?
    public var anchor_level_name: String?
    public var is_open: String?
    public var is_exchange: String?
    public var levelRight: String?
    public var game_live: String?
    public var worn_badge: String?
    
    required public init() {}
}

public class ZQLiveMeVideoUserInfo2Model: HandyJSON {
    
    public var following_count: String?
    public var follower_count: String?
    public var black_count: String?
    public var video_count: String?
    public var live_count: String?
    public var replay_count: String?
    public var ad_num: String?
    public var friends_count: String?
    
    required public init() {}
}


