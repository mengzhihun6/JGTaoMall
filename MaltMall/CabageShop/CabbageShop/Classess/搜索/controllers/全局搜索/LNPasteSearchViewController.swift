//
//  LNPasteSearchViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/21.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNPasteSearchViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var search_text: UILabel!
    @IBOutlet weak var zhuanhuankoulingBun: UIButton!
    
    @objc public var type : String?
    
    //    回调
    typealias swiftBlock = (_ searchType:String, _ realName:String) -> Void
    var willClick : swiftBlock? = nil
    
    @objc func callKeywordBlock(block: @escaping (_ searchType:String, _ realName:String) -> Void ) {
        willClick = block
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        UIPasteboard.general.string = ""
    }
    
    @IBAction func searchTB(_ sender: UIButton) {
        dismissAction(type: "1")
    }
    
    @IBAction func searchJD(_ sender: UIButton) {
        dismissAction(type: "1")
    }
    
    @IBAction func searchPDD(_ sender: UIButton) {
        dismissAction(type: "1")
    }
    // 转换口令
    @IBAction func zhuanhuankoulingClick(_ sender: UIButton) {
        
        let request3 = SKRequest.init()
        request3.setParam(UIPasteboard.general.string! as NSObject, forKey: "keywords")
        weak var weakSelf = self
        kDeBugPrint(item: UIPasteboard.general.string)
        request3.callGET(withUrl: LNUrls().kTaokouling) { (response) in
            kDeBugPrint(item: response?.data)
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!).stringValue
                
                let pasteboard = UIPasteboard.general
                pasteboard.string = datas
                setToast(str: "口令转换成功, 已自动复制到粘贴板!")
                weakSelf?.dismiss(animated: false, completion: nil)
            }
        }
        
    }
    
    func dismissAction(type:String) {
        
        self.dismiss(animated: false) {
            if (OCTools().getCurrentVC()?.isKind(of: LQSearchResultViewController.self))! {
                NotificationCenter.default.post(name: Notification.Name(rawValue: LQTools().LQReloadGoodInfo), object: self, userInfo: ["keyword":UIPasteboard.general.string!,"type":type])
                UIPasteboard.general.string = ""
            }else{
                let searchVc = LQSearchResultViewController()
                searchVc.keyword = UIPasteboard.general.string!
                searchVc.type  = type
                UIPasteboard.general.string = ""
                OCTools().getCurrentVC()?.navigationController!.pushViewController(searchVc, animated: true)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search_text.text = UIPasteboard.general.string
        bgView.cornerRadius = 8
        self.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.55)
        
        zhuanhuankoulingBun.clipsToBounds = true
        zhuanhuankoulingBun.cornerRadius = 5
        
        let arr1 = search_text.text!.components(separatedBy: "€")
        let arr2 = search_text.text!.components(separatedBy: "《")
        let arr3 = search_text.text!.components(separatedBy: "￥")
        let arr4 = search_text.text!.components(separatedBy: "$")
        let arr5 = search_text.text!.components(separatedBy: "₰")
        let arr6 = search_text.text!.components(separatedBy: "₴")
        let arr7 = search_text.text!.components(separatedBy: "¢")
        if arr1.count == 3 || arr2.count == 3 || arr3.count == 3 || arr4.count == 3 || arr5.count == 3 || arr6.count == 3 || arr7.count == 3 || ((search_text.text?.contains("("))! && (search_text.text?.contains(")"))!) {
            zhuanhuankoulingBun.isHidden = false
        } else {
            zhuanhuankoulingBun.isHidden = true
        }
        
    }

}
