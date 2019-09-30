//
//  SZYShareGoodsViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/7.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import DeviceKit

class SZYShareGoodsViewController: LNBaseViewController, UIScrollViewDelegate {
    
    var goodsModel = SZYGoodsInformationModel()
    var shareGoods = SZYShareGoodsModel()
    
    var string = ""
    var array = [String]()
    var imageS = [String]()
    
    var segmentedControl = UISegmentedControl()
    var scrollView = UIScrollView()
    var bg_view = UIView()
    var bg_bg_view = UIView()
    var numLab = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigaView.backgroundColor = UIColor.black
        backBtn.setImage(UIImage.init(named: "nav_return_black"), for: .normal)
        
    }
    //  导航上面的按钮  选择点击后的事件
    @objc func segmentedControlChanged(sender:UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        
        print(sender.titleForSegment(at: sender.selectedSegmentIndex) as Any)
        
        if sender.selectedSegmentIndex == 0 {
            scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        } else if sender.selectedSegmentIndex == 1 {
            scrollView.contentOffset = CGPoint.init(x: kSCREEN_WIDTH, y: 0)
        }
    }
    @objc override func rightAction(sender: UIButton) {
//        self.view.window?.rootViewController = LNMainTabBarController()
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func configSubViews() {
        string = goodsModel.share.content
        array.append(goodsModel.pic_url)
        imageS.append(goodsModel.pic_url)
        for urlString in goodsModel.images {
            array.append(urlString)
        }
        
        var backBtnCenterY = navigaView.centerY + 10
        var gao = navHeight
        if kSCREEN_HEIGHT >= 812 {
            backBtnCenterY = navigaView.centerY + 20
            gao = navHeight + 20
        }
        
        rightBtn1.setImage(UIImage.init(named: "home"), for: .normal)
        rightBtn1.setTitleColor(UIColor.black, for: .normal)
//        导航上面的按钮
        let items = [ "分享文案", "分享图片"] as [Any] //分段选项显示
        segmentedControl = UISegmentedControl(items:items) //初始化对象
        segmentedControl.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH * 2 / 3.0, height: 30) //设置from
        segmentedControl.center = CGPoint.init(x: navigaView.centerX, y: backBtnCenterY) //设置位置
        segmentedControl.selectedSegmentIndex = 0 //当前选中下标
        segmentedControl.tintColor = UIColor.white //颜色设定
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: UIControlEvents.valueChanged) //添加事件
        navigaView.addSubview(segmentedControl) //添加
//        底部scrollView
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: gao, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - gao))
        scrollView.delegate = self
        scrollView.tag = 10001
        scrollView.bounces = false // 弹性效果
        scrollView.isPagingEnabled = true // 分页
        scrollView.showsHorizontalScrollIndicator = false // 水平方向滑动条 不显示
        scrollView.showsVerticalScrollIndicator = false // 垂直方向上滑动条 不显示
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: kSCREEN_WIDTH * 2, height: scrollView.height)
        
//        第一页scrollView
        let scroll = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: scrollView.height))
        scroll.tag = 10002
        scroll.delegate = self
        scrollView.addSubview(scroll)
        // 文案底层 背景色
        var height = KGetLabHeight(labelStr: string, font: UIFont.systemFont(ofSize: 13), width: (kSCREEN_WIDTH - 30))
        let bg_textView = UIView.init(frame: CGRect.init(x: 10, y: 15, width: kSCREEN_WIDTH - 20, height: height + 10))
        bg_textView.backgroundColor = kSetRGBColor(r: 237, g: 235, b: 237)
        scroll.addSubview(bg_textView)
        // 显示文案
        let textView = UILabel.init(frame: CGRect.init(x: 5, y: 5, width: kSCREEN_WIDTH - 30, height: height))
        textView.text = string
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.numberOfLines = 0
        textView.textColor = kSetRGBColor(r: 50, g: 50, b: 50)
        bg_textView.addSubview(textView)
        // 复制按钮
        height = height + 10 + 15 + 15
        let fuzhi = UIButton.init(frame: CGRect.init(x: 10, y: height, width: kSCREEN_WIDTH - 20, height: 45))
        fuzhi.clipsToBounds = true
        fuzhi.cornerRadius = 5
        fuzhi.backgroundColor = UIColor.black
        fuzhi.setTitle("复制文案", for: .normal)
        fuzhi.setTitleColor(UIColor.white, for: .normal)
        fuzhi.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        fuzhi.addTarget(self, action: #selector(fuzhiButtonClick(bun:)), for: .touchUpInside)
        scroll.addSubview(fuzhi)
        // 提示信息
        height = height + 45 + 20
        let labHeight = KGetLabHeight(labelStr: "麦芽淘提供技术支持, 请自行确保分享内容真实合法(如不使用淘宝内部优惠券, 好评返现等虚假描述)", font: UIFont.systemFont(ofSize: 15), width: kSCREEN_WIDTH - 20)
        let tishi = UILabel.init(frame: CGRect.init(x: 10, y: height, width: kSCREEN_WIDTH - 20, height: labHeight + 50))
        tishi.text = "麦芽淘仅提供技术支持, 请自行确保分享内容真实合法(如不使用淘宝内部优惠券, 好评返现等虚假描述)"
        tishi.numberOfLines = 0
        tishi.font = UIFont.systemFont(ofSize: 15)
        tishi.textColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.45)
        scroll.addSubview(tishi)
        // 添加行间距
        let paraStyle = NSMutableParagraphStyle.init()
        paraStyle.lineBreakMode = .byCharWrapping
        paraStyle.alignment = .left
        paraStyle.lineSpacing = 6
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0
        paraStyle.tailIndent = 0
        let dictionary = [NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.paragraphStyle: paraStyle, NSAttributedStringKey.kern: 1.0] as! [NSAttributedStringKey : Any]
        let attributeStr = NSAttributedString.init(string: tishi.text!, attributes: dictionary)
        tishi.attributedText = attributeStr
        
        height = height + labHeight
        if height > scroll.height {
            scroll.contentSize = CGSize(width: kSCREEN_WIDTH, height: height)
        }
        secondClick()
    }
    // 复制文案事件
    @objc func fuzhiButtonClick(bun: UIButton) {
        let paste = UIPasteboard.general
        paste.string = string
        setToast(str: "复制成功")
    }
    // 第二个页面 事件
    func secondClick() {
        let scroll = UIScrollView.init(frame: CGRect.init(x: kSCREEN_WIDTH, y: 0, width: kSCREEN_WIDTH, height: scrollView.height - 50))
        scroll.delegate = self
        scroll.backgroundColor = kSetRGBColor(r: 240, g: 237, b: 240)
        scroll.tag = 10003
        scrollView.addSubview(scroll)
        // 底部按钮
        for index in 0..<2 {
            let bun = UIButton.init(frame: CGRect.init(x: kSCREEN_WIDTH + kSCREEN_WIDTH / 2.0 * CGFloat(index), y: scrollView.height - 50, width: kSCREEN_WIDTH / 2.0, height: 50))
            bun.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            if index == 0 {
                bun.setTitle("保存图片", for: .normal)
                bun.setTitleColor(UIColor.white, for: .normal)
                bun.backgroundColor = UIColor.hex(" #F3D6B5")
            } else {
                bun.setTitle("立即分享", for: .normal)
                bun.setTitleColor(UIColor.white, for: .normal)
                bun.backgroundColor = UIColor.black
            }
            bun.tag = 200 + index
            bun.addTarget(self, action: #selector(buttonClick(bun:)), for: .touchUpInside)
            scrollView.addSubview(bun)
        }
        // 提示信息
        let width = getLabWidth(labelStr: "选择宝贝图", font: UIFont.systemFont(ofSize: 13), height: 30)
        let nameLab = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: width, height: 30))
        nameLab.text = "选择宝贝图"
        nameLab.font = UIFont.systemFont(ofSize: 13)
        nameLab.textColor = kSetRGBColor(r: 66, g: 66, b: 66)
        scroll.addSubview(nameLab)
        // 选中的图片数
        let width1 = getLabWidth(labelStr: "2", font: UIFont.systemFont(ofSize: 13), height: 30)
        numLab = UILabel.init(frame: CGRect.init(x: 10 + width + 5, y: 5, width: width1, height: 30))
        numLab.text = "1"
        numLab.textAlignment = .right
        numLab.textColor = kSetRGBColor(r: 243, g: 108, b: 55)
        numLab.font = UIFont.systemFont(ofSize: 13)
        scroll.addSubview(numLab)
        // 总图品数
        let width2 = getLabWidth(labelStr: "/" + String(array.count), font: UIFont.systemFont(ofSize: 13), height: 30)
        let zongLab = UILabel.init(frame: CGRect.init(x: 10 + width + 5 + width1, y: 5, width: width2, height: 30))
        zongLab.text = "/" + String(array.count)
        zongLab.textColor = kSetRGBColor(r: 150, g: 150, b: 150)
        zongLab.font = UIFont.systemFont(ofSize: 13)
        scroll.addSubview(zongLab)
        // 提示信息
        let tishiLab = UILabel.init(frame: CGRect.init(x: 10 + width + 5 + width1 + width2 + 20, y: 5, width: kSCREEN_WIDTH - (10 + width + 5 + width1 + width2 + 20) - 10, height: 30))
        tishiLab.text = "选择多张宝贝图将自动生成1张拼图"
        tishiLab.textAlignment = .right
        tishiLab.textColor = kSetRGBColor(r: 150, g: 150, b: 150)
        tishiLab.font = UIFont.systemFont(ofSize: 13)
        scroll.addSubview(tishiLab)
        // 滑动 商品图 UIScrollView
        let scrollImage = UIScrollView.init(frame: CGRect.init(x: 0, y: 40, width: kSCREEN_WIDTH, height: 100))
        scrollImage.tag = 10004
        scrollImage.delegate = self
        scrollImage.showsHorizontalScrollIndicator = false // 水平方向滑动条 不显示
        scrollImage.showsVerticalScrollIndicator = false // 垂直方向上滑动条 不显示
        scroll.addSubview(scrollImage)
        // 滑动 商品图
        for index in 0..<array.count {
            let imageV = UIImageView.init(frame: CGRect(x: 10 + 110 * index, y: 0, width: 100, height: 100))
            imageV.sd_setImage(with: OCTools.getEfficientAddress(array[index]), placeholderImage: UIImage.init(named: "goodImage_1"))
            imageV.tag = index + 100
            imageV.contentMode = .scaleAspectFill
            imageV.clipsToBounds = true
            imageV.isUserInteractionEnabled = true
            imageV.cornerRadius = 2
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
            singleTap.numberOfTapsRequired = 1
            imageV.addGestureRecognizer(singleTap)
            scrollImage.addSubview(imageV)
            
            let mark = UIButton.init(frame: CGRect(x: imageV.width - 20, y: 0, width: 20, height: 20))
            mark.setImage(UIImage.init(named: "save_unselect"), for: .normal)
            mark.setImage(UIImage.init(named: "save_select"), for: .selected)
            mark.tag = 10
            mark.isUserInteractionEnabled = false
            imageV.addSubview(mark)
            mark.isSelected = imageS.contains(array[index])
        }
        scrollImage.contentSize = CGSize(width: 110 * array.count + 10, height: 100)
        // 背景view
        bg_bg_view = UIView.init(frame: CGRect.init(x: 50, y: 150, width: kSCREEN_WIDTH - 100, height: 200))
        bg_bg_view.backgroundColor = kSetRGBColor(r: 240, g: 237, b: 240)
        scroll.addSubview(bg_bg_view)
        bg_view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH - 100, height: 200))
        bg_view.backgroundColor = UIColor.white//kSetRGBColor(r: 240, g: 237, b: 240)
        bg_bg_view.addSubview(bg_view)
        
        bg_viewClick()
    }
    // 选择图片
    @objc  func viewTheBigImage(ges:UITapGestureRecognizer) {
        kDeBugPrint(item: ges.view?.tag)
        let tag = (ges.view?.tag)! - 100
        let urlString = array[tag]
        
        if imageS.contains(urlString) {
            if imageS.count == 1 {
                setToast(str: "最少选择一张图片")
                return
            }
            for index in 0..<imageS.count {
                if imageS[index] == urlString {
                    imageS.remove(at: index)
                    break
                }
            }
        } else {
            imageS.append(urlString)
        }
        numLab.text = String(imageS.count)
        let bun = ges.view?.viewWithTag(10) as! UIButton
        bun.isSelected = !bun.isSelected
        bg_viewClick()
    }
    // 制作 分享图
    func bg_viewClick() {
        for views in bg_view.subviews {
            views.removeFromSuperview()
        }
        var height: CGFloat = 25.0, width: CGFloat = kSCREEN_WIDTH - 100 - 20
        
        //  标题
        let strGao = KGetLabHeight(labelStr: goodsModel.title, font: UIFont.systemFont(ofSize: 15), width: width)
        let nameLab = UILabel.init(frame: CGRect.init(x: 10, y: height, width: width, height: strGao))
        nameLab.text = goodsModel.title
        nameLab.font = UIFont.systemFont(ofSize: 15)
        nameLab.numberOfLines = 0
        bg_view.addSubview(nameLab)
        // 原价 文字
        height = height + strGao + 10
        let labKuan = getLabWidth(labelStr: "原价", font: UIFont.systemFont(ofSize: 13), height: 30)
        let xianjia = UILabel.init(frame: CGRect.init(x: 10, y: height, width: labKuan, height: 30))
        xianjia.text = "原价"
        xianjia.font = UIFont.systemFont(ofSize: 13)
        xianjia.textColor = kSetRGBColor(r: 153, g: 153, b: 153)
        bg_view.addSubview(xianjia)
        // 现在的价格
        let labKuan1 = getLabWidth(labelStr: "¥" + goodsModel.price, font: UIFont.systemFont(ofSize: 13), height: 30)
        let price = UILabel.init(frame: CGRect.init(x: 10 + labKuan + 5, y: height, width: labKuan1, height: 30))
        price.textColor = kSetRGBColor(r: 153, g: 153, b: 153)
        price.text = "¥" + goodsModel.price
        price.font = UIFont.systemFont(ofSize: 13)
        bg_view.addSubview(price) // 价格的横线
        let priceView = UIView.init(frame: CGRect.init(x: 10 + labKuan + 5, y: height + 14.5, width: labKuan1, height: 1))
        priceView.backgroundColor = kSetRGBColor(r: 153, g: 153, b: 153)
        bg_view.addSubview(priceView)
        // 优惠券 图片
        height = height + 30 + 10
        let quanKuan1 = getLabWidth(labelStr: OCTools().getStrWithIntStr(goodsModel.coupon_price) + "元券", font: UIFont.systemFont(ofSize: 13), height: 25)
        let quanImageView = UIImageView.init(frame: CGRect.init(x: 10, y: height, width: quanKuan1 + 15, height: 25))
        quanImageView.image = UIImage.init(named: "coupon_bg")
        bg_view.addSubview(quanImageView)
        // 优惠券 券额
        let quanLab = UILabel.init(frame: CGRect.init(x: 10, y: height, width: quanKuan1 + 15, height: 25))
        quanLab.text = OCTools().getStrWithIntStr(goodsModel.coupon_price) + "元券"
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
        quanNumLab.text = "¥" + goodsModel.final_price
        quanNumLab.textColor = kSetRGBColor(r: 234, g: 80, b: 57)
        quanNumLab.font = UIFont.systemFont(ofSize: 20)
        bg_view.addSubview(quanNumLab)
        
        height = height + 30 + 5
        
        let heng = UIView.init(frame: CGRect.init(x: 10, y: height, width: width, height: 1))
        heng.backgroundColor = kSetRGBColor(r: 238, g: 238, b: 238)
        bg_view.addSubview(heng)
        
        height = height + 15
        // 制作第一张图
        let bg_imageView = UIImageView.init(frame: CGRect.init(x: 10, y: height, width: width, height: width))
        for urlString in array {
            if imageS.contains(urlString) {
                bg_imageView.sd_setImage(with: OCTools.getEfficientAddress(urlString), placeholderImage: UIImage.init(named: "goodImage_1"))
                break
            }
        }
        bg_imageView.contentMode = .scaleAspectFill
        bg_imageView.clipsToBounds = true
        bg_view.addSubview(bg_imageView)
        // 根据不同的选择 制作图片效果
        height = height + width
        var num = 0
        if imageS.count == 2 {
            let imageView = UIImageView.init(frame: CGRect.init(x: 10, y: height, width: width, height: width))
            for urlString in array {
                if imageS.contains(urlString) {
                    if num == 1 {
                        imageView.sd_setImage(with: OCTools.getEfficientAddress(urlString), placeholderImage: UIImage.init(named: "goodImage_1"))
                        break
                    }
                    num += 1
                }
            }
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            bg_view.addSubview(imageView)
            
            height = height + width
        } else if imageS.count == 3 {
            for index in 0..<2 {
                let imageView = UIImageView.init(frame: CGRect.init(x: 10 + width / 2.0 * CGFloat(index), y: height, width: width / 2.0, height: width / 2.0))
                num = 0
                for urlString in array {
                    if imageS.contains(urlString) {
                        if num == index + 1 {
                            kDeBugPrint(item: index)
                            kDeBugPrint(item: num)
                            kDeBugPrint(item: urlString)
                            imageView.sd_setImage(with: OCTools.getEfficientAddress(urlString), placeholderImage: UIImage.init(named: "goodImage_1"))
                        }
                        num += 1
                    }
                }
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                bg_view.addSubview(imageView)
            }
            height = height + width / 2.0
        } else if imageS.count == 4 {
            for index in 0..<3 {
                let imageView = UIImageView.init(frame: CGRect.init(x: 10 + width / 3.0 * CGFloat(index), y: height, width: width / 3.0, height: width / 3.0))
                num = 0
                for urlString in array {
                    if imageS.contains(urlString) {
                        if num == index + 1 {
                            kDeBugPrint(item: index)
                            kDeBugPrint(item: num)
                            kDeBugPrint(item: urlString)
                            imageView.sd_setImage(with: OCTools.getEfficientAddress(urlString), placeholderImage: UIImage.init(named: "goodImage_1"))
                        }
                        num += 1
                    }
                }
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                bg_view.addSubview(imageView)
            }
            height = height + width / 3.0
            
        } else if imageS.count == 5 {
            for index in 0..<4 {
                let imageView = UIImageView.init(frame: CGRect.init(x: 10 + width / 2.0 * CGFloat(index % 2), y: height, width: width / 2.0, height: width / 2.0))
                num = 0
                for urlString in array {
                    if imageS.contains(urlString) {
                        if num == index + 1 {
                            kDeBugPrint(item: index)
                            kDeBugPrint(item: num)
                            kDeBugPrint(item: urlString)
                            imageView.sd_setImage(with: OCTools.getEfficientAddress(urlString), placeholderImage: UIImage.init(named: "goodImage_1"))
                        }
                        num += 1
                    }
                }
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                bg_view.addSubview(imageView)
                
                if index == 1 {
                    height = height + width / 2.0
                }
            }
            height = height + width / 2.0
        }
        
        height = height + 25 //app_logo
        let qrCodeImageView = UIImageView.init(frame: CGRect.init(x: width + 10 - 100, y: height, width: 100, height: 100))
        qrCodeImageView.image = setupQRCodeImage( goodsModel.share.url, image: nil)
        bg_view.addSubview(qrCodeImageView)
        
        let app_logoImageView = UIImageView.init(frame: CGRect.init(x: 10 + (width - 100) / 2.0 - 25, y: height + 10, width: 50, height: 50))
        app_logoImageView.image = UIImage.init(named: "jg_logo_1")  // UIImage.init(named: "app_logo")  // 523  158
        bg_view.addSubview(app_logoImageView)

        let app_nameLabel = UILabel.init(frame: CGRect.init(x: 10, y: height + 70, width: width - 100, height: 30))
        app_nameLabel.text = "麦芽价  淘好货"
        app_nameLabel.textAlignment = .center
        app_nameLabel.font = UIFont.systemFont(ofSize: 15)
        bg_view.addSubview(app_nameLabel)
        
        
        
        height = height + 120 + 5
        let lab = UILabel.init(frame: CGRect.init(x: 10, y: height, width: width, height: 30))
        lab.text = "长按识别二维码购买商品"
        lab.textColor = kSetRGBColor(r: 150, g: 150, b: 150)
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 13)
        bg_view.addSubview(lab)
        
        height = height + 30
        
        bg_view.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH - 100, height: height + 15)
        bg_bg_view.frame = CGRect.init(x: 50, y: 150, width: kSCREEN_WIDTH - 100, height: height + 15)
        let scroll = bg_bg_view.superview as! UIScrollView
        scroll.contentSize = CGSize(width: kSCREEN_WIDTH, height: 150 + height + 15 + 20)
    }
    // 保存图片 分享事件
    @objc func buttonClick(bun: UIButton) {
        let paste = UIPasteboard.general
        paste.string = string
        if bun.tag == 200 {
            bg_view.DDGScreenShot { (image) in
                UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
            }
        } else if bun.tag == 201 {
            if bindingClick() {
                bg_view.DDGScreenShot { (image) in
                    DispatchQueue.main.async {
                        let activityItems = [image]
                        let activityVC = UIActivityViewController.init(activityItems: activityItems as [Any], applicationActivities: nil)
                        self.present(activityVC, animated: true, completion: nil)
                    }
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    // 图片保存成功 调用的方法
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        DispatchQueue.init(label: "saveImages").async(execute: {
            setToast(str: "保存成功!")
        })
    }
    // UIScrollView 代理 滑动结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 10001 {
            kDeBugPrint(item: scrollView.contentOffset.x / kSCREEN_WIDTH)
            if scrollView.contentOffset.x / kSCREEN_WIDTH == 1 {
                segmentedControl.selectedSegmentIndex = 1 // 设置当前选中下标
            } else {
                segmentedControl.selectedSegmentIndex = 0
            }
            
        }
        
    }
}
