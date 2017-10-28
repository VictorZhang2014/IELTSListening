//
//  ZQAudioSettingViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//  音频播放器的设置

import UIKit

class ZQAudioSettingViewController: ZQViewController, UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView!
    private var dataList: Array<String>?
    
    private var pickerView: ZQPickerView?
    private var wantChangeBackward: Bool = false
    
    private static let audioPlayerForwardSecondsKey = "ZQAudioPlayerForwardSecondsKey"
    private static let audioPlayerBackwardSecondsKey = "ZQAudioPlayerBackwardSecondsKey"
    private var forwardSeconds: Int = 0
    private var backwardSeconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.defaultLightGray
        setTitleLabel()
        loadDataList()
        setTableView()
        setPickerView()
        
        checkWhetherRestoreToDefaultValues()
    }
    
    func setTitleLabel() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        title.text = "音频播放器基本设置"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
    }
    
    func loadDataList()  {
        dataList = [ "回放秒数 - 默认4秒", "快进秒数 - 默认4秒" ]
    }
    
    func setTableView() {
        tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView!.dataSource = self
        tableView!.delegate = self
        self.view.addSubview(tableView!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.dataList?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            let seconds = ZQAudioSettingViewController.getBackwardSeconds()
            return "当前回放秒数是\(seconds)秒"
        }
        let seconds = ZQAudioSettingViewController.getForwardSeconds()
        return "当前快进秒数是\(seconds)秒"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "cellOfAudioPlayerSetting_ReuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseId)
        }
        let txt = self.dataList![indexPath.section]
        cell?.textLabel?.text = txt
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            wantChangeBackward = true
        } else {
            wantChangeBackward = false
        }
        pickerView?.isHidden = false
    }
     
    func setPickerView() {
        let height = self.view.frame.size.height - 64
        
        let w: CGFloat = self.view.frame.size.width
        let h: CGFloat = 140
        let y: CGFloat = height - h
        
        let list = [ 1,2,3,4,5,6,7,8,9,10 ]
        let pickerFrame = CGRect(x: 0, y: y, width: w, height: h)
        pickerView = ZQPickerView(title: "请选择", list: list, frame: pickerFrame)
        pickerView?.isHidden = true
        pickerView?.setCompletion { (seconds) in
            if self.wantChangeBackward {
                self.setValueToUserDefaults(seconds: seconds as! Int, forKey: ZQAudioSettingViewController.audioPlayerBackwardSecondsKey)
            } else {
                self.setValueToUserDefaults(seconds: seconds as! Int, forKey: ZQAudioSettingViewController.audioPlayerForwardSecondsKey)
            }
            
            self.tableView!.reloadData()
            self.pickerView?.isHidden = true
        }
        self.view.addSubview(pickerView!)
        
    }
    
    // 检查是否需要恢复到默认值
    func checkWhetherRestoreToDefaultValues() {
        let backward = ZQAudioSettingViewController.getBackwardSeconds()
        let forward = ZQAudioSettingViewController.getForwardSeconds()
        if backward == 0 && forward == 0  {
            resetToDefaultValues()
        }
    }
    
    // 获取回退返回值
    public static func getBackwardSeconds() -> Int {
        return UserDefaults.standard.integer(forKey: ZQAudioSettingViewController.audioPlayerBackwardSecondsKey)
    }
    
    // 获取前进返回值
    public static func getForwardSeconds() -> Int {
        return UserDefaults.standard.integer(forKey: ZQAudioSettingViewController.audioPlayerForwardSecondsKey)
    }
    
    func setValueToUserDefaults(seconds: Int, forKey: String) {
        let userDefault = UserDefaults.standard
        userDefault.set(seconds, forKey: forKey)
        userDefault.synchronize()
    }
    
    func resetToDefaultValues() {
        setValueToUserDefaults(seconds: 4, forKey: ZQAudioSettingViewController.audioPlayerBackwardSecondsKey)
        setValueToUserDefaults(seconds: 4, forKey: ZQAudioSettingViewController.audioPlayerForwardSecondsKey)
    }
}
