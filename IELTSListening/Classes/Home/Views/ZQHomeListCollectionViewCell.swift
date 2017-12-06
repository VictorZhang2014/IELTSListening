//
//  ZQHomeListCollectionViewCell.swift
//  IELTSListening
//
//  Created by Victor Zhang on 10/11/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit
import SDWebImage

public class ZQHomeListCollectionViewCell: UICollectionViewCell {
    
    private var mainImg: UIImageView?
    private var detailedText: UILabel?
    private var opBtnsView: UIView?
    private var btmLine: UIView?
    private var upvoteBtn: UIButton?
    
    private let cornerRadius: CGFloat = 5
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = cornerRadius
        
        //图片显示
        mainImg = UIImageView(frame: CGRect())
        mainImg!.backgroundColor = UIColor.white
        self.addSubview(mainImg!)
        
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
        upvoteBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        opBtnsView!.addSubview(upvoteBtn!)
        
        updateViewsFrame();
    }
    
    func updateViewsFrame() {
        
        //图片
        let mainImgWidth: CGFloat = frame.size.width
        let mainImgHeight: CGFloat = mainImgWidth * 0.6
        let mainImgFrame = CGRect(x: 0, y: 0, width: mainImgWidth, height: mainImgHeight)
        mainImg!.frame = mainImgFrame
        mainImg!.cornerRadiiWith(isTopLeft: true, isTopRight: true, isBottomLeft: false, isBottomRight: false, viewBounds: mainImg!.bounds, cornerRadius: cornerRadius)
        
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
    
    func updateModel(model: ZQPlistCommonModel) {
        //let origImgSize = mainImg!.frame.size
        mainImg?.sd_setImage(with: URL(string: model.thumbnail!), placeholderImage: UIImage(named: "zq_icn_img_loading"), options: .continueInBackground, completed:
            {
                /*[weak self]*/ (image, error, cacheType, url) in
                //if image != nil {
                //    //重新计算图片的大小
                    //self?.mainImg!.image = image?.resizeImage(size: origImgSize)
                //}
            })
        
        detailedText?.text = model.title
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("ZQHomeListCollectionViewCell init(coder:) has not been implemented")
    } 
    
}



// MARK: 就一张图片的Cell
public class ZQListCollectionViewCell0: UICollectionViewCell {
    
    private var mainImg: UIImageView?
    private let cornerRadius: CGFloat = 5
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        //self.layer.cornerRadius = cornerRadius
        
        mainImg = UIImageView(frame: CGRect())
        mainImg!.backgroundColor = UIColor.white
        self.addSubview(mainImg!)

        updateViewsFrame();
    }
    
    func updateViewsFrame() {
        let mainImgWidth: CGFloat = frame.size.width
        let mainImgHeight: CGFloat = frame.size.height
        let mainImgFrame = CGRect(x: 0, y: 0, width: mainImgWidth, height: mainImgHeight)
        mainImg!.frame = mainImgFrame
        mainImg!.cornerRadiiWith(isTopLeft: true, isTopRight: true, isBottomLeft: true, isBottomRight: true, viewBounds: mainImg!.bounds, cornerRadius: cornerRadius)
    }
    
    func updateModel(model: ZQPlistCommonModel) {
        mainImg?.image = UIImage(named: model.thumbnail!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("ZQListCollectionViewCell0 init(coder:) has not been implemented")
    }
    
}





public class ZQListCollectionViewCell1: UICollectionViewCell {
    
    private var detailedText: UILabel?
    private let cornerRadius: CGFloat = 5
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.getColorByRed(51, green: 153, blue: 204)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        let detailedTextFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        detailedText = UILabel(frame: detailedTextFrame)
        detailedText!.backgroundColor = UIColor.clear
        detailedText!.textColor = UIColor.white
        detailedText!.textAlignment = .center
        detailedText!.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(detailedText!)
    }
    
    func updateModel(model: ZQPlistCommonModel) {
        detailedText?.text = model.detailedText!
    }
    
    func updateBackgroundColor(withColor: UIColor) {
        self.backgroundColor = withColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("ZQListCollectionViewCell1 init(coder:) has not been implemented")
    }
}



