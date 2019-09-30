//
//  LNTopWithImageView.swift
//  LingQuan
//
//  Created by RongXing on 2018/5/25.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SnapKit

class LNTopWithImageView: UIView {
    //    回调
    typealias swiftBlock = (_ message:String) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping ( _ message:String) -> Void ) {
        willClick = block
    }
    
    //    下划线
    fileprivate var underLine = UIView()
    //    当前选择的下标
    fileprivate var currentIndex = NSInteger()
    
    fileprivate var scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTopView(titles:[String],images:[String],selectIndex:NSInteger,isUrl:Bool) -> Void {
        
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }
        
        currentIndex = selectIndex
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 44))
        scrollView.showsHorizontalScrollIndicator = false
        
        let kHeight = CGFloat(44)
        let kSpace = CGFloat(8)
        var totalWidth = CGFloat()
        let moreWidth = CGFloat(30)
        
        for index in 0..<titles.count{
            let kWidth = getLabWidth(labelStr: titles[index], font: kFont34, height: kHeight) + 10
            
            let markBtn = UIButton.init(frame: CGRect(x: kSpace + totalWidth , y: 1, width: kWidth, height: kHeight))
            markBtn.setTitle(titles[index], for: .normal)
            markBtn.setTitleColor(kGaryColor(num: 89), for: .normal)
            markBtn.titleLabel?.font = kFont28
            markBtn.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
            markBtn.tag = 130 + index
            totalWidth += (kWidth+kSpace)
            scrollView.addSubview(markBtn)
        }
        
        scrollView.contentSize = CGSize(width: totalWidth+moreWidth, height: 44)
        
        let line = UIView.init(frame: CGRect(x: 0, y: 41 , width: kSCREEN_WIDTH, height: 1))
        line.backgroundColor = kGaryColor(num: 145)
        self.addSubview(line)
        line.snp.makeConstraints { (ls) in
            ls.bottom.equalToSuperview()
            ls.width.equalToSuperview()
            ls.height.equalTo(1)
            ls.leading.equalToSuperview()
        }
        
        if titles.count>0 {
            let selectButton = scrollView.viewWithTag(130+selectIndex) as! UIButton
            selectButton.setTitleColor(kGaryColor(num: 39), for: .normal)
            selectButton.titleLabel?.font = kFont32
            underLine = UIView.init(frame: CGRect(x: 0, y: 40, width: getLabWidth(labelStr: titles[selectIndex], font: kFont32, height: 1) - 5, height: 2))
            underLine.center.x = selectButton.center.x
            
        }
        underLine.backgroundColor = kUnderLineColor()
        underLine.layer.cornerRadius = 1
        underLine.clipsToBounds = true
        scrollView.addSubview(underLine)
        
        let bottomView = UIView.init(frame: CGRect(x: 0, y: 43, width: kSCREEN_WIDTH, height: 1))
        bottomView.backgroundColor = kGaryColor(num: 240)
        self.addSubview(bottomView)
        
        self.addSubview(scrollView)
        
        let showMore = UIButton.init(frame: CGRect(x: self.width-moreWidth, y: 0, width: moreWidth, height: self.height))
        showMore.addTarget(self, action: #selector(showAllOptions(sender:)), for: .touchUpInside)
        showMore.setImage(UIImage.init(named: "down_selet"), for: .normal)
        showMore.backgroundColor = UIColor.white
        self.addSubview(showMore)
        self.backgroundColor = UIColor.white
    }
    
    @objc fileprivate func showAllOptions(sender: UIButton) {
        
        if nil != willClick {
            willClick!("10086")
        }
        
    }

    
    
    //MARK:   顶部选择栏选择事件
    @objc func goodAtProject(sender:UIButton) {
        
        let lastButton = self.viewWithTag(currentIndex+130) as! UIButton
        
        if lastButton == sender {
            return
        }
        
        sender.setTitleColor(kGaryColor(num: 39), for: .normal)
        sender.titleLabel?.font = kFont32
        
        lastButton.setTitleColor(kGaryColor(num: 89), for: .normal)
        lastButton.titleLabel?.font = kFont28
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.underLine.bounds.size.width = getLabWidth(labelStr: (sender.titleLabel?.text)!, font: kFont32, height: 2)-5
            
            weakSelf?.underLine.center = CGPoint(x:  sender.center.x, y:  (weakSelf?.underLine.center.y)!)
            
            if sender.centerX > self.width/2 && (weakSelf?.scrollView.contentSize.width)!-sender.centerX > self.width/2{
                weakSelf?.scrollView.contentOffset = CGPoint(x: sender.centerX-self.width/2, y: 0)
            }else{
                if sender.centerX < self.width/2 {
                    weakSelf?.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                }else{
                    weakSelf?.scrollView.contentOffset = CGPoint(x: (weakSelf?.scrollView.contentSize.width)!-self.width, y: 0)
                }
            }
            
        })
        currentIndex = sender.tag - 130
        if nil != willClick {
            willClick!("\(currentIndex)")
        }
    }
    
    public func setSelectIndex(index:NSInteger) {
        
        let sender = self.viewWithTag(index+130) as! UIButton
        goodAtProject(sender: sender)
    }

}
