//
//  SZYBannerView.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/14.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYBannerView: UIView {
    
    var banner = ADView()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "点击响应事件"
        label.textColor = UIColor.white
        label.frame.origin.y = 30
        label.frame.origin.x = 50
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(_:))))
        label.sizeToFit()
        return label
    }()
    @objc private func tapLabel(_ gesture: UITapGestureRecognizer)  {
        print("tapLabel☄")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
//        let imageUrls =  NSMutableArray.init(array: ["透明bannner"])
//        banner = ADView.init(frame: CGRect.init(x: 10, y: 10, width: kSCREEN_WIDTH - 20, height: 92), andImageNameArray: imageUrls, andIsRunning: true)
//
//        addSubview(banner)
//        addSubview(label)
    }
    
    func buildUrlData(models:[LNBannersModel]) {
        
        let imageUrls =  NSMutableArray.init()
        for model in models {
            imageUrls.add(model.image)
        }
        if imageUrls.count == 0 {
            return
        }
        banner.removeFromSuperview()
        
        banner = ADView.init(frame: CGRect.init(x: 10, y: 10, width: kSCREEN_WIDTH - 20, height: 92), andImageURLArray: imageUrls, andIsRunning: true)
        
        weak var weakSelf = self
        banner.block = { //点击调用的block
            kDeBugPrint(item: $0)
            
            let index = Int($0!)!-1
            let model = models[index]
            
//            let WebVC = LQWebViewController()
//            WebVC.webTitle = "详情"
//            WebVC.webUrl = model.url
//            weakSelf?.navigationController?.pushViewController(WebVC, animated: true)
        }
        addSubview(banner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
