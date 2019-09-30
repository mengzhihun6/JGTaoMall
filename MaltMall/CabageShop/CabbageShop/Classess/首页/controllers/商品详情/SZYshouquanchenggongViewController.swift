//
//  SZYshouquanchenggongViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/26.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYshouquanchenggongViewController: LNBaseViewController {
    
    var titleStr = String()
    var code = String()
    
    @IBOutlet weak var bg_icon: UIImageView!
    @IBOutlet weak var bg_top: NSLayoutConstraint!
    @IBOutlet weak var biaoti: UILabel!
    @IBOutlet weak var miaoshu: UILabel!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backBtn.isHidden = true
        
        navigationTitle = "授权结果"
        titleLabel.textColor = UIColor.white
//        navigationBgImage = UIImage.init(named: "Rectangle")
        
        if code == "1001" {
            bg_icon.image = UIImage.init(named: "成功")
            biaoti.text = "授权成功"
        } else {
            bg_icon.image = UIImage.init(named: "成功1")
            biaoti.text = "授权失败"
        }
        miaoshu.text = titleStr
    }
    
    @IBAction func buttonC(_ sender: UIButton) {
//        self.navigationController?.popToViewController(self.navigationController?.viewControllers, animated: <#T##Bool#>)
//        for (UIViewController *temp in self.navigationController.viewControllers) {
//            if ([temp isKindOfClass:[你要跳转到的Controller class]]) {
//                [self.navigationController popToViewController:temp animated:YES];
//            }
//
//        }
//        for temp:UIViewController in (self.navigationController?.viewControllers)! {
//            if temp.
//        }
        
        self.view.window?.rootViewController = LNMainTabBarController()
        
    }
}
