//
//  LNMainADsViewController.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/27.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
class LNMainADsViewController: LNBaseViewController {

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var close: UIButton!
    
    @objc public var model : Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.65)
        
        if let adModel = model as? LNMainAdsModel1 {
            showImage.sd_setImage(with: OCTools.getEfficientAddress(adModel.thumb), completed: nil)
        }
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
        singleTap.numberOfTapsRequired = 1
        showImage.addGestureRecognizer(singleTap)
        showImage.isUserInteractionEnabled = true

        self.navigaView.isHidden = true
    }
    
    @objc  func viewTheBigImage(ges:UITapGestureRecognizer) {
        
        
        self.dismiss(animated: false, completion: nil)

        guard let adModel = model as? LNMainAdsModel1 else {
            return
        }
        if adModel.type == "1" {
            let webVc = LQWebViewController()
            webVc.webUrl = adModel.url
            webVc.webTitle = adModel.title
            let tabbar = self.presentingViewController as? LNMainTabBarController
            (tabbar?.selectedViewController as? LNNavigationController)?.pushViewController(webVc, animated: true)
        }else{
            let detailVc = SZYGoodsViewController()
            detailVc.good_item_id = adModel.url
            detailVc.coupone_type = "1"
            let tabbar = self.presentingViewController as? LNMainTabBarController
            (tabbar?.selectedViewController as? LNNavigationController)?.pushViewController(detailVc, animated: true)
        }
        
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
