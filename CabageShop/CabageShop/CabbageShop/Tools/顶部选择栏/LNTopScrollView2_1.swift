//
//  LNTopScrollView2_1.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/19.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNTopScrollView2_1: UIView {

    //    回调
    typealias swiftBlock = (_ message:NSInteger, _ model:LNTopListModel) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping ( _ message:NSInteger, _ model:LNTopListModel) -> Void ) {
        willClick = block
    }
    //    下划线
    fileprivate var underLine = UIView()

    //    当前选择的下标
    fileprivate var currentIndex = NSInteger()
    
    fileprivate var scrollView = UIScrollView()
    
    fileprivate var scrollHeight:CGFloat = 40
    
    fileprivate var isOut  = false
    fileprivate var lineView  = UIView()
    
    fileprivate var showMore  = UIButton()
    
    fileprivate var selectFont  = UIFont.systemFont(ofSize: 15)
    fileprivate var normalFont  = UIFont.systemFont(ofSize: 14)
    
    var lineColor = UIColor.white
    var textColor = kGaryColor(num: 255)
    
    var datas = [LNTopListModel]()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTopView(titles:[LNTopListModel], selectIndex:NSInteger) -> Void {
        datas = titles
        let model = LNTopListModel()
        model.name = "全部"
        datas.insert(model, at: 0)
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }
        
        currentIndex = selectIndex
        let moreWidth = CGFloat(45)
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-moreWidth, height: scrollHeight))
        scrollView.showsHorizontalScrollIndicator = false
        let kHeight = CGFloat(scrollHeight)
        let kSpace = CGFloat(8)
        var totalWidth = CGFloat()

        for index in 0..<datas.count{
            
            let kWidth = getLabWidth(labelStr: datas[index].name, font: selectFont, height: kHeight) + 10
            
            let markBtn = UIButton.init(frame: CGRect(x: kSpace + totalWidth , y: 1, width: kWidth, height: kHeight))
            markBtn.setTitle(datas[index].name, for: .normal)
            markBtn.setTitleColor(textColor, for: .normal)
            markBtn.titleLabel?.font = normalFont
            markBtn.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
            markBtn.tag = 130 + index
            totalWidth += (kWidth+kSpace)
            scrollView.addSubview(markBtn)
        }
        
        scrollView.contentSize = CGSize(width: totalWidth, height: scrollHeight)

        if datas.count>0 {
            let selectButton = scrollView.viewWithTag(130+selectIndex) as! UIButton
            selectButton.titleLabel?.font = selectFont
            underLine = UIView.init(frame: CGRect(x: 0, y: scrollHeight-4, width: getLabWidth(labelStr: datas[selectIndex].name, font: selectFont, height: 1) - 7, height: 2))
            underLine.center.x = selectButton.center.x
            
        }
        
        underLine.backgroundColor = lineColor
        underLine.layer.cornerRadius = 1
        underLine.clipsToBounds = true
        scrollView.addSubview(underLine)

        self.addSubview(scrollView)
        showMore = UIButton.init(frame: CGRect(x: self.width-moreWidth, y: 0, width: moreWidth, height: self.height))
        showMore.addTarget(self, action: #selector(showAllOptions(sender:)), for: .touchUpInside)
        showMore.setImage(UIImage.init(named: "Sizer_white_icon"), for: .normal)
        showMore.backgroundColor = UIColor.clear
        showMore.tag = 10086
        self.addSubview(showMore)
        
        lineView = UIView.init(frame: CGRect(x: self.width-moreWidth, y: 10, width: 0.5, height: scrollHeight-20))
        lineView.backgroundColor = lineColor
        self.addSubview(lineView)
    }
    
    
    @objc func changeStyle() {
        showMore.setImage(UIImage.init(named: "Sizer_black_icon"), for: .normal)
    }
    
    @objc fileprivate func showAllOptions(sender: UIButton) {
        if nil != willClick {
            willClick!(10086,LNTopListModel())
        }
    }
    
    
    //MARK:   顶部选择栏选择事件
    @objc func goodAtProject(sender:UIButton) {
        
        let lastButton = self.viewWithTag(currentIndex+130) as! UIButton
        
        if lastButton == sender {
            return
        }
        
        sender.titleLabel?.font = selectFont
        lastButton.titleLabel?.font = normalFont
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.underLine.bounds.size.width = getLabWidth(labelStr: (sender.titleLabel?.text)!, font: self.selectFont, height: 2)-5
            
            weakSelf?.underLine.center = CGPoint(x:  sender.center.x, y:  (weakSelf?.underLine.center.y)!)

            if sender.centerX > self.scrollView.width/2 && (weakSelf?.scrollView.contentSize.width)!-sender.centerX > self.scrollView.width/2{
                weakSelf?.scrollView.contentOffset = CGPoint(x: sender.centerX-self.scrollView.width/2, y: 0)
            }else{
                if sender.centerX < self.scrollView.width/2 {
                    weakSelf?.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                }else{
                    weakSelf?.scrollView.contentOffset = CGPoint(x: (weakSelf?.scrollView.contentSize.width)!-self.scrollView.width, y: 0)
                }
            }
        })
        currentIndex = sender.tag - 130
        if nil != willClick {
            willClick!(currentIndex,datas[sender.tag-130])
        }
    }
}
