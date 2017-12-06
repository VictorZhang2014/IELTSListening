//
//  ZQLiveDataDownload.swift
//  IELTSListening
//
//  Created by Victor Zhang on 18/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//  直播数据下载类

import UIKit

// MARK: 直播数据类型
public enum ZQLiveDataType: Int {
    
    case global = 0
    case girls  = 1
    case boys   = 2
    case talent = 3
    
    static func getGirls() -> String {
        return String("girls")
    }
    
    static func getBoys() -> String {
        return String("boys")
    }
    
    static func getTalent() -> String {
        return String("talent")
    }
    
    static func getGlobal(countryType: ZQLiveInCountryType) -> String {
        var typeStr: String = String()
        switch countryType {
        case .UK:
            typeStr = "countryCode=GB"
            break
        case .Canada:
            typeStr = "countryCode=CA"
            break
        case .Taiwan:
            typeStr = "countryCode=TW"
            break
        case .Japan:
            typeStr = "countryCode=JP"
            break
        case .Indian:
            typeStr = "countryCode=IN"
            break
        case .Ukraine:
            typeStr = "countryCode=UA"
            break
        case .Vietnam:
            typeStr = "countryCode=VN"
            break
        case .Indonesia:
            typeStr = "countryCode=ID"
            break
        case .France:
            typeStr = "countryCode=FR"
            break
        case .Russia:
            typeStr = "countryCode=RU"
            break
        default:
            typeStr = ""
            break
        }
        return typeStr
    }
}

// MARK: 直播国家类型
public enum ZQLiveInCountryType: Int {
    case USA        = 1
    case UK         = 2
    case Canada     = 3
    case Taiwan     = 4
    case Japan      = 5
    case Indian     = 6
    case Ukraine    = 7
    case Vietnam    = 8
    case Indonesia  = 9
    case France     = 10
    case Russia     = 11
}

public class ZQLiveDataDownload: NSObject {

    private let networkProtocol: String = "https"
    private let prefixDomain: String = "live"
    private let centerPartDomain: String = "ksmobile"
    private let suffixDomain: String = "net"
    private let _user: String = "user"
    private let _getinfo: String = "getinfo"
    
    private let liveDataType: ZQLiveDataType = .global
    
    public static let cn_countries = [ "美女", "帅哥", "才艺表演", "美国", "英国", "加拿大", "中国台湾", "乌克兰", "印度", "越南", "印度尼西亚", "日本", "法国", "俄罗斯" ]
    public static let en_countries = [ "Girls", "Boys", "Talent", "USA", "UK", "Canada", "Taiwan", "Ukraine", "India", "Vietnam", "Indonesia", "Japan", "France", "Russia" ]
    
    // MARK: 获取直播数据的参数
    public static func getLiveType(_ country: String) -> (ZQLiveDataType, ZQLiveInCountryType) {
        var livetype: ZQLiveDataType = .girls
        var livecountrytype: ZQLiveInCountryType = .USA
        switch country {
        case "Girls":
            livetype = .girls
            livecountrytype = .USA
            break
        case "Boys":
            livetype = .boys
            livecountrytype = .USA
            break
        case "Talent":
            livetype = .talent
            livecountrytype = .USA
            break
        case "USA":
            livetype = .global
            livecountrytype = .USA
            break
        case "UK":
            livetype = .global
            livecountrytype = .UK
            break
        case "Canada":
            livetype = .global
            livecountrytype = .Canada
            break
        case "Taiwan":
            livetype = .global
            livecountrytype = .Taiwan
            break
        case "Ukraine":
            livetype = .global
            livecountrytype = .Ukraine
            break
        case "Ukraine":
            livetype = .global
            livecountrytype = .Ukraine
            break
        case "Vietnam":
            livetype = .global
            livecountrytype = .Vietnam
            break
        case "Indonesia":
            livetype = .global
            livecountrytype = .Indonesia
            break
        case "Japan":
            livetype = .global
            livecountrytype = .Japan
            break
        case "France":
            livetype = .global
            livecountrytype = .France
            break
        case "Russia":
            livetype = .global
            livecountrytype = .Russia
            break
        default:
            livetype = .girls
            livecountrytype = .USA
            break
        }
        return (livetype, livecountrytype)
    }
    
    // MARK: 下载指定主播的个人信息等
    func downloadLiveHostInfo(userId: String, completionHandler: @escaping (ZQLiveMeVideoHostInfoModel?, String?) -> Swift.Void) {
        let urlStr = getHostInfoPrefixURLStr() + userId
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let _data = data, error == nil {
                let jsondict = ZQCommonUtility.getDictByConverting(jsondata: _data)
                if let dict = jsondict {
                    let dictObj = dict as? Dictionary<String, Any>
                    let dictData = dictObj!["data"] as? Dictionary<String, Any>
                    let dictUser = dictData!["user"] as? Dictionary<String, Any>
                    if let object = ZQLiveMeVideoHostInfoModel.deserialize(from: dictUser) {
                        completionHandler(object, nil)
                        return
                    }
                    return
                }
                completionHandler(nil, "JSON对象转换失败！")
            } else {
                completionHandler(nil, error?.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    // MARK: 下载直播数据，根据直播类型、国家、页码
    func downloadLiveDataArray(byLiveType: ZQLiveDataType, atPage index: Int, completionHandler: @escaping (Array<ZQLiveMeVideoInfoModel>?, String?) -> Swift.Void) {
        downloadLiveDataArray(byLiveType: byLiveType, withCountryType: .USA, atPage: 1, completionHandler: completionHandler)
    }
    
    // MARK: 下载直播数据，根据直播类型、国家、页码
    func downloadLiveDataArray(byLiveType: ZQLiveDataType, withCountryType: ZQLiveInCountryType, atPage index: Int, completionHandler: @escaping (Array<ZQLiveMeVideoInfoModel>?, String?) -> Swift.Void) {
        let url = getRequestURL(byLiveType: byLiveType, withCountryType: withCountryType, atPage: index)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                let jsondict = ZQCommonUtility.getDictByConverting(jsondata: data!)
                if jsondict != nil {
                    let dict = jsondict as? Dictionary<String, Any>
                    if dict != nil {
                        let dataDict = dict!["data"] as! Dictionary<String, Any>
                        let videoArr = dataDict["video_info"] as? Array<Dictionary<String, Any>>
                        
                        var resultList = Array<ZQLiveMeVideoInfoModel>()
                        for item in videoArr! {
                            let model = ZQLiveMeVideoInfoModel()
                            model.setModel(by: item)
                            resultList.append(model)
                        }
                        completionHandler(resultList, nil)
                        return
                    }
                }
                completionHandler(nil, "JSON String is incorrect!")
            } else {
                completionHandler(nil, error?.localizedDescription)
            }
        }
        task.resume()
    }

    func getRequestURL(byLiveType: ZQLiveDataType, withCountryType: ZQLiveInCountryType, atPage index: Int) -> URL {
        
        //获取URL前缀
        var urlStr = getPrefixURLStr()
        switch byLiveType {
        case .girls:
            urlStr += ZQLiveDataType.getGirls() + "?"
            break
        case .boys:
            urlStr += ZQLiveDataType.getBoys() + "?"
            break
        case .talent:
            urlStr += ZQLiveDataType.getTalent() + "?"
            break
        default:
            urlStr += "featurelist?"
            break
        }
        
        //URL中间类型
        if byLiveType == .global {
            urlStr += ZQLiveDataType.getGlobal(countryType: withCountryType)
        } else {
            urlStr += "countryCode=US"
        }
        
        //页码
        if urlStr.hasSuffix("?") {
            urlStr += getPage(atIndex: index)
        } else {
            urlStr += "&" + getPage(atIndex: index)
        }
        
        return URL(string: urlStr)!
    }
    
    // MARK: 获取页码参数字符串
    func getPage(atIndex index: Int) -> String {
        return String("page=\(index)&pagesize=20&page_index=\(index)&page_size=20")
    }
    
    // MARK: 获取下载字符串的前缀
    func getPrefixURLStr() -> String {
        return networkProtocol + "://" + prefixDomain + "." + centerPartDomain + "." + suffixDomain + "/" + prefixDomain + "/"
    }
    
    // MARK: 获取下载直播用户的URL前缀
    func getHostInfoPrefixURLStr() -> String {
        return networkProtocol + "://" + prefixDomain + "." + centerPartDomain + "." + suffixDomain + "/" + _user + "/" + _getinfo + "?" + _user + "id="
    }
    
}
