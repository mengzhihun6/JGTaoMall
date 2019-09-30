//
//  BCTVersionViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/5/5.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class BCTVersionViewController: LNBaseViewController {
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lnviteCode_textField: UITextField!
    @IBOutlet weak var describe_Label: UILabel!
    @IBOutlet weak var cancel_Button: UIButton!
    @IBOutlet weak var update_Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigaView.isHidden = true
        
        bg_view.cornerRadius = 7
        bg_view.clipsToBounds = true
    
//        cancel_Button.cornerRadius = cancel_Button.height / 2.0
        cancel_Button.clipsToBounds = true
//        cancel_Button.backgroundColor = kSetRGBColor(r: 245, g: 244, b: 246)
//        cancel_Button.setTitleColor(kSetRGBColor(r: 160, g: 160, b: 160), for: .normal)
        
//        update_Button.cornerRadius = update_Button.height / 2.0
        update_Button.clipsToBounds = true
//        update_Button.backgroundColor = kSetRGBColor(r: 175, g: 43, b: 45)
//        update_Button.setTitleColor(UIColor.white, for: .normal)
        
    }
    //    MARK: 取消事件
    @IBAction func cancelClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    //    MARK: 提交事件
    @IBAction func updateClick(_ sender: UIButton) {
        
        if !isPurnInt(string: lnviteCode_textField.text!) {
            setToast(str: "仅支持纯数字邀请码!")
            return
        }
        
        let request = SKRequest.init()
        //user/inviterCode   token,  code == 邀请码
        request.setParam(lnviteCode_textField.text! as NSObject, forKey: "code")
        
        request.callGET(withUrl: LNUrls().kInviterCode) { (response) in
            kDeBugPrint(item: response?.data)
            if !(response?.success)! {
                setToast(str: (response?.message)!)
                return
            }
            setToast(str: (response?.message)!)
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    func isPurnInt(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
}
