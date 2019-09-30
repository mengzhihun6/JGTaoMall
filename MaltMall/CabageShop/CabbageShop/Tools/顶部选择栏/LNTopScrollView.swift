
//
//  LNTopScrollView.swift
//  LingQuan
//
//  Created by 付耀辉 on 2018/5/23.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SnapKit

class LNTopScrollView: UIView {
    //    回调
    typealias swiftBlock = (_ message:NSInteger, _ model:LNTopListModel) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping ( _ message:NSInteger, _ model:LNTopListModel) -> Void ) {
        willClick = block
    }
    
    //    回调
    typealias swiftBlock2 = (_ message:NSInteger, _ model:LNSuperChildrenModel) -> Void
    var willClick2 : swiftBlock2? = nil
    func callBackBlock2(block2: @escaping ( _ message:NSInteger, _ model:LNSuperChildrenModel) -> Void ) {
        willClick2 = block2
    }

    var shadowLine = UIView()
    //    下划线
    fileprivate var underLine = UIView()
    //    当前选择的下标
    fileprivate var currentIndex = NSInteger()
    
    fileprivate var scrollView = UIScrollView()
    
    fileprivate var scrollHeight:CGFloat = 40

    fileprivate var isOut  = false
    
    fileprivate let selectFont  = UIFont.systemFont(ofSize: 16)
    fileprivate let normalFont  = UIFont.systemFont(ofSize: 15)

    fileprivate var datas = [LNTopListModel]()
     var datas2 = [LNSuperChildrenModel]()

    var textColor = UIColor.hex("#F3D6B5")
    var rightWidth = 35
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTopView(titles:[LNTopListModel],selectIndex:NSInteger) -> Void {
        
        datas = titles
        if titles.count == 0 {
            return
        }
        if titles[0].name != "全部" {
//            let model = LNTopListModel()
//            model.name = "猜你喜欢"
//            datas.insert(model, at: 0)
            
            let model2 = LNTopListModel()
            model2.name = "优选"
            datas.insert(model2, at: 0)
        }
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }

        currentIndex = selectIndex
        let moreWidth = CGFloat(rightWidth)

        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-moreWidth, height: self.height))
        scrollView.showsHorizontalScrollIndicator = false
        
        let kHeight = self.height
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
            markBtn.contentEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
            scrollView.addSubview(markBtn)
        }
        
        scrollView.contentSize = CGSize(width: totalWidth, height: scrollHeight)
        
        if datas.count>0 {
            let selectButton = scrollView.viewWithTag(130+selectIndex) as! UIButton
            selectButton.titleLabel?.font = selectFont
            underLine = UIView.init(frame: CGRect(x: 0, y: self.height-4, width: getLabWidth(labelStr: datas[selectIndex].name, font: selectFont, height: 1) - 5, height: 2))
            underLine.center.x = selectButton.center.x

        }
        
        underLine.backgroundColor = textColor
        underLine.layer.cornerRadius = 1
        underLine.clipsToBounds = true
        scrollView.addSubview(underLine)
        
        self.addSubview(scrollView)
        let showMore = UIButton.init(frame: CGRect(x: self.width-moreWidth, y: 0, width: moreWidth, height: scrollHeight))
        showMore.addTarget(self, action: #selector(showAllOptions(sender:)), for: .touchUpInside)
        showMore.setImage(UIImage.init(named: "jg_menu_home"), for: .normal)
        showMore.backgroundColor = UIColor.clear

        shadowLine = UIView.init(frame: CGRect(x: 0, y: 0, width: 0.8, height:0))
//        shadowLine.clipsToBounds = false
//        shadowLine.layer.shadowColor = kGaryColor(num: 0).cgColor
//        shadowLine.layer.shadowOffset = CGSize(width: -3, height: 0)
//        shadowLine.layer.shadowOpacity = 1//阴影透明度，默认0
//        shadowLine.layer.shadowRadius = 3//阴影半径，默认3
//        shadowLine.centerY = showMore.centerY
//        shadowLine.backgroundColor = kSetRGBAColor(r: 213, g: 213, b: 213, a: 0.9)

        showMore.addSubview(shadowLine)
        
        self.addSubview(showMore)
    }
    
    func changeShadowColor(color:UIColor) {
        shadowLine.backgroundColor = color
    }
    
    @objc fileprivate func showAllOptions(sender: UIButton) {
        
        if nil != willClick {
            willClick!(10086,LNTopListModel())
        }
        
    }

    
    
    func setTopView2(titles:[LNSuperChildrenModel],selectIndex:NSInteger) -> Void {
        
        datas2 = titles
        
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }
        
        currentIndex = selectIndex
        let moreWidth = CGFloat(0)
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-moreWidth, height: scrollHeight))
        scrollView.showsHorizontalScrollIndicator = false
        
        let kHeight = CGFloat(scrollHeight)
        let kSpace = CGFloat(8)
        var totalWidth = CGFloat()
        
        for index in 0..<datas2.count{
            let kWidth = getLabWidth(labelStr: datas2[index].title, font: selectFont, height: kHeight) + 10
            
            let markBtn = UIButton.init(frame: CGRect(x: kSpace + totalWidth , y: 1, width: kWidth, height: kHeight))
            markBtn.setTitle(datas2[index].title, for: .normal)
            markBtn.setTitleColor(textColor, for: .normal)
            markBtn.titleLabel?.font = normalFont
            markBtn.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
            markBtn.tag = 130 + index
            totalWidth += (kWidth+kSpace)
            scrollView.addSubview(markBtn)
        }
        
        scrollView.contentSize = CGSize(width: totalWidth, height: scrollHeight)
        
        if datas2.count>0 {
            let selectButton = scrollView.viewWithTag(130+selectIndex) as! UIButton
            selectButton.titleLabel?.font = selectFont
            underLine = UIView.init(frame: CGRect(x: 0, y: scrollHeight-4, width: getLabWidth(labelStr: datas2[selectIndex].title, font: selectFont, height: 1) - 5, height: 2))
            underLine.center.x = selectButton.center.x
            
        }
        
        underLine.backgroundColor = textColor
        underLine.layer.cornerRadius = 1
        underLine.clipsToBounds = true
        scrollView.addSubview(underLine)
        
        self.addSubview(scrollView)
    }
    
    
    //MARK:   顶部选择栏选择事件
    @objc func goodAtProject(sender:UIButton) {
        
        let lastButton = self.viewWithTag(currentIndex+130) as! UIButton
        let selectButton = self.viewWithTag(sender.tag) as! UIButton
        
        if lastButton == selectButton {
            return
        }
        
        sender.titleLabel?.font = selectFont

        lastButton.titleLabel?.font = normalFont

        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.underLine.bounds.size.width = getLabWidth(labelStr: (selectButton.titleLabel?.text)!, font: self.selectFont, height: 2)-5
            
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
        
        if datas.count > 0 {
            if nil != willClick {
                willClick!(currentIndex,datas[sender.tag-130])
            }
        }else{
            if nil != willClick2 {
                willClick2!(currentIndex,datas2[sender.tag-130])
            }
        }
    }
    
    public func setSelectIndex(index:NSInteger,animation:Bool) {
        if index > self.scrollView.subviews.count-2 {
            return
        }
        let sender = self.viewWithTag(index+130) as! UIButton
        let lastButton = self.viewWithTag(currentIndex+130) as! UIButton
        
//        if lastButton == sender {
//            return
//        }
        
        
        lastButton.titleLabel?.font = normalFont
        sender.titleLabel?.font = selectFont

        weak var weakSelf = self
        
        var duration:TimeInterval = 0
        
        if animation {
            duration = 0.3
        }
        
        UIView.animate(withDuration: duration, animations: {
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
    }

}
