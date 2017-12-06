//
//  ViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
// https://ielts.etest.edu.cn/showTestCenters  雅思考点查询



import UIKit

class ZQHomeListViewController: ZQViewController,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private var collectionView: UICollectionView?
    private let collectionViewCellReuseIdentifier: String = "collectionViewCell_Reuse_Identifier"
    private let collectionViewCellReuseIdentifierList0: String = "collectionViewCell_Reuse_Identifier_list0"
    private let collectionViewCellReuseIdentifierList1: String = "collectionViewCell_Reuse_Identifier_list1"
    private var collectionViewCellSize = CGSize()
    private let minimumSpacing: CGFloat = 6
    
    private lazy var dataList: Array<ZQPlistCommonModel> = Array<ZQPlistCommonModel>()
    
    private let englishWithIELTS12: String = "EnglishWithIELTS_12"
    private let englishWithIELTS11: String = "EnglishWithIELTS_11"
    
    //private let englishWithLucyKey: String = "englishWithLucy_UserDefaults_Key"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleLabel()
        readDataInPlist()
        setFlowCollectionView()
    }
    
    func setTitleLabel() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = "嗨，世界！"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
    }
    
    func setFlowCollectionView() {
        let superViewSize = self.viewframe.size
        
        
        let flowLayout = ZQWaterFallViewLayout()
        flowLayout.minimumLineSpacing = minimumSpacing
        flowLayout.minimumInteritemSpacing = minimumSpacing
        flowLayout.headerReferenceSize = CGSize()
        flowLayout.footerReferenceSize = CGSize()
        
        var collectionViewRect = self.viewframe
        collectionViewRect.origin.x = 0
        collectionViewRect.origin.y = 0
        collectionView = UICollectionView(frame: collectionViewRect, collectionViewLayout: flowLayout)
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.layer.cornerRadius = 7
        collectionView?.contentSize.width = 0
        
        //注册cell
        let itemWidth = (superViewSize.width - minimumSpacing * 3) / 2
        let itemHeight = itemWidth
        collectionViewCellSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView!.register(ZQHomeListCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)
       
        collectionView!.register(ZQListCollectionViewCell0.self, forCellWithReuseIdentifier: collectionViewCellReuseIdentifierList0)
        
        collectionView?.register(ZQListCollectionViewCell1.self, forCellWithReuseIdentifier: collectionViewCellReuseIdentifierList1)
        
        self.addSubview(collectionView!)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataList[indexPath.row]
        if model.cellType == .customHeightCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifierList0, for: indexPath) as! ZQListCollectionViewCell0
            cell.updateModel(model: model)
            return cell
        } else if model.cellType == .halfLengCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifier, for: indexPath) as! ZQHomeListCollectionViewCell
            cell.updateModel(model: model)
            return cell
        } else if model.cellType == .soloTextCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifierList1, for: indexPath) as! ZQListCollectionViewCell1
            cell.updateModel(model: model)
            if model.eventType == .cellEventExamSpots {
                cell.updateBackgroundColor(withColor: UIColor.getColorByRed(227, green: 25, blue: 54))
            } else {
                cell.updateBackgroundColor(withColor: UIColor.getColorByRed(51, green: 153, blue: 204))
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(minimumSpacing, minimumSpacing, minimumSpacing, minimumSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataList[indexPath.row]
        if model.cellType == .customHeightCell {
            return CGSize(width: collectionViewCellSize.width, height: collectionViewCellSize.height * 1.4)
        } else if model.cellType == .halfLengCell {
            return collectionViewCellSize
        } else if model.cellType == .soloTextCell {
            return CGSize(width: collectionViewCellSize.width, height: 45)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        
        //如果是雅思
        if isIELTSCell(indexPath) {
            var ieltsIndex: Int = 11
            if model.title == englishWithIELTS12 {
                ieltsIndex = 12
            }
            let listeningView = ZQPracticeTestListeningListViewController(index: ieltsIndex)
            listeningView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(listeningView, animated: true)
        } else if model.eventType == .cellEventExamSpots {
            let examVenues = ZQExamVenuesQueryViewController()
            examVenues.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(examVenues, animated: true)
        } else {
            
            //其他的都是视频播放
            let videoPlayer = ZQVideoPlayerViewController(url: model.videoURL!)
            videoPlayer.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(videoPlayer, animated: true)
        }
    }
    
    // 是否是雅思cell
    func isIELTSCell(_ indexPath: IndexPath) -> Bool {
        let model = dataList[indexPath.row]
        if model.title == englishWithIELTS12 || model.title == englishWithIELTS11 {
            return true
        }
        return false
    }
    
    func readDataInPlist() {
        dataList = Array<ZQPlistCommonModel>()
        
        //添加雅思12的听力
        let modelIELTS12 = ZQPlistCommonModel()
        modelIELTS12.title = englishWithIELTS12
        modelIELTS12.thumbnail = "ielts12academicbook"
        modelIELTS12.detailedText = "IELTS 12 学术型真题"
        modelIELTS12.cellType = .soloTextCell
        dataList.append(modelIELTS12)
        
        //添加雅思11的听力
        let modelIELTS11 = ZQPlistCommonModel()
        modelIELTS11.title = englishWithIELTS11
        modelIELTS11.thumbnail = "ielts11academicbook"
        modelIELTS11.cellType = .customHeightCell
        dataList.append(modelIELTS11)
        
        //添加雅思中国的考点信息
        let modelIELTSSpot = ZQPlistCommonModel()
        modelIELTSSpot.detailedText = "雅思中国的考点信息"
        modelIELTSSpot.cellType = .soloTextCell
        modelIELTSSpot.eventType = .cellEventExamSpots
        dataList.append(modelIELTSSpot)

        let englishWithLucyPath = Bundle.main.path(forResource: "englishWithLucy", ofType: "plist")
        let array = NSArray(contentsOfFile: englishWithLucyPath!) as? Array<Dictionary<String, String>>
        if array != nil {
            for item in array! {
                dataList.append(ZQPlistCommonModel(dict: item))
            }
            collectionView?.reloadData()
        }
    
//        ZQCommonUtility.inUserDefaultsSet(value: fullpath, forKey: englishWithLucyKey)
    }
    
//    func alert(errStr: String) {
//        let alertC = UIAlertController(title: nil, message: errStr, preferredStyle: .alert)
//        let actionOk = UIAlertAction(title: "重新下载", style: .default) { (alertAction) in
//            //self.downloadRes()
//        }
//        let actionCancel = UIAlertAction(title: "取消", style: .cancel) { (alertAction) in
//        }
//        alertC.addAction(actionOk)
//        alertC.addAction(actionCancel)
//        self.present(alertC, animated: true, completion: nil)
//    }
    
    
    //    // MARK: 下载资源
    //    func downloadRes() {
    //        let urlStr = "http://hi-world.oss-cn-beijing.aliyuncs.com/plist/englishwithlucy.plist?Expires=1510305065&OSSAccessKeyId=TMP.AQHkykRn3QgZsw_dF2h35SFpX5l45Pr3h3NdxkoFZYtSwZx2vD6z7sgV0mQVAAAwLAIURb0CmKvL7Pv9kicISWr4MRAKtfwCFDHJ8oSEnUZOXYLGKdZEkpQ3Qavc&Signature=S6vAZCeatNoKeuljCtGb8l%2FUfBg%3D"
    //
    //        let download = ZQDownloadFiles()
    //        download.download(urlStr: urlStr, filename: "englishwithlucy.plist", progress: { (progressVal: Double) in
    //            print("progress=\(progressVal)")
    //        }) { [weak self](error, fullpath, path) in
    //            if error != nil {
    //                self?.alert(errStr: error!)
    //            } else {
    //                self?.parsePlist(fullpath: fullpath!)
    //            }
    //        }
    //    }
    
    
    
    
    /*
    // MARK: 第一种 瓷砖布局
    func setTiledLayout() {
        let frame = self.viewframe
        
        //雅思12
        let i12W: CGFloat = frame.size.width / 2
        let i12H: CGFloat = frame.size.height / 3
        let ielts12View = UIView(frame: CGRect(x: 0, y: 0, width: i12W, height: i12H))
        self.addSubview(ielts12View)
        
        //雅思11
        let ielts11View = UIView(frame: CGRect(x: i12W, y: 0, width: i12W, height: i12H)) 
        self.addSubview(ielts11View)
        
        //雅思12
        let imgX: CGFloat = 30
        let imgY: CGFloat = 25
        let imgW: CGFloat = i12W - imgX * 2
        let imgH: CGFloat = i12H - imgY * 2
        let imgRect = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
        let i12Img = UIImageView(frame: imgRect)
        i12Img.image = UIImage(named: "ielts12academicbook")
        ielts12View.addSubview(i12Img)
        
        //雅思11
        let i11Img = UIImageView(frame: imgRect)
        i11Img.image = UIImage(named: "ielts11academicbook")
        ielts11View.addSubview(i11Img)
        
        //雅思12
        let i12labW: CGFloat = ielts12View.frame.size.width
        let i12labH: CGFloat = 20
        let i12labY: CGFloat = ielts12View.frame.size.height - i12labH
        let i12lab = UILabel(frame: CGRect(x: 0, y: i12labY, width: i12labW, height: i12labH))
        i12lab.text = "剑桥雅思12真题"
        if ZQCommonUtility.is4inches() {
            i12lab.font = UIFont.systemFont(ofSize: 13)
        }
        i12lab.textColor = UIColor.white
        i12lab.textAlignment = .center
        ielts12View.addSubview(i12lab)
        
        //雅思11
        let i11lab = UILabel(frame: CGRect(x: 0, y: i12labY, width: i12labW, height: i12labH))
        i11lab.text = "剑桥雅思11真题"
        if ZQCommonUtility.is4inches() {
            i11lab.font = UIFont.systemFont(ofSize: 13)
        }
        i11lab.textColor = UIColor.white
        i11lab.textAlignment = .center
        ielts11View.addSubview(i11lab)
        
        let i12ClickX: CGFloat = 21
        let i12ClickY: CGFloat = 17
        let i12ClickW: CGFloat = i12W - i12ClickX * 2
        let i12ClickH: CGFloat = (i12H - i12ClickY * 2) + i12labH
        let i12Click = UIView(frame: CGRect(x: i12ClickX, y: i12ClickY, width: i12ClickW, height: i12ClickH))
        i12Click.layer.borderColor = UIColor.lightGray.cgColor
        i12Click.layer.borderWidth = 0.5
        i12Click.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openIELTS12)))
        ielts12View.addSubview(i12Click)
        
        let i11Click = UIView(frame: CGRect(x: i12ClickX, y: i12ClickY, width: i12ClickW, height: i12ClickH))
        i11Click.layer.borderColor = UIColor.lightGray.cgColor
        i11Click.layer.borderWidth = 0.5
        i11Click.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openIELTS11)))
        ielts11View.addSubview(i11Click)
    }
    
    @objc func openIELTS12() {
        let listeningView = ZQPracticeTestListeningListViewController(index: 12)
        listeningView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(listeningView, animated: true)
    }
    
    @objc func openIELTS11() {
        let listeningView = ZQPracticeTestListeningListViewController(index: 11)
        listeningView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(listeningView, animated: true)
    }
     */

}

