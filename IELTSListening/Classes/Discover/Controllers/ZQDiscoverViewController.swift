//
//  ZQDiscoverViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 06/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//
//

/*
 
 Girls
 https://live.ksmobile.net/live/girls?countryCode=US&page=1&pagesize=20&page_index=1&page_size=20
 https://live.ksmobile.net/live/girls?countryCode=US&page=2&pagesize=20&page_index=2&page_size=20
 
 Boys
 https://live.ksmobile.net/live/boys?countryCode=US&page=1&pagesize=20&page_index=1&page_size=20
 
 Talent
 https://live.ksmobile.net/live/talent?countryCode=US&page=1&pagesize=20
 
 Global
 USA
 https://live.ksmobile.net/live/featurelist?page_index=1&page_size=20
 Indonesia
 https://live.ksmobile.net/live/featurelist?countryCode=ID&page_index=1&page_size=20
 Vietnam
 https://live.ksmobile.net/live/featurelist?countryCode=VN&page_index=1&page_size=20
 Indian
 https://live.ksmobile.net/live/featurelist?countryCode=IN&page_index=1&page_size=20
 The Greater British
 https://live.ksmobile.net/live/featurelist?countryCode=GB&page_index=1&page_size=20
 Canada
 https://live.ksmobile.net/live/featurelist?countryCode=CA&page_index=1&page_size=20
 Japan
 https://live.ksmobile.net/live/featurelist?countryCode=JP&page_index=1&page_size=20
 Taiwan
 https://live.ksmobile.net/live/featurelist?countryCode=TW&page_index=1&page_size=20
 Ukraine
 https://live.ksmobile.net/live/featurelist?countryCode=UA&page_index=1&page_size=20
 France
 https://live.ksmobile.net/live/featurelist?countryCode=FR&page_index=1&page_size=20
 Russia
 https://live.ksmobile.net/live/featurelist?countryCode=RU&page_index=1&page_size=20
 
 
 获取直播博主信息
 https://live.ksmobile.net/user/getinfo?userid=800362426452541440
 https://live.ksmobile.net/user/getinfo?userid=839205163196874752
 "https://live.ksmobile.net/user/getinfo/userid=835239403625906176"
 */

import UIKit
import MJRefresh

/*
    func updateModel1() {
        //YouTube播放层
        let ytPlayer = YTPlayerView()
        ytPlayer.frame = mainImg!.bounds
        //ytPlayer!.delegate = self
        mainImg!.addSubview(ytPlayer)
        
        let ytVideoId = "uhzGUrRB0R8"
        
        //加载视频
        let playerVars = [ "playsinline": 1 ] //参数的意思是，在指定是view中播放
        ytPlayer.load(withVideoId: ytVideoId, playerVars: playerVars)
    }

*/


class ZQDiscoverViewController: ZQViewController,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //当前界面的数据
    private var dataList: Array<ZQLiveMeVideoInfoModel>?
    
    //缓存每个国家的已下载的数据
    private lazy var dataDict: Dictionary<String, Array<ZQLiveMeVideoInfoModel>> = Dictionary<String, Array<ZQLiveMeVideoInfoModel>>()
    
    private var collectionView: UICollectionView?
    private var collectionViewCellSize = CGSize()
    private var countryDataCount: Int = 40 //每个国家最多40个直播
    
    private let collectionViewCellReuseIdentifier: String = "Discover_CollectionViewCell_Reuse_Identifier"
    private let collectionHeaderViewCellIdentifier: String = "Discover_CollectionHeaderViewCell_Identifier"
    private let collectionFooterViewCellIdentifier: String = "Discover_CollectionFooterViewCell_Identifier"

    private let minimumSpacing: CGFloat = 6
    
    //数据加载提示层
    private var loadingView: ZQLoadingBackgroundView?
    
    //当前选中的国家的数据
    private var currentCountry: String = ZQLiveDataDownload.en_countries.first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = Array<ZQLiveMeVideoInfoModel>()
        
        setTitleLabel()
        setLoadinView()
        loadData(byLiveType: .girls, withCountryType: .USA, atPage: 1)
        setFlowCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(liveInCountrySwitching(_:)), name: Notification.Name.kUIEventLiveInCountrySwitchover, object: nil)
    }
    
    // MARK: Notification
    @objc func liveInCountrySwitching(_ notification: Notification) {
        let userInfo = notification.userInfo
        if userInfo != nil {
            let country = userInfo!["country"] as! String
            if country == currentCountry {
                return
            }
            currentCountry = country
            
            refreshCurrentCountryDataList(currentCountry)
        }
    }
    
    func refreshCurrentCountryDataList(_ countryName: String) {
        var pageIndex = 1
        
        //如果有数据，就读取缓存的数据，反之，就去下载，这里做的，只能翻两页
        if let tmpDataList = self.dataDict[currentCountry] {
            self.dataList = tmpDataList
            if (self.dataList?.count)! >= countryDataCount {
                self.collectionView?.reloadData()
                self.collectionView?.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            pageIndex = 2
        }
        
        let (livetype, livecountrytype) = ZQLiveDataDownload.getLiveType(currentCountry)
        loadData(byLiveType: livetype, withCountryType: livecountrytype, atPage: pageIndex)
    }

    // MARK: 从网络加载数据
    func loadData(byLiveType: ZQLiveDataType, withCountryType: ZQLiveInCountryType, atPage index: Int) {
        ZQLiveDataDownload().downloadLiveDataArray(byLiveType: byLiveType, withCountryType: withCountryType, atPage: index)  { (resultList, error) in
            DispatchQueue.main.async(execute: {
                
                if self.loadingView != nil {
                    self.loadingView?.removeFromSuperview()
                    self.loadingView = nil
                }
                
                if resultList != nil {
                    
                    if index == 2 {
                        for (_, item) in (resultList?.enumerated())! {
                            self.dataList!.append(item)
                        }
                    } else {
                        self.dataList = resultList
                    }
                    
                    //将下载的数据加入到数据缓存里
                    self.dataDict[self.currentCountry] = self.dataList!
                    
                    self.collectionView?.reloadData()
                } else {
                    self.alert(withMessage: error!)
                }
                
                self.collectionView?.mj_footer.endRefreshing()
            })
        }
    }
    
    func alert(withMessage: String) {
        let alert = UIAlertController(title: nil, message: withMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "好吧", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setTitleLabel() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = "发现 · 精彩"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose2))
    }
    
//    @objc func compose() {
//        let player = ZQYouTubePlayerViewController(videoId: "uhzGUrRB0R8")
//        player.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(player, animated: true)
//    }
//
//    @objc func compose2() {
//        let videoPlayer = ZQVideoPlayerViewController(url: "http://pl-ali.youku.com/playlist/m3u8?vid=XMjkwMjMwNTAxMg%3D%3D&type=flv&ups_client_netip=123.119.227.37&ups_ts=1509982843&utid=g7KEEj%2BufiYCAXtwUTfuxlSu&ccode=0502&psid=7c6e2e92d6fefc8993c28bb6954464bd&ups_userid=755692542&ups_ytid=755692542&duration=297&expire=18000&ups_key=b372f10e3ef0e428b9601eae3db85866")
//        videoPlayer.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(videoPlayer, animated: true)
//    }
    
    func setFlowCollectionView() {
        let superViewSize = self.viewframe.size
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = minimumSpacing
        flowLayout.minimumInteritemSpacing = minimumSpacing
        
        var collectionViewRect = self.viewframe
        collectionViewRect.origin.x = 0
        collectionViewRect.origin.y = 0
        collectionView = UICollectionView(frame: collectionViewRect, collectionViewLayout: flowLayout)
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.layer.cornerRadius = 7
        self.addSubview(collectionView!)
        
        let itemWidth = (superViewSize.width - minimumSpacing * 3) / 2
        let itemHeight = itemWidth * 1.5
        collectionViewCellSize = CGSize(width: itemWidth, height: itemHeight)
        
        //注册cell
        collectionView!.register(ZQDiscoverItemCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)
        
        //注册header
        collectionView?.register(ZQDiscoverCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeaderViewCellIdentifier)
        
//        //注册footer
//        collectionView?.register(ZQDiscoverCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: collectionFooterViewCellIdentifier)
        
        
        collectionView!.mj_footer = MJRefreshBackNormalFooter.init { [weak self] in
            self?.refreshCurrentCountryDataList((self?.currentCountry)!)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataList?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataList![indexPath.row]
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifier, for: indexPath) as! ZQDiscoverItemCollectionViewCell
        cell.updateModel(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(minimumSpacing, minimumSpacing, minimumSpacing, minimumSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.size.width - minimumSpacing * 2
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.size.width - minimumSpacing * 2
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
            // 头部view
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeaderViewCellIdentifier, for: indexPath)
            
            return headerView
//        } else {
//            // 底部view
//            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: collectionFooterViewCellIdentifier, for: indexPath)
//
//            return footerView
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataList![indexPath.row]
        
        let videoPlayer = ZQLiveVideoPlayerViewController(url: model.hlsvideosource!)
        videoPlayer.hostUserId = model.userid
        videoPlayer.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(videoPlayer, animated: true)
    }
    
    
    func setLoadinView() {
        var rect = self.view.frame
        rect.origin.x = 0
        rect.origin.y = 0
        loadingView = ZQLoadingBackgroundView(frame: rect)
        self.view.addSubview(loadingView!)
    }
    
}
