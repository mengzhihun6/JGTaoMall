//
//  SZYLQGoodsImagesCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/19.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class SZYLQGoodsImagesCell: UITableViewCell, UIWebViewDelegate{

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    
    var webView1 = UIWebView()
    var webModel1 = WebModel()
    //    回调
    typealias swiftBlock = (_ phoneNum:String) -> Void
    var willClick : swiftBlock? = nil
    func callBackPhoneNum(block: @escaping ( _ phoneNum:String) -> Void ) {
        willClick = block
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let web = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: 1))
        web.scrollView.isScrollEnabled = false
        web.sizeToFit()
        /**
         网页收缩适配
         */
        web.scalesPageToFit = true
        web.delegate = self
        self.webView1 = web;
        self.addSubview(self.webView1)
        webView1.snp.makeConstraints { (ls) in
            ls.left.bottom.top.right.equalToSuperview()
        }
    }
    
    func setToString(urlStr: String) {
        kDeBugPrint(item: urlStr)
        webView1 = UIWebView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0))
        webView1.sizeToFit()
        /**
         网页收缩适配
         */
        webView1.scalesPageToFit = true
        webView1.delegate = self
        webView1.loadHTMLString(urlStr, baseURL: nil)
    }
    func setToString(webModel: WebModel) {
        webModel1 = webModel
        if webModel.webViewHeight <= 0 {
            webView1.loadHTMLString(webModel.urlStr, baseURL: nil)
        }
    }
    
    func setToGoodsAndStore(goods: String, store: String) {
        let url = "https://h5.m.taobao.com/app/detail/fulldesc.html#!id="+goods+"&sellerId="+store+"&ext=&fromMobile=1"
        webView1 = UIWebView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 1))
        webView1.sizeToFit()
        /**
         网页收缩适配
         */
        webView1.scalesPageToFit = true
        webView1.delegate = self
        webView1.scrollView.isScrollEnabled = false
        let myRequest = URLRequest(url: OCTools.getEfficientAddress(url))
        webView1.loadRequest(myRequest)
        self.contentView.addSubview(webView1)
        webView1.snp.makeConstraints { (ls) in
            ls.left.bottom.top.right.equalToSuperview()
        }
    }
    func setToGoodsAndStor(webModel: WebModel) { //weakSelf!.webModel
        webModel1 = webModel
//        let url = "https://h5.m.taobao.com/app/detail/fulldesc.html#!id="++"&sellerId="+webModel.userId+"&ext=&fromMobile=1"
        
        let url = "https://mdetail.tmall.com/templates/pages/desc?id="+webModel.good_item_id
        
//        webView1 = UIWebView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 1))
//        webView1.sizeToFit()
//        /**
//         网页收缩适配
//         */
//        webView1.scalesPageToFit = true
//        webView1.delegate = self
//        webView1.scrollView.isScrollEnabled = false
        kDeBugPrint(item: url)
        if webModel.webViewHeight <= 0 {
            let myRequest = URLRequest(url: OCTools.getEfficientAddress(url))
            kDeBugPrint(item: myRequest)
            webView1.loadRequest(myRequest)
        }
        
//        self.contentView.addSubview(webView1)
//        webView1.snp.makeConstraints { (ls) in
//            ls.left.bottom.top.right.equalToSuperview()
//        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        //开始加载
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) { //加载完成
        kDeBugPrint(item: webView.scrollView.contentSize.height)
        webViewHeight.constant = webView.scrollView.contentSize.height
        if webModel1.webViewHeight !=  CFloat(webView.scrollView.contentSize.height) {
            webModel1.webViewHeight = CFloat(webView.scrollView.contentSize.height)
            if willClick != nil {
                willClick!("")
            }
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.url?.absoluteString.contains("tbopen"))! {
            return false
        }
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
