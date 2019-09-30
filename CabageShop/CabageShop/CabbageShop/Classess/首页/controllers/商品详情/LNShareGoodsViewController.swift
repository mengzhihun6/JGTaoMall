//
//  LNShareGoodsViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/3.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNShareGoodsViewController: LNBaseViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var image_scrollView: UIScrollView!
    
    @IBOutlet weak var description_text: UILabel!
    @IBOutlet weak var icon_imageView: UIImageView!
    @IBOutlet weak var store_nameLabel: UILabel!
    @IBOutlet weak var sold_label: UILabel!
    @IBOutlet weak var new_price: UILabel!
    @IBOutlet weak var old_price: UILabel!
    @IBOutlet weak var quanBun: UIButton!
    @IBOutlet weak var yuguZhuanBun: UIButton!
    
    fileprivate var saved_images = [UIImage]()
    var show_images = [String]()
    var good_title : String?
    var shareUrl : String?
    var type = String()

    var model = LNYHQDetailModel()

    fileprivate var selectImages = [UIImage]()

    var GoodsInformationModel = SZYGoodsInformationModel() //商品信息
    var StoreInformationModel = SZYStoreInformationModel() //商店信息
    var goodsShareModel = SZYGoodsShareModel() //商品分享信息
    
    
    @IBOutlet weak var top_space: NSLayoutConstraint!
    
    var lastButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layoutButton(with: .top, imageTitleSpace: 8)
        button2.layoutButton(with: .top, imageTitleSpace: 8)
        button3.layoutButton(with: .top, imageTitleSpace: 8)
        button4.layoutButton(with: .top, imageTitleSpace: 8)
        
        top_space.constant = 44
        
        description_text.layer.cornerRadius = 5
        description_text.clipsToBounds = true
        description_text.borderWidth = 0.5
        description_text.borderColor = kGaryColor(num: 199)
        description_text.backgroundColor = UIColor.clear
        description_text.text = good_title
        
        navigationTitle = "商品分享"
//        navigationBgImage = UIImage.init(named: "Rectangle")
        titleLabel.textColor = UIColor.white
        
        image_scrollView.bounces = false
        image_scrollView.showsVerticalScrollIndicator = false
        image_scrollView.showsHorizontalScrollIndicator = false
        image_scrollView.alwaysBounceHorizontal = true
        
        
        let kHeight:CGFloat = 90
        let kSpace:CGFloat = 10
        
        for index in 0..<GoodsInformationModel.images.count {
            let imageV = UIImageView.init(frame: CGRect(x: kSpace + (kHeight + kSpace) * CGFloat(index), y:0, width: kHeight, height: kHeight))
            imageV.sd_setImage(with: OCTools.getEfficientAddress(GoodsInformationModel.images[index]), placeholderImage: UIImage.init(named: "tabbar_main_select"))
            imageV.contentMode = .scaleToFill
            imageV.cornerRadius = 3
            imageV.clipsToBounds = true
            imageV.isUserInteractionEnabled = true
            imageV.tag = 100+index
            
            let mark = UIButton.init(frame: CGRect(x: imageV.width-20, y: 0, width: 20, height: 20))
            mark.setImage(UIImage.init(named: "save_unselect"), for: .normal)
            mark.setImage(UIImage.init(named: "save_select"), for: .selected)
            mark.tag = 10
            imageV.addSubview(mark)
            
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
            singleTap.numberOfTapsRequired = 1
            imageV.addGestureRecognizer(singleTap)

            image_scrollView.addSubview(imageV)
        }
        image_scrollView.contentSize = CGSize(width: CGFloat(GoodsInformationModel.images.count)*(kHeight+kSpace)+kSpace, height: image_scrollView.height)
        
        if GoodsInformationModel.type == "1" { //淘宝
            icon_imageView.image = UIImage.init(named: "miaosha_mark")
        } else {
            icon_imageView.image = UIImage.init(named: "tianmao_icon")
        }
        store_nameLabel.text = GoodsInformationModel.title
        
        sold_label.text = GoodsInformationModel.volume + "人购买"
        new_price.text = GoodsInformationModel.final_price
        old_price.text = GoodsInformationModel.price
        quanBun.setTitle(GoodsInformationModel.coupon_price + "元券", for: .normal)
        if OCTools().getStrWithFloatStr2(GoodsInformationModel.finalCommission) != "0" && OCTools().getStrWithFloatStr2(GoodsInformationModel.finalCommission) != "0.00"{
            yuguZhuanBun.isHidden = false
            yuguZhuanBun.setTitle("  预估赚￥"+OCTools().getStrWithFloatStr2(GoodsInformationModel.finalCommission)+"  ", for: .normal)
        }else{
            yuguZhuanBun.isHidden = true
        }
        
        
//                share.show_images = (weakSelf?.GoodsInformationModel.small_images)
        
//                if weakSelf?.GoodsInformationModel.coupon_link_url.count == 0 {
//                    weakSelf?.GoodsInformationModel.coupon_link_url = "没有找到链接"
//                }
        description_text.text = GoodsInformationModel.title+"\n【在售价】￥"+OCTools().getStrWithFloatStr2((GoodsInformationModel.price))+"\n【券后价】￥"+OCTools().getStrWithFloatStr2((GoodsInformationModel.final_price))+"\n【优惠券】￥"+GoodsInformationModel.coupon_price//+"复制这条信息，"+GoodsInformationModel.kouling+"，打开【手机淘宝】即可查看"
        
    }
    override func requestData() { // 获取优惠券数据
        let request = SKRequest.init()
        
        request.setParam(GoodsInformationModel.pic_url as NSObject, forKey: "pic_url")
        request.setParam(GoodsInformationModel.item_id as NSObject, forKey: "item_id")
        request.setParam("1" as NSObject, forKey: "type")
        
        weak var weakSelf = self
        DispatchQueue.init(label: "loading.show.tread").async {
            LQLoadingView().SVPwillShowAndHideNoText1()
        }
        request.callGET(withUrl: LNUrls().kShare) { (response) in
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                return
            }
            kDeBugPrint(item: JSON((response?.data["data"])!))
            let datas =  JSON((response?.data["data"])!)
            
            weakSelf?.goodsShareModel = SZYGoodsShareModel.setupValues(json: datas)
            
            
            DispatchQueue.main.async(execute: { () -> Void in
//                let datas =  JSON((response?.data["data"])!)
//                weakSelf?.GoodsInformationModel = SZYGoodsInformationModel.setupValues(json: datas)
//
//                if weakSelf?.GoodsInformationModel.favourite == "0" {
//                    weakSelf?.collection_label.isSelected = false
//                } else {
//                    weakSelf?.collection_label.isSelected = true
//                }
//                if weakSelf?.StoreInformationModel != nil {
//                    weakSelf?.mainTableView.reloadData()
//                }
//                weakSelf?.mainTableView.mj_header.endRefreshing()
            })
        }
    }
    @objc  func viewTheBigImage(ges:UITapGestureRecognizer) {
        
        let selectImage = ges.view as! UIImageView
        let selectMark = selectImage.viewWithTag(10) as! UIButton
        
        if selectImages.contains(selectImage.image!) {
            selectImages.remove(at: selectImages.index(of: selectImage.image!)!)
            selectMark.isSelected = false
        }else{
            selectImages.append(selectImage.image!)
            selectMark.isSelected = true
        }
    }
    
    
    @IBAction func saveImagesAction(_ sender: UIButton) {
        
        if selectImages.count == 0 {
            setToast(str: "请选择图片")
            return
        }

        for image in selectImages {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error == nil {
            let paste = UIPasteboard.general
            paste.string = description_text.text
            setToast(str: "已保存,内容已复制")
        }
    }
    
    //复制文案事件
    @IBAction func copyAction(_ sender: UIButton) {
   
        let paste = UIPasteboard.general
        paste.string = description_text.text
        setToast(str: "复制成功")
    }
    
    // 底部按钮点击事件
    @IBAction func chooseSharePalatm(_ sender: UIButton) {
        
        if show_images.count == 0 {
            setToast(str: "暂无可分享图片")
            return
        }
//        系统的分享
//
//        let activityItems = selectImages
//        let activityVC = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
//        self.present(activityVC, animated: true, completion: nil)

        let paste = UIPasteboard.general
        paste.string = description_text.text

        LQLoadingView().SVPWillShow("文字已复制，正在生成海报")
        let request = SKRequest.init()
        request.setParam(show_images[0] as NSObject, forKey: "pic_url")
        request.setParam(model.item_id as NSObject, forKey: "item_id")
        request.setParam(type as NSObject, forKey: "type")
        
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kShare) { (response) in
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                setToast(str: "分享参数获取失败")
                return
            }

            if sender.tag == 103 {
                
                let data = try! Data.init(contentsOf: URL.init(string: JSON((response?.data)!)["data"].stringValue)!)
                let image = UIImage.init(data: data as Data)
                
                UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
            }else{
                DispatchQueue.main.async {
                    // 1.创建分享参数
                    let shareParames = NSMutableDictionary()
                    shareParames.ssdkSetupShareParams(byText: nil, images : JSON((response?.data)!)["data"].stringValue, url : nil, title : nil, type : .image)
                    var platform = SSDKPlatformType.typeQQ
                    
                    switch sender.tag {
                    case 101:
                        platform = .typeWechat
                    case 102:
                        platform = .subTypeWechatTimeline
                    case 103:
                        platform = .subTypeQQFriend
                    case 104:
                        platform = .typeSinaWeibo
                    default:
                        break
                    }
                    
                    ShareSDK.share(platform, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
                        
                        switch state{
                        case SSDKResponseState.success: //setToast(str: "分享成功")
                            break
                        case SSDKResponseState.fail:    setToast(str: "分享失败")
                        case SSDKResponseState.cancel:
                            setToast(str: "取消分享")
                            break
                        default:
                            break
                        }
                    }
                }
            }
        }
    }

}
