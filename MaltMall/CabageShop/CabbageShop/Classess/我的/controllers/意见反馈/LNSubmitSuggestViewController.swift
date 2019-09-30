//
//  LNSubmitSuggestViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNSubmitSuggestViewController: LNBaseViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var resume: UIButton!
    
    @IBOutlet weak var top_space: NSLayoutConstraint!
    
    @IBOutlet weak var title_textfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle = "意见反馈"
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = UIColor.black;
        top_space.constant = navHeight
        
        content.layer.cornerRadius = 6
        content.clipsToBounds = true
        content.delegate = self
        
        resume.layer.cornerRadius = 6
        resume.clipsToBounds = true
        
        title_textfield.borderStyle = .none
        title_textfield.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: 8, height: 17))
        title_textfield.leftViewMode = .always
        title_textfield.clearButtonMode = .whileEditing
        title_textfield.layer.cornerRadius = 5
        title_textfield.clipsToBounds = true
        title_textfield.font = UIFont.systemFont(ofSize: 14)
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 6, height: 17))
        let leftImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 6, height: 14))
        view.addSubview(leftImage)
        title_textfield.leftView = view
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        if title_textfield.text?.count == 0 {
            setToast(str: "请输入主题")
            return
        }
        
        if content.text?.count == 0 {
            setToast(str: "请输入内容")
            return
        }

        let request = SKRequest.init()
        request.setParam(title_textfield.text! as NSObject, forKey: "title")
        request.setParam(content.text as NSObject, forKey: "content")
        weak var weakSelf = self
        request.callPOST(withUrl: LNUrls().kFeedback) { (response) in
            DispatchQueue.main.async {
               
                if !(response?.success)! {
                    return
                }

                weakSelf?.navigationController?.pushViewController(LNShowSucceedViewController(), animated: true)
            }
        }

    }
    
}


extension LNSubmitSuggestViewController:UITextViewDelegate {
    //    MARK:UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0 {
            tipLabel.isHidden = false
        }else{
            tipLabel.isHidden = true
        }
        
    }
    
    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        if textView.text.count>=300 {
//            setToast(str: "最多输入300个字符")
//            return false
//        }else{
//            return true
//        }
//    }
    
}
