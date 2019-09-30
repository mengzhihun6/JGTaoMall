

import UIKit

class SZYBannerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var bg_view_height: NSLayoutConstraint!
    
//    var banner = ADView()
    
    var JGBanner: JGBannarView!
    
    var bannerModel: bannerDiyModel?
    
    
     var headBottomImage: UIImageView? //接收外界变换视图
    
    weak var superViewController : UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        banner.backgroundColor = UIColor.white
        
        bg_view_height.constant = 150

        let H : CGFloat = bg_view.height - 20;
        
         JGBanner = JGBannarView(frame: CGRect(x: 10, y: 10, width: kDeviceWidth - 20, height: H), viewSize: CGSize(width: kDeviceWidth - 20, height: H), type: BannarTypePageControl)
        bg_view.addSubview(JGBanner)
        JGBanner.snp.makeConstraints { (make) in
           make.edges.equalToSuperview().inset(10)
        }
        
         weak var weakSelf = self
        JGBanner.imageViewClick { (BanView, index) in
            
            //            dataDiyModel
            let bannerModel = weakSelf!.bannerModel!.data[index]
            
            kDeBugPrint(item: "轮播图点击事件\(bannerModel.url)")
            
            
            kDeBugPrint(item: weakSelf?.viewContainingController())
            kDeBugPrint(item: weakSelf?.viewContainingController()?.classForCoder)
            
            
            let vc = weakSelf?.viewContainingController() as? SZYMainViewController  //推荐
            vc!.moduleIdentifier(str: bannerModel.url, vc: (weakSelf?.superViewController)!)
            
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUpValues(model: bannerDiyModel) {
        let dataArr = model.data
        bannerModel = model
        if dataArr.count == 0 {
            bg_view_height.constant = 0
            return
        }
        bg_view_height.constant = 150
        
        
//        for views in bg_view.subviews {
//
//            if views.isKind(of: ADView.self) == true {
//                let Ban :ADView = views as! ADView
//                Ban.invalidateTheTimer()
//            }
//
//            views.removeFromSuperview()
//        }
        
        let imageUrls =  NSMutableArray.init()
        for Banners in dataArr {
            let url = Banners.imageUrl
            imageUrls.add(url)
        }

        JGBanner.items = imageUrls as! [Any]
        
        JGBanner.didChangeImageView { (image) in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangePageViewTopBg"), object:image)
        }
        
        
 
//        banner = ADView.init(frame: CGRect.init(x: 0, y: 10, width: kSCREEN_WIDTH, height: bg_view.height - 20), andImageURLArray: imageUrls )
//        weak var weakSelf = self
//
//        banner.block = {
//            kDeBugPrint(item: $0)
//            let index = Int($0!)!-1
////            dataDiyModel
//            let bannerModel = model.data[index]
//
//            kDeBugPrint(item: "轮播图点击事件\(bannerModel.url)")
//
//
//            kDeBugPrint(item: weakSelf?.viewContainingController())
//            kDeBugPrint(item: weakSelf?.viewContainingController()?.classForCoder)
//
//
//            let vc = weakSelf?.viewContainingController() as? SZYMainViewController  //推荐
//            vc!.moduleIdentifier(str: bannerModel.url, vc: (weakSelf?.superViewController)!)
//
//
//
//
//
////            vc!.navigationController?.tabBarController?.selectedIndex = 3
////            kDeBugPrint(item: "个人中心 \n\(vc!.navigationController)  \n\(vc!.navigationController?.tabBarController)     \n\(vc!.navigationController?.tabBarController?.selectedIndex)")
//
//
////            let nvc = SZYBannerViewController()
////            if index == 0 {
////                nvc.titleString = "母婴专场"
////                nvc.SZYTypeString = "母婴"
////            } else if index == 1 {
////                nvc.titleString = "吃货专场"
////                nvc.SZYTypeString = "零食"
////            }
////            let vc = weakSelf?.viewContainingController() as? LNNewMainViewController
////            vc?.superViewController?.navigationController?.pushViewController(nvc, animated: true)
//        }
//
//                banner.changeBlock = {
//        //            这个是d轮播图定时器再运行的时候的回调，用于改变首页背景色
//                    let index = Int($0!)!-1
//
////                    JGLog("\(index)")
//
//                    if index > model.data.count {
//                        return
//                    }
//
//
//                    let mo : dataDiyModel = model.data[index]
//
//                    //ChangePageViewTopBg
//
//
////                    JGLog("\(mo.bgImage)")
//
//
////                    headBottomImage.sd_setImage(with: OCTools.getEfficientAddress((noti.object as! String)), placeholderImage: UIImage.init(named: "nav_head_bg"))
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangePageViewTopBg"), object: mo.bgImage)
//
//
////                    if models.count>index && index>=0{
////                        let model = models[index]
////
////                        let vc = weakSelf?.viewContainingController() as? LNNewMainViewController
////
////                        UIView.animate(withDuration: 0.5) {
////                            vc?.superViewController!.headBottomImage.backgroundColor = OCTools.color(withHexString: model.color)
////                        }
////                    }
//                }
//        bg_view.addSubview(banner)
//        banner.snp.makeConstraints { (ls) in
//            ls.top.equalToSuperview().offset(10)
//            ls.left.right.equalToSuperview()
//            ls.bottom.equalToSuperview().offset(-10)
//        }
    }
    
    
}


extension SZYBannerTableViewCell : SDCycleScrollViewDelegate {
    
    
    
    
}
