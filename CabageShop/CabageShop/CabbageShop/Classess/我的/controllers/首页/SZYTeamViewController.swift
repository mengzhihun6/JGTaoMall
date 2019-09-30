//
//  SZYTeamViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/21.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYTeamViewController: LNBaseViewController {
    
    @IBOutlet weak var tishiLabel: UILabel!
    //    let vc = UIViewController()
//    let str = String()
    @objc var vc : UIViewController?
    @objc var str : String?
    @objc var tishiStr = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.6)
        navigaView.isHidden = true
        
        tishiLabel.text = tishiStr + "暂无查看权限"
    }
    @IBAction func cancelButtonClick(_ sender: UIButton) { //取消按钮事件!
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func determineButtonClick(_ sender: UIButton) { //确定按钮事件!
        kDeBugPrint(item: vc)
        let vcs = vc as! LNNavigationController
        vcs.pushViewController(LNNewTeamDetailViewController(), animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false, completion: nil)
    }
}
