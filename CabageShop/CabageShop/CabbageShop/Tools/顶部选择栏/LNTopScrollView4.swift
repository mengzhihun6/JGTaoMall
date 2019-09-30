//
//  LNTopScrollView4.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/22.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNTopScrollView4: UIView {
    //    回调
    typealias swiftBlock = (_ message:NSInteger, _ isUp:Bool) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping ( _ message:NSInteger, _ isUp:Bool) -> Void ) {
        willClick = block
    }
    //    下划线
    fileprivate var underLine = UIView()
    
    //    当前选择的下标
    fileprivate var currentIndex = NSInteger()
    
    fileprivate var scrollView = UIScrollView()
    
    fileprivate var scrollHeight:CGFloat = 49
    
    fileprivate var isOut  = false
    fileprivate var lineView  = UIView()
    
    fileprivate var showMore  = UIButton()
    
    fileprivate var selectFont  = UIFont.systemFont(ofSize: 15)
    fileprivate var normalFont  = UIFont.systemFont(ofSize: 14)
    
    var lineColor = UIColor.white
    var textColor = kGaryColor(num: 69)
    
    var datas = [String]()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTopView(selectIndex:NSInteger) -> Void {
//        datas = ["综合","销量","券额","排列"]
        datas = ["综合","佣金","销量","价格","排列"]
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }
        
        currentIndex = selectIndex
        //        let moreWidth = CGFloat(45)
        let moreWidth = CGFloat(0)
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-moreWidth, height: scrollHeight))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled  = false
        let kHeight = CGFloat(scrollHeight)
        let kSpace = CGFloat(8)
        
        let kWidth:CGFloat = (kSCREEN_WIDTH-moreWidth-kSpace*CGFloat(datas.count)-kSpace)/CGFloat(datas.count)
        
        for index in 0..<datas.count{
            
            let markBtn = UIButton.init(frame: CGRect(x: kSpace + (kWidth+kSpace)*CGFloat(index) , y: 1, width: kWidth, height: kHeight))
            markBtn.setTitle(datas[index], for: .normal)
            markBtn.setTitleColor(textColor, for: .normal)
            markBtn.setTitleColor(textColor, for: .normal)
//
            markBtn.titleLabel?.font = normalFont
            markBtn.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
//            if index != 0 && index != 4{
            if index == 3 {
                markBtn.setImage(UIImage.init(named: "jiantou_no"), for: .normal)
                markBtn.setImage(UIImage.init(named: "jiantou_bottom"), for: .selected)
                markBtn.layoutButton(with: .right, imageTitleSpace: 5)
            }else{
                if index == 4 {
                    markBtn.setImage(UIImage.init(named: "show_horizontal2"), for: .normal)
                    markBtn.setImage(UIImage.init(named: "show_vertical2"), for: .selected)
//                    markBtn.layoutButton(with: .right, imageTitleSpace: 5)
                    markBtn.setTitleColor(kMainColor1(), for: .selected)
                }else{
//                    markBtn.setImage(UIImage.init(named: "other_zong_unselect"), for: .normal)
//                    markBtn.setImage(UIImage.init(named: "other_zong_selected"), for: .selected)
                    markBtn.layoutButton(with: .right, imageTitleSpace: 5)
                    markBtn.setTitleColor(kMainColor1(), for: .selected)
                }
            }
            markBtn.tag = 130 + index
            //            totalWidth += (kWidth+kSpace)
            scrollView.addSubview(markBtn)
        }
        if datas.count>0 {
            let selectButton = scrollView.viewWithTag(130+selectIndex) as! UIButton
            selectButton.titleLabel?.font = selectFont
            underLine = UIView.init(frame: CGRect(x: 0, y: scrollHeight-4, width: getLabWidth(labelStr: datas[selectIndex], font: selectFont, height: 1) - 7, height: 2))
            underLine.center.x = selectButton.center.x
            
        }
        
        underLine.backgroundColor = kGaryColor(num: 255)
        underLine.layer.cornerRadius = 1
        underLine.clipsToBounds = true
        scrollView.addSubview(underLine)
        
        //        scrollView.contentSize = CGSize(width: totalWidth, height: scrollHeight)
        
        self.addSubview(scrollView)
        //        showMore = UIButton.init(frame: CGRect(x: self.width-moreWidth, y: 0, width: moreWidth, height: self.height))
        //        showMore.addTarget(self, action: #selector(showAllOptions(sender:)), for: .touchUpInside)
        //        showMore.backgroundColor = UIColor.clear
        //        showMore.tag = 10086
        //        self.addSubview(showMore)
        
        lineView = UIView.init(frame: CGRect(x: self.width-moreWidth, y: 10, width: 0.5, height: scrollHeight-20))
        lineView.backgroundColor = lineColor
        self.addSubview(lineView)
    }
    
    func changerStyle() {
        if self.subviews.count > 0 {
            let lastButton = self.viewWithTag(3+130) as! UIButton
            lastButton.setTitle(nil, for: .normal)
            lastButton.layoutButton(with: .right, imageTitleSpace: 0)
        }
    }
    
    func hiddenView() {
        let sender = self.viewWithTag(130) as? UIButton
        if sender != nil {
            sender!.isSelected = false
        }
    }
    
    @objc fileprivate func showAllOptions(sender: UIButton) {
        if nil != willClick {
            willClick!(10086,false)
        }
    }
    
    
    //MARK:   顶部选择栏选择事件
    @objc func goodAtProject(sender:UIButton) {
        
        if sender.tag == 130 {

            let lastButton = self.viewWithTag(1+130) as! UIButton
            let lastButton2 = self.viewWithTag(2+130) as! UIButton
            let lastButton3 = self.viewWithTag(3+130) as! UIButton
            
//            lastButton.setImage(UIImage.init(named: "jiantou_no"), for: .normal)
//            lastButton2.setImage(UIImage.init(named: "jiantou_no"), for: .normal)
            lastButton3.setImage(UIImage.init(named: "jiantou_no"), for: .normal)
            
            lastButton.isSelected = false
            lastButton2.isSelected = false
            lastButton3.isSelected = false
            if sender.isSelected {
                return
            }
            sender.isSelected = !sender.isSelected
        }else if sender.tag == 131{
            
            let lastButton2 = self.viewWithTag(2+130) as! UIButton
            let lastButton3 = self.viewWithTag(3+130) as! UIButton
//            lastButton2.setImage(UIImage.init(named: "jiantou_no"), for: .normal)
//            lastButton2.setImage(UIImage.init(named: "jiantou_bottom"), for: .selected)
            lastButton2.isSelected = false
            lastButton3.setImage(UIImage.init(named: "jiantou_no"), for: .normal)
            lastButton3.setImage(UIImage.init(named: "jiantou_bottom"), for: .selected)
            lastButton3.isSelected = false
            
//            sender.setImage(UIImage.init(named: "jiantou_top"), for: .normal)
//            sender.setImage(UIImage.init(named: "jiantou_bottom"), for: .selected)
            if sender.isSelected {
                return
            }
            sender.isSelected = !sender.isSelected

        }else if sender.tag == 132{
            
            let lastButton1 = self.viewWithTag(1+130) as! UIButton
            let lastButton3 = self.viewWithTag(3+130) as! UIButton
//            lastButton1.setImage(UIImage.init(named: "jiantou_no"), for: .normal)
//            lastButton1.setImage(UIImage.init(named: "jiantou_bottom"), for: .selected)
            lastButton1.isSelected = false
            lastButton3.setImage(UIImage.init(named: "jiantou_no"), for: .normal)
            lastButton3.setImage(UIImage.init(named: "jiantou_bottom"), for: .selected)
            lastButton3.isSelected = false
            
//            sender.setImage(UIImage.init(named: "jiantou_top"), for: .normal)
//            sender.setImage(UIImage.init(named: "jiantou_bottom"), for: .selected)
            if sender.isSelected {
                return
            }
            sender.isSelected = !sender.isSelected
        }else if sender.tag == 133{
            
            let lastButton1 = self.viewWithTag(1+130) as! UIButton
            let lastButton2 = self.viewWithTag(2+130) as! UIButton
//            lastButton1.setImage(UIImage.init(named: "jiantou_no"), for: .normal)
//            lastButton1.setImage(UIImage.init(named: "jiantou_bottom"), for: .selected)
            lastButton1.isSelected = false
//            lastButton2.setImage(UIImage.init(named: "jiantou_no"), for: .normal)
//            lastButton2.setImage(UIImage.init(named: "jiantou_bottom"), for: .selected)
            lastButton2.isSelected = false
            
            sender.setImage(UIImage.init(named: "jiantou_top"), for: .normal)
            sender.setImage(UIImage.init(named: "jiantou_bottom"), for: .selected)
            sender.isSelected = !sender.isSelected
        }else{
            sender.isSelected = !sender.isSelected
        }
        
        weak var weakSelf = self
        
        UIView.animate(withDuration: 0.3) {
            weakSelf?.underLine.bounds.size.width = getLabWidth(labelStr: (sender.titleLabel?.text)!, font: self.selectFont, height: 2)-5
            
            weakSelf?.underLine.center = CGPoint(x:  sender.center.x, y:  (weakSelf?.underLine.center.y)!)
        }

        currentIndex = sender.tag - 130
        if nil != willClick {
            willClick!(currentIndex,sender.isSelected)
        }
    }
}
