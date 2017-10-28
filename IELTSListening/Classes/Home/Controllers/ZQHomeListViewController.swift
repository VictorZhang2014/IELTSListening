//
//  ViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class ZQHomeListViewController: ZQViewController /*, UITableViewDelegate, UITableViewDataSource */ {
    
//    private var tableView: UITableView!
//    private var dataList: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleLabel()
        setTiledLayout()
        
    }
    
    func setTitleLabel() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = "雅思听力 - 精听真题"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
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
    
    // MARK: 第一种 瓷砖布局
    func setTiledLayout() {
        let frame = self.view.frame
        
        //模糊背景
        blurBackgroundImgView(frame: frame)
        
        //雅思12
        let i12W: CGFloat = frame.size.width / 2
        let i12H: CGFloat = frame.size.height / 3
        let ielts12View = UIView(frame: CGRect(x: 0, y: 0, width: i12W, height: i12H))
        self.view.addSubview(ielts12View)
        
        //雅思11
        let ielts11View = UIView(frame: CGRect(x: i12W, y: 0, width: i12W, height: i12H)) 
        self.view.addSubview(ielts11View)
        
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
    
    // MARK: 第二种 TableView布局
    /*
    func setTableView() {
        tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView!.delegate = self
        tableView!.dataSource = self
        self.view.addSubview(tableView!)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.dataList?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "cellOfPracticeTestMainList"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseId)
        }
        let txt = self.dataList![indexPath.section]
        cell?.textLabel?.text = txt
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let listeningView = ZQPracticeTestListeningListViewController(index: indexPath.section == 0 ? 12 : 11)
        self.navigationController?.pushViewController(listeningView, animated: true)
    }
     
     
     func loadDataList()  {
         dataList = [ "IELTS 12 Academic - 雅思12真题",
                         "IELTS 11 Academic - 雅思11真题",
                         //"IELTS 10 Academic - 雅思10真题"
                         ]
     }
    */

}

