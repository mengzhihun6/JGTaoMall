//
//  LNMainCenterReusableView.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/18.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNMainCenterReusableView: UICollectionReusableView {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!

    fileprivate var isUp = false
    //    回调
    typealias swiftBlock = (_ selectParam:NSInteger) -> Void
    var willClick : swiftBlock? = nil
    func callBackPhoneNum(block: @escaping ( _ selectParam:NSInteger) -> Void ) {
        willClick = block
    }
    
    
    @IBAction func selectAction1(_ sender: UIButton) {
        
        if sender == button1 {
            return
        }
        
        button1.isSelected = true
        button2.isSelected = false
        button3.isSelected = false
        button4.isSelected = false
        if willClick != nil {
            willClick!(0)
        }
    }
    
    @IBAction func selectAction2(_ sender: UIButton) {
        
        if sender == button2 {
            return
        }
        
        button1.isSelected = false
        button2.isSelected = true
        button3.isSelected = false
        button4.isSelected = false
        if willClick != nil {
            willClick!(1)
        }
    }
    
    @IBAction func selectAction3(_ sender: UIButton) {
        
        if sender == button3 {
            return
        }

        button1.isSelected = false
        button2.isSelected = false
        button3.isSelected = true
        button4.isSelected = false
        if willClick != nil {
            willClick!(2)
        }

    }
    
    @IBAction func selectAction4(_ sender: UIButton) {
        button1.isSelected = false
        button2.isSelected = false
        button3.isSelected = false
        button4.isSelected = true
        
        if isUp {
            if willClick != nil {
                willClick!(3)
            }
        }else{
            if willClick != nil {
                willClick!(4)
            }
        }
        isUp = !isUp
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        button4.layoutButton(with: .right, imageTitleSpace: 5)
        
    }
    
}
