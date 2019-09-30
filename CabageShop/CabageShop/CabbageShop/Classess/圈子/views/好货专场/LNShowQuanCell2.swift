//
//  LNShowQuanCell2.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON

class LNShowQuanCell2: UITableViewCell {

    
    @IBOutlet weak var user_icon: UIImageView!
    
    @IBOutlet weak var user_nickname: UILabel!
    
    @IBOutlet weak var share_count: UILabel!
    
    @IBOutlet weak var share_button: UIButton!
    
    @IBOutlet weak var quan_content: UILabel!
    
    @IBOutlet weak var quan_images: UIView!
    
    @IBOutlet weak var send_time: UILabel!
    
    @IBOutlet weak var imagesHeight: NSLayoutConstraint!
    
    let menu = UIMenuController.shared
    // 制作分享图片
    var bg_view = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        bg_view = UIView.init()
        bg_view.backgroundColor = UIColor.white//kSetRGBColor(r: 240, g: 237, b: 240)
//        self.contentView.addSubview(bg_view)
        
        share_button.layer.cornerRadius = share_button.height/2
        share_button.clipsToBounds = true
        share_button.layoutButton(with: .left, imageTitleSpace: 6)

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

    
    func setupValues(images:[LNQuanGoodsItems]) {
        
        _ = quan_images.subviews.map {
            $0.removeFromSuperview()
        }
        
        let count = images.count
        
        let kSpace = CGFloat(7)
        var kWidth = CGFloat()
        
        kWidth = (kSCREEN_WIDTH-kSpace*2-68-16)/3
        
        let kHeight = kWidth
        let lines = 3
        var commentHeight:CGFloat = 0

        //MARK: 根据图片的数量进行排列
        for index in 0..<count{
            let row =  CGFloat(index%lines)
            
            let imageV = UIImageView.init(frame: CGRect(x:(kWidth + kSpace) * row, y:(kSpace+kHeight)*CGFloat(index/lines), width: kWidth, height: kHeight))
            imageV.sd_setImage(with: OCTools.getEfficientAddress(images[index].pic_url), placeholderImage:  UIImage.init(named: "goodImage_1"))
            imageV.contentMode = .scaleAspectFill
            imageV.clipsToBounds = true
            imageV.isUserInteractionEnabled = true
            imageV.cornerRadius = 2

            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
            singleTap.numberOfTapsRequired = 1
            imageV.addGestureRecognizer(singleTap)
            
            imageV.tag = 170 + index
            quan_images.addSubview(imageV)
            
            let price_label = UILabel.init(frame: CGRect(x: imageV.width-kGetSizeOnString("￥"+OCTools().getStrWithFloatStr2(images[index].final_price), 9).width-6, y: imageV.height-20    , width: kGetSizeOnString("￥"+OCTools().getStrWithFloatStr2(images[index].final_price), 9).width+6, height: 13))
            price_label.text = "￥"+OCTools().getStrWithFloatStr2(images[index].final_price)
            price_label.font = UIFont.systemFont(ofSize: 9)
            price_label.textAlignment  = .center
            price_label.textColor = UIColor.white
//            price_label.backgroundColor = kMainColor1()
            
            let bgLayer1 = CAGradientLayer()
            bgLayer1.colors = [UIColor(red: 1, green: 0.39, blue: 0.69, alpha: 1).cgColor, UIColor(red: 0.41, green: 0.34, blue: 0.96, alpha: 1).cgColor]
            bgLayer1.locations = [0, 1]
            bgLayer1.frame = price_label.bounds
            bgLayer1.startPoint = CGPoint(x: -0.08, y: 0.12)
            bgLayer1.endPoint = CGPoint(x: 1, y: 1)
            price_label.layer.addSublayer(bgLayer1)
            
            let maskPath = UIBezierPath.init(roundedRect: price_label.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topLeft.rawValue)|UInt8(UIRectCorner.bottomLeft.rawValue))), cornerRadii: CGSize(width: 8, height: 8))
            
            let maskLayer = CAShapeLayer.init()
            maskLayer.frame = price_label.bounds
            maskLayer.path = maskPath.cgPath
            price_label.layer.mask = maskLayer
            imageV.addSubview(price_label)
            
            if Int(row) == 0 {
                commentHeight = commentHeight+kSpace+kWidth
            }
        }
        
//        var height = 0
//        let line = CGFloat((count)%3)
//        if line == 0 {
//            height = Int(CGFloat((count)/3)*kHeight + kSpace*CGFloat(count/3)-kSpace)
//        }else{
//            height = Int(CGFloat((count)/3+1)*kHeight + kSpace*CGFloat(count/3))
//        }
//        imagesHeight.constant = CGFloat(height)
        imagesHeight.constant = commentHeight
    }
    
    @objc  func viewTheBigImage(ges:UITapGestureRecognizer) {
        let detailVc = SZYGoodsViewController()
        if Defaults[kIsSuper_VIP] == "true" {
//            detailVc.isSuper_VIP = true
        }
        detailVc.good_item_id = model.items[(ges.view?.tag)!-170].itemid
        detailVc.coupone_type = model.items[(ges.view?.tag)!-170].type
        detailVc.goodsUrl = model.items[(ges.view?.tag)!-170].pic_url
       viewContainingController()?.navigationController?.pushViewController(detailVc, animated: true)
    }

    
    public var model : LNQuanGoodsModel = LNQuanGoodsModel(){
        didSet {
            
//            user_icon.sd_setImage(with: OCTools.getEfficientAddress(model.app_hot_image), placeholderImage: UIImage.init(named: "goodImage_1"))
            
//            user_nickname.text = model.title
            share_count.text = "已分享"+model.shares+"次"
            var text = model.text.replacingOccurrences(of: "<br/>", with: "\n")
            text = text.replacingOccurrences(of: "<br/>", with: "\n")
            quan_content.text = text
            setupValues(images: model.items)
            send_time.text = model.start_time
        }
    }
    
    var saveImages = [String]()
    var saveImage = [UIImage]()
    @IBAction func shareAction(_ sender: UIButton) {
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = quan_content.text
        
        LQLoadingView().SVPWillShow("文字已复制，正在生成图片")
        self.saveImages.removeAll()
        self.saveImage.removeAll()
        
        let vca: SZYGoodNightViewController = self.viewContainingController() as! SZYGoodNightViewController
        if !vca.loginClick() {
            return
        }
        if !vca.bindingClick() {
            return
        }
        huoqufenxiangshuju(num: 0)
    }
    
    func huoqufenxiangshuju(num: Int) {
        LQLoadingView().SVPHide()
        LQLoadingView().SVPWillShow("正在生成第" + String(num + 1) + "/" + String(model.items.count) + "张图片...") //"文字已复制，正在生成图片"
        
        let number = num + 1
        let item = model.items[num]
        let request = SKRequest.init()
        request.setParam(item.itemid as NSObject, forKey: "item_id")
        request.setParam("1" as NSObject, forKey: "type")
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kShare) { (response) in
            kDeBugPrint(item: response?.data)
            if !(response?.success)! {
                if weakSelf!.model.items.count == number {
                    LQLoadingView().SVPHide()
                    kDeBugPrint(item: weakSelf?.saveImage)
                    OCTools().presnetShareVc2(weakSelf?.viewContainingController()?.tabBarController, withImageUrls: nil, andImages: weakSelf?.saveImage, type: "2")
                } else {
                    weakSelf?.huoqufenxiangshuju(num: number)
                }
                return
            }
            let shareGoods = SZYShareGoodsModel.setupValues(json: JSON(response?.data["data"] as Any))
            shareGoods.pic_url = item.pic_url
            weakSelf?.shareClick(shareGoods: shareGoods, numInt: num)
            weakSelf?.saveImages.append(shareGoods.pic_url)
            if weakSelf!.model.items.count == number {
                LQLoadingView().SVPHide()
                kDeBugPrint(item: weakSelf?.saveImage)
                OCTools().presnetShareVc2(weakSelf?.viewContainingController()?.tabBarController, withImageUrls: nil, andImages: weakSelf?.saveImage, type: "2")
            } else {
                weakSelf?.huoqufenxiangshuju(num: number)
            }
        }
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        LQLoadingView().SVPwillSuccessShowAndHide("图片已保存")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func shareClick(shareGoods: SZYShareGoodsModel, numInt:Int) {
        for vie in bg_view.subviews {
            vie.removeFromSuperview()
        }
        // 标题
        var height: CGFloat = 25.0, width: CGFloat = kSCREEN_WIDTH - 100 - 20
        let strGao = KGetLabHeight(labelStr: shareGoods.title, font: UIFont.systemFont(ofSize: 15), width: width)
        let nameLab = UILabel.init(frame: CGRect.init(x: 10, y: height, width: width, height: strGao))
        nameLab.text = shareGoods.title
        nameLab.font = UIFont.systemFont(ofSize: 15)
        nameLab.numberOfLines = 0
        bg_view.addSubview(nameLab)
        // 现价 文字
        height = height + strGao + 10
        let labKuan = getLabWidth(labelStr: "现价", font: UIFont.systemFont(ofSize: 13), height: 30)
        let xianjia = UILabel.init(frame: CGRect.init(x: 10, y: height, width: labKuan, height: 30))
        xianjia.text = "现价"
        xianjia.font = UIFont.systemFont(ofSize: 13)
        xianjia.textColor = kSetRGBColor(r: 153, g: 153, b: 153)
        bg_view.addSubview(xianjia)
        // 现在的价格
        let labKuan1 = getLabWidth(labelStr: "¥" + shareGoods.price, font: UIFont.systemFont(ofSize: 13), height: 30)
        let price = UILabel.init(frame: CGRect.init(x: 10 + labKuan + 5, y: height, width: labKuan1, height: 30))
        price.textColor = kSetRGBColor(r: 153, g: 153, b: 153)
        price.text = "¥" + shareGoods.price
        price.font = UIFont.systemFont(ofSize: 13)
        bg_view.addSubview(price) // 价格的横线
        let priceView = UIView.init(frame: CGRect.init(x: 10 + labKuan + 5, y: height + 14.5, width: labKuan1, height: 1))
        priceView.backgroundColor = kSetRGBColor(r: 153, g: 153, b: 153)
        bg_view.addSubview(priceView)
        // 优惠券 图片
        height = height + 30 + 10
        let quanKuan1 = getLabWidth(labelStr: OCTools().getStrWithIntStr(shareGoods.coupon_price) + "元券", font: UIFont.systemFont(ofSize: 13), height: 25)
        let quanImageView = UIImageView.init(frame: CGRect.init(x: 10, y: height, width: quanKuan1 + 15, height: 25))
        quanImageView.image = UIImage.init(named: "coupon_bg")
        bg_view.addSubview(quanImageView)
        // 优惠券 券额
        let quanLab = UILabel.init(frame: CGRect.init(x: 10, y: height, width: quanKuan1 + 15, height: 25))
        quanLab.text = OCTools().getStrWithIntStr(shareGoods.coupon_price) + "元券"
        quanLab.textColor = UIColor.white
        quanLab.font = UIFont.systemFont(ofSize: 13)
        quanLab.textAlignment = .center
        bg_view.addSubview(quanLab)
        // 券后价 文字
        let quanKuan2 = getLabWidth(labelStr: "券后价", font: UIFont.systemFont(ofSize: 15), height: 25)
        let quanhoujiaLab = UILabel.init(frame: CGRect.init(x: 10 + quanKuan1 + 15 + 10, y: height, width: quanKuan2, height: 25))
        quanhoujiaLab.text = "券后价"
        quanhoujiaLab.textColor = kSetRGBColor(r: 30, g: 30, b: 30)
        quanhoujiaLab.font = UIFont.systemFont(ofSize: 15)
        bg_view.addSubview(quanhoujiaLab)
        // 券后价 价格
        let quanNumLab = UILabel.init(frame: CGRect.init(x: 10 + quanKuan1 + 15 + 10 + quanKuan2 + 5, y: height, width: width - (10 + quanKuan1 + 15 + 10 + quanKuan2 + 5 - 10), height: 25))
        quanNumLab.text = "¥" + shareGoods.final_price
        quanNumLab.textColor = kSetRGBColor(r: 234, g: 80, b: 57)
        quanNumLab.font = UIFont.systemFont(ofSize: 20)
        bg_view.addSubview(quanNumLab)
        // 横线
        height = height + 35
        let heng = UIView.init(frame: CGRect.init(x: 10, y: height, width: width, height: 1))
        heng.backgroundColor = kSetRGBColor(r: 238, g: 238, b: 238)
        bg_view.addSubview(heng)
        // 制作第一张图
        height = height + 15
        let bg_imageView = UIImageView.init(frame: CGRect.init(x: 10, y: height, width: width, height: width))
        let imageView = quan_images.subviews[numInt] as? UIImageView
        bg_imageView.image = imageView?.image
        bg_imageView.contentMode = .scaleAspectFill
        bg_imageView.clipsToBounds = true
        bg_view.addSubview(bg_imageView)
        // 制作二维码
        height = height + width + 20
        let qrCodeImageView = UIImageView.init(frame: CGRect.init(x: width + 10 - 100, y: height, width: 100, height: 100))
        qrCodeImageView.image = setupQRCodeImage(shareGoods.url, image: nil)
        bg_view.addSubview(qrCodeImageView)
        
        let app_logoImageView = UIImageView.init(frame: CGRect.init(x: 10 + (width - 100) / 2.0 - 25, y: height + 10, width: 50, height: 50))
        app_logoImageView.image = UIImage.init(named: "app_icon")  // UIImage.init(named: "app_logo")  // 523  158
        bg_view.addSubview(app_logoImageView)
        
        let app_nameLabel = UILabel.init(frame: CGRect.init(x: 10, y: height + 70, width: width - 100, height: 30))
        app_nameLabel.text = "白菜价  淘好货"
        app_nameLabel.textAlignment = .center
        app_nameLabel.font = UIFont.systemFont(ofSize: 15)
        bg_view.addSubview(app_nameLabel)
        
        //提示信息
        height = height + 120 + 5
        let lab = UILabel.init(frame: CGRect.init(x: 10, y: height, width: width, height: 30))
        lab.text = "长按识别二维码购买商品"
        lab.textColor = kSetRGBColor(r: 150, g: 150, b: 150)
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 13)
        bg_view.addSubview(lab)
        
        height = height + 30
        bg_view.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH - 100, height: height + 15)
        
        weak var weakSelf = self
        bg_view.DDGScreenShot { (image) in
            weakSelf?.saveImage.append(image!)
        }
    }
}
