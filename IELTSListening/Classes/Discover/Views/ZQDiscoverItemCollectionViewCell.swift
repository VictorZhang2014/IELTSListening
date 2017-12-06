//
//  ZQDiscoverItemCollectionViewCell.swift
//  IELTSListening
//
//  Created by Victor Zhang on 18/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

public class ZQDiscoverItemCollectionViewCell: UICollectionViewCell {
    
    private var mainImg: UIImageView?
    private var impressionView: UIView?
    private var detailedText: UILabel?
    private var opBtnsView: UIView?
    private var btmLine: UIView?
    private var upvoteBtn: UIButton?
    private let cornerRadius: CGFloat = 5
    private let colorsArray: Array<UIColor> = [ UIColor.brown, UIColor.black, UIColor.green, UIColor.blue, UIColor.orange, UIColor.red, UIColor.purple, UIColor.cyan ]
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = cornerRadius
        
        //图片显示
        mainImg = UIImageView(frame: CGRect())
        mainImg!.backgroundColor = UIColor.white
        self.addSubview(mainImg!)
        
        //印象
        impressionView = UIView(frame: CGRect())
        impressionView!.backgroundColor = UIColor.clear
        self.addSubview(impressionView!)
        
        //添加三个子"印象"视图
        for _ in 1...3 {
            let implabel = UILabel(frame: CGRect())
            let tempIndex = Int(arc4random()%7)+1
            implabel.backgroundColor = colorsArray[tempIndex]
            implabel.textColor = UIColor.white
            implabel.alpha = 0.5
            implabel.layer.cornerRadius = cornerRadius
            implabel.layer.masksToBounds = true
            implabel.font = UIFont.systemFont(ofSize: 10)
            implabel.textAlignment = .center
            impressionView!.addSubview(implabel)
        }
        
        //发表的文字
        detailedText = UILabel(frame: CGRect())
        detailedText!.font = UIFont.systemFont(ofSize: 10)
        detailedText!.textColor = UIColor.gray
        detailedText!.numberOfLines = 2
        self.addSubview(detailedText!)
        
        //顶部操作按钮
        opBtnsView = UIView(frame: CGRect())
        opBtnsView!.backgroundColor = UIColor.clear
        //opBtnsView!.cornerRadiiWith(isTopLeft: false, isTopRight: false, isBottomLeft: true, isBottomRight: true, viewBounds: opBtnsView!.bounds, cornerRadius: cornerRadius)
        self.addSubview(opBtnsView!)
        
        //底部横线
        btmLine = UIView(frame: CGRect())
        btmLine!.backgroundColor = UIColor.defaultLightGray
        opBtnsView!.addSubview(btmLine!)
        
        //点赞
        upvoteBtn = UIButton(frame: CGRect())
        upvoteBtn!.setTitle("赞", for: .normal)
        upvoteBtn!.setImage(UIImage(named: "zq_btm_icn_praise"), for: .normal)
        upvoteBtn!.setTitleColor(UIColor.gray, for: .normal)
        upvoteBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        opBtnsView!.addSubview(upvoteBtn!)
        
        updateViewsFrame();
    }
    
    func updateViewsFrame() {
        
        //图片
        let mainImgWidth: CGFloat = frame.size.width
        let mainImgHeight: CGFloat = mainImgWidth * 1.1
        let mainImgFrame = CGRect(x: 0, y: 0, width: mainImgWidth, height: mainImgHeight)
        mainImg!.frame = mainImgFrame
        mainImg!.cornerRadiiWith(isTopLeft: true, isTopRight: true, isBottomLeft: false, isBottomRight: false, viewBounds: mainImg!.bounds, cornerRadius: cornerRadius)
        
        //印象
        impressionView!.frame = CGRect(x: 10, y: 20, width: 50, height: 51)
        var subviewY: CGFloat = 0
        var subviewIndex: CGFloat = 0
        for subview in impressionView!.subviews {
            subviewY = (15 + 2) * subviewIndex
            let label = subview as! UILabel
            label.frame = CGRect(x: 0, y: subviewY, width: 50, height: 15)
            subviewIndex += 1
        }
        
        //发表的文字
        let margin: CGFloat = 8
        let detailedTextY: CGFloat = mainImgHeight
        let detailedTextHeight: CGFloat = mainImgWidth * 0.2
        let detailedTextWidth: CGFloat = mainImgWidth - margin * 2
        let detailedTxtFrame = CGRect(x: margin, y: detailedTextY, width: detailedTextWidth, height: detailedTextHeight)
        detailedText!.frame = detailedTxtFrame
        
        //顶部操作按钮
        let opBtnsViewY: CGFloat = detailedTextY + detailedTextHeight
        let opBtnsViewHeight: CGFloat = mainImgWidth * 0.2
        let opBtnsViewFrame = CGRect(x: 0, y: opBtnsViewY, width: mainImgWidth, height: opBtnsViewHeight)
        opBtnsView!.frame = opBtnsViewFrame
        
        //底部横线
        let btmLineX: CGFloat = margin
        let btmLineW: CGFloat = mainImgWidth - btmLineX * 2
        btmLine!.frame = CGRect(x: btmLineX, y: 0, width: btmLineW, height: 0.5)
        
        //点赞
        let btnY: CGFloat = 7
        let btnH: CGFloat = opBtnsViewFrame.size.height - btnY * 2
        let btnW: CGFloat = btnH * 3
        let btnX: CGFloat = (opBtnsViewFrame.size.width - btnW) / 2
        upvoteBtn!.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
    }
    
    func updateModel(model: ZQLiveMeVideoInfoModel) {
        
        //let origImgSize = mainImg!.frame.size
        mainImg?.sd_setImage(with: URL(string: model.videocapture!), placeholderImage: UIImage(named: "zq_icn_img_loading"), options: .continueInBackground, completed:
            {
                /*[weak self]*/ (image, error, cacheType, url) in
                //if image != nil {
                //    //重新计算图片的大小
                //    self?.mainImg!.image = image?.resizeImage(size: origImgSize)
                //}
        })
        
        detailedText?.text = model.title! + ", " + model.addr! + " \n " + model.uname!
        
        //添加印象的标签内容
        if let impressionTags = model.impression {
            var index = 0
            for impModel: ZQLiveMeVideoInfoImpressionModel in impressionTags {
                let label = (impressionView!.subviews[index]) as! UILabel
                label.text = impModel.tag_name
                index += 1
            }
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("ZQHomeListCollectionViewCell init(coder:) has not been implemented")
    }
    
}


public class ZQDiscoverCollectionHeaderView: UICollectionViewCell {
    
    class ZQDiscoverCollectionHeaderViewCountryBtn: UIButton {
        
        private var bottomView: UIView?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        init(frame: CGRect, index: Int, country: String) {
            super.init(frame: frame)
            
            self.setTitle(country, for: .normal)
            self.setTitleColor(UIColor.gray, for: .normal)
            self.setTitleColor(UIColor.lightRed, for: .selected)
            self.titleLabel!.font = UIFont.systemFont(ofSize: 14)
            self.titleLabel!.textAlignment = .center
            self.tag = index
            
            var bottomLineFrame = frame
            bottomLineFrame.size.height = 1
            bottomLineFrame.origin.x = 8
            bottomLineFrame.origin.y = frame.size.height - 1
            bottomLineFrame.size.width -= (bottomLineFrame.origin.x * 2)
            bottomView = UIView(frame: bottomLineFrame)
            bottomView!.backgroundColor = UIColor.lightRed
            bottomView!.tag = index
            bottomView!.isHidden = true
            self.addSubview(bottomView!)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("ZQDiscoverCollectionHeaderViewCountryBtn init(coder:) has not been implemented")
        }
        
        func beSelected(_ selected: Bool) {
            isSelected = selected
            bottomView!.isHidden = !selected
        }
    }
    
    
    private var scrollView: UIScrollView?
    private var countriesBtn = Array<ZQDiscoverCollectionHeaderViewCountryBtn>()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.defaultLightGray
        
        var scrFrame = frame
        scrFrame.origin.x = 0
        scrFrame.origin.y = 0
        scrollView = UIScrollView(frame: scrFrame)
        scrollView!.showsVerticalScrollIndicator = false
        scrollView!.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView!)
        
        let btnW: CGFloat = frame.size.width / 4
        let btnH: CGFloat = frame.size.height
        var btnFrame = CGRect(x: 0, y: 0, width: btnW, height: btnH)
        let cnCountries = ZQLiveDataDownload.cn_countries
        for (index, country) in cnCountries.enumerated() {
            btnFrame.origin.x = CGFloat(index) * btnW
            let button = ZQDiscoverCollectionHeaderViewCountryBtn(frame: btnFrame, index: index, country: country)
            button.addTarget(self, action: #selector(chooseCountry(_:)), for: .touchUpInside)
            scrollView!.addSubview(button)
            countriesBtn.append(button)
        }
        
        countriesBtn[0].beSelected(true)
        
        scrollView!.contentSize = CGSize(width: btnW * CGFloat(cnCountries.count), height: scrFrame.size.height)
        scrollView!.isPagingEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("ZQDiscoverCollectionHeaderView init(coder:) has not been implemented")
    }
    
    @objc func chooseCountry(_ button: UIButton) {
        let btnsCount = countriesBtn.count
        for index in stride(from: 0, to: btnsCount, by: 1) {
            countriesBtn[index].beSelected(false)
        }
        countriesBtn[button.tag].beSelected(true)
        
        let country = ZQLiveDataDownload.en_countries[button.tag]
        NotificationCenter.default.post(name: Notification.Name.kUIEventLiveInCountrySwitchover, object: nil, userInfo: [ "country" : country ])
    }
}



public class ZQDiscoverCollectionFooterView: UICollectionViewCell {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.defaultLightGray
        
        let loadBGView = UIView()
        loadBGView.translatesAutoresizingMaskIntoConstraints = false
        loadBGView.backgroundColor = UIColor.clear
        loadBGView.layer.cornerRadius = 6
        loadBGView.layer.borderColor = UIColor.gray.cgColor
        loadBGView.layer.borderWidth = 0.5
        self.addSubview(loadBGView)
        let topViews = [ "loadBGView" : loadBGView ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(6)-[loadBGView]-(6)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: topViews))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[loadBGView]-(0)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: topViews))
        
        let loadMore = UIButton()
        loadMore.translatesAutoresizingMaskIntoConstraints = false
        loadMore.setTitle("加载更多", for: .normal)
        loadMore.setTitleColor(UIColor.gray, for: .normal)
        loadMore.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        loadMore.titleLabel!.textAlignment = .center
        loadMore.addTarget(self, action: #selector(didClickLoadMore(_:)), for: .touchUpInside)
        loadBGView.addSubview(loadMore)
        let btnViews = [ "loadMore" : loadMore ]
        loadBGView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[loadMore]-(0)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: btnViews))
        loadBGView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[loadMore]-(0)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: btnViews))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("ZQDiscoverCollectionFooterView init(coder:) has not been implemented")
    }
    
    @objc func didClickLoadMore(_ button: UIButton) {
        
    }
    
}
