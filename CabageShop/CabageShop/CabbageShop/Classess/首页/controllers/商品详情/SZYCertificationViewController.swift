//
//  SZYCertificationViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/6.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

//声明一个协议
protocol SZYCertificationViewControllerDelegate {
    // 协议方法
    func getButtonClick(tag: Int, code: String, urlString: String)
}

class SZYCertificationViewController: LNBaseViewController {
    
    @IBOutlet weak var shaohouBun: UIButton!
    @IBOutlet weak var mashangBun: UIButton!
    
    @IBOutlet weak var shouquanBun: UIButton!
    @IBOutlet weak var bg_view: UIView!
    var code = ""
    var urlString = ""
    
    
    var daliCanshu : SZYCertificationViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigaView.isHidden = true
        
        
        shaohouBun.cornerRadius = 5
        shaohouBun.clipsToBounds = true
        
        mashangBun.clipsToBounds = true
        mashangBun.cornerRadius = 5
        
        bg_view.clipsToBounds = true
        bg_view.cornerRadius = 5
        
        shouquanBun.clipsToBounds = true
        shouquanBun.cornerRadius = shouquanBun.height / 2.0
    }
    
    
    @IBAction func buttonClick(_ sender: UIButton) {
//        100 稍后   101 马上认证
        
        if sender.tag == 100 {
            self.dismiss(animated: true, completion: nil)
        } else {
            if daliCanshu != nil {
//                daliCanshu?.getButtonClick(tag: sender.tag)
                self.dismiss(animated: true, completion: nil)
                daliCanshu?.getButtonClick(tag: sender.tag, code: code, urlString: urlString)
                
            }
        }
    }
    @IBAction func shouquanBunClick(_ sender: UIButton) {
        kDeBugPrint(item: "授权")
        if daliCanshu != nil {
            self.dismiss(animated: true, completion: nil)
            daliCanshu?.getButtonClick(tag: sender.tag, code: code, urlString: urlString)
        }
    }
    
    
}
