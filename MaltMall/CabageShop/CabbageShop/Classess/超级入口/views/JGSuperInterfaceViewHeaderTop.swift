//
//  JGSuperInterfaceViewHeaderTop.swift
//  CabbageShop
//
//  Created by 郭军 on 2019/8/28.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit


class JGSuperInterfaceViewHeaderTopCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.hex("#F2F2F2")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




class JGSuperInterfaceViewHeaderTop: UIView {

    private var TitleLbl : UILabel? //标题
    private var Icon : UIImageView? //图像
    
    private lazy var collectionVew : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let col = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        col.backgroundColor = UIColor.clear
        col.delegate = self
        col.dataSource = self
//        col.isPagingEnabled = true
        col.register(JGSuperInterfaceViewHeaderTopCell.self, forCellWithReuseIdentifier: "JGSuperInterfaceViewHeaderTopCell")
        return col
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() {
        
        self.backgroundColor = JGMainColor

        
        TitleLbl = UILabel()
        
        let titleStr = "爆款推荐大家都在买"
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: titleStr)
        //设置字体
        attributeString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldFont(18), range: NSMakeRange(0,titleStr.count))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, titleStr.count))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.hex("#E6B082"), range: NSMakeRange(4, 2))
        TitleLbl!.attributedText = attributeString
        
        
        Icon = UIImageView()
        Icon?.image = UIImage(named: "home_hot")
        
        
        self.addSubview(TitleLbl!)
        self.addSubview(Icon!)
        self.addSubview(collectionVew)

        
        TitleLbl?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(40)
        })
        
        Icon?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(TitleLbl!.snp_centerY)
            make.left.equalTo(TitleLbl!.snp_right).offset(10)
        })
        
        collectionVew.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(TitleLbl!.snp_bottom)
            make.height.equalTo(125)
        }
        
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


extension JGSuperInterfaceViewHeaderTop : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    //返回每组有多少个item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    //显示每组显示的Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : JGSuperInterfaceViewHeaderTopCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JGSuperInterfaceViewHeaderTopCell", for: indexPath) as! JGSuperInterfaceViewHeaderTopCell
        
        return cell
    }
    
    //每组头部高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    //每组尾部高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    //返回每个子视图的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = floor(Double(kDeviceWidth  - 40) / 3.0)
        return CGSize(width: width, height: 105)
    }
    
    //设置每个子视图的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom:  0, right: 0)
    }
    
    //设置子视图上下之间的距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //设置子视图左右之间的距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
