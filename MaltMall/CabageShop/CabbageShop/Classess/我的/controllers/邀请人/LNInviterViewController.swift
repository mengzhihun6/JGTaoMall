//
//  LNInviterViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/3.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class LNInviterViewController: LNBaseViewController {
   
    @IBOutlet weak var copy_btn: UIButton!
    
    @IBOutlet weak var share_btn: UIButton!
    
    var array = [String]() //图片数组
    var scrollView = UIScrollView()
    var InviteView : UIView!
    var urlStr = String()
    var inviteCodeStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "邀请合伙人"
        titleLabel.textColor = UIColor.white
//        navigationBgImage = UIImage.init(named: "Rectangle")
        navigaView.backgroundColor = UIColor.black;
        copy_btn.isHidden = true
        share_btn.isHidden = true
        
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 100, width: kSCREEN_WIDTH, height: 400))
        scrollView.backgroundColor = UIColor.clear
        scrollView.bounces = false // 弹性效果
        scrollView.showsHorizontalScrollIndicator = false // 水平方向滑动条 不显示
        self.view.addSubview(scrollView)
        weak var weakSelf = self
        scrollView.snp.makeConstraints { (ls) in
            ls.top.equalTo(weakSelf!.navigaView.snp.bottom)
//            ls.left.right.equalToSuperview()
            ls.left.right.equalTo(weakSelf!.view).inset(10)
            ls.bottom.equalTo(weakSelf!.copy_btn.snp.top)
        }
        
        requestImages()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (Defaults[kInviterArray] != nil) {
            let str: String = Defaults[kInviterArray]!
            let urlArr = str.components(separatedBy: ",")
            array = urlArr
            createClick()
        }
    }
    func requestImages() {
        let request = SKRequest.init()
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().KInvitation) { (response) in
            if !(response?.success)! {
                return
            }
            kDeBugPrint(item: response?.data)
            weakSelf?.array.removeAll()
            let datas =  JSON((response?.data["data"])!)["template"].arrayValue
            
            var stringUrl = ""
            for index in 0..<datas.count {
                weakSelf?.array.append(datas[index].stringValue)
                if index == 0 {
                    stringUrl = datas[index].stringValue
                } else {
                    stringUrl = stringUrl + "," + datas[index].stringValue
                }
            }
//            Defaults[kInviterArray] = stringUrl
            UserDefaults.standard.set( /*Defaults[kInviterArray]*/ stringUrl, forKey: "kInviterArray")
//            UserDefaults.standard.synchronize()
            weakSelf?.urlStr = JSON((response?.data["data"])!)["url"].stringValue
            weakSelf?.createClick()
        }
    }
    
    func createClick() {
        for views in scrollView.subviews {
            views.removeFromSuperview()
        }
        copy_btn.isHidden = false
        share_btn.isHidden = false
        for index in 0..<array.count {
            let urlString = array[index]
            let viewWidth = kSCREEN_WIDTH * 2 / 3
            let x = (self.view.width - viewWidth) / 2 + (viewWidth) * CGFloat(index), height = viewWidth * 667 / 375
            
            let bg_bg_View = UIView.init(frame: CGRect.init(x: x, y: (self.view.height - height  - navigaView.height - 50) / 2, width: viewWidth, height: height))
            bg_bg_View.tag = 10001
            scrollView.addSubview(bg_bg_View)
            let bg_view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: bg_bg_View.width, height: bg_bg_View.height))
            bg_view.tag = 10002
            bg_bg_View.addSubview(bg_view)
            
            let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: bg_view.width, height: bg_view.height ))
            imageView.sd_setImage(with: OCTools.getEfficientAddress(urlString), placeholderImage: UIImage.init(named: "goodImage_1"))
            imageView.isUserInteractionEnabled = true
            imageView.tag = 10003
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
            singleTap.numberOfTapsRequired = 1
            imageView.addGestureRecognizer(singleTap)
            bg_view.addSubview(imageView)
            
            let bunImageView = UIImageView.init(frame: CGRect.init(x: imageView.width - 30, y: 10, width: 20, height: 20))
            bunImageView.image = UIImage.init(named: "save_unselect")
            bunImageView.tag = 35
            bg_bg_View.addSubview(bunImageView)
            
            let codeImageView = UIImageView.init(frame: CGRect.init(x: 135 * viewWidth / 375, y: 490 * height / 667, width: 105 * viewWidth / 375, height: 105 * viewWidth / 375))
            codeImageView.image = setupQRCodeImage( urlStr, image: nil)
            bg_view.addSubview(codeImageView)
            
            
            let inviteiCodeLab = UILabel.init(frame: CGRect.init(x: 180 * viewWidth / 375, y: 615 * height / 667, width: 73 * viewWidth / 375, height: 24 * height / 667))
            inviteiCodeLab.text = "邀请码：" + inviteCodeStr
            inviteiCodeLab.font = UIFont.systemFont(ofSize: 10)
            inviteiCodeLab.textColor = UIColor.red
            bg_view.addSubview(inviteiCodeLab)
            
            inviteiCodeLab.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(codeImageView.snp_bottom).offset(2)
            }
            
            
            if index == 0 {
                bunImageView.image = UIImage.init(named: "save_select")
                InviteView = bg_view
            }
        }
        scrollView.contentSize = CGSize(width: (kSCREEN_WIDTH * 2 / 3 ) * CGFloat(array.count) + 15, height: scrollView.height)
        
    }
    // 选择图片
    @objc  func viewTheBigImage(ges:UITapGestureRecognizer) {
        kDeBugPrint(item: ges.view?.tag)
        let imageView = InviteView.superview?.viewWithTag(35) as! UIImageView
        imageView.image = UIImage.init(named: "save_unselect")
        
        let bg_view = ges.view?.superview
        let imageView1 = bg_view!.superview?.viewWithTag(35) as! UIImageView
        imageView1.image = UIImage.init(named: "save_select")
        
        InviteView = bg_view
    }
    
    override func configSubViews() {
        copy_btn.cornerRadius = copy_btn.height/2
        copy_btn.clipsToBounds = true
        
        share_btn.cornerRadius = share_btn.height/2
        share_btn.clipsToBounds = true
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        InviteView.DDGScreenShot { (image) in
            DispatchQueue.main.async {
                let activityItems = [image]
                let activityVC = UIActivityViewController.init(activityItems: activityItems as [Any], applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            }
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func copyAction(_ sender: UIButton) {
        
        let paste = UIPasteboard.general
        paste.string = inviteCodeStr
        setToast(str: "复制成功")
    }
    
    
}
