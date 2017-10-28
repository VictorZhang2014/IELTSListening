//
//  ZQTextFieldTableViewController.swift
//  IELTSListening
//
//  Created by Victor Zhang on 03/10/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class ZQAudioPlayerTextFieldViewController: ZQViewController {
    
    private var textField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hasDone))
        
        textField = UITextField(frame: CGRect(x: -5, y: 90, width: self.view.frame.size.width + 10, height: 44))
        textField?.keyboardType = .numberPad
        textField?.borderStyle = .roundedRect
        self.view.addSubview(textField!)
    }
    
    @objc func hasDone() {
//        let text = textField?.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
    }
    
    func showAlert(msg: String)  {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
