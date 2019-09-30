

import UIKit
import SwiftyUserDefaults

class SZYCollectionViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var bg_view_height: NSLayoutConstraint!
    @IBOutlet weak var gengduoBun: UIButton!
    
    var mainCollectionView : UICollectionView?
    let identyfierTable1 = "identyfierTable1"
    let identyfierTable2 = "identyfierTable2"
    let identyfierTable3 = "identyfierTable3"
    let identyfierTable4 = "identyfierTable4"
    
    let kSpace : CGFloat = 6
    
    var typeString = ""
    var goodsArr = [SZYGoodsInformationModel]()
    var goods = goodsDiyModel()
    
    
    weak var superViewController : UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        gengduoBun.layoutButton(with: .right, imageTitleSpace: 10)
        
        //        配置UICollectionView
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .horizontal
        
        //        最小列间距
        layout.minimumInteritemSpacing = kSpace
        //        最小行间距
        layout.minimumLineSpacing = kSpace
        
        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: -kStatusBarH, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT+kStatusBarH-49), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        mainCollectionView?.register(UINib.init(nibName: "JTHLNMainShowHotCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable1)
        mainCollectionView?.register(UINib.init(nibName: "SZY24HoursHotListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable2)
        bg_view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = UIColor.clear
        mainCollectionView?.showsHorizontalScrollIndicator = false
        mainCollectionView?.showsVerticalScrollIndicator = false
        mainCollectionView?.snp.makeConstraints({ (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.top.equalToSuperview()
        })
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUpValues(model: goodsDiyModel) {
        goods = model
        goodsArr = model.list
        
        bg_view_height.constant = (kSCREEN_WIDTH) / 3 - 10 + 44
        mainCollectionView?.reloadData()
    }
    func setUpValues(model: [SZYGoodsInformationModel]) {
        goodsArr = model
        bg_view_height.constant = (kSCREEN_WIDTH) / 3 - 10 + 44
        mainCollectionView?.reloadData()
    }
    //    #MARK:更多事件
    @IBAction func gengduoButtonClick(_ sender: UIButton) {
//        goods
        kDeBugPrint(item: "查看更多商品!")
        let dataUrl = goods.data[0].url
        if dataUrl.contains("list") {
            let arr1 = dataUrl.components(separatedBy: "?")
            
            let viewC = SZYModuleViewController()
            viewC.titleString = goods.title
            viewC.typeInt = 2
            if arr1.count > 1 {
                viewC.SZYTypeString = arr1[1]
            }
            superViewController?.navigationController?.pushViewController(viewC, animated: true)
        } else if dataUrl.contains("webview") {
            var pageUrl = dataUrl.replacingOccurrences(of: "hongtang://webview?url=", with: "")
            
            if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
                if !pageUrl.contains(Defaults[kUserToken]!) {
                    if !pageUrl.contains("?") {
                        pageUrl = "\(pageUrl)?token=\(Defaults[kUserToken]!)"
                    } else {
                        pageUrl = "\(pageUrl)&token=\(Defaults[kUserToken]!)"
                    }
                }
            }
            let page = AlibcTradePageFactory.page(pageUrl)
            let taoKeParams = AlibcTradeTaokeParams.init()
            taoKeParams.pid = nil
            let showParam = AlibcTradeShowParams.init()
            showParam.openType = .auto
            let myView = SZYwebViewViewController.init()
            myView.webTitle = goods.title
            let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
                kDeBugPrint(item: "======11111=======")
            }, tradeProcessFailedCallback: { (error) in
                kDeBugPrint(item: error)
            })
            if (ret == 1) {
                superViewController?.navigationController?.pushViewController(myView, animated: true)
            }
            
        }
        
    }
    
}

extension SZYCollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SZY24HoursHotListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable2, for: indexPath) as! SZY24HoursHotListCollectionViewCell
        cell.setUpValues(model: goodsArr[indexPath.row], typeStr: typeString)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = goodsArr[indexPath.row].item_id
        detailVc.coupone_type = goodsArr[indexPath.row].type
        detailVc.goodsUrl = goodsArr[indexPath.row].pic_url
        detailVc.GoodsInformationModel = goodsArr[indexPath.row]
        superViewController?.navigationController?.pushViewController(detailVc, animated: true)
        
    }
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kSCREEN_WIDTH) / 3 - 10, height: (kSCREEN_WIDTH) / 3 - 10 + 44)
    }
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
