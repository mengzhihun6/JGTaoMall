//
//  JGTaobaoAuthorizedAlert.swift
//  CabbageShop
//
//  Created by 郭军 on 2019/9/2.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit

typealias ActionClosure = ()->Void


class JGTaobaoAuthorizedAlert: JGBaseView {

    private var Closure: ActionClosure?

    
    private lazy var alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = UIColor.hex("#F3D6B5")
        alert.layer.cornerRadius = 9.0;
        alert.clipsToBounds = true
        return alert
    }()
    
    
    private lazy var logo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "nav_left")
        return img
    }()
    
    private lazy var titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.font = UIFont.font(17)
        lbl.text = "一键授权，立享优惠权益!"
        return lbl
    }()
    
    private lazy var sureBtn:UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5.0
        btn.backgroundColor = UIColor.black
        btn.setTitle("淘宝授权", for: .normal)
        btn.titleLabel?.font = UIFont.font(14)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        
        return btn
    }()
    
    override func configUI() {
    
        addSubview(alertView)
        alertView.addSubview(logo)
        alertView.addSubview(titleLbl)
        alertView.addSubview(sureBtn)
        
        alertView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        logo.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        titleLbl.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(logo.snp_right).offset(10)
        }
        
        sureBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
    }
    
    
    @objc func btnClick(btn:UIButton) {
        
        guard let closure = Closure else { return }
        closure()
    }
    
    
   open func CloseBtnClick()  {
        self.removeFromSuperview()
    }
    
    
    func ActionClosure(_ closure: @escaping ActionClosure) {
        Closure = closure
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
