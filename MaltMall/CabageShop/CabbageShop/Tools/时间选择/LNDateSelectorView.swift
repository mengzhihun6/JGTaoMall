//
//  LNDateSelectorView.swift
//  RentHouse
//
//  Created by RongXing on 2018/3/16.
//  Copyright © 2018年 Fu Yaohui. All rights reserved.
//

import UIKit

class LNDateSelectorView: UIView {
    
    //    回调
    typealias swiftBlock = (_ isSelected:Bool,_ message:String) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping (_ isSelected:Bool, _ message:String) -> Void ) {
        willClick = block
    }
    
    //    当前选择的时间
    fileprivate var selectDate = String()
    //    选择器
    fileprivate var datePicker = UIDatePicker()
    
    fileprivate let DateHeight:CGFloat = 250

    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpDateSelector() {
        
        let formatter = DateFormatter()
        //日期样式
        //        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: NSDate() as Date))
        selectDate = formatter.string(from: NSDate() as Date)

        
        //MARK:  把datapicker的背景设为透明，这个selecView可以模拟选择栏
        let selectView = UIView.init(frame: CGRect(x: 0, y: DateHeight/2-17, width: kSCREEN_WIDTH, height: 34))
        selectView.backgroundColor = kGaryColor(num: 233)
        //        selectView.center = datePickerView.center
        self.addSubview(selectView)
        
        //创建日期选择器
        datePicker = UIDatePicker(frame: CGRect(x:0, y: 0, width:kSCREEN_WIDTH, height:DateHeight))
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh")
//        datePicker.datePickerMode = .dateAndTime
        
        datePicker.addTarget(self, action: #selector(dateChanged),
                             for: .valueChanged)
        datePicker.backgroundColor = UIColor.clear
        datePicker.datePickerMode = .date
//        datePicker.minimumDate = NSDate.init(timeIntervalSinceNow: 0) as Date
        self.addSubview(datePicker)
        
        //MARK:  顶部需要显示三个控件
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 100 * kSCREEN_SCALE))
        topView.backgroundColor = kSetRGBColor(r: 255, g: 101, b: 101)
        topView.layer.cornerRadius = 16 * kSCREEN_SCALE
        
        //MARK:  取消按钮
        let cancel = UIButton.init(frame: CGRect(x: 15, y: 20 * kSCREEN_SCALE, width: 45, height: 60 * kSCREEN_SCALE))
        cancel.titleLabel?.font = kFont32
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor.white, for: .normal)
        cancel.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
        topView.addSubview(cancel)
        
        //MARK:   确定按钮
        let contain = UIButton.init(frame: CGRect(x: kSCREEN_WIDTH - 60, y: 20 * kSCREEN_SCALE, width: 45, height: 60 * kSCREEN_SCALE))
        contain.titleLabel?.font = kFont32
        contain.setTitle("确定", for: .normal)
        contain.setTitleColor(UIColor.white, for: .normal)
        contain.addTarget(self, action: #selector(containAction(sender:)), for: .touchUpInside)
        topView.addSubview(contain)
        
        //MARK:  题目
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH - 120, height: 60 * kSCREEN_SCALE))
        titleLabel.text = "选择时间"
        titleLabel.font = kFont36
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.center = topView.center
        
        topView.addSubview(titleLabel)
        
        self.addSubview(topView)
        
        //MARK:  因为需要设置圆角 还是只能上面有，所以我又给下面盖了一个。。。
        let theView = UIView.init(frame: CGRect(x: 0, y: 80 * kSCREEN_SCALE, width: kSCREEN_WIDTH, height: 20 * kSCREEN_SCALE))
        theView.backgroundColor = kSetRGBColor(r: 255, g: 101, b: 101)
        self.addSubview(theView)

    }
    
    //MARK:      取消事件
    @objc fileprivate func cancelAction(sender:UIButton) {
        if nil != willClick {
            willClick!(false,selectDate)
        }

    }
    
    //MARK:      确定事件
    @objc fileprivate func containAction(sender:UIButton) {
        if nil != willClick {
            willClick!(true,selectDate)
        }

    }
    
    
    //MARK://日期选择器响应方法
    @objc fileprivate func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
//        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: datePicker.date))
        selectDate = formatter.string(from: datePicker.date)
    }


}
