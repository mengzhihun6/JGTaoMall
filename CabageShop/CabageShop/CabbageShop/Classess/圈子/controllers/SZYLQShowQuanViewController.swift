//
//  SZYLQShowQuanViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/16.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import MJRefresh

private let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)
class SZYLQShowQuanViewController: LNBaseViewController {
    private let headerHeight: CGFloat = 200.0
    //防止侧滑的时候透明度变化
    private var currentProgress: CGFloat = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigaView.alpha = currentProgress
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UIApplication.shared.statusBarStyle = .default
        navigaView.alpha = 1.0
    }
    
    private lazy var titles: [String] = {
        return ["精选单品", "好货专场"/*, "营销素材"*/]
    }()
    
    private lazy var viewControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        vcs.append(SZYItemViewController())
        vcs.append(SZYGoodNightViewController())
//        vcs.append(SZYGoodNightViewController())
        return vcs
    }()
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight))
        return headerView
    }()
    private lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: headerView.bounds.height))
        headerImageView.image = UIImage(named: "品牌")
        headerImageView.isUserInteractionEnabled = true
        headerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(_:))))
        return headerImageView
    }()
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        
        layout.titleViewBgColor = UIColor.white  //背景色
        layout.titleColor = UIColor(r: 113, g: 113, b: 113) // 标题颜色值(格式不能改) 没选中的
        layout.titleSelectColor = UIColor(r: 231, g: 8, b: 63) //选中标题颜色值
        layout.titleFont = UIFont.systemFont(ofSize: 15) //
        layout.bottomLineColor = kSetRGBColor(r: 231, g: 8, b: 63)   //滑块颜色
        layout.sliderHeight = 44.0  //整个滑块的高
        layout.bottomLineHeight = 2 //滑块底部线的高
        layout.bottomLineCornerRadius = 1 // 滑块底部线圆角
        layout.isHiddenSlider = true //是否隐藏滑块、底部线
        
        layout.isAverage = true
        layout.sliderWidth = 40
        return layout
    }()
    private lazy var simpleManager: LTSimpleManager = {
        let Y: CGFloat = 0.0
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - 34) : view.bounds.height
        let simpleManager = LTSimpleManager(frame: CGRect(x: 0, y: Y, width: view.bounds.width, height: H), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout)
        
        /* 设置代理 监听滚动 */
        simpleManager.delegate = self
        
        /* 设置悬停位置 */
        simpleManager.hoverY = navHeight
        
        return simpleManager
    }()
    var statusBarStyle: UIStatusBarStyle = .lightContent
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigaView.backgroundColor = UIColor.white
        navigaView.layer.shadowOpacity = 0//阴影透明度，默认0
        navigaView.layer.shadowRadius = 0//阴影半径，默认3
        navigationTitle = "发朋友圈"
        titleLabel.textColor = UIColor.white
//        navigationBgImage = UIImage.init(named: "Rectangle")
        backBtn.setImage(nil, for: .normal)
        backBtn.isHidden = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        view.insertSubview(simpleManager, at: 0)
        simpleManagerConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("LTSimpleManagerDemo < --> deinit")
    }
}
extension SZYLQShowQuanViewController {
    //MARK: 具体使用请参考以下
    private func simpleManagerConfig() {
        
        //MARK: headerView设置
        simpleManager.configHeaderView {[weak self] in
            guard let strongSelf = self else { return nil }
            strongSelf.headerView.addSubview(strongSelf.headerImageView)
            return strongSelf.headerView
        }
        
        //MARK: pageView点击事件
        simpleManager.didSelectIndexHandle { (index) in
            print("点击了 \(index) 😆")
        }
    }
    
    @objc private func tapLabel(_ gesture: UITapGestureRecognizer)  {
        print("tapLabel☄")
    }
}
extension SZYLQShowQuanViewController: LTSimpleScrollViewDelegate {
    //MARK: 滚动代理方法
    func glt_scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var headerImageViewY: CGFloat = offsetY
        var headerImageViewH: CGFloat = headerHeight - offsetY
        if offsetY <= 0.0 {
            navigaView.alpha = 0
            currentProgress = 0.0
        }else {
            headerImageViewY = 0
            headerImageViewH = headerHeight
            
            let adjustHeight: CGFloat = headerHeight - navHeight
            let progress = 1 - (offsetY / adjustHeight)
//            //设置状态栏
//            UIApplication.shared.statusBarStyle = progress > 0.5 ? .lightContent : .default
            
            //设置导航栏透明度
            navigaView.alpha = 1 - progress
            currentProgress = 1 - progress
        }
    }
    
    //MARK: 控制器刷新事件代理方法
    func glt_refreshScrollView(_ scrollView: UIScrollView, _ index: Int) {
        //注意这里循环引用问题。
        scrollView.mj_header = MJRefreshNormalHeader {[weak scrollView] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("对应控制器的刷新自己玩吧，这里就不做处理了🙂-----\(index)")
                scrollView?.mj_header.endRefreshing()
            })
        }
    }
}
