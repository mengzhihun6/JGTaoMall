//
//  JTHtaoBao.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/4/3.
//  Copyright © 2019 HT. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class JTHtaoBao: LNBaseViewController {
    
    //    cell之间的距离
    fileprivate var kSpace:CGFloat = 8
    //    cell的高度
    fileprivate let kHeight:CGFloat = (kSCREEN_WIDTH - 8 - 24) / 2 + 106 //255
    fileprivate var mainCollectionView:UICollectionView?
    //    数据源
    fileprivate var resource = [LNYHQModel]()
    var GoodsInformationModel = [SZYGoodsInformationModel]() //商品信息
    
    fileprivate var header : UICollectionReusableView?
    fileprivate var headView : UIView!
    fileprivate var selectView : UIView!
    fileprivate let identyfierTableHeader = "identyfierTableHeader"
    fileprivate let identyfierTable1 = "identyfierTable1"
    
    fileprivate let identyfierTable2 = "identyfierTable2"
    
    var selecType = 1
    var searchtype = "2"
    
    var model = LNTopListModel()
    
    weak var superViewController : UIViewController?
    
    fileprivate var select_type = "id"
    fileprivate var sortedBy = "desc"
    var topBun = UIButton()       // 返回顶部按钮
    
    fileprivate var isCollect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addFooterRefresh()
    }
    override func addHeaderRefresh() {
        weak var weakSelf = self
        mainCollectionView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.refreshHeaderAction()
        })
    }
    override func addFooterRefresh() {
        weak var weakSelf = self
        mainCollectionView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            weakSelf?.refreshFooterAction()
        })
    }
    ///下拉刷新事件
    override func refreshHeaderAction() {
        currentPage = 1
        requestData()
    }
    override func refreshFooterAction() {
        currentPage = currentPage + 1
        requestData()
    }
    override func configSubViews() {
        navigaView.isHidden = true
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical  //        滑动方向
        layout.minimumInteritemSpacing = kSpace   //        最小列间距
        layout.minimumLineSpacing = kSpace   //        最小行间距
        var top = navHeight + 20
        if kSCREEN_HEIGHT > 800 {
            top = navHeight + 35
        }
        
        headView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 182))
        selectView = UIView.init(frame: CGRect(x: 10, y: 3, width: kSCREEN_WIDTH - 20, height: 182))
        selectView.cornerRadius = 5
        selectView.clipsToBounds = true
        setUpValues(models: model.children)
        headView.addSubview(selectView)
        headView.backgroundColor = kGaryColor(num: 245)
        headView.isUserInteractionEnabled = true
        
        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: navHeight - 5, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - navHeight - 64 + 10), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        mainCollectionView?.register(UINib.init(nibName: "JTHCommodityInformationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        mainCollectionView?.register(UINib.init(nibName: "JTHCommodityInformationCollectionViewCell1", bundle: nil), forCellWithReuseIdentifier: identyfierTable1)
        
        mainCollectionView?.register(UINib.init(nibName: "JTHtaobaoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable2)
        mainCollectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identyfierTableHeader)
        self.view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = kBGColor()
//        //        隐藏返回按钮
//        topBun = UIButton.init(frame: CGRect.init(x: kSCREEN_WIDTH - 55, y: kSCREEN_HEIGHT - 165, width: 45, height: 45));
//        topBun.backgroundColor = UIColor.red
//        topBun.setImage(UIImage.init(named: "返回顶部"), for: .normal)
//        topBun.addTarget(self, action: #selector(topBunClick), for: .touchUpInside)
//        topBun.cornerRadius = topBun.height / 2.0
//        topBun.clipsToBounds = true
//        topBun.isHidden = true
//        self.view.addSubview(topBun)
        
    }
    @objc func topBunClick() {
        let indexPat = IndexPath.init(row: 0, section: 0)
        mainCollectionView?.scrollToItem(at: indexPat as IndexPath, at: .bottom, animated: true)
    }
    
    //    根据该分类下的子分类进行布局，t如果子分类数量为0，就不要显示 了。
    func setUpValues(models:[LNSuperChildrenModel]) {
        var total = models.count
        if total > 8 {
            total = 8
        }
        
        let lines = 4
        let kWidth:CGFloat = selectView.width/CGFloat(lines)
        let height = selectView.height/2
        
        for index in 0..<total {
            let row =  CGFloat(index%lines)
            
            let optionBtn = UIButton.init(frame: CGRect(x:kWidth * row, y:height*CGFloat(index/lines), width: kWidth, height: height))
            optionBtn.addTarget(self, action: #selector(chooseOptions(sender:)), for: .touchUpInside)
            optionBtn.tag = index+10
            optionBtn.backgroundColor = UIColor.white
            print(optionBtn.frame)
            selectView.addSubview(optionBtn)
            
            let buttonImage = UIImageView.init(frame: CGRect(x: optionBtn.width/4-5, y:5, width: optionBtn.width/2+10, height: optionBtn.width/2+10))
            
            buttonImage.sd_setImage(with: OCTools.getEfficientAddress(models[index].logo), placeholderImage: UIImage.init(named: "goodImage_1"))
            
            buttonImage.isUserInteractionEnabled = false
            optionBtn.addSubview(buttonImage)
            
            let buttonTitle = UILabel.init(frame: CGRect(x: 0, y: buttonImage.height+buttonImage.y, width: optionBtn.width, height: optionBtn.height-buttonImage.height-5))
            buttonTitle.textColor = kGaryColor(num: 179)
            buttonTitle.font = UIFont.systemFont(ofSize: 12)
            buttonTitle.text = models[index].name
            buttonTitle.textAlignment = .center
            buttonTitle.isUserInteractionEnabled = false
            optionBtn.addSubview(buttonTitle)
        }
        selectView.backgroundColor = UIColor.white
    }
    
    @objc func chooseOptions(sender:UIButton)  {
        
        let searchVc = LQSearchResultViewController()
        searchVc.keyword = model.children[sender.tag-10].name
        searchVc.type = "1"
        superViewController?.navigationController?.pushViewController(searchVc, animated: true)
    }
    
    override func requestData() {
        let request = SKRequest.init()
        if model.taobao == "" {
            request.setParam("type:1"as NSObject, forKey: "search")
        } else {
            request.setParam("cat:"+model.taobao+";type:1"as NSObject, forKey: "search")
        }
        request.setParam(select_type as NSObject, forKey: "orderBy")
        request.setParam(sortedBy as NSObject, forKey: "sortedBy")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        if currentPage == 1 {
            request.setParam("11" as NSObject, forKey: "limit")
        } else {
            request.setParam("10" as NSObject, forKey: "limit")
        }
        LQLoadingView().SVPwillShowAndHideNoText()
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kSwhow_coupon) { (response) in
            LQLoadingView().SVPHide()
            DispatchQueue.main.async {
                if !(response?.success)! {
                    weakSelf?.mainCollectionView?.mj_footer.endRefreshing()
                    weakSelf?.mainCollectionView?.mj_header.endRefreshing()
                    return
                }
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                if datas.count >= 0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    if weakSelf?.currentPage == 1 {
                        weakSelf?.GoodsInformationModel.removeAll()
                        if weakSelf?.currentPage == pages {
                            weakSelf?.mainCollectionView?.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            weakSelf?.mainCollectionView?.mj_footer.resetNoMoreData()
                        }
                    }else{
                        if (weakSelf?.currentPage)! >= pages {
                            weakSelf?.mainCollectionView?.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            weakSelf?.mainCollectionView?.mj_footer.endRefreshing()
                        }
                    }
                    
                    for index in 0..<datas.count{
                        let json = datas[index]
                        weakSelf?.GoodsInformationModel.append(SZYGoodsInformationModel.setupValues(json: json))
                    }
                    
                    if (weakSelf?.mainCollectionView?.mj_header.isRefreshing)! {
                        weakSelf?.mainCollectionView?.mj_header.endRefreshing()
                    }
                }else{
                    if weakSelf?.mainCollectionView?.mj_footer != nil {
                        weakSelf?.mainCollectionView?.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                weakSelf?.mainCollectionView?.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.mj_offsetY > 600 {
            topBun.isHidden = false
        } else {
            topBun.isHidden = true
        }
    }
    
    //zhegefangfameiyouyong
    func createTwoLabelAndView() {
        let label = UILabel()
        let attrString = NSMutableAttributedString(string: "投入(元）")
        label.frame = CGRect(x: 26, y: 130, width: 63.5, height: 21)
        label.numberOfLines = 0
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont(name: "苹方-简 常规体", size: 15),.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
        attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
        label.attributedText = attrString
        view.addSubview(label)
        
        let label1 = UILabel()
        let attrString1 = NSMutableAttributedString(string: "打卡时间：06:28")
        label1.frame = CGRect(x: 41, y: 265.5, width: 111.5, height: 21)
        label1.numberOfLines = 0
        let attr1: [NSAttributedString.Key : Any] = [.font: UIFont(name: "苹方-简 常规体", size: 15),.foregroundColor: UIColor(red: 0.94, green: 0.33, blue: 0, alpha: 1)]
        attrString1.addAttributes(attr1, range: NSRange(location: 0, length: attrString.length))
        label1.attributedText = attrString
        view.addSubview(label1)
        
        let layerView = UIView()
        layerView.frame = CGRect(x: 0, y: 0, width: 375, height: 787.5)
        // fillCode
        let bgLayer1 = CALayer()
        bgLayer1.frame = layerView.bounds
        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layerView.layer.addSublayer(bgLayer1)
        view.addSubview(layerView)
    }
    
}

extension JTHtaoBao: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return GoodsInformationModel.count - 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if GoodsInformationModel.count > 0 {
            return 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell:JTHtaobaoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable2, for: indexPath) as! JTHtaobaoCollectionViewCell
            cell.clipsToBounds = true
            
            cell.setUpModel(model: GoodsInformationModel[indexPath.row])
            
            return cell
        } else {
            if !isCollect {
                let cell:JTHCommodityInformationCollectionViewCell1 = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable1, for: indexPath) as! JTHCommodityInformationCollectionViewCell1
                cell.clipsToBounds = true
                
                cell.setUpModel(model: GoodsInformationModel[indexPath.row + 1])
                
                return cell
            }else{
                let cell:JTHCommodityInformationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! JTHCommodityInformationCollectionViewCell
                cell.clipsToBounds = true
                
                cell.setUpModel(model: GoodsInformationModel[indexPath.row + 1])
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let detailVc = SZYGoodsViewController()
            detailVc.good_item_id = GoodsInformationModel[indexPath.row].item_id
            detailVc.coupone_type = GoodsInformationModel[indexPath.row].type
            detailVc.goodsUrl = GoodsInformationModel[indexPath.row].pic_url
            detailVc.GoodsInformationModel = GoodsInformationModel[indexPath.row]
            superViewController?.navigationController?.pushViewController(detailVc, animated: true)
        } else {
            let detailVc = SZYGoodsViewController()
            detailVc.good_item_id = GoodsInformationModel[indexPath.row + 1].item_id
            detailVc.coupone_type = GoodsInformationModel[indexPath.row + 1].type
            detailVc.goodsUrl = GoodsInformationModel[indexPath.row + 1].pic_url
            detailVc.GoodsInformationModel = GoodsInformationModel[indexPath.row + 1]
            superViewController?.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: kSCREEN_WIDTH, height: 240)
        } else {
            if isCollect {
                return CGSize(width: kSCREEN_WIDTH, height: 157.5)
            } else {
                return CGSize(width: (kSCREEN_WIDTH-kSpace-24) / 2, height: kHeight)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            if header != nil {
                return header!
            }
            if kind == UICollectionElementKindSectionHeader {
                let headView1 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identyfierTableHeader, for: indexPath)
                headView1.addSubview(headView)
                headView1.isUserInteractionEnabled = true
                header = headView1
                
                return header!
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //        如果子分类数量为0，就不要显示了。
        if section == 0 {
            if model.children.count == 0 {
                return CGSize.zero
            }
            return CGSize(width: kSCREEN_WIDTH, height: 12 + 182)
        }
        return CGSize.zero
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    }
    
}
