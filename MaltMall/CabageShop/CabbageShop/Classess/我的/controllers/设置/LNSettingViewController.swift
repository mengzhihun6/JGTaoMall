//
//  LNSettingViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LNSettingViewController: LNBaseViewController {

    let identyfierTable1 = "identyfierTable1"
    
    var titles = [String]()
    var images = [UIImage]()
    var values = [String]()
    var model = LNMemberModel()
    var model1 = SZYPersonalCenterModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configSubViews() {
        navigaView.backgroundColor = UIColor.black
        navigaView.layer.shadowOpacity = 0//阴影透明度，默认0
        navigaView.layer.shadowRadius = 0//阴影半径，默认3
        navigationTitle = "设置"
//        navigationBgImage = UIImage.init(named: "Rectangle")
        titleLabel.textColor = UIColor.white
        
        self.view.backgroundColor = UIColor.init(r: 242, g: 242, b: 242)
        
        
        self.titles = ["推荐人","邀请码","手机号","绑定微信","清除缓存","版本号","淘宝授权"]
        self.images = [UIImage.init(named: "setting_inviter"), UIImage.init(named: "setting_code"), UIImage.init(named: "setting_phone"), UIImage.init(named: "setting_wechat"), UIImage.init(named: "setting_clean"), UIImage.init(named: "版本"), UIImage.init(named: "iconfonttao"),] as! [UIImage]
        
        var inviter = self.model1.inviter.nickname
        if inviter.count == 0 { inviter = "无" }
        var hashid = self.model1.hashid
        if self.model1.invite_code != "" {
            hashid = self.model1.invite_code
        }
        if hashid.count == 0 || model1.inviter_id.count == 0 { hashid = "无" }
        var phone = self.model1.phone
        if phone.count == 0 { phone = "无" }
        var nickname = self.model1.nickname
        if nickname.count == 0 { nickname = "无" }
        let appVersion:String = Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String// App 版本号
        let buildVersion : String = Bundle.main.infoDictionary! ["CFBundleVersion"] as! String //Bulid 版本号
        kDeBugPrint(item: appVersion)
        kDeBugPrint(item: buildVersion)
        self.values = [inviter,hashid,phone,nickname,LQTools().getCacheMamery(),appVersion,""]
        
        
//        let imageView = UIImageView.init(image: UIImage.init(named: "Rectangle1"))
//        imageView.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: navHeight)
//        navigaView.insertSubview(imageView, at: 0)

        mainTableView = getTableView(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight), style: .plain, vc: self)
        
        mainTableView.register(UINib(nibName: "LNMineSettingCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.register(UINib(nibName: "SZYLNMineSettingCell", bundle: nil), forCellReuseIdentifier: identyfierTable1)
        mainTableView.separatorStyle = .none
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.backgroundColor = kGaryColor(num: 245)
        mainTableView.estimatedRowHeight=49
        self.view.addSubview(mainTableView)
        
        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 120))
        footView.backgroundColor = kGaryColor(num: 245)
        
        let logout = UIButton.init(frame: CGRect(x: 47, y: 0, width: kSCREEN_WIDTH-47*2, height: 49))
        logout.centerY = footView.centerY
        logout.backgroundColor = UIColor.black
        logout.clipsToBounds = true
        logout.setTitle("退出登录", for: .normal)
        logout.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logout.cornerRadius = 10
        logout.addTarget(self, action: #selector(rightAction(sender:)), for: .touchUpInside)
        footView.addSubview(logout)
        
        mainTableView.tableFooterView = footView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
////        //创建一个队列
//        let queue = DispatchQueue(label: "com.test.myqueue")
////        在队列' queue' 中同步打印0~10
//        queue.async {
//            self.titles = ["推荐人","邀请码","手机号","绑定微信","清除缓存","版本号","淘宝授权"]
//            self.images = [UIImage.init(named: "setting_inviter"), UIImage.init(named: "setting_code"), UIImage.init(named: "setting_phone"), UIImage.init(named: "setting_wechat"), UIImage.init(named: "setting_clean"), UIImage.init(named: "版本"), UIImage.init(named: "iconfonttao"),] as! [UIImage]
//
//            var inviter = self.model1.inviter.nickname
//            if inviter.count == 0 { inviter = "无" }
//            var hashid = self.model1.hashid
//            if hashid.count == 0 { hashid = "无" }
//            var phone = self.model1.phone
//            if phone.count == 0 { phone = "无" }
//            var nickname = self.model1.nickname
//            if nickname.count == 0 { nickname = "无" }
//            let appVersion:String = Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String// App 版本号
//            let buildVersion : String = Bundle.main.infoDictionary! ["CFBundleVersion"] as! String //Bulid 版本号
//            kDeBugPrint(item: appVersion)
//            kDeBugPrint(item: buildVersion)
//            self.values = [inviter,hashid,phone,nickname,LQTools().getCacheMamery(),appVersion,""]
//            DispatchQueue.main.async {
//                self.mainTableView.reloadData()
//            }
//        }
    }
    
    override func rightAction(sender: UIButton) {
        self.view.window?.rootViewController = loginOut()
    }
}

extension LNSettingViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if titles.count > 0 {
            return titles.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! SZYLNMineSettingCell
            cell.selectionStyle = .none
            cell.setUpValues(image: self.model1.headimgurl, text: self.model1.nickname)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNMineSettingCell
            cell.selectionStyle = .none
            if images.count>0 && values.count>0 && titles.count>0{
                if indexPath.section == 5 {
                    cell.setUpValues(image: images[indexPath.section - 1], title: titles[indexPath.section - 1], value: values[indexPath.section - 1], type: "1")
                } else if indexPath.section == 7 {
                    cell.setUpValues(image: images[indexPath.section - 1], title: titles[indexPath.section - 1], value: values[indexPath.section - 1], type: "2")
                } else {
                    cell.setUpValues(image: images[indexPath.section - 1], title: titles[indexPath.section - 1], value: values[indexPath.section - 1], type: "")
                }
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
            if indexPath.section == 5 {
                LQLoadingView().SVPWillShow("清除中")
                LQTools().clearCacheMamery()
                
                weak var weakSelf = self
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    LQLoadingView().SVPwillSuccessShowAndHide("清除成功")
                    weakSelf?.values[4] = LQTools().getCacheMamery()
                    tableView.reloadData()
                }
                
                let imageData = try? Data.init(contentsOf: URL.init(string: Defaults[kLastImage]!)!)
                if imageData == nil {
                    return
                }
                let image = UIImage.init(data: imageData!)
                SDWebImageManager.shared().saveImage(toCache: image, for: OCTools.getEfficientAddress(Defaults[kLastImage]!))
                
            } else if indexPath.section == 3 {
                if titles[indexPath.section - 1] != "无" {
                    let vc = SZYModifyPhoneViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return 49
        }
        return 131;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section == 0{
            return 0
        }else if section == 1{
            return 23
        }
        return 3
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = kGaryColor(num: 245)
        return view
    }
}
