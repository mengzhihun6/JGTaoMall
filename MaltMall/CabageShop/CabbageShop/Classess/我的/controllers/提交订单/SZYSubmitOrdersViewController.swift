//
//  SZYSubmitOrdersViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/25.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYSubmitOrdersViewController: LNBaseViewController {

    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tijiaodingdanBun: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationTitle = "订单找回"
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = UIColor.black
//        navigationBgImage = UIImage.init(named: "Rectangle")
        
        backBtn.setImage(UIImage.init(named: "nav_return_black"), for: .normal)
        
        self.view.backgroundColor = UIColor.white
//        textFieldHeight.constant = navHeight + 35
        
        textField.clipsToBounds = true
        textField.cornerRadius = 25
        textField.returnKeyType = .search
        textField.delegate = self
    }

    @IBAction func tijiaodingdanClick(_ sender: UIButton) {
        kDeBugPrint(item: "提交订单!")
        if textField.text == "" {
            setToast(str: "请填写订单号!")
            return
        }
        let request = SKRequest.init()
        LQLoadingView().SVPwillShowAndHideNoText()
        request.setParam(textField.text! as NSObject, forKey: "ordernum")
        request.setParam("1" as NSObject, forKey: "type")
//        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kTijiaodingdan) { (response) in
            DispatchQueue.main.async {
                LQLoadingView().SVPHide()
                if !(response?.success)! {
                    setToast(str: JSON((response?.data)!)["message"].stringValue)
                    return
                }
                setToast(str: "提交成功!")
                let datas =  JSON((response?.data)!)["data"]
                kDeBugPrint(item: datas)
            }
        }
        
    }
}
extension SZYSubmitOrdersViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tijiaodingdanClick(UIButton.init())
        textField.resignFirstResponder()
        return true
    }
}
