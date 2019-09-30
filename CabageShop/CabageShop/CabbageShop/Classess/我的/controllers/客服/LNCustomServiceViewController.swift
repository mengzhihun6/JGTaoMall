//
//  LNCustomServiceViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNCustomServiceViewController: LNBaseViewController {

    @IBOutlet weak var erwei_code: UIButton!
    
    @IBOutlet weak var save_button: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var weixin_code: UILabel!
    
    @IBOutlet weak var top_space: NSLayoutConstraint!
    
    var group = LNMemberGroupModel()
    var PersonalCenterModel = SZYGroupModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "客服"
        titleLabel.textColor = UIColor.white
        
        top_space.constant = navHeight+25
        
//        erwei_code.sd_setBackgroundImage(with: OCTools.getEfficientAddress(group.qrcode), for: .normal, completed: nil)
//        weixin_code.text = group.wechat
        erwei_code.sd_setBackgroundImage(with: OCTools.getEfficientAddress(PersonalCenterModel.qrcode), for: .normal, completed: nil)
        weixin_code.text = PersonalCenterModel.wechat
    }

    
    override func configSubViews() {
        save_button.cornerRadius = save_button.height/2
        save_button.clipsToBounds = true
        save_button.backgroundColor = kMainColor1()
        
        bgView.cornerRadius = bgView.height/2
        bgView.clipsToBounds = true
        bgView.borderColor = kSetRGBColor(r: 255, g: 134, b: 2)
        bgView.borderWidth = 1
    }
    
    
    @IBAction func saveImage(_ sender: UIButton) {
        if erwei_code.backgroundImage(for: .normal) == nil {
            setToast(str: "暂无图片")
            return
        }
        UIImageWriteToSavedPhotosAlbum(erwei_code.backgroundImage(for: .normal)!, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error == nil{
            setToast(str: "已保存")
        }
    }

    
    @IBAction func copyAction(_ sender: UIButton) {

        let paste = UIPasteboard.general
        paste.string = weixin_code.text
        setToast(str: "复制成功")
    }
    
    
}
