//
//  SZYMembersViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/4/20.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class SZYMembersViewController: LNBaseViewController, UIWebViewDelegate, UIGestureRecognizerDelegate {
    
    @objc var webView : UIWebView = UIWebView()
    @objc var webTitle : String = ""
    fileprivate var theItemId : String?
    @objc var typeString : String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationTitle = "会员权益"
        titleLabel.textColor = UIColor.white
        backBtn.isHidden = true
        navigaView.backgroundColor = kSetRGBColor(r: 66, g: 63, b: 61)
        
        var height = viewHeight
        if kSCREEN_HEIGHT >= 812 {
            height = viewHeight + 20
        }
        
        var url = JGBaseH5Url + "/pages/upgrade/index?token="
        if Defaults[kUserToken] == nil || Defaults[kUserToken] == "" {
            let presentVc = JGLoginViewController.init()
//            presentVc.typeString = "3"
//            presentVc.nav = self.navigationController!
            let nav = LNNavigationController.init(rootViewController: presentVc)
            
            
            //
            
            nav.isNavigationBarHidden = true
            self.present(nav, animated: true, completion: nil)
            
            
            
            return
//            self.navigationController!.tabBarController?.selectedIndex = 3
        } else {
            url = url + Defaults[kUserToken]!
            kDeBugPrint(item: "url === \n \(url)")
        }
        
        webView = UIWebView.init(frame: CGRect(x: 0, y: height, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - height))
        webView.delegate = self
        webView.loadRequest(URLRequest(url: OCTools.getEfficientAddress(url)))
        view.addSubview(webView)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        webView.backgroundColor = UIColor.white
        webView.snp.makeConstraints { (ls) in
            ls.top.equalTo(navigaView.snp.bottom)
            ls.left.right.bottom.equalToSuperview()
        }
        
//        navigaView.backgroundColor = UIColor.red
//
//
//        self.navigationController?.navigationBar.isHidden = true
//
//        btnImage = "reload_black"
//        let leftBtn2 = UIButton.init()
//        leftBtn2.titleLabel?.textAlignment = .right
//        leftBtn2.addTarget(self, action: #selector(rightAction2(sender:)), for: .touchUpInside)
//        leftBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        leftBtn2.setTitleColor(UIColor.black, for: .normal)
//        leftBtn2.setTitle("关闭", for: .normal)
//        navigaView.addSubview(leftBtn2)
//
//        leftBtn2.snp.makeConstraints { (ls) in
//            ls.left.equalTo(backBtn.snp.right)
//            ls.width.greaterThanOrEqualTo(40)
//            ls.height.equalTo(30)
//            ls.centerY.equalTo(backBtn)
//        }
//        changeStyle()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if Defaults[kUserToken] == nil || Defaults[kUserToken] == "" {
//            let presentVc = LNLoginViewController.init()
//            presentVc.typeString = "3"
//            presentVc.nav = self.navigationController!
//            let nav = LNNavigationController.init(rootViewController: presentVc)
//            nav.isNavigationBarHidden = true
//            self.present(nav, animated: true, completion: nil)
//            return
//        }
        webView.reload()
    }
    override func backAction(sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }else{
            if typeString == "1" {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    override func rightAction(sender: UIButton) {
//        webView.reload()
    }
    override func rightAction2(sender: UIButton) {
        if typeString == "1" {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    func webViewDidStartLoad(_ webView: UIWebView) { // 开始加载
        //        LQLoadingView().SVPwillShowAndHideNoText()
        
        kDeBugPrint(item: "")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) { // 加载结束
        titleLabel.text = webView.stringByEvaluatingJavaScript(from: "document.title")
        
    }
    func webView(webView:UIWebView, shouldStartLoadWithRequest request:NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlStr = request.url?.absoluteString
        kDeBugPrint(item: "++++++++++++--------")
        kDeBugPrint(item: urlStr)
        
        return true
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        weak var weakSelf = self
        let urlStr = request.url?.absoluteString
        kDeBugPrint(item: "******************")
        kDeBugPrint(item: urlStr)
        
        let dict = self.urlTurnStr(str: urlStr!)
        theItemId = nil
        
        if dict.count > 0 {
            for index in 0..<dict.allKeys.count {
                let str = dict.allKeys[index] as! String
                if str == "id" {
                    weakSelf?.theItemId = (dict["id"] as! String)
                } else if str == "itemId" {
                    weakSelf?.theItemId = (dict["itemId"] as! String)
                } else if str == "item_id" {
                    weakSelf?.theItemId = (dict["item_id"] as! String)
                }
            }
            if weakSelf?.theItemId != nil {
                kDeBugPrint(item: weakSelf?.theItemId)
                if (weakSelf?.theItemId?.count)! >= 9 /*&& (weakSelf?.theItemId?.count)! <= 13*/ {
                    let detailVc = SZYGoodsViewController()
                    detailVc.good_item_id = self.theItemId!
                    detailVc.coupone_type = "1"
                    navigationController?.pushViewController(detailVc, animated: true)
                    return false
                }
                return true
            }
            return true
        } else {
            return true
        }
        
    }
    
    func urlTurnStr(str: String) -> NSMutableDictionary {
        let dict = NSMutableDictionary.init()
        
        // 判断是否有参数
        if !str.contains("?") {
            return dict
        }
        
        // 截取参数
        let urlArr = str.components(separatedBy: "?")
        let paramsString = urlArr[1]
        // 判断参数是单个参数还是多个参数
        if paramsString.contains("&") {
            // 多个参数，分割参数
            let urlComponents = paramsString.components(separatedBy: "&")
            // 遍历参数
            for keyValuePair in urlComponents {
                // 生成Key/Value
                let pairComponents = keyValuePair.components(separatedBy: "=")
                let key = pairComponents.first
                let value = pairComponents.last
                dict.setObject(value! as NSCopying, forKey: key! as NSCopying)
            }
        } else {
            // 单个参数
            let pairComponents = paramsString.components(separatedBy: "=")
            // 判断是否有值
            if pairComponents.count == 1 {
                return dict
            }
            let key = pairComponents.first
            let value = pairComponents.last
            dict.setObject(value! as NSCopying, forKey: key! as NSCopying)
        }
        return dict
    }
    
    
    
    
}
