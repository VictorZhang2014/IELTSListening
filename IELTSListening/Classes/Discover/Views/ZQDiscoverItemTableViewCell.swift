//
//  ZQDiscoverItemTableViewCell.swift
//  IELTSListening
//
//  Created by Victor Zhang on 11/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit


@objc public protocol ZQDiscoverItemTableViewCellDelegate : NSObjectProtocol {
    
    // 点赞按钮点击了
    @objc optional func tableViewcellDidPraise(tableViewCell: ZQDiscoverItemTableViewCell)
    
}


public class ZQDiscoverItemTableViewCell: UITableViewCell {
    /*
     第一版规则是：
     正文：99字，不分中英文
     图片：一次允许1到9张
     视频：一次允许一个
     */
    
    private var coverView: UIView?
    private var avatar: UIImageView?        // 头像
    private var name: UILabel?              // 名字
    private var time: UILabel?              // 时间
    private var details: UILabel?           // 正文
    private var attachPics: Array<String>?  // 附带图片名称集合，最多9张
    private var attachPicsView: UIView?     // 附带图片view
    private var attachVideo: UIView?        // 附带视频
    private var toolView: UIView?           // 点赞，评论的view
    private var praisedBtn: UIButton?       // 点赞按钮
    
    public weak var discoverItemCellDelegate: ZQDiscoverItemTableViewCellDelegate?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        
        // 背景
        let coverX: CGFloat = 5
        let coverY: CGFloat = 5
        let coverWidth = UIScreen.main.bounds.size.width - coverX * 2
        let coverHeight: CGFloat = getHeight() - coverY
        coverView = UIView(frame: CGRect(x: coverX, y: 0, width: coverWidth, height: coverHeight))
        coverView!.backgroundColor = UIColor.white
        coverView!.layer.cornerRadius = 10
        self.contentView.addSubview(coverView!)
        
        let margin: CGFloat = 6
        
        // 头像
        let avatarW: CGFloat = 35
        let avatarH: CGFloat = avatarW
        let avatarX: CGFloat = margin
        let avatarY: CGFloat = margin
        avatar = UIImageView(frame: CGRect(x: avatarX, y: avatarY, width: avatarW, height: avatarH))
        avatar?.image = UIImage(named: "ic_default_general")
        avatar?.layer.cornerRadius = avatarW / 2
        avatar?.clipsToBounds = true
        coverView!.addSubview(avatar!)
        
        // 名字的view
        let nameX: CGFloat = avatarW  + margin * 2
        let nameW: CGFloat = coverWidth - nameX - margin
        let nameH: CGFloat = 22
        let nameY = avatarY
        let nameView = UIView(frame: CGRect(x: nameX, y: nameY, width: nameW, height: nameH))
        nameView.backgroundColor = UIColor.clear
        coverView!.addSubview(nameView)
        
        //名字
        let nameWidth = nameW * 0.75
        name = UILabel(frame: CGRect(x: 0, y: 0, width: nameWidth, height: nameH))
        name?.textColor = UIColor.lightBlue
        name?.font = UIFont.systemFont(ofSize: 13)
        name?.textAlignment = .left
        nameView.addSubview(name!)
        
        //时间
        let timeWidth = nameW * 0.25
        let timeXaxis = nameW - timeWidth
        time = UILabel(frame: CGRect(x: timeXaxis, y: 0, width: timeWidth, height: nameH))
        time?.textColor = UIColor.lightGray
        time?.font = UIFont.systemFont(ofSize: 10)
        time?.textAlignment = .right
        nameView.addSubview(time!)
        
        // 正文
        let detailsX: CGFloat = avatarX * 2 + avatarW
        let detailsY: CGFloat = nameY * 2 + nameH
        let detailsW: CGFloat = coverWidth - detailsX - margin
        let detailsH: CGFloat = 45
        details = UILabel(frame: CGRect(x: detailsX, y: detailsY, width: detailsW, height: detailsH))
        details?.textColor = UIColor.lightGray
        details?.font = UIFont.systemFont(ofSize: 12)
        details?.textAlignment = .left
        details?.numberOfLines = 0
        coverView?.addSubview(details!)
        
        // 图片集
        let viewImgX: CGFloat = detailsX
        let viewImgY: CGFloat = detailsY + detailsH + margin
        let viewImgW: CGFloat = coverWidth - viewImgX - margin * 2
        let viewImgH: CGFloat = viewImgW
        attachPicsView = UIView(frame: CGRect(x: viewImgX, y: viewImgY, width: viewImgW, height: viewImgH))
        //        attachPicsView?.backgroundColor = UIColor.cyan
        coverView?.addSubview(attachPicsView!)
        
        let imgItemSpace: CGFloat = 4
        var imgItemX: CGFloat = 0
        var imgItemY: CGFloat = 0
        let imgItemW: CGFloat = (viewImgW - imgItemSpace * 4) / 3
        let imgItemH: CGFloat = imgItemW
        for index1 in 0..<3 {
            imgItemX = CGFloat(index1) * (imgItemW + imgItemSpace) + imgItemSpace
            for index2 in 0..<3 {
                imgItemY = CGFloat(index2) * (imgItemW + imgItemSpace) + imgItemSpace
                let imgItem = UIImageView(frame: CGRect(x: imgItemX, y: imgItemY, width: imgItemW, height: imgItemH))
                imgItem.backgroundColor = UIColor.defaultLightGray
                imgItem.image = UIImage(named: "zq_icn_img_loading")
                attachPicsView?.addSubview(imgItem)
            }
        }
        
        // 视频
        
        //点赞，评论的view
        let tlX: CGFloat = nameX
        let tlY: CGFloat = viewImgY + viewImgH + 7
        let tlW: CGFloat = viewImgW
        let tlH: CGFloat = 30
        toolView = UIView(frame: CGRect(x: tlX, y: tlY, width: tlW, height: tlH))
        toolView?.backgroundColor = UIColor.clear
        coverView?.addSubview(toolView!)
        
        // 点赞
        let likeBtnW: CGFloat = tlW / 3
        let likeBtnY: CGFloat = 3
        let likeBtnH: CGFloat = tlH - likeBtnY * 2
        praisedBtn = UIButton(frame: CGRect(x: 0, y: likeBtnY, width: likeBtnW, height: likeBtnH))
        praisedBtn!.setImage(UIImage(named: "zq_btm_icn_praise"), for: .normal)
        praisedBtn!.setImage(UIImage(named: "zq_btm_icn_praised"), for: .selected)
        praisedBtn?.addTarget(self, action: #selector(praiseClick(_:)), for: .touchUpInside)
        toolView?.addSubview(praisedBtn!)
        
//        // 评论
//        let cmtBtn = UIButton(frame: CGRect(x: likeBtnW, y: likeBtnY, width: likeBtnW, height: likeBtnH))
//        cmtBtn.setImage(UIImage(named: "zq_btm_icn_comment"), for: .normal)
//        cmtBtn.setImage(UIImage(named: "zq_btm_icn_commented"), for: .selected)
//        toolView?.addSubview(cmtBtn)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("ZQDiscoverTableViewCell init(coder:) has not been implemented")
    }
    
    @objc func praiseClick(_ button: UIButton) {
        praisedBtn!.image(for: .selected)
        
        if (self.discoverItemCellDelegate?.responds(to: #selector(discoverItemCellDelegate?.tableViewcellDidPraise(tableViewCell:))))! {
            self.discoverItemCellDelegate?.tableViewcellDidPraise!(tableViewCell: self)
        }
    }
    
    func updateModel(model: ZQDiscoverItemModel) {
        name?.text = model.name
        time?.text = model.time
        details?.text = model.detailsText
        
        if model.attachedPics != nil && (model.attachedPics?.count)! > 0 {
            for picPath in attachPics! {
                
            }
        }
         
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getHeight() -> CGFloat {
        return 450
    }

}
