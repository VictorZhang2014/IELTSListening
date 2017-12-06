//
//  ZQDownloadAudio.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

public enum ZQFileFormat: String {
    case none = "none"
    
    case plist = "plist"
    case rar = "rar"
    case zip = "zip"
    
    case png = "png"
    case jpg = "jpg"
    case gif = "gif"
}

public class ZQDownloadFiles: UIView, URLSessionDelegate, URLSessionDownloadDelegate {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    private var downloadIELTSIndex: Int = 0
    private var progressClosure: ((Double) -> Swift.Void)?
    private var completionClosure: ((String?, String?, String?) -> Swift.Void)?
    
    private var isDownloadCommonFile: Bool = false //是否是下载普通文件
    private var downloadFilename: String = ""
    
    // MARK: 下载雅思音频资源
    public func download(index: Int, progress: ((Double) -> Swift.Void)? = nil, completion: ((String?, String?, String?) -> Swift.Void)?) {
        downloadIELTSIndex = index
        progressClosure = progress
        completionClosure = completion
        isDownloadCommonFile = false
        
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
    
    // MARK: 下载普通文件
    public func download(urlStr: String, filename: String, progress: ((Double) -> Swift.Void)? = nil, completion: ((String?, String?, String?) -> Swift.Void)?) {
        progressClosure = progress
        completionClosure = completion
        isDownloadCommonFile = true
        downloadFilename = filename
        
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        
        let dataTask: URLSessionDownloadTask = session.downloadTask(with: request)
        dataTask.resume()
    }
    
    // MARK: URLSessionDelegate
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
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
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        //输出下载文件原来的存放目录
        let locationPath = location.path
        
        if isDownloadCommonFile {
            handle_common_files(locationPath)
        } else {
            handle_IELTS_res(locationPath)
        }
    }

    // MARK: 下载完雅思文件后处理函数
    private func handle_IELTS_res(_ locationPath: String) {
        let docDir: String = NSHomeDirectory() + "/Documents/res/audio/"
        
        let fileManager = FileManager.default
        try? fileManager.createDirectory(atPath: docDir, withIntermediateDirectories: true, attributes: nil)
        
        var docDir_zip = docDir
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
    
    // MARK: 下载完普通文件后处理函数
    private func handle_common_files(_ locationPath: String) {
        let docDir: String = NSHomeDirectory() + "/Documents/data/"
        
        let fileManager = FileManager.default
        try? fileManager.createDirectory(atPath: docDir, withIntermediateDirectories: true, attributes: nil)
        
        let docDir_data = docDir + String.getStrDate() + downloadFilename
        try! fileManager.copyItem(atPath: locationPath, toPath: docDir_data)
        
        DispatchQueue.main.async {
            if let completionHandler = self.completionClosure {
                completionHandler(nil, docDir_data, docDir)
            }
        }
    }
    
    
    
    // MARK: 音频文件是否存在
    static public func hasAudioFiles(ieltsIndex: Int) -> Bool {
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
    static public func changeDirName(ieltsIndex: Int) {
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
    
    static public func getResAudioPath() -> String {
        return NSHomeDirectory() + "/Documents/res/audio/"
    }
    
}
