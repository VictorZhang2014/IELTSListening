//
//  NSDate.swift
//  IELTSListening
//
//  Created by Victor Zhang on 10/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: 获取日期时间字符串
    static public func getStrDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: date)
    }
    
}

