//
//  LQShowAllOptionsView.swift
//  LingQuan
//
//  Created by RongXing on 2018/5/25.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

let viewHeight:CGFloat = 60


class LQShowAllOptionsView: UIView {

//    @IBOutlet weak var packUp: UIButton!
//    @IBOutlet weak var optionsView: UIView!
    
    fileprivate var packUp = UIButton()
    
    fileprivate var optionsView = UIButton()

    fileprivate var datas = [LNTopListModel]()

    
    fileprivate var isDown = false
    
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

    
    override func awakeFromNib() {
        
    }
    
    
    fileprivate func configSubviews() {

    }
    
    
    func setupValues(titles:[LNTopListModel],images:[String],selectIndex:Int,isUrl:Bool) -> Void {

        datas = titles

//        let model = LNTopListModel()
//        model.name = "猜你喜欢"
//        datas.insert(model, at: 0)
        
        let model2 = LNTopListModel()
        model2.name = "优选"
        datas.insert(model2, at: 0)
        
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }
        
        self.addSubview(optionsView)

        let count = datas.count
        
        let kSpace = CGFloat(8)
        let kSpaceH = CGFloat(10)

        let kWidth = (self.width-kSpace*5)/4
        let kHeight:CGFloat = viewHeight
        
        let lines = 4
        
        //MARK: 根据图片的数量进行排列
        for index in 0..<count{
            let row =  CGFloat(index%lines)
            
            let optionBtn = UIButton.init(frame: CGRect(x:kSpace+(kWidth + kSpace) * row, y:kSpaceH+(kSpaceH+kHeight)*CGFloat(index/lines), width: kWidth, height: kHeight))
            optionBtn.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
            optionBtn.tag = index+130
            optionBtn.backgroundColor = UIColor.white
            print(optionBtn.frame)
            self.addSubview(optionBtn)
            
            let buttonImage = UIImageView.init(frame: CGRect(x: optionBtn.width/4, y:5, width: optionBtn.width/2, height: optionBtn.width/2))
            buttonImage.backgroundColor = UIColor.clear
            buttonImage.contentMode = .scaleToFill

            if index == 0 {
                buttonImage.image = UIImage.init(named: "select_all")
                buttonImage.contentMode = .scaleAspectFit
            }/*else if index == 1 {
                buttonImage.contentMode = .scaleAspectFit
                buttonImage.image = UIImage.init(named: "guess_like")
            }*/else{
                buttonImage.sd_setImage(with: OCTools.getEfficientAddress(datas[index].logo), placeholderImage: UIImage.init(named: "goodImage_1"))
            }
            buttonImage.clipsToBounds = true
            buttonImage.isUserInteractionEnabled = false
            optionBtn.addSubview(buttonImage)
            
            let buttonTitle = UILabel.init(frame: CGRect(x: 0, y: buttonImage.height+buttonImage.y+2, width: optionBtn.width, height: optionBtn.height-buttonImage.height))
            buttonTitle.textColor = kGaryColor(num: 132)
            buttonTitle.font = UIFont.systemFont(ofSize: 12)
            buttonTitle.text = datas[index].name
            buttonTitle.textAlignment = .center
            buttonTitle.tag = 10
            buttonTitle.isUserInteractionEnabled = false
            buttonTitle.backgroundColor = UIColor.clear
            optionBtn.addSubview(buttonTitle)
        }
        
    }
    
    //MARK:   顶部选择栏选择事件
    @objc func goodAtProject(sender:UIButton) {
        
        let lastButton = self.viewWithTag(currentIndex+130) as! UIButton
        
        if lastButton == sender {
            return
        }
        
//        sender.backgroundColor = kGaryColor(num: 230)
//        lastButton.backgroundColor = kGaryColor(num: 255)

        currentIndex = sender.tag - 130
        
        let label = sender.viewWithTag(10) as? UILabel
        label?.textColor = kSetRGBColor(r: 208, g: 176, b: 113)
        
        let label2 = lastButton.viewWithTag(10) as? UILabel
        label2?.textColor = kGaryColor(num: 132)

        if nil != willClick {
            willClick!(currentIndex,datas[currentIndex])
        }
    }
    
    @objc fileprivate func showAllOptions(sender: UIButton) {
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1) //设置动画时间
        packUp.transform = .identity
        UIView.commitAnimations()

        if nil != willClick {
            willClick!(10086,LNTopListModel())
        }
    }
    
    
    public func setSelectIndex(index:NSInteger) {
        
        let lastButton = self.viewWithTag(currentIndex+130) as! UIButton
        let sender = self.viewWithTag(index+130) as! UIButton
        
        if lastButton == sender {
            return
        }
        
//        sender.backgroundColor = kGaryColor(num: 230)
//        lastButton.backgroundColor = kGaryColor(num: 255)
        let label = sender.viewWithTag(10) as? UILabel
        label?.textColor = kSetRGBColor(r: 208, g: 176, b: 113)
        
        let label2 = lastButton.viewWithTag(10) as? UILabel
        label2?.textColor = kGaryColor(num: 132)

        currentIndex = index
    }
    
    public func hiddenView() {
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.3) //设置动画时间
//        packUp.transform = .identity
//        UIView.commitAnimations()

    }
    
    public func showView() {
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(0.5) //设置动画时间
//        packUp.transform = transform.rotated(by: .pi)
//        UIView.commitAnimations()
//        self.isUserInteractionEnabled = true
    }

}
