//
//  ZQDiscoverViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 06/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//
//https://ielts.etest.edu.cn/showTestCenters  雅思考点查询

import UIKit


class ZQDiscoverViewController: ZQViewController, UITableViewDelegate, UITableViewDataSource, ZQDiscoverItemTableViewCellDelegate {

    private var tableView: UITableView!
    private var dataList: Array<ZQDiscoverItemModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleLabel()
        loadData()
        setTableView()
    }
    
    //模糊背景
    func blurBackgroundImgView(frame: CGRect) {
        let bgBlurImg = UIImageView(frame: frame)
        bgBlurImg.image = UIImage(named: "zq_audioplayer_background_5")
        self.view.addSubview(bgBlurImg)
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bgBlurImg.frame
        self.view.addSubview(blurView)
    }
    
    func setTableView() {
        var vframe = self.view.frame
        vframe.size.height -= 64
        
        blurBackgroundImgView(frame: vframe)
        
        tableView = UITableView(frame: vframe)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.backgroundColor = UIColor.clear
        tableView!.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView!.separatorStyle = .none
        tableView!.showsHorizontalScrollIndicator = false
        self.view.addSubview(tableView!)
    }

    func setTitleLabel() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = "发现"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
    }
    
    func loadData() {
        let model = ZQDiscoverItemModel()
        model.name = "树上栖息"
        model.time = "11:09"
        model.detailsText =  "向日葵的花姿虽然没有玫瑰那么浪漫，也没有百合那么纯净，但它阳光，明亮 \n 向日葵的花姿虽然没有玫瑰那么浪漫，也没有百合那么纯净，但它阳光，明亮"
        
        let model1 = ZQDiscoverItemModel()
        model1.name = "海洋的🐟"
        model1.time = "07:56"
        model1.detailsText =  "向图片都不会因为被拉伸或者缩放而出现失真。但是当图片的比例和 Button 的尺寸比例不一样时，这两种方式设置图片的效果就不一样了，拿下图的例子来说"
        
        let model2 = ZQDiscoverItemModel()
        model2.name = "所有移动开发者提供资讯服务"
        model2.time = "19:21"
        model2.detailsText =  "CocoaChina前身是全球成立最早规模最大的苹果开发中文站,现致力为所有移动开发者提供资讯服务、问答服务、代码下载、工具库及人才招聘服务。"

        dataList = Array<ZQDiscoverItemModel>()
        dataList?.append(model)
        dataList?.append(model1)
        dataList?.append(model2)
    }
    
    @objc func compose() {
        let mypost = ZQNewPostViewController()
        mypost.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mypost, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList == nil {
            return 0
        }
        return (dataList?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuse_identifier = "discover_item_reuse_identifier_cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuse_identifier) as? ZQDiscoverItemTableViewCell
        if cell == nil {
            cell = ZQDiscoverItemTableViewCell(style: .default, reuseIdentifier: reuse_identifier)
            cell?.discoverItemCellDelegate = self
        }
        let model = dataList![indexPath.row]
        cell?.updateModel(model: model)
        return cell!
    }
    
    func tableViewcellDidPraise(tableViewCell: ZQDiscoverItemTableViewCell) {
        let indexPath = tableView.indexPath(for: tableViewCell)
        tableView.reloadRows(at: [indexPath!], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
 
    }
    

}
