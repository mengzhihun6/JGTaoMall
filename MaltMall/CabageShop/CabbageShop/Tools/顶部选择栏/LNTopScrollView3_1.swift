//
//  LNTopScrollView3_1.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/4/10.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class LNTopScrollView3_1: UIView {
    //    回调
    typealias swiftBlock = (_ message:NSInteger, _ model:String) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping ( _ message:NSInteger, _ model:String) -> Void ) {
        willClick = block
    }
    
    //    当前选择的下标
    fileprivate var currentIndex = NSInteger()
    
    fileprivate var scrollView = UIScrollView()
    
    fileprivate var scrollHeight:CGFloat = 60
    
    fileprivate var isOut  = false
    
    fileprivate var selectFont  = UIFont.systemFont(ofSize: 15)
    fileprivate var normalFont  = UIFont.systemFont(ofSize: 14)
    
    var lineColor = kGaryColor(num: 69)
    var textColor = kGaryColor(num: 255)
    
    var datas = [String]()
    
    var bg_ImageView = UIImageView()
    
    
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
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: scrollHeight))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clear
        
        let bg_view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: 54))
        bg_view.backgroundColor = lineColor
        scrollView.addSubview(bg_view)
        
        let kHeight = CGFloat(scrollHeight - 6)
        let kSpace = CGFloat(8)
        let kWidth:CGFloat = 60
        var totalWidth = kSpace
        
        let dateFamater = DateFormatter.init()
        dateFamater.dateFormat = "HH"
        let time = Int(dateFamater.string(from: Date.init()))
        
        bg_ImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: 60))
        bg_ImageView.image = UIImage.init(named: "快抢图标")
        scrollView.addSubview(bg_ImageView)
        
        for index in 0..<titles.count {
            let markBtn = UIButton.init(frame: CGRect(x: kSpace + (kWidth + kSpace) * CGFloat(index) , y: 0, width: kWidth, height: kHeight))
            markBtn.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
            markBtn.tag = 130 + index
            markBtn.clipsToBounds = true
            markBtn.centerY = scrollView.centerY
            markBtn.backgroundColor = UIColor.clear
            if index == selectIndex {
                bg_ImageView.center = CGPoint.init(x: markBtn.centerX, y: 30)
            }
            totalWidth += (kWidth + kSpace)
            
            let labelTime = UILabel.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHeight / 2))
            labelTime.text = titles[index]
            labelTime.tag = 50
            labelTime.textColor = kGaryColor(num: 0)
            labelTime.font = UIFont.systemFont(ofSize: 17)
            labelTime.textAlignment = .center
            labelTime.backgroundColor = UIColor.clear
            labelTime.isUserInteractionEnabled = false
            markBtn.addSubview(labelTime)
            
            let labelState = UILabel.init(frame: CGRect(x: 0, y: kHeight / 2, width: kWidth, height: kHeight / 2))
            labelState.font = UIFont.systemFont(ofSize: 10)
            labelState.textColor = kGaryColor(num: 141)
            labelState.tag = 51
            if index < 5 {
                labelState.text = "昨日开抢"
            }else if index > 9 {
                labelState.text = "明日开抢"
            }else{
                if index > selectIndex {
                    labelState.text = "即将开抢"
                }else{
                    if index == selectIndex {
                        labelState.text = "正在开抢中"
                        labelTime.textColor = kGaryColor(num: 255)
                        labelState.textColor = kGaryColor(num: 255)
                    }else{
                        labelState.text = "已开抢"
                    }
                }
            }
            labelState.textAlignment = .center
            labelState.backgroundColor = UIColor.clear
            labelState.isUserInteractionEnabled = false
            markBtn.addSubview(labelState)
            
            scrollView.addSubview(markBtn)
        }
        bg_view.frame = CGRect.init(x: 0, y: 0, width: totalWidth, height: 54)
        scrollView.contentSize = CGSize(width: totalWidth, height: scrollHeight)
        
        self.addSubview(scrollView)
        
    }
    
    //MARK:   顶部选择栏选择事件
    @objc func goodAtProject(sender:UIButton) {
        
        let lastButton = self.viewWithTag(currentIndex + 130) as? UIButton
        
        if lastButton == sender {
            return
        }
        
        let labelTime = lastButton?.viewWithTag(50) as? UILabel
        let labelState = lastButton?.viewWithTag(51) as? UILabel
        labelTime!.textColor = kGaryColor(num: 0)
        labelState!.textColor = kGaryColor(num: 141)
        
        let labelTime1 = sender.viewWithTag(50) as? UILabel
        let labelState1 = sender.viewWithTag(51) as? UILabel
        labelTime1!.textColor = kGaryColor(num: 255)
        labelState1!.textColor = kGaryColor(num: 255)
        
        bg_ImageView.center = CGPoint.init(x: sender.centerX, y: 30)
        
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
        
        let sender = self.viewWithTag(index + 130) as! UIButton
        let lastButton = self.viewWithTag(currentIndex + 130) as? UIButton
        
        if lastButton == sender {
            return
        }
        bg_ImageView.center = CGPoint.init(x: sender.centerX, y: 30)
        
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
