//
//  GH_LunBoViewController.swift
//  CabbageShop
//
//  Created by ZhiYuan on 2019/9/4.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit

class GH_LunBoViewController: LNBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigaView.isHidden  = true
        creatUI()
    }
    
    func creatUI()  {
        let scrollerView = UIScrollView()
        scrollerView.frame = CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT)
        scrollerView.isPagingEnabled = true
        self.view.addSubview(scrollerView)
        scrollerView.contentSize = CGSize(width: kSCREEN_WIDTH * 6, height: kSCREEN_HEIGHT)
        var imgArray = ["jg_0","jg_1","jg_2","jg_3","jg_4","jg_5"]
        
        for i in 0...5 {
            let img = UIImageView()
            img.frame = CGRect(x: kSCREEN_WIDTH * CGFloat(i), y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT)
            img.image = UIImage.init(named: imgArray[i])
            img.isUserInteractionEnabled = true
            scrollerView .addSubview(img)
            if i == 5{
                let joinInAppBt = UIButton()
//                joinInAppBt.setTitle("立即进入", for: UIControl.State.normal)
                joinInAppBt.backgroundColor = UIColor.clear
                joinInAppBt.addTarget(self, action: #selector(joinApp), for: UIControl.Event.touchDown)
                img.addSubview(joinInAppBt)
                joinInAppBt.snp.makeConstraints { (make) in
                    make.centerX.equalTo(img)
                    make.bottom.equalTo(img).offset(-21)
                    make.width.equalTo(200)
                    make.height.equalTo(50)
                }
            }
        }
        
        
        
      
        
    }
    @objc  func joinApp(){
        UIApplication.shared.keyWindow?.rootViewController = LNMainTabBarController()
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
