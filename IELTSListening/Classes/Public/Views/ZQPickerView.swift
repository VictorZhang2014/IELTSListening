//
//  ZQPickerView.swift
//  IELTSListening
//
//  Created by Victor Zhang on 04/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

public class ZQPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var titleStr: String?
    private var pickerList: Array<Any>?
    private var pickerView: UIPickerView?
    private var completionClosure: ((Any?) -> Swift.Void)?
    private let rowHeight: CGFloat = 40
    private var selectedSeconds: Int = 0
    
    init(title: String, list: Array<Any>, frame: CGRect) {
        super.init(frame: frame)
        pickerList = list
        titleStr = title
     
        let width: CGFloat = frame.size.width
        let height: CGFloat = frame.size.height
        
        let topVH: CGFloat = rowHeight
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: topVH))
        topView.backgroundColor = UIColor.white
        self.addSubview(topView)
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1))
        topLine.backgroundColor = UIColor.lightGray
        topView.addSubview(topLine)
        
        let cLine = UIView(frame: CGRect(x: 0, y: topVH, width: width, height: 0.5))
        cLine.backgroundColor = UIColor.lightGray
        topView.addSubview(cLine)
        
        let tiW: CGFloat = 100
        let tiH: CGFloat = 25
        let tiX: CGFloat = (width - tiW) / 2
        let tiY: CGFloat = (topVH - tiH) / 2
        let tiFrame = CGRect(x: tiX, y: tiY, width: tiW, height: tiH)
        let tiLab = UILabel(frame: tiFrame)
        tiLab.text = titleStr
        tiLab.textColor = UIColor.black
        tiLab.font = UIFont.systemFont(ofSize: 15)
        tiLab.textAlignment = .center
        topView.addSubview(tiLab)
        
        let conW: CGFloat = 50
        let conH: CGFloat = tiH
        let conX: CGFloat = width - conW - 15
        let conBtn = UIButton(frame: CGRect(x: conX, y: tiY, width: conW, height: conH))
        conBtn.setTitle("确定", for: .normal)
        conBtn.setTitleColor(UIColor.black, for: .normal)
        conBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        conBtn.titleLabel?.textAlignment = .center
        conBtn.layer.borderColor = UIColor.lightGray.cgColor
        conBtn.layer.borderWidth = 0.5
        conBtn.layer.cornerRadius = 3
        conBtn.addTarget(self, action: #selector(confirmSelection), for: .touchUpInside)
        topView.addSubview(conBtn)
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: topVH, width: width, height: height - topVH))
        pickerView!.dataSource = self
        pickerView?.delegate = self
        pickerView?.showsSelectionIndicator = true
        self.addSubview(pickerView!)

    }
    
    @objc func confirmSelection() {
        if completionClosure != nil {
            completionClosure!(selectedSeconds)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("ZQPickerView init(coder:) has not been implemented")
    }
    
    func setCompletion(_ completion: ((Any?) -> Swift.Void)?) {
        completionClosure = completion
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (pickerList?.count)!
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = pickerList?[row] ?? ""
        return "\(title)"
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let seconds = pickerList?[row]
        selectedSeconds = seconds as! Int
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }

}
