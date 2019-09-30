//
//  SZYwebViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/26.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYwebViewController: LNBaseViewController, UIWebViewDelegate, UIGestureRecognizerDelegate {
    @objc var webView : UIWebView = UIWebView()
    var str = String()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        var height = viewHeight
        if kSCREEN_HEIGHT >= 812 {
            height = viewHeight + 20
        }
        
        webView = UIWebView.init(frame: CGRect(x: 0, y: height, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - height))
        webView.delegate = self
        view.addSubview(webView)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        webView.backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "淘宝授权"
        titleLabel.textColor = UIColor.white
//        navigationBgImage = UIImage.init(named: "Rectangle")
        backBtn.isHidden = true
        
        btnTitle = "暂不授权"
    }
    override func rightAction(sender: UIButton) {
        self.view.window?.rootViewController = LNMainTabBarController()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let requestURL : URL? = self.webView.request?.url
        let username : String = self.webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('html')[0].innerHTML")!
        if username.contains("<head></head><body><pre style=\"word-wrap: break-word; white-space: pre-wrap;\">{\"code\":") {
            let strArray = username.components(separatedBy: "{")
            if strArray.count > 1 {
                let strArray1 = strArray[1].components(separatedBy: "}")
                let str = "{" + strArray1[0] + "}"
                kDeBugPrint(item: str)
                let strStr = JSON.init(parseJSON: str)
                kDeBugPrint(item: strStr)
                
                let vc = SZYshouquanchenggongViewController()
                vc.code = strStr["code"].stringValue
                vc.titleStr = strStr["message"].stringValue
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        kDeBugPrint(item: request)
        if (request.url?.absoluteString.contains("tbopen"))! {
            return false
        }
        return true
    }
}
