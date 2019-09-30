//
//  YHJDorPDDTableHeaderView.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/6/12.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit

class YHJDorPDDTableHeaderView: UIView {
    
    var banner = ADView()
    var bg_view = UIView()
    
    @objc private func tapLabel(_ gesture: UITapGestureRecognizer)  {
        print("京东tapLabel☄")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    func viewInit() {
        bg_view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: 150))
        bg_view.backgroundColor = UIColor.clear
        self.addSubview(bg_view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpValues(model: bannerDiyModel) {
        for views in bg_view.subviews {
            views.removeFromSuperview()
        }
        
        var imageUrls =  NSMutableArray.init()
        imageUrls = ["http://ht-dev.oss-cn-beijing.aliyuncs.com/images/20190411/CmrkhVCBuYYpihKjAv2HTgiZNoO05hLiazyjHnDV.jpeg", "http://ht-dev.oss-cn-beijing.aliyuncs.com/images/20190411/b6FPJci9cTzrVjAugzNOKGVmn31UgIupS9oLPknq.jpeg", "http://ht-dev.oss-cn-beijing.aliyuncs.com/images/20190411/c7TLDHazRFHFc0b5rLyLaxVcWk7c6yQX0Vnn1fhM.png"]
        banner = ADView.init(frame: CGRect.init(x: 0, y: 10, width: kSCREEN_WIDTH, height: 130), andImageURLArray: imageUrls )
        weak var weakSelf = self
        banner.block = {
            let index = Int($0!)!-1
//            let bannerModel = model.data[index]
            kDeBugPrint(item: index)
        }
        
        bg_view.addSubview(banner)
        banner.snp.makeConstraints { (ls) in
            ls.top.equalToSuperview().offset(10)
            ls.left.right.equalToSuperview()
            ls.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    func setImage(type: String) {
        for views in bg_view.subviews {
            views.removeFromSuperview()
        }
        let img = type == "2" ? "jd_head" : "pdd_head"
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: 147 * kSCREEN_WIDTH / 375))
        imageView.image = UIImage.init(named: img)
        bg_view.addSubview(imageView)

    }
    
}
