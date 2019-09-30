import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import MJRefresh

class YHJDorPDDPageVC: LNBaseViewController {
    
    var typeIntString = "2"    // 2. 京东   3. 拼多多
    
    let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)
    var viewControllers = [UIViewController]()
    var titles = [String]()
    var advancedManager: LTAdvancedManager!
//    顶部导航栏
    fileprivate var navigationView: UIView!
//    弧形的图案
    var headBottomImage = UIImageView()
    var superViewController = UIViewController()
    
    private func managerReact() -> CGRect {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
        return CGRect(x: 0, y: Y, width: view.bounds.width, height: H)
    }
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.titleViewBgColor = UIColor.white  //背景色
        layout.titleColor = UIColor(r: 153, g: 153, b: 153) // 标题颜色值(格式不能改) 没选中的
        layout.titleSelectColor = UIColor(r: 200, g: 200, b: 200) //选中标题颜色值
        layout.titleFont = UIFont.systemFont(ofSize: 15) //
        layout.bottomLineColor = UIColor.red   //滑块颜色
        layout.sliderHeight = 44.0  //整个滑块的高
        layout.bottomLineHeight = 2 //滑块底部线的高
        layout.bottomLineCornerRadius = 1 // 滑块底部线圆角
        return layout
    }()
    private lazy var simpleManager: LTSimpleManager = {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
        let simpleManager = LTSimpleManager(frame: CGRect(x: 0, y: Y, width: view.bounds.width, height: H + 50), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout)
        /* 设置代理 监听滚动 */
        simpleManager.delegate = self as? LTSimpleScrollViewDelegate
        /* 设置悬停位置 */
        simpleManager.hoverY = 0
        return simpleManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = LTLayout()
        layout.titleViewBgColor = UIColor.white  //背景色
        layout.titleColor = UIColor(r: 153, g: 153, b: 153) // 标题颜色值(格式不能改) 没选中的
        layout.titleSelectColor = UIColor(r: 200, g: 200, b: 200) //选中标题颜色值
        layout.titleFont = UIFont.systemFont(ofSize: 15) //
        layout.bottomLineColor = UIColor.red   //滑块颜色
        layout.sliderHeight = 44.0  //整个滑块的高
        layout.bottomLineHeight = 2 //滑块底部线的高
        layout.bottomLineCornerRadius = 1 // 滑块底部线圆角
        
        requestTopSelectList()
    }
    
    
    
    override func configSubViews()  {
        navigaView.isHidden = true
        
        navigationView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: navHeight))
        headBottomImage.frame = CGRect(x: 0, y: 0, width: navigationView.width, height: navigationView.height)
        headBottomImage.backgroundColor = kGaryColor(num: 246)
        navigationView.addSubview(headBottomImage)
        
        self.view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (ls) in
            ls.top.left.right.equalToSuperview()
            ls.height.equalTo(navHeight)
        }
        
        let searchButton = UIButton.init()
        searchButton.layoutButton(with: .left, imageTitleSpace: 5)
        searchButton.layer.cornerRadius = 5
        searchButton.setImage(UIImage.init(named: "com_search_icon_default"), for: .normal)
        searchButton.setTitle("输入关键词搜索", for: .normal)
        searchButton.setTitleColor(kGaryColor(num: 69), for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        searchButton.addTarget(self, action: #selector(pushToSearch), for: .touchUpInside)
        searchButton.backgroundColor = UIColor.white
        navigationView.addSubview(searchButton)
//        消息按钮，没用到   右边
        let noticeButton = UIButton.init()
        noticeButton.setImage(UIImage.init(named: "home_inform"), for: .normal)
        noticeButton.addTarget(self, action: #selector(pushToMessage), for: .touchUpInside)
        navigationView.addSubview(noticeButton)
//        签到按钮，没用到  左边
        let dateBtn = UIButton.init()
        dateBtn.setImage(UIImage.init(named: "back_icon"), for: .normal)
        dateBtn.addTarget(self, action: #selector(pushToDate), for: .touchUpInside)
        navigationView.addSubview(dateBtn)
        self.view.addSubview(navigationView)
        
        var backBtnCenterY = navHeight/2+10
        if kSCREEN_HEIGHT == 812 {
            backBtnCenterY = navHeight/2+20
        }
        
        noticeButton.snp.makeConstraints { (ls) in
            ls.right.equalToSuperview().offset(-6)
            ls.width.height.equalTo(0)
            ls.centerY.equalTo(backBtnCenterY)
        }
        dateBtn.snp.makeConstraints { (ls) in
            ls.left.equalToSuperview().offset(6)
            ls.width.height.equalTo(35)
            ls.centerY.equalTo(backBtnCenterY)
        }
        searchButton.snp.makeConstraints { (ls) in
            ls.left.equalTo(dateBtn.snp.right).offset(6)
            ls.right.equalTo(noticeButton.snp.left).offset(-6)
            ls.height.equalTo(33)
            ls.centerY.equalTo(noticeButton)
        }
        
 
        
        
    }
//      #MARK:  跳转到搜索
    @objc func pushToSearch() {
        let search = UIStoryboard(name:"CXShearchStoryboard",bundle:nil).instantiateViewController(withIdentifier: "CXSearchController") as! CXSearchController
        search.hidesBottomBarWhenPushed = true
        search.isPresent = false
        search.typeString = typeIntString
        self.navigationController?.pushViewController(search, animated: false)
        
//        let search = UIStoryboard(name:"CXShearchStoryboard",bundle:nil).instantiateViewController(withIdentifier: "CXSearchController") as! CXSearchController
//        search.hidesBottomBarWhenPushed = true
//        search.isPresent = false
//        search.typeString = "1"
//        self.navigationController?.pushViewController(search, animated: false)
        
    }
//   #MARK: 左 右按钮事件
    @objc func pushToMessage() { //右
        if !self.loginClick() { //判断登陆
            return
        }
        
//        let url = "\(DPUrls().noticeH5_url)?token=\(Defaults[kUserToken]!)"
//        let webVc = DPToolsWebVC()
//        webVc.webUrl = url
//        webVc.webTitle = "通知"
//        webVc.titleTextColor = UIColor.black
//        webVc.backBtnImg = "com_nav_return_black"
//        webVc.rightBtnImg = "com_refresh_black"
//        self.navigationController?.pushViewController(webVc, animated: true)
    }
    @objc func pushToDate() {  //左
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
//    顶部选择栏数据
    fileprivate func requestTopSelectList() {
        let request = SKRequest.init()
        request.setParam("parent_id:0;status:1" as NSObject, forKey: "search")
        request.setParam("sort" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        request.setParam(typeIntString as NSObject, forKey: "type")
        weak var weakSelf = self
        
        request.callGET(withUrl: LNUrls().kCategory) { (response) in
        
            if !(response?.success)! {
//                weakSelf?.view.addSubview((weakSelf?.beijingView)!)   //没数据添加一个刷新按钮
                return
            }
//            weakSelf?.beijingView.removeFromSuperview()   //移除刷新按钮
            weakSelf?.titles.removeAll()
            weakSelf?.viewControllers.removeAll()
            
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                var listModels = [LNTopListModel]()
                weakSelf?.titles.append("全部")
                for index in 0..<datas.count{
                    listModels.append(LNTopListModel.setupValues(json: datas[index]))
                    weakSelf?.titles.append(LNTopListModel.setupValues(json: datas[index]).name)
                }
                
//                把子控制器添加一下，除了首页推荐e和猜你喜欢，其他的都一样
                let other = YHJDorPDDSecondVC()
                other.typeIntString = (weakSelf?.typeIntString)!
                other.model = LNTopListModel()
                other.superViewController = weakSelf?.superViewController
                weakSelf?.viewControllers.append(other)
                
                for index in 0..<listModels.count {
                    let otherVc = YHJDorPDDSecondVC()
                    otherVc.typeIntString = (weakSelf?.typeIntString)!
                    otherVc.model = listModels[index]
                    otherVc.superViewController = weakSelf?.superViewController
                    weakSelf?.viewControllers.append(otherVc)
                }
                weakSelf?.tianjiashijian()
            }
        }
    }
    
    func tianjiashijian() {
        view.insertSubview(simpleManager, at: 0)
        simpleManager.configHeaderView {[weak self] in
            guard let strongSelf = self else { return nil }

            return strongSelf.testLabel()
        }
        simpleManager.didSelectIndexHandle { (index) in
            print("点击了 \(index) 😆")
        }
    }
    deinit { //页面注销事件
        print("LTAdvancedManagerDemo < --> deinit")
    }
    
    
}
extension YHJDorPDDPageVC: LTSimpleScrollViewDelegate {
    //MARK: 控制器刷新事件代理方法
    func glt_refreshScrollView(_ scrollView: UIScrollView, _ index: Int) {
        //注意这里循环引用问题。
        weak var weakSelf = self
        scrollView.mj_header = MJRefreshNormalHeader {[weak scrollView] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("对应控制器的刷新自己玩吧，这里就不做处理了🙂-----\(index)")
                scrollView?.mj_header.endRefreshing()
                let vc = weakSelf?.viewControllers[index] as! YHJDorPDDSecondVC
                vc.refreshHeaderAction()
            })
        }
    }
}

extension YHJDorPDDPageVC {
    private func testLabel() -> YHJDorPDDTableHeaderView {
        let jingdongView = YHJDorPDDTableHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: 165))
//        jingdongView.setUpValues(model: bannerDiyModel())
        jingdongView.setImage(type: typeIntString)
        jingdongView.backgroundColor = kSetRGBColor(r: 246, g: 246, b: 246)
        return jingdongView
    }
}
