//
//  LNShowQuanCell1.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/29.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class LNShowQuanCell1: UITableViewCell {

    @IBOutlet weak var user_icon: UIImageView!
    
    @IBOutlet weak var user_nickname: UILabel!
    
    @IBOutlet weak var share_count: UILabel!
    
    @IBOutlet weak var share_button: UIButton!
    @IBOutlet weak var buy_button: UIButton!

    @IBOutlet weak var quan_content: UILabel!
    
    @IBOutlet weak var quan_images: UIView!
    
    @IBOutlet weak var send_time: UILabel!
    
    @IBOutlet weak var quan_comments: UIView!
        
    @IBOutlet weak var imagesHeight: NSLayoutConstraint!
    
    @IBOutlet weak var comments_height: NSLayoutConstraint!
    
    @IBOutlet weak var yujizhuanBun: UIButton!
    let menu = UIMenuController.shared

    fileprivate var theCount = Int()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        yujizhuanBun.layoutButton(with: .left, imageTitleSpace: 9)
        
        share_button.layer.cornerRadius = share_button.height/2
        share_button.clipsToBounds = true
        share_button.layoutButton(with: .left, imageTitleSpace: 6)
        
        
        buy_button.layer.cornerRadius = share_button.height/2
        buy_button.clipsToBounds = true
        buy_button.layoutButton(with: .left, imageTitleSpace: 6)
        buy_button.backgroundColor = kMainColor1()
        user_icon.layer.cornerRadius = user_icon.height/2
        user_icon.clipsToBounds = true

        
        quan_content.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(ges:)))
        longPress.minimumPressDuration = 1
        longPress.numberOfTouchesRequired = 1
        quan_content.addGestureRecognizer(longPress)
        
        quan_content.becomeFirstResponder()
        quan_content.canPerformAction(#selector(copyAction), withSender: quan_content)

    }
    
    @objc  func copyAction() {
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = quan_content.text
        
        setToast(str: "已复制到粘贴板")
    }
    
    
    @objc  func longPressAction(ges:UIGestureRecognizer) {
        
        if ges.state == .began {
            contentView.becomeFirstResponder()
            self.becomeFirstResponder() // 这句很重要
            
            let copyItem = UIMenuItem.init(title: "复制", action: #selector(copyAction))
            
            
            menu.setTargetRect(CGRect(x: quan_content.width/2+25, y: 58, width: 50, height: 20), in: contentView)
            menu.menuItems = [copyItem]
            menu.setMenuVisible(true, animated: true)
            menu.isMenuVisible = true
            
        }
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if [#selector(copyAction)].contains(action) {
            return true
        }
        return false
    }
    // MARK: - 必须实现的两个方法
    
    override var canBecomeFirstResponder: Bool {
        
        return true
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        menu.isMenuVisible = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupValues(images:[String],comments:[String]) {
        
        _ = quan_images.subviews.map {
            $0.removeFromSuperview()
        }

        theCount = images.count
        let count = images.count
//        let count2 = comments.count

        let kSpace = CGFloat(7)
        var kWidth = CGFloat()
        
        kWidth = (kSCREEN_WIDTH-kSpace*2-68-16)/3
        
        let kHeight = kWidth
        let lines = 3
        
        var height:CGFloat = 0

        //MARK: 根据图片的数量进行排列
        for index in 0..<count{
            let row =  CGFloat(index%lines)
            
            let imageV = UIImageView.init(frame: CGRect(x:(kWidth + kSpace) * row, y:(kSpace+kHeight)*CGFloat(index/lines), width: kWidth, height: kHeight))
            imageV.sd_setImage(with: OCTools.getEfficientAddress(images[index]), placeholderImage: UIImage.init(named: "goodImage_1"))
            imageV.contentMode = .scaleAspectFill
            imageV.clipsToBounds = true
            imageV.isUserInteractionEnabled = true
            imageV.cornerRadius = 2
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
            singleTap.numberOfTapsRequired = 1
            imageV.addGestureRecognizer(singleTap)
            
            imageV.tag = 170 + index
            quan_images.addSubview(imageV)
            
            if row == 0 {
                height = height+kSpace+kHeight
            }
        }
        
//        let line = CGFloat((count)%2)
//        if line == 0 {
//            height = Int(CGFloat((count)/2)*kHeight + kSpace*CGFloat(count/2)-kSpace)
//        }else{
//            height = Int(CGFloat((count)/2+1)*kHeight + kSpace*CGFloat(count/2))
//        }
        imagesHeight.constant = height+kSpace
        
        
        _ = quan_comments.subviews.map {
            $0.removeFromSuperview()
        }

        var commentHeight:CGFloat = 0
        let bgWidth = kSCREEN_WIDTH-kSpace*2-68-20
        for index in 0..<comments.count{
            
            var text = comments[index].replacingOccurrences(of: "<br>", with: "\n")
            text = text.replacingOccurrences(of: "<br/>", with: "\n")
            let str_height = KGetLabHeight(labelStr: text, font: UIFont.systemFont(ofSize: 13), width: bgWidth-20)+10
            
//            if str_height < 40 {
//                str_height = 40
//            }
            
            let bgView = UIView.init(frame: CGRect(x:0, y:commentHeight, width: bgWidth, height: str_height))
            bgView.backgroundColor = kGaryColor(num: 244)
            bgView.tag = index + 10
            bgView.layer.cornerRadius = 3
            
            let comment = UILabel.init(frame: CGRect(x:4, y:0, width: bgWidth-20-8, height: bgView.height))
            comment.clipsToBounds = true
            comment.text = text
            comment.centerY = bgView.centerY
            comment.numberOfLines = 0
            comment.textColor = kGaryColor(num: 102)
            comment.font = UIFont.systemFont(ofSize: 13)
            comment.tag = 100
            comment.backgroundColor = UIColor.clear
            bgView.addSubview(comment)
            
            let button = UIButton.init(frame: CGRect(x: bgView.width-20, y: 0, width: 40, height: 40))
            button.backgroundColor = kSetRGBColor(r: 113, g: 179, b: 255)
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitle("复制\n评论", for: .normal)
            button.clipsToBounds = true
            button.cornerRadius = 5
            button.addTarget(self, action: #selector(copyText(sender:)), for: .touchUpInside)
            bgView.addSubview(button)
            
            commentHeight = commentHeight+str_height+kSpace
            
            comment.frame = CGRect(x:8, y:0, width: bgWidth-20-15, height: bgView.height)

            button.frame = CGRect(x: bgView.width-30, y: 0, width: 40, height: 40)
            button.centerY = comment.centerY

            quan_comments.addSubview(bgView)

        }
        
        comments_height.constant = commentHeight
        
    }
    
    @objc fileprivate func copyText(sender: UIButton) {  // 复制文档
        
        let label = sender.superview?.viewWithTag(100) as! UILabel
        let paste = UIPasteboard.general

        if model.comment1.count > 1 && sender.superview?.tag == 10{
            
            let vca: SZYItemViewController = viewContainingController() as! SZYItemViewController
            
            if !vca.loginClick() {
                return
            }
            
            let request = SKRequest.init()
            request.setParam(model.itemid as NSObject, forKey: "item_id")
            request.setParam("1" as NSObject, forKey: "type")
            weak var weakSelf = self
            LQLoadingView().SVPwillShowAndHideNoText1()
            request.callGET(withUrl1: LNUrls().kShare) { (response) in
                LQLoadingView().SVPHide()
                kDeBugPrint(item: response?.data)
                let code = JSON(response?.code as Any).stringValue
                var dataString = ""
                if code == "4005" {
                    dataString =  JSON((response?.data["data"])!).stringValue
                }
                if !vca.jumpPageClick(code: code, urlStr: dataString) {
                    return
                }
                if !(response?.success)! {
                    setToast(str: (response?.message)!)
                    return
                }
                var text = weakSelf?.model.comment1.replacingOccurrences(of: "$淘口令$", with: JSON((response?.data)!)["data"]["kouling"].stringValue)
                text = text!.replacingOccurrences(of: "<br>", with: "\n")
                kDeBugPrint(item: response?.data)
                kDeBugPrint(item: text)
                paste.string = text!.replacingOccurrences(of: "<br/>", with: "\n")
                setToast(str: "已复制")
            }
        }else{
            paste.string = label.text
            setToast(str: "已复制")
        }
    }
    
    @objc  func viewTheBigImage(ges:UITapGestureRecognizer) {
        
        var images = [KSPhotoItem]()
        
        for index in 0..<theCount {
            let theView = quan_images.viewWithTag(index+170) as! UIImageView
            let watchIMGItem = KSPhotoItem.init(sourceView: theView, image: theView.image)
            images.append(watchIMGItem!)
        }
        
        let watchIMGView = KSPhotoBrowser.init(photoItems: images,
                                               selectedIndex:UInt((ges.view?.tag)!-170))
        watchIMGView?.dismissalStyle = .scale
        watchIMGView?.backgroundStyle = .blurPhoto
        watchIMGView?.loadingStyle = .indeterminate
        watchIMGView?.pageindicatorStyle = .text
        watchIMGView?.bounces = false
        watchIMGView?.show(from: viewContainingController()!)
    }    
    
    
    public var model : LNQuanSingleModel = LNQuanSingleModel(){
        didSet {

            share_count.text = "已分享"+model.shares+"次"
            
            var text = model.content.replacingOccurrences(of: "<br>", with: "\n")
            text = text.replacingOccurrences(of: "<br/>", with: "\n")
            quan_content.text = text
            
            var comments = [String]()
            if model.comment1.count>0 {
                comments.append(model.comment1)
            }
            if model.comment2.count>0 {
                comments.append(model.comment2)
            }
//            if OCTools().getStrWithFloatStr2(model.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model.finalCommission) != "0.00"{
//                yujizhuanBun.isHidden = false
//                yujizhuanBun.setTitle("预计赚：￥"+OCTools().getStrWithFloatStr2(model.finalCommission), for: .normal)
//            }else{
//                yujizhuanBun.isHidden = true
//            }
            if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
                yujizhuanBun.isHidden = true
            } else {
                yujizhuanBun.isHidden = false
                let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
                yujizhuanBun.setTitle("预计赚：￥" + String.init(format:"%.2f",jieguo), for: .normal)
            }
            
            
            setupValues(images: model.pic_url, comments: comments)
            send_time.text = model.show_at
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) { //分享
//        if Defaults[kBandingPhone] == "0" || Defaults[kBandingInviter] == "0" {
//            isBanding = true
//            if Defaults[kBandingPhone] == "0" {
//                let nav = LNNavigationController.init(rootViewController: LNBandingPhoneViewController())
//                viewContainingController()?.tabBarController?.present(nav, animated: true, completion: nil)
//            }else{
//                let nav = LNNavigationController.init(rootViewController: LNBandingCodeViewController())
//                viewContainingController()?.tabBarController?.present(nav, animated: true, completion: nil)
//            }
//            return
//        }
//        let item: SZYItemViewController = self.viewContainingController() as! SZYItemViewController
//        if !item.bindingClick() {
//            return
//        }
        setToast(str: "内容已复制")
        let pasteboard = UIPasteboard.general
        pasteboard.string = quan_content.text
        OCTools().presnetShareVc2(self.viewContainingController()?.tabBarController, withImageUrls: model.pic_url, andImages: nil)

//        return
//        if model.pic_url.count<2 {
//            return
//        }
//        let request = SKRequest.init()
//        request.setParam(model.pic_url[1] as NSObject, forKey: "pic_url")
//        request.setParam(model.itemid as NSObject, forKey: "item_id")
//        request.setParam("1" as NSObject, forKey: "type")
//        LQLoadingView().SVPWillShow("文字已复制，正在生成图片")
//        request.callGET(withUrl: LNUrls().kShare) { (response) in
//            LQLoadingView().SVPHide()
//            if !(response?.success)! {
//                setToast(str: "分享参数获取失败")
//                return
//            }
//            OCTools().presnet(self.viewContainingController()?.tabBarController, imageUrl: JSON((response?.data)!)["data"].stringValue, callback: nil)
//        }
        
    }
    
    
    @IBAction func buyAction(_ sender: UIButton) { // 购买
        let detailVc = SZYGoodsViewController()
//        if Defaults[kIsSuper_VIP] == "true" {
//            detailVc.isSuper_VIP = true
//        }
        detailVc.good_item_id = model.itemid
        detailVc.coupone_type = "1"
        viewContainingController()?.navigationController?.pushViewController(detailVc, animated: true)
    }

    
    

}
