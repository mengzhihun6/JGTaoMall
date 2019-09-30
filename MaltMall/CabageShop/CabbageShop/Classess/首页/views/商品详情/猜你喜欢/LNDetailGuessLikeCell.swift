//
//  LNDetailGuessLikeCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/23.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LNDetailGuessLikeCellCCell: JGBaseCollectionViewCell {
    
    var Icon :UIImageView? //图片
    var TitleLbl:UILabel? //标题
    var CPriceLbl:UILabel? //现价
    var DescPLbl:UILabel? //卷后价
    
    override func configUI() {
        
        Icon = UIImageView()
        //        Icon?.backgroundColor = UIColor.random
        
        TitleLbl = UILabel()
        TitleLbl?.textColor = UIColor.hex("#5D5D5D")
        TitleLbl?.font = UIFont.font(12)
        //        TitleLbl?.text = "不好吃上传上传白蛇传说不擅长不是是才好深V缓存办事处近几年"
        
        CPriceLbl = UILabel()
        CPriceLbl?.textColor = UIColor.hex("#DCBF9E")
        CPriceLbl?.font = UIFont.boldFont(12)
        //        CPriceLbl?.text = "¥3850"
        
        DescPLbl = UILabel()
        DescPLbl?.textColor = UIColor.hex("#D3D3D3")
        DescPLbl?.font = UIFont.font(11)
        DescPLbl?.text = "卷后价"
        
        
        addSubview(Icon!)
        addSubview(TitleLbl!)
        addSubview(CPriceLbl!)
        addSubview(DescPLbl!)
        
        
        Icon?.snp.makeConstraints({ (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kWidthScale(110))
        })
        
        TitleLbl?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(Icon!.snp_bottom).offset(5)
        })
        
        CPriceLbl?.snp.makeConstraints({ (make) in
            make.left.equalTo(TitleLbl!.snp_left)
            make.top.equalTo(Icon!.snp_bottom).offset(27)
        })

        DescPLbl?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(CPriceLbl!.snp_centerY)
            make.left.equalTo(CPriceLbl!.snp_right).offset(5)
        })
    }
    
    public var model1 : SZYGoodsInformationModel? {
        didSet {
            if model1 == nil {
                return
            }
            TitleLbl!.text = model1?.title
            
//            kDeBugPrint(item: model1?.finalCommission)

            CPriceLbl!.text = OCTools().getStrWithFloatStr2(model1?.final_price)
            
            Icon!.sd_setImage(with: OCTools.getEfficientAddress(model1?.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        }
    }
}


class LNDetailGuessLikeCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 0
    //    cell的高度
    fileprivate let kHeight:CGFloat = kWidthScale(110) + 59

    fileprivate var mainCollectionView:UICollectionView?
//    let identyfierTable  = "identyfierTable1"
    
    fileprivate var resource = [LNYHQListModel]()
    var newResourct = [SZYGoodsInformationModel]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //        配置UICollectionView
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .vertical
//        layout.scrollDirection = .horizontal

        mainCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
//        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        mainCollectionView?.register(cellType: LNDetailGuessLikeCellCCell.self)
        
        bgView.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = UIColor.white
        mainCollectionView?.showsHorizontalScrollIndicator = false
        mainCollectionView?.showsVerticalScrollIndicator = false
        mainCollectionView?.snp.makeConstraints({ (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.top.equalToSuperview()
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    func setGuessLikeData(models:[LNYHQListModel]) {
//
//        var lines = models.count/2
//        if models.count%2 != 0{
//            lines = lines+1
//        }
//        viewHeight.constant = 300
//        resource = models
//        mainCollectionView?.reloadData()
//    }
    
    func setUpData(models:[SZYGoodsInformationModel]) {
        var lines = models.count / 3
        if models.count % 3 != 0{
            lines = lines+1
        }
        viewHeight.constant = CGFloat(lines)*(kHeight+kSpace)+20
        newResourct = models
        mainCollectionView?.reloadData()
    }
}
    
extension LNDetailGuessLikeCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return resource.count
        return newResourct.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNMainFootCell
////        cell.model2 = resource[indexPath.row]
//        cell.model1 = newResourct[indexPath.row]
//        return cell
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LNDetailGuessLikeCellCCell.self)
        cell.model1 = newResourct[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = newResourct[indexPath.row].item_id
        detailVc.coupone_type = newResourct[indexPath.row].type
        detailVc.goodsUrl = newResourct[indexPath.row].pic_url
        detailVc.GoodsInformationModel = newResourct[indexPath.row]
        viewContainingController()?.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        return CGSize(width: (kSCREEN_WIDTH-kSpace-22)/2, height: kHeight)
        let cellW = (kDeviceWidth - 20 - 26) / 3.0
        return CGSize.init(width: cellW, height: kHeight)
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 11, left: 11, bottom: 10, right: 11)
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }

    //设置子视图上下之间的距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 5
    }
    
    //设置子视图左右之间的距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 12
    }

}
