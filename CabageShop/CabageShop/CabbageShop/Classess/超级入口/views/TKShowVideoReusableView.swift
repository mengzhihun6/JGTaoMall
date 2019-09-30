//
//  TKShowVideoReusableView.swift
//  RentHouse-LandLord
//
//  Created by RongXing on 2018/3/21.
//  Copyright © 2018年 Fu Yaohui. All rights reserved.
//

import UIKit

@objc public protocol TKSearchVideoDelegate: NSObjectProtocol {
    @objc func searchBegin(_ searchKey: String)
}


class TKShowVideoReusableView: UICollectionReusableView {

    @IBOutlet weak var headBg: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var searchMark: UIButton!
    var searchDelegate : TKSearchVideoDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = backView.height/2
        backView.clipsToBounds = true
        backView.backgroundColor = kSetRGBAColor(r: 255, g: 255, b: 255, a: 0.85)
        searchField.delegate = self
        headBg.snp.makeConstraints { (ls) in
            ls.bottom.top.left.equalToSuperview()
            ls.width.equalTo(kSCREEN_WIDTH)
        }
        backView.snp.makeConstraints { (ls) in
            ls.left.equalToSuperview().offset(16)
            ls.right.equalToSuperview().offset(-16)
            ls.height.equalTo(34)
            ls.bottom.equalToSuperview().offset(-20)
        }
        searchMark.snp.makeConstraints { (ls) in
            ls.bottom.equalToSuperview()
            ls.top.equalToSuperview().offset(8)
            ls.width.equalTo(25)
            ls.left.equalToSuperview().offset(35)
        }
        searchField.snp.makeConstraints { (ls) in
            ls.bottom.top.right.equalToSuperview()
            ls.left.equalTo(searchMark.snp.right).offset(8)
        }
    }
}

extension TKShowVideoReusableView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == nil {
            setToast(str: "请输入您想搜索的关键字")
            return false
        }
        
        if searchDelegate != nil {
            searchDelegate?.searchBegin(textField.text!)
        }
        
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        viewContainingController()?.navigationController?.pushViewController(LNSuperKindViewController(), animated: true)
//        searchDelegate?.searchBegin("")
        return false
    }
    
}
