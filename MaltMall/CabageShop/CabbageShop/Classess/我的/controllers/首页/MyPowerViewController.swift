//
//  MyPowerViewController.swift
//  CabbageShop
//
//  Created by ZhiYuan on 2019/8/30.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit

class MyPowerViewController: LNBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigaView.backgroundColor = UIColor.black
        creatUI()
    }
    
    
    func creatUI()  {
        
        
        
        let BGImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT))
        BGImage.image = UIImage.init(named: "jg_plus_bg")
        self.view.addSubview(BGImage)
        
        let backbutton = UIButton()
        backbutton.frame = CGRect(x: 10, y: 30, width: 31, height: 31)
        backbutton.setImage(UIImage.init(named: "jg_nav_back"), for: UIControl.State.normal)
        backbutton.addTarget(self, action: #selector(back), for: UIControlEvents.touchDown)
        BGImage.addSubview(backbutton)
        
        
        let iconImage = UIImageView.init(frame: CGRect(x: (kSCREEN_WIDTH - 43) / 2, y: 109, width: 43, height: 34))
        iconImage.image = UIImage.init(named: "jg_super_plus")
        BGImage.addSubview(iconImage)
        
        let MypowerLable = UILabel.init(frame: CGRect(x: 0, y: 162, width: kSCREEN_WIDTH, height: 25))
        MypowerLable.text = "我的影响力0"
        MypowerLable.textColor = UIColor.init(r: 243, g: 214, b: 181)
        MypowerLable.font = UIFont.systemFont(ofSize: 18)
        MypowerLable.textAlignment = NSTextAlignment.center
        BGImage.addSubview(MypowerLable)
        
        let customLabe = UILabel.init(frame: CGRect(x: 20, y: 217, width: 200, height: 25))
        customLabe.text = "普通会员"
        customLabe.textColor = UIColor.init(r: 243, g: 214, b: 181)
        customLabe.font = UIFont.systemFont(ofSize: 16)
        BGImage.addSubview(customLabe)
        
        let image0 = UIImageView.init(frame: CGRect(x: 20, y: 262, width: kSCREEN_WIDTH - 40, height: 100))
        image0.layer.cornerRadius = 10
        image0.image = UIImage.init(named: "jg_plus_onel")
        BGImage.addSubview(image0)
        
        let image1 = UIImageView.init(frame: CGRect(x: 20, y: 387, width: kSCREEN_WIDTH - 40, height: 100))
        image1.layer.cornerRadius = 10
        image1.image = UIImage.init(named: "jg_plus_twol")
        BGImage.addSubview(image1)
        
        
        let image2 = UIImageView.init(frame: CGRect(x: 20, y: 512, width: kSCREEN_WIDTH - 40, height: 100))
        image2.layer.cornerRadius = 10
        image2.image = UIImage.init(named: "jg_plus_threel")
        BGImage.addSubview(image2)
    }

    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
