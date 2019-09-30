//
//  LNShowSucceedViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNShowSucceedViewController: LNBaseViewController {

    @IBOutlet weak var tiplabel: UILabel!
    var textStr = "您的反馈已提交"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "提现申请已提交"
        titleLabel.textColor = UIColor.white
        tiplabel.text = textStr
        // Do any additional setup after loading the view.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    override func backAction(sender: UIButton) {
        self.navigationController?.popToViewController((self.navigationController?.childViewControllers[0])!, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
