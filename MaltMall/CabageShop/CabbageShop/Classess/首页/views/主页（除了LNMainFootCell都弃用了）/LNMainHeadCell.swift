//
//  LNMainHeadCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/28.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class LNMainHeadCell: UICollectionViewCell {

    @IBOutlet weak var bannerView: UIView!
    

    @IBOutlet weak var showHotView: UIView!
    
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var theWidth: NSLayoutConstraint!
    
    
    var banner = ADView()
    var resource = [LNYHQListModel]()
    
    //    collectionView
    fileprivate var mainCollectionView:UICollectionView?
    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 0
    //    cell的高度
    fileprivate let kHeight:CGFloat = 100
    let identyfierTable  = "identyfierTable"

    override func awakeFromNib() {
        super.awakeFromNib()
        theWidth.constant = kSCREEN_WIDTH
        let model = NSMutableArray.init(array: ["今日热销",
                                                "今日热销",
                                                "今日热销",
                                                "今日热销"])

        banner = ADView.init(frame:CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: bannerView.height),
                             andImageNameArray: model,
                             andIsRunning: true)

        weak var weakSelf = self
        banner.block = {
            kDeBugPrint(item: $0)
            
            let index = Int($0!)!-1
            
        }
        bannerView.addSubview(banner)
        banner.snp.makeConstraints { (ls) in
            ls.left.right.top.bottom.equalToSuperview()
            ls.height.equalTo(150)
        }
        
        for view in buttonsView.subviews {
            let button = view as? UIButton
            button?.layoutButton(with: .top, imageTitleSpace: 6)
        }
        
        let courseCardView = CourseCardView.init(frame: CGRect(x: 0, y: 30, width: kSCREEN_WIDTH, height: showHotView.height-30))
        courseCardView.selectedIndex = 3
        courseCardView.selectedCourseClosure = { course in
            
            let detailVc = SZYGoodsViewController()
            detailVc.good_item_id = course.item_id
            detailVc.coupone_type = course.type
            self.viewContainingController()?.navigationController?.pushViewController(detailVc, animated: true)

        }
        showHotView.addSubview(courseCardView)
        
        DispatchQueue.main.async {
            let request = SKRequest.init()
            request.setParam("20" as NSObject, forKey: "limit")
            request.setParam("volume" as NSObject, forKey: "orderBy")
            request.setParam("desc" as NSObject, forKey: "sortedBy")
            request.setParam("type:1;tag:2"as NSObject, forKey: "search")
            request.setParam("and" as NSObject, forKey: "searchJoin")
            request.callGET(withUrl: LNUrls().kSwhow_coupon) { (response) in
                if !(response?.success)! {
                    return
                }
                
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                ////////////////////////////////////////////////////////
                if datas.count>=0 {
                    
                    for index in 0..<datas.count{
                        weakSelf?.resource.append(LNYHQListModel.setupValues(json: datas[index]))
                    }
                }
                courseCardView.models = (weakSelf?.resource)!
                
            }

        }
        
        button41.setImage(nil, for: .normal)
        button31.setImage(nil, for: .normal)
        button21.setImage(nil, for: .normal)
        button11.setImage(nil, for: .normal)

        button41.layoutButton(with: .right, imageTitleSpace: 5)
        button31.layoutButton(with: .right, imageTitleSpace: 5)
        button21.layoutButton(with: .right, imageTitleSpace: 5)
        
        button11.setTitleColor(kGaryColor(num: 80), for: .selected)
        button21.setTitleColor(kGaryColor(num: 80), for: .selected)
        button31.setTitleColor(kGaryColor(num: 80), for: .selected)
        button41.setTitleColor(kGaryColor(num: 80), for: .selected)
    }
    
    @IBAction func selectAppWay(_ sender: UIButton) {
        
        if sender.tag < 14 {
            let resultVc = LNTypeGoodsiewController()
            
            switch sender.tag {
            case 10:
                resultVc.type = "1"
                break
            case 11:
                resultVc.type = "10"
                break
            case 12:
                resultVc.type = "2"
                break
            case 13:
                resultVc.type = "3"
                break
            default:
                break
            }
            viewContainingController()?.navigationController?.pushViewController(resultVc, animated: true)
        }else if sender.tag > 13 && sender.tag != 15{
            let kindVc = LNShowKindViewController()
            
            switch sender.tag {
            case 14:
                kindVc.title = "9.9包邮"
                kindVc.tagStr = "min_price:9.9"
            case 16:
                kindVc.title = "聚划算"
                kindVc.tagStr = "tag:5"
            case 17:
                kindVc.title = "淘抢购"
                kindVc.tagStr = "tag:4"
            case 18:
                kindVc.title = "实时跑单"
                kindVc.tagStr = "tag:1"
            case 19:
                kindVc.title = "爆款商品"
                kindVc.tagStr = "tag:2"
            default:
                break
            }
            viewContainingController()?.navigationController?.pushViewController(kindVc, animated: true)
            
        }else if sender.tag == 15 {
                
                viewContainingController()?.navigationController?.pushViewController(LNMiaoshaViewController(), animated: true)
        }else{
            
//            let quanVc = viewContainingController()?.tabBarController?.viewControllers![1].childViewControllers[0] as! LQShowQuanViewController
//            if sender.tag == 19  {
//                quanVc.selectIndex = 1
//            }else{
//                quanVc.selectIndex = 0
//            }
//            viewContainingController()?.tabBarController?.selectedIndex = 1
        }
        
    }
    
    
    
    
    
    func buildUrlData(models:[LNBannersModel]) {
        banner.removeFromSuperview()
        
        let imageUrls =  NSMutableArray.init()
        
        for model in models {
            imageUrls.add(model.image)
        }
        
        banner = ADView.init(
            frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: bannerView.height),
            andImageURLArray: imageUrls,
            andIsRunning: true)
        
        weak var weakSelf = self
        banner.block = {
            kDeBugPrint(item: $0)
            
            let index = Int($0!)!-1
            let model = models[index]
            
            let WebVC = LQWebViewController()
            WebVC.webTitle = "详情"
            WebVC.webUrl = model.url
            weakSelf?.viewContainingController()?.navigationController?.pushViewController(WebVC, animated: true)
            
        }
        bannerView.addSubview(banner)
        
        banner.snp.makeConstraints { (ls) in
            ls.left.right.top.bottom.equalToSuperview()
        }
    }

    
    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var button21: UIButton!
    @IBOutlet weak var button31: UIButton!
    @IBOutlet weak var button41: UIButton!
    
    fileprivate var isUp = false
    fileprivate var isUp1 = false
    fileprivate var isUp2 = false
    //    回调
    typealias swiftBlock = (_ selectParam:NSInteger) -> Void
    var willClick : swiftBlock? = nil
    func callBackPhoneNum(block: @escaping ( _ selectParam:NSInteger) -> Void ) {
        willClick = block
    }
    
    
    @IBAction func selectAction1(_ sender: UIButton) {
        
//        if sender == button11 {
//            return
//        }
        
        button11.isSelected = true
        button21.isSelected = false
        button31.isSelected = false
        button41.isSelected = false
        
        
        button11.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button21.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button31.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button41.titleLabel?.font = UIFont.systemFont(ofSize: 15)

        if willClick != nil {
            willClick!(0)
        }
    }
    
    @IBAction func selectAction2(_ sender: UIButton) {
        
//        if sender == button21 {
//            return
//        }
        
        button11.isSelected = false
        button21.isSelected = true
        button31.isSelected = false
        button41.isSelected = false
        
        button11.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button21.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button31.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button41.titleLabel?.font = UIFont.systemFont(ofSize: 15)

        if isUp2 {
            if willClick != nil {
                willClick!(1)
            }
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0) //设置动画时间
            sender.imageView?.transform = .identity
            UIView.commitAnimations()
            
        }else{
            if willClick != nil {
                willClick!(11)
            }
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0) //设置动画时间
            sender.imageView?.transform = CGAffineTransform.init(rotationAngle: .pi)
            UIView.commitAnimations()
        }
        isUp2 = !isUp2
    }
    
    @IBAction func selectAction3(_ sender: UIButton) {
        
//        if sender == button31 {
//            return
//        }
        
        button11.isSelected = false
        button21.isSelected = false
        button31.isSelected = true
        button41.isSelected = false
        
        button11.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button21.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button31.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button41.titleLabel?.font = UIFont.systemFont(ofSize: 15)

        if isUp1 {
            if willClick != nil {
                willClick!(2)
            }
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0) //设置动画时间
            sender.imageView?.transform = .identity
            UIView.commitAnimations()
            
        }else{
            if willClick != nil {
                willClick!(21)
            }
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0) //设置动画时间
            sender.imageView?.transform = CGAffineTransform.init(rotationAngle: .pi)
            UIView.commitAnimations()
        }
        isUp1 = !isUp1

    }
    
    @IBAction func selectAction4(_ sender: UIButton) {
        button11.isSelected = false
        button21.isSelected = false
        button31.isSelected = false
        button41.isSelected = true
        
        
        button11.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button21.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button31.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button41.titleLabel?.font = UIFont.systemFont(ofSize: 16)

        if isUp {
            if willClick != nil {
                willClick!(3)
            }
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0) //设置动画时间
            sender.imageView?.transform = .identity
            UIView.commitAnimations()

        }else{
            if willClick != nil {
                willClick!(4)
            }
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0) //设置动画时间
            sender.imageView?.transform = CGAffineTransform.init(rotationAngle: .pi)
            UIView.commitAnimations()
        }
        isUp = !isUp
    }

}
