//
//  LNMineInfoTabbarController.swift
//  YouQianQuan
//
//  Created by 吴伟助 on 2019/1/7.
//  Copyright © 2019年 付耀辉. All rights reserved.
//

import UIKit

class LNMineInfoTabbarController: UITabBarController {
    let earningVc  = LNMyEarningViewController()
    let orderVc = LNOrderViewController()
    var withdrawVc  = LNWithdrawViewController()
    let teamVc    = LNShowMyTeamViewController()
    
    var selectIndex = NSInteger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false
    }
    
    
    var personalInfo : LNMemberModel! {
        didSet{
            earningVc.model = personalInfo
            setupOneChildViewController("我的收益", image: "select_index_11", selectedImage: "select_index_1", controller: earningVc)
            
            setupOneChildViewController("我的订单", image: "select_index_22", selectedImage: "select_index_2", controller: orderVc)
            
            withdrawVc.model = personalInfo
            setupOneChildViewController("余额提现", image: "select_index_33", selectedImage: "select_index_3", controller: withdrawVc)
            
            setupOneChildViewController("我的团队", image: "select_index_44", selectedImage: "select_index_4", controller: teamVc)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.selectedIndex = selectIndex
    }
    
    /// 添加一个子控制器
    fileprivate func setupOneChildViewController(_ title: String, image: String, selectedImage: String, controller: UIViewController) {
        
        controller.tabBarItem.title = title
        controller.title = title
        selectedTapTabBarItems(tabBarItem: controller.tabBarItem)
        unSelectedTapTabBarItems(tabBarItem: controller.tabBarItem)
        controller.tabBarItem.image = UIImage(named: image)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage)
        let naviController = LNNavigationController.init(rootViewController: controller)
        
        addChildViewController(naviController)
    }
    
    
    func unSelectedTapTabBarItems(tabBarItem:UITabBarItem) {
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.black], for: .normal);
    }
    
    
    func selectedTapTabBarItems(tabBarItem:UITabBarItem) {
        
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:kMainColor1()], for: .selected);
    }
    
}



