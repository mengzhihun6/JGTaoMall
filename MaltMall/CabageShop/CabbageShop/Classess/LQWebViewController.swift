//
//  LQWebViewController.swift
//  RentHouse
//
//  Created by RongXing on 2018/6/13.
//  Copyright © 2018年 Fu Yaohui. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import SwiftyUserDefaults

class LQWebViewController: LNBaseViewController ,UIWebViewDelegate,UIGestureRecognizerDelegate {
    
    var webUrl = ""
    var webTitle = ""
    var webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = webTitle
        titleLabel.textColor = UIColor.white
        
        webView = UIWebView.init(frame: CGRect(x: 0, y: CGFloat(navHeight), width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - 64))
        
        if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
            if !webUrl.contains(Defaults[kUserToken]!) {
                if !webUrl.contains("?") {
                    webUrl = "\(Defaults[kLastUrl]!)?token=\(Defaults[kUserToken]!)"
                } else {
                    webUrl = "\(Defaults[kLastUrl]!)&token=\(Defaults[kUserToken]!)"
                }
            }
        }
        kDeBugPrint(item: webUrl)
        let myRequest = URLRequest(url: OCTools.getEfficientAddress(webUrl))
        webView.loadRequest(myRequest)
        webView.delegate = self
        
//        webView.loadHTMLString("", baseURL: nil)
        
        view.addSubview(webView)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        webView.backgroundColor = UIColor.white
        btnImage = "reload_white"
        
//        接受通知时携带的h5地址，并刷新当前页面
        NotificationCenter.default.addObserver(self, selector: #selector(LQLoadH5DeailNification(nitofication:)), name: NSNotification.Name(rawValue: LQTools().LQLoadH5DeailNification), object: nil)

    }
    
    @objc func LQLoadH5DeailNification(nitofication:Notification) {
        let urlStr = JSON(nitofication.userInfo!).dictionaryValue
        
        
        let myRequest = URLRequest(url: OCTools.getEfficientAddress(urlStr["requsetUrl"]?.stringValue))
        webView.loadRequest(myRequest)
    }

    
    override func rightAction(sender: UIButton) {
        webView.reload()
    }
    override func backAction(sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
//        LQLoadingView().SVPwillShowAndHideNoText()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
//         LQLoadingView().SVPHide()
//        let str = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '95%'"
        titleLabel.text = webView.stringByEvaluatingJavaScript(from: "document.title")

    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        kDeBugPrint(item: request)
        if (request.url?.absoluteString.contains("tbopen"))! {
            return false
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf!.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         LQLoadingView().SVPHide()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
