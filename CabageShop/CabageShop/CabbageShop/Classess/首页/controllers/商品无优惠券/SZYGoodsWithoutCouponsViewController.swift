//
//  SZYGoodsWithoutCouponsViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/12.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
//声明一个协议
protocol SZYGoodsWithoutCouponsViewControllerDelegate {
    // 协议方法
    func getButtonClick(tag: Int)
}
class SZYGoodsWithoutCouponsViewController: LNBaseViewController {
    
    @objc var titleStr = String()
    @objc var contentStr = String()
    
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    
    var daliCanshu : SZYGoodsWithoutCouponsViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigaView.isHidden = true
        bg_view.cornerRadius = 5
        bg_view.clipsToBounds = true
        titleLab.text = titleStr
        contentLab.text = contentStr
        
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        
        if sender.tag == 100 {
            kDeBugPrint(item: "返回事件")
        } else if sender.tag == 101 {
            kDeBugPrint(item: "确认事件")
        }
        if daliCanshu != nil {
            self.dismiss(animated: false, completion: nil)
            daliCanshu?.getButtonClick(tag: sender.tag)
        }
    }
    
    
}
