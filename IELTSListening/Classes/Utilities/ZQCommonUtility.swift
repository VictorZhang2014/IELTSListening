//
//  ZQCommonUtility.swift
//  IELTSListening
//
//  Created by Victor Zhang on 04/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

public enum ZQiOSVersionType : Int {
    case iOS_8
    case iOS_9
    case iOS_10
    case iOS_11
}

public enum ZQComparisonType : Int {
    case isGreaterThan
    case isEqual
    case isLessThan
}

public class ZQCommonUtility: NSObject {
    
    func versionComparison(version: ZQiOSVersionType, comparisonType: ZQComparisonType) -> Bool {
        return true
    }
    
    // MARK: 当前设备是否是4寸屏幕
    static func is4inches() -> Bool {
        let size: CGSize = UIScreen.main.bounds.size
        if (size.width == 320 && size.height == 568) || (size.width == 568 && size.height == 320) {
            return true
        }
        return false
    }
    
    
    // MARK: 获取文件大小
    static func getAudioDirectoriesAndFilesSize() -> Double {
        let IELTS11path = ZQDownloadFiles.getResAudioPath() + "IELTS11/"
        let IELTS12path = ZQDownloadFiles.getResAudioPath() + "IELTS12/"
        let fileManager = FileManager.default
        
        var totalSize: UInt64 = 0
        let ielts11Files = try? fileManager.contentsOfDirectory(atPath: IELTS11path)
        if ielts11Files != nil && (ielts11Files?.count)! > 0 {
            for fileItem in ielts11Files! {
                let fileAttr = try? fileManager.attributesOfItem(atPath: IELTS11path + fileItem)
                let fileSize = fileAttr![FileAttributeKey.size] as! UInt64
                totalSize += fileSize
            }
        }
        
        let ielts12Files = try? fileManager.contentsOfDirectory(atPath: IELTS12path)
        if ielts12Files != nil && (ielts12Files?.count)! > 0 {
            for fileItem in ielts12Files! {
                let fileAttr = try? fileManager.attributesOfItem(atPath: IELTS12path + fileItem)
                let fileSize = fileAttr![FileAttributeKey.size] as! UInt64
                totalSize += fileSize
            }
        }
        
        let mbSize = Double(totalSize / 1024 / 1024)
        return mbSize
    }
    
    // MARK: 清除所有的音频文件
    static func removeAllAudioFiles() {
        let audioFilepath = ZQDownloadFiles.getResAudioPath()
        try? FileManager.default.removeItem(atPath: audioFilepath)
    }

}
