//
//  LNMainADsViewController2.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/30.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNMainADsViewController2: LNBaseViewController {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var search_text: UILabel!
    @objc public var model : Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let adModel = model as? LNMainAdsModel1 {
            search_text.text = adModel.title
        }

        bgView.cornerRadius = 8
        self.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.55)
        self.navigaView.isHidden = true
    }

    @IBAction func viewAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
        guard let adModel = model as? LNMainAdsModel1 else {
            return
        }

        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = adModel.url
        detailVc.coupone_type = "1"
        let tabbar = self.presentingViewController as? LNMainTabBarController
        (tabbar?.selectedViewController as? LNNavigationController)?.pushViewController(detailVc, animated: true)

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
