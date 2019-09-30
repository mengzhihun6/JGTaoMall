//
//  LNTopSelectView.swift
//  RentHouse
//
//  Created by RongXing on 2018/3/15.
//  Copyright © 2018年 Fu Yaohui. All rights reserved.
//

import UIKit
import SnapKit

class LNTopSelectView: UIView {

    //    回调
    typealias swiftBlock = (_ message:String) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping ( _ message:String) -> Void ) {
        willClick = block
    }
    //    回调
    typealias swiftBlock2 = (_ message:String, _ model:LNSuperChildrenModel) -> Void
    var willClick2 : swiftBlock2? = nil
    func callBackBlock2(block2: @escaping ( _ message:String, _ model:LNSuperChildrenModel) -> Void ) {
        willClick2 = block2
    }

    fileprivate var models = [LNSuperChildrenModel]()
    
//    下划线
    var underLine = UIView()
//    当前选择的下标
    fileprivate var currentIndex = NSInteger()

    public var theFont = kFont30
    var selectColor = UIColor.init(r: 2016, g: 178, b: 124)
    fileprivate var lineHeight:CGFloat = 2

    var normalColor = kGaryColor(num: 34)
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setTopView(titles:[String],selectIndex:NSInteger) -> Void {
        
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }

        currentIndex = selectIndex
        
        let kHeight = CGFloat(44)
        var contentWidth = CGFloat()
//        总长度
        var totalWidth = CGFloat()
        
        //MARK: 因为按钮字数不一样，长短有别，所以我先看看一共有多长再平分space
        for index in 0..<titles.count{
            
            let kWidth = getLabWidth(labelStr: titles[index], font: theFont, height: kHeight) + 10
            totalWidth += kWidth
            
        }
        
        let kSpace = CGFloat(self.width - totalWidth)/CGFloat(titles.count+1)
        
        for index in 0..<titles.count{
            
            let kWidth = getLabWidth(labelStr: titles[index], font: theFont, height: kHeight) + 10
            let markBtn = UIButton.init(frame: CGRect(x: kSpace + (contentWidth + kSpace * CGFloat(index)) , y: 1, width: kWidth, height: kHeight))
            //            markBtn.center.y = headView.center.y
            markBtn.setTitle(titles[index], for: .normal)
            markBtn.setTitleColor(normalColor, for: .normal)
            markBtn.titleLabel?.font = theFont
            markBtn.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
            contentWidth += kWidth
            markBtn.tag = 130 + index
            self.addSubview(markBtn)
        }
        
        
        let line = UIView.init(frame: CGRect(x: 0, y: 41 , width: self.width, height: 1))
        line.backgroundColor = UIColor.clear
        line.tag = 10086
        self.addSubview(line)
        line.snp.makeConstraints { (ls) in
            ls.bottom.equalToSuperview()
            ls.width.equalToSuperview()
            ls.height.equalTo(1)
            ls.leading.equalToSuperview()
        }
        
        let view = self.viewWithTag(130+selectIndex) as! UIButton
        view.setTitleColor(selectColor, for: .normal)
        underLine = UIView.init(frame: CGRect(x: 0, y: 43, width: getLabWidth(labelStr: titles[selectIndex], font: theFont, height: 1) - 5, height: lineHeight))
        underLine.backgroundColor = selectColor
        underLine.layer.cornerRadius = underLine.height/2
        underLine.clipsToBounds = true
        underLine.center.x = view.center.x
        self.addSubview(underLine)
    }
    
    
    
    
    func setTopViewModel(titles:[LNSuperChildrenModel],selectIndex:NSInteger) -> Void {
        
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }

        currentIndex = selectIndex
        models = titles
        let kHeight = CGFloat(44)
        let kWidth = self.width/2-20
        
        for index in 0..<titles.count{
            
            let markBtn = UIButton.init(frame: CGRect(x: CGFloat(index)*kWidth, y: 1, width: kWidth, height: kHeight))
            //            markBtn.center.y = headView.center.y
            markBtn.setTitle(titles[index].title, for: .normal)
            markBtn.setTitleColor(normalColor, for: .normal)
            markBtn.titleLabel?.font = theFont
            markBtn.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
            markBtn.tag = 130 + index
            self.addSubview(markBtn)
        }
        
        
        let line = UIView.init(frame: CGRect(x: 0, y: 41 , width: self.width, height: 1))
        line.backgroundColor = UIColor.clear
        line.tag = 10086
        self.addSubview(line)
        line.snp.makeConstraints { (ls) in
            ls.bottom.equalToSuperview()
            ls.width.equalToSuperview()
            ls.height.equalTo(1)
            ls.leading.equalToSuperview()
        }
        
        let view = self.viewWithTag(130+selectIndex) as! UIButton
        view.setTitleColor(normalColor, for: .normal)
        underLine = UIView.init(frame: CGRect(x: 0, y: 43, width: self.width/2-50, height: lineHeight))
        underLine.backgroundColor = selectColor
        underLine.layer.cornerRadius = underLine.height/2
        underLine.clipsToBounds = true
        underLine.center.x = view.center.x
        self.addSubview(underLine)
    }

    
    func setSelectColor(color:UIColor) -> Void {
        let view = self.viewWithTag(130+currentIndex) as! UIButton
        view.setTitleColor(color, for: .normal)
        selectColor = color
        underLine.backgroundColor = color
    }
    
    func hiddenGaryLine() {
        let view = self.viewWithTag(10086)
        view?.isHidden = true
    }
    
    
    func setUnderlineColor(color:UIColor, andLineheight height:CGFloat) -> Void {
        underLine.backgroundColor = color
        underLine.bounds.size.height = height
        lineHeight = height
        underLine.layer.cornerRadius = underLine.height/2
    }

    
    //MARK:   顶部选择栏选择事件
     @objc func goodAtProject(sender:UIButton) {
        
        let view = self.viewWithTag(currentIndex+130) as! UIButton
        
        let button = self.viewWithTag(sender.tag) as! UIButton
        
        if view == button {
            return
        }
        
        view.setTitleColor(normalColor, for: .normal)
        button.setTitleColor(selectColor, for: .normal)
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.underLine.bounds.size.width = getLabWidth(labelStr: (button.titleLabel?.text)!, font: (weakSelf?.theFont)!, height: (weakSelf?.lineHeight)!)-5
            
            weakSelf?.underLine.center = CGPoint(x:  button.center.x, y:  (weakSelf?.underLine.center.y)!)
        })
        currentIndex = button.tag - 130

        if nil != willClick {
            willClick!("\(currentIndex)")
        }
        
        if willClick2 != nil {
            willClick2!("\(currentIndex)",models[currentIndex])
        }
    }
    
    func setSelecIndex(index:NSInteger)  {
        let view = self.viewWithTag(currentIndex+130) as! UIButton
        
        let button = self.viewWithTag(index+130) as! UIButton
        
        if view == button {
            return
        }
        
        view.setTitleColor(normalColor, for: .normal)
        button.setTitleColor(selectColor, for: .normal)
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.underLine.bounds.size.width = getLabWidth(labelStr: (button.titleLabel?.text)!, font: (weakSelf?.theFont)!, height: (weakSelf?.lineHeight)!)-5
            
            weakSelf?.underLine.center = CGPoint(x:  button.center.x, y:  (weakSelf?.underLine.center.y)!)
        })
        currentIndex = button.tag - 130
    }
    
    
}
