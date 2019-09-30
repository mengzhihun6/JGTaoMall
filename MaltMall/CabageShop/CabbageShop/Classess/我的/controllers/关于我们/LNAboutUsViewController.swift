//
//  LNAboutUsViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNAboutUsViewController: LNBaseViewController {

    @IBOutlet weak var top_space: NSLayoutConstraint!
    
    @IBOutlet weak var version: UILabel!
    
    @IBOutlet weak var new_version: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "关于我们"
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = UIColor.black
        top_space.constant = navHeight+25
        
        version.text = "v"+(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
    }
    
    
    @IBAction func haveNewVersion(_ sender: UIButton) {
        
        
    }
    

}
