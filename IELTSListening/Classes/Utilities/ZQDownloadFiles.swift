//
//  ZQDownloadAudio.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class ZQDownloadFiles: UIView, URLSessionDelegate, URLSessionDownloadDelegate {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    private var downloadIELTSIndex: Int = 0
    private var progressClosure: ((Double) -> Swift.Void)?
    private var completionClosure: ((String?, String?, String?) -> Swift.Void)?
    
    func download(index: Int, progress: ((Double) -> Swift.Void)? = nil, completion: ((String?, String?, String?) -> Swift.Void)?) {
        downloadIELTSIndex = index
        progressClosure = progress
        completionClosure = completion
        
        var address = ""
        if downloadIELTSIndex == 12 {
            //雅思12
            address = "http://uimg.gximg.cn/v/docs/201706/644/%E5%89%91%E6%A1%A512-%E9%9F%B3%E9%A2%91.zip"
        } else {
            //雅思11
            address = "http://uimg.gximg.cn/v/docs/201606/608/%E5%89%91%E6%A1%A511-%E9%9F%B3%E9%A2%91.zip"
        }
        
        let url = URL(string: address)
        let request = URLRequest(url: url!)
        
        let dataTask: URLSessionDownloadTask = session.downloadTask(with: request)
        dataTask.resume()
    }
    
    // MARK: URLSessionDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        //获取进度
        let written:CGFloat = (CGFloat)(totalBytesWritten)
        let total:CGFloat = (CGFloat)(totalBytesExpectedToWrite)
        let pro:CGFloat = written/total
        
        DispatchQueue.main.async {
            if self.progressClosure != nil {
                self.progressClosure!(Double(pro))
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        //输出下载文件原来的存放目录
        let locationPath = location.path
        
        //压缩文件存放的目录 和 解压目录 是同一个
        let docDir: String = NSHomeDirectory() + "/Documents/res/audio/"
        var docDir_zip = docDir
        
        let fileManager = FileManager.default
        try? fileManager.createDirectory(atPath: docDir_zip, withIntermediateDirectories: true, attributes: nil)
        
        if downloadIELTSIndex == 12 {
            docDir_zip += "IELTS12.zip"
        } else if downloadIELTSIndex == 11 {
            docDir_zip += "IELTS11.zip"
        } else {
            completionClosure!("指定的下载文件不对！", nil, nil)
            return
        }
        try! fileManager.copyItem(atPath: locationPath, toPath: docDir_zip)
        
        DispatchQueue.main.async {
            self.completionClosure!(nil, docDir_zip, docDir)
        }
    }
    
    // MARK: 音频文件是否存在
    static func hasAudioFiles(ieltsIndex: Int) -> Bool {
        var filename = ""
        if ieltsIndex == 12 {
            filename = "IELTS12/"
        } else if ieltsIndex == 11 {
            filename = "IELTS11/"
        }
        let filepath = NSHomeDirectory() + "/Documents/res/audio/" + filename
        let fileManager = FileManager.default
        let contents = try? fileManager.contentsOfDirectory(atPath: filepath)

        if contents == nil {
            return false
        }
        
        if (contents?.count)! <= 0 {
            return false
        }
        
        return true
    }

    // MARK: 更换解压完后的文件名目录，删除压缩文件
    static func changeDirName(ieltsIndex: Int) {
        var filepath = NSHomeDirectory() + "/Documents/res/audio/"
        var targetPath = filepath
        var deleteFilePath = filepath
        if ieltsIndex == 12 {
            filepath += "剑12听力音频"
            targetPath += "IELTS12/"
            deleteFilePath += "IELTS12.zip"
        } else if ieltsIndex == 11 {
            filepath += "剑桥11-音频"
            targetPath += "IELTS11/"
            deleteFilePath += "IELTS11.zip"
        }
        
        let fileManager = FileManager.default
        try? fileManager.moveItem(atPath: filepath, toPath: targetPath)
        try? fileManager.removeItem(atPath: deleteFilePath)
    }
    
    static func getResAudioPath() -> String {
        return NSHomeDirectory() + "/Documents/res/audio/"
    }
    
}
