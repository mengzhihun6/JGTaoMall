//
//  LNShareViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/3.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNShareViewController: LNBaseViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    @objc var shareText : String?
    @objc var shareImage : String?
    @objc var shareUrl : URL?
    @objc var shareTitle : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.4)
        
        button1.layoutButton(with: .top, imageTitleSpace: 8)
        button2.layoutButton(with: .top, imageTitleSpace: 8)
        button3.layoutButton(with: .top, imageTitleSpace: 8)
        button4.layoutButton(with: .top, imageTitleSpace: 8)
        button5.layoutButton(with: .top, imageTitleSpace: 8)
        
        navigaView.isHidden = true
    }
    
    
    @IBAction func chooseSharePalatm(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            // 1.创建分享参数
            let shareParames = NSMutableDictionary()
            shareParames.ssdkSetupShareParams(byText: self.shareText,
                                              images :self.shareImage,
                                              url : self.shareUrl,
                                              title : self.shareTitle,
                                              type : .image)
            
            var platform = SSDKPlatformType.typeQQ
            
            switch sender.tag {
            case 101:
                platform = .typeWechat
            case 102:
                platform = .subTypeWechatTimeline
            case 103:
//                platform = .subTypeQQFriend
                
                if !((self.shareImage?.contains("http"))!) {
                    return
                }
                
                let data = try! Data.init(contentsOf: URL.init(string: self.shareImage!)!)
                let image = UIImage.init(data: data as Data)
                
                UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
                return
            case 104:
                platform = .typeSinaWeibo
            default:
                break
            }
            
            
            ShareSDK.share(platform, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
                
                switch state{
                case SSDKResponseState.success: break //setToast(str: "分享成功")
                case SSDKResponseState.fail:    setToast(str: "分享失败")
                case SSDKResponseState.cancel:
//                    setToast(str: "取消分享")
                    break
                default:
                    break
                }
            }
        }
        self.dismiss(animated: false, completion: nil)
    }
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error == nil {
            setToast(str: "已保存")
        }else{
            setToast(str: "保存失败，请重试")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
