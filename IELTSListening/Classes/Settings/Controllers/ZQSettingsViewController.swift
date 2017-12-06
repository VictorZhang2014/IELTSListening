//
//  ZQSettingsViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 06/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit


class ZQSettingsViewController: ZQViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    private var dataList: Array<Array<String>>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.defaultLightGray
        
        setTitleLabel()
        loadDataList()
        setTableView()
        
    }
    
    func setTitleLabel() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = "我"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
    }
    
    func loadDataList()  {
        dataList = [
                    ["我的头像"],
                    
                    [ /*"我的动态",*/
                      "语言切换",
                      "清除缓存"],
                     
                     ["意见反馈",
                     "分享雅思精听",
                     "为应用点赞"],
                     
                     ["关于 - 嗨！世界"]
                    ]
    }
    
    func setTableView() {
        let superframe = self.viewframe
        tableView = UITableView(frame: superframe, style: .grouped)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.layer.cornerRadius = 7
        tableView!.backgroundColor = UIColor.clear
        self.addSubview(tableView!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.dataList?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataList?[section].count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if indexPath.section == 0 {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.imageView?.image = UIImage(named: "ic_default_general")
            cell.textLabel?.text = "点击登录"
            cell.detailTextLabel?.text = ""
        } else {
            let subArr = self.dataList![indexPath.section]
            cell.textLabel?.text = subArr[indexPath.row]
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let arr1 = self.dataList![indexPath.section]
        let rowTitle = arr1[indexPath.row]
        
        if indexPath.section == 0 {
            let myDetail = ZQMyDetailViewController()
            myDetail.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myDetail, animated: true)
        } else if indexPath.section == 1 {
            
//            if indexPath.row == 0 {
//                let mypost = ZQMyPostViewController()
//                mypost.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(mypost, animated: true)
//
//            } else
            if indexPath.row == 0 {
                let languageSwitch = ZQLanguageSwitchViewController()
                languageSwitch.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(languageSwitch, animated: true)
                
            } else if indexPath.row == 1 {
                cleanCaches()
            }
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                
            } else if indexPath.row == 1 {
                
            } else if indexPath.row == 2 {
                UIApplication.shared.openURL(URL(string: "https://ielts-listening-20171005.firebaseapp.com/")!)
            }
            
        } else if indexPath.section == 3 {
            let aboutVC = ZQAboutAppViewController()
            aboutVC.titleStr = rowTitle
            aboutVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(aboutVC, animated: true)
        }
    }
    
    func cleanCaches() {
        let mbSize = ZQCommonUtility.getAudioDirectoriesAndFilesSize()
        
        let alert = UIAlertController(title: nil, message: "一共\(mbSize)MB的缓存大小，确定要清除吗？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "立即清除", style: .default) { (action) in
            ZQCommonUtility.removeAllAudioFiles()
        })
        alert.addAction(UIAlertAction(title: "以后再说吧", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(msg: String)  {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

