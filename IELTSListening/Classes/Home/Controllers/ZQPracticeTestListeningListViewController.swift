//
//  ZQPracticeTestListeningListViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit
import SSZipArchive

class ZQPracticeTestListeningListViewController: ZQViewController, UITableViewDataSource, UITableViewDelegate {

    private var tableView: UITableView!
    private var dataList: Array<Array<String>>?
    private var ieltsIndex: Int = 0  // 范围 11-12
    
    private var isWifiConnection: Bool = false
    private var hasDownloadedAudio: Bool = false   // 音频文件是否已经下载了
    
    private lazy var progressView = ZQProgressView()
    private lazy var downloadObj = ZQDownloadFiles()
    
    init(index: Int) {
        super.init(nibName: nil, bundle: nil)
        ieltsIndex = index
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("ZQListeningDetailsViewController init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToNetwork()
        setTitleLabel()
        loadDataList()
        setTableView()
    }
    
    func setTitleLabel() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = "雅思\(ieltsIndex)真题 - 听力"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
    }
    
    func loadDataList()  {
        if ieltsIndex == 12 {
            dataList = [ [  "IELTS 12 Test 5_S1",
                            "IELTS 12 Test 5_S2",
                            "IELTS 12 Test 5_S3",
                            "IELTS 12 Test 5_S4"    ],
                         [  "IELTS 12 Test 6_S1",
                            "IELTS 12 Test 6_S2",
                            "IELTS 12 Test 6_S3",
                            "IELTS 12 Test 6_S4"    ],
                         [  "IELTS 12 Test 7_S1",
                            "IELTS 12 Test 7_S2",
                            "IELTS 12 Test 7_S3",
                            "IELTS 12 Test 7_S4"    ],
                         [  "IELTS 12 Test 8_S1",
                            "IELTS 12 Test 8_S2",
                            "IELTS 12 Test 8_S3",
                            "IELTS 12 Test 8_S4"    ]
                        ]
        } else {
            dataList = [ [ "IELTS11_Test1_Section1",
                           "IELTS11_Test1_Section2",
                           "IELTS11_Test1_Section3",
                           "IELTS11_Test1_Section4",
                           ],
                         [ "IELTS11_Test2_Section1",
                           "IELTS11_Test2_Section2",
                           "IELTS11_Test2_Section3",
                           "IELTS11_Test2_Section4",
                           ],
                         [ "IELTS11_Test3_Section1",
                           "IELTS11_Test3_Section2",
                           "IELTS11_Test3_Section3",
                           "IELTS11_Test3_Section4",
                           ],
                         [ "IELTS11_Test4_Section1",
                           "IELTS11_Test4_Section2",
                           "IELTS11_Test4_Section3",
                           "IELTS11_Test4_Section4",
                           ]
                        ]
        }
        
        checkAudioFilesExist()
    }
    
    func checkAudioFilesExist() {
        hasDownloadedAudio = ZQDownloadFiles.hasAudioFiles(ieltsIndex: ieltsIndex)
    }
    
    //模糊背景
    func blurBackgroundImgView(frame: CGRect) {
        let bgBlurImg = UIImageView(frame: frame)
        bgBlurImg.image = UIImage(named: "ielts12academicbookBlur")
        self.view.addSubview(bgBlurImg)
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bgBlurImg.frame
        self.view.addSubview(blurView)
    }

    func setTableView() {
        let topMargin: CGFloat = 64
        var vframe = self.view.frame
        vframe.size.height -= topMargin
        
        blurBackgroundImgView(frame: vframe)
        
        tableView = UITableView(frame: vframe, style: .grouped)
        tableView!.delegate = self
        tableView!.dataSource = self
        //浮点数比较版本号，效率高
//        if NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_9_0 {
//            tableView.contentInset = UIEdgeInsetsMake(64 , 0, 0, 0);
//        }
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.dataList?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "cellOfPracticeTestMainList"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseId)
        }
        let arr = self.dataList![indexPath.section]
        cell?.textLabel?.text = arr[indexPath.row]
        
        if hasDownloadedAudio {
            cell?.accessoryView =  nil
            cell?.accessoryType = .detailDisclosureButton
        } else {
            cell?.accessoryView = UIImageView(image: UIImage(named: "ic_audio_download"))
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if hasDownloadedAudio {
            let arr = self.dataList![indexPath.section]
            let fileName = arr[indexPath.row]
            let listeningDetail = ZQListeningDetailViewController(index: ieltsIndex, fileName: fileName) 
            self.navigationController?.pushViewController(listeningDetail, animated: true)
        } else {
            download()
        }
    }

    func download() {
        let executeCode = { () in
            self.view.addSubview(self.progressView)
            self.showProgress(progress: 0.01)
            
            self.downloadObj.download(index: self.ieltsIndex, progress: { [weak self] (progressVal) in
                self?.showProgress(progress: progressVal * 100)
            }) { [weak self] (err, filePath, unzipDir) in
                
                if err != nil {
                    self?.dismissProgress()
                    self?.showAlert(msg: (err?.description)!)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    self?.progressView.setHintText(text: "解压中...")
                })
                
                //解压下载的文件
                let succeed = SSZipArchive.unzipFile(atPath: filePath!, toDestination: unzipDir!)
                if succeed {
                    ZQDownloadFiles.changeDirName(ieltsIndex: (self?.ieltsIndex)!)
                    self?.checkAudioFilesExist()
                    self?.tableView.reloadData()
                }
                self?.dismissProgress()
            }
        }
        
        if !isWifiConnection {
            let alertController = UIAlertController(title: nil, message: "您正在使用数据流量下载，确定要下载吗？", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                executeCode()
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            })
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        executeCode()
    }
    
    func showProgress(progress: Double) {
        self.progressView.processing(progressNumber: CGFloat(progress))
    }
    
    func dismissProgress() {
        self.progressView.dismiss()
        self.progressView.removeFromSuperview()
    }
    
    // MARK: 网络监听
    func listenToNetwork() {
        let reachability = Reachability()!
        NotificationCenter.default.addObserver(self, selector: #selector(networkReachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    @objc
    func networkReachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            isWifiConnection = true
            break;
        case .cellular:
            isWifiConnection = false
            break;
        case .none:
            showAlert(msg: "Your network is unavailable, check your network please.")
            break;
        }
    }
    
    func showAlert(msg: String)  {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
