//
//  LNTopScrollView3.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/15.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNTopScrollView3: UIView {
    //    回调
    typealias swiftBlock = (_ message:NSInteger, _ model:String) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping ( _ message:NSInteger, _ model:String) -> Void ) {
        willClick = block
    }
    
    //    当前选择的下标
    fileprivate var currentIndex = NSInteger()
    
    fileprivate var scrollView = UIScrollView()
    
    fileprivate var scrollHeight:CGFloat = 58
    
    fileprivate var isOut  = false
    
    fileprivate var selectFont  = UIFont.systemFont(ofSize: 15)
    fileprivate var normalFont  = UIFont.systemFont(ofSize: 14)
    
    var lineColor = kGaryColor(num: 69)
    var textColor = kGaryColor(num: 255)
    
    var datas = [String]()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTopView(titles:[String],selectIndex:NSInteger) -> Void {
        datas = titles
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }
        
//        currentIndex = selectIndex
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: scrollHeight))
        scrollView.showsHorizontalScrollIndicator = false
        
        let kHeight = CGFloat(scrollHeight)
        let kSpace = CGFloat(8)
        let kWidth:CGFloat = 60
        var totalWidth = kSpace
        
        let dateFamater = DateFormatter.init()
        dateFamater.dateFormat = "HH"
        let time = Int(dateFamater.string(from: Date.init()))

        for index in 0..<titles.count{
            
            let markBtn = UIButton.init(frame: CGRect(x: kSpace + (kWidth+kSpace
                )*CGFloat(index) , y: 1, width: kWidth, height: kHeight))
            markBtn.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
            markBtn.tag = 130 + index
            markBtn.clipsToBounds = true
//            markBtn.cornerRadius = 4
            markBtn.centerY = scrollView.centerY
            if index == selectIndex {
                markBtn.backgroundColor = kSetRGBColor(r: 245, g: 166, b: 35)
            }else{
                markBtn.backgroundColor = UIColor.clear
            }
            
            totalWidth += (kWidth+kSpace)
            
            let labelTime = UILabel.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHeight/2))
            labelTime.text = titles[index]
            labelTime.textColor = kGaryColor(num: 255)
            labelTime.font = UIFont.systemFont(ofSize: 17)
            labelTime.textAlignment = .center
            labelTime.backgroundColor = UIColor.clear
            labelTime.isUserInteractionEnabled = false
            markBtn.addSubview(labelTime)
            
            let labelState = UILabel.init(frame: CGRect(x: 0, y: kHeight/2, width: kWidth, height: kHeight/2))
            labelState.font = UIFont.systemFont(ofSize: 10)
            if index < 5 {
                labelState.text = "昨日开抢"
            }else if index > 9 {
                labelState.text = "明日开抢"
            }else{
                if index > selectIndex {
                    labelState.text = "即将开抢"
                }else{
                    if index == selectIndex {
                        labelState.text = "正在快抢中"
//                        labelState.font = UIFont
                    }else{
                        labelState.text = "已开抢"
                    }
                }
            }
            labelState.textColor = kGaryColor(num: 255)
            labelState.textAlignment = .center
            labelState.backgroundColor = UIColor.clear
            labelState.isUserInteractionEnabled = false
            markBtn.addSubview(labelState)
            
            scrollView.addSubview(markBtn)
        }
        
        scrollView.contentSize = CGSize(width: totalWidth, height: scrollHeight)
        
        self.addSubview(scrollView)
    }
    
    //MARK:   顶部选择栏选择事件
    @objc func goodAtProject(sender:UIButton) {
        
        let lastButton = self.viewWithTag(currentIndex+130) as? UIButton
        
        if lastButton == sender {
            return
        }
        
        sender.backgroundColor = kSetRGBColor(r: 245, g: 166, b: 35) //kSetRGBColor(r: 232, g: 59, b: 46)
        
        if lastButton != nil {
            lastButton?.backgroundColor = UIColor.clear
        }

        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            
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
    
    
    public func setSelectIndex(index:NSInteger,animation:Bool) {
        
        let sender = self.viewWithTag(index+130) as! UIButton
        let lastButton = self.viewWithTag(currentIndex+130) as? UIButton
        
        
        if lastButton == sender {
            return
        }
        
        sender.backgroundColor = kSetRGBColor(r: 245, g: 166, b: 35)//kSetRGBColor(r: 232, g: 59, b: 46)
        if lastButton != nil {
            lastButton?.backgroundColor = UIColor.clear
        }

        weak var weakSelf = self
        
        var duration:TimeInterval = 0
        
        if animation {
            duration = 0.3
        }
        
        UIView.animate(withDuration: duration, animations: {
            
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
    }
    
}
