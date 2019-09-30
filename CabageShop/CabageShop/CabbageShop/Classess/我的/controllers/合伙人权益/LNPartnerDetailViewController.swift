//
//  LNPartnerDetailViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/1.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNPartnerDetailViewController: LNBaseViewController {

    @IBOutlet weak var top_space: NSLayoutConstraint!
    
    @IBOutlet weak var content: UITextView!
    
    var isProtcol = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isProtcol {
            navigationTitle = "《使用协议》"
        }else{
            navigationTitle = "合伙人权益"
        }
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = UIColor.clear
        navigationBackGroundImage.backgroundColor = UIColor.clear
        
        top_space.constant = navHeight-kStatusBarH+10

        self.view.backgroundColor = kGaryColor(num: 39)
        
        content.clipsToBounds = true
        content.cornerRadius = 4
        
        let bgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH+80, height: kSCREEN_HEIGHT+100))
        bgView.image = getNavigationIMGVertical(NSInteger(self.view!.height+100), fromColor: kSetRGBColor(r: 255, g: 135, b: 82), toColor: kSetRGBColor(r: 255, g: 82, b: 84))
        bgView.contentMode = .scaleToFill
        self.view.insertSubview(bgView, at: 0)

    }

    override func requestData() {
        let request = SKRequest.init()
        weak var weakSelf = self
        
        
        request.callGET(withUrl: LNUrls().kSetting) { (response) in
            
            DispatchQueue.main.async {
                if !(response?.success)! {
                    return
                }
                var datas =  JSON((response?.data["data"])!)["data"]["level_desc"].stringValue

                if (weakSelf?.isProtcol)! {
                    datas =  JSON((response?.data["data"])!)["data"]["xieyi"].stringValue
                }

//                weakSelf?.content.text = datas
                
                let attrStr = try! NSMutableAttributedString(
                    data: (datas.data(using: .unicode, allowLossyConversion: true)!),
                    options:[.documentType: NSAttributedString.DocumentType.html,
                             .characterEncoding: String.Encoding.utf8.rawValue],
                    documentAttributes: nil)
                //行高
                let paraph = NSMutableParagraphStyle()
                paraph.lineSpacing = 8
                attrStr.addAttributes([NSAttributedStringKey.paragraphStyle:paraph],
                                      range: NSMakeRange(0, attrStr.length))
                
                weakSelf?.content.attributedText = attrStr

            }
        }
    }
}
