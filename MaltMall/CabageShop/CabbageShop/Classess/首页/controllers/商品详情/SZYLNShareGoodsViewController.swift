//
//  SZYLNShareGoodsViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/22.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYLNShareGoodsViewController: LNBaseViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var bootomView: UIView!
    
    let identyfierTable1  = "identyfierTable1"
    let identyfierTable2  = "identyfierTable2"
    
    var GoodsInformationModel = SZYGoodsInformationModel() //商品信息
    var StoreInformationModel = SZYStoreInformationModel() //商店信息
    var goodsShareModel : SZYGoodsShareModel! //商品分享信息
    var goodsImages = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        button1.layoutButton(with: .top, imageTitleSpace: 8)
        button2.layoutButton(with: .top, imageTitleSpace: 8)
        button3.layoutButton(with: .top, imageTitleSpace: 8)
        button4.layoutButton(with: .top, imageTitleSpace: 8)
        navigationTitle = "商品分享"
//        navigationBgImage = UIImage.init(named: "Rectangle")
        titleLabel.textColor = UIColor.white
        bootomView.isHidden = true
    }
    override func configSubViews() {
        mainTableView = getTableView(frame: CGRect(x: 0, y: -kStatusBarH, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT+kStatusBarH-50), style: .grouped, vc: self)
//        图片
        mainTableView.register(UINib(nibName: "SZYgoodsShareCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
//        商品详情
        mainTableView.register(UINib.init(nibName: "SZYgoodsInformationCell", bundle: nil), forCellReuseIdentifier: identyfierTable1)
//        分享文案
        mainTableView.register(UINib.init(nibName: "SZYgoodsShareCopyCell", bundle: nil), forCellReuseIdentifier: identyfierTable2)
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        mainTableView.tableHeaderView?.isHidden = true
        mainTableView.separatorStyle = .none
        mainTableView.tag = 1021
        self.view.addSubview(mainTableView)
        mainTableView.backgroundColor = kBGColor()
        self.view.backgroundColor = kBGColor()
        
        mainTableView.snp.makeConstraints { (ls) in
            ls.left.width.equalToSuperview()
            ls.bottom.equalTo(bootomView.snp.top)
            ls.top.equalTo(navigaView.snp.bottom)
        }
    }
    override func addHeaderRefresh()  { // 下拉事件!
        
//        mainTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
//            self.refreshHeaderAction()
//        })
        
    }
    override func refreshHeaderAction() {
        requestData()
    }
    override func requestData() { // 获取优惠券数据
        let request = SKRequest.init()
        request.setParam(GoodsInformationModel.images[0] as NSObject, forKey: "pic_url")
        request.setParam(GoodsInformationModel.item_id as NSObject, forKey: "item_id")
        request.setParam("1" as NSObject, forKey: "type")
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText1()
        request.callGET(withUrl: LNUrls().kShare) { (response) in
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                return
            }
            kDeBugPrint(item: response?.data)
            weakSelf?.bootomView.isHidden = false
            let datas =  JSON((response?.data["data"])!)
            weakSelf?.goodsShareModel = SZYGoodsShareModel.setupValues(json: datas)
            weakSelf!.goodsImages.append(JSON(response?.data["data"] as Any)["url"].stringValue)
            weakSelf?.mainTableView.reloadData()
        }
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        let paste = UIPasteboard.general
        paste.string = self.goodsShareModel.comment
        setToast(str: "复制成功")
        if sender.tag == 150 {
            DispatchQueue.main.async(execute: { () -> Void in
                LQLoadingView().SVPWillShow("保存中")
            })
            DispatchQueue.init(label: "saveImages").async(execute: {
                for url in self.goodsImages {
                    if url.contains("http") {
                        let data = try! Data.init(contentsOf: URL.init(string: url)!)
                        let image = UIImage.init(data: data as Data)
                        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
                    }
                }
            })
        } else if sender.tag == 151 { // 复制文案
            
        }  else if sender.tag == 152 || sender.tag == 153 {
//            // 1.创建分享参数
//            let shareParames = NSMutableDictionary()
//            shareParames.ssdkSetupShareParams(byText: nil, images: self.goodsImages, url: nil, title: self.goodsShareModel.comment, type: .image)
//            var platform = SSDKPlatformType.subTypeWechatSession
//            if sender.tag == 152 {
//                platform = .subTypeWechatSession
//            } else if sender.tag == 153 {
//                platform = .subTypeWechatTimeline
//            }
//            ShareSDK.share(platform, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
//                switch state{
//                case SSDKResponseState.success:
//                    //setToast(str: "分享成功")
//                    break
//                case SSDKResponseState.fail:
//                    setToast(str: "分享失败")
//                    break
//                case SSDKResponseState.cancel:
//                    setToast(str: "取消分享")
//                    break
//                default:
//                    break
//                }
//            }
            DispatchQueue.main.async {
                var images = [UIImage]()
                for url in self.goodsImages {
                    if url.contains("http") {
                        let data = try! Data.init(contentsOf: URL.init(string: url)!)
                        let image = UIImage.init(data: data as Data)
                        images.append(image!)
                    }
                }
                let activityItems = images
                let activityVC = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
//                self.presentingViewController!.present(activityVC, animated: true, completion: nil)
//                activityVC.excludedActivityTypes = presentViewController
                self.present(activityVC, animated: true, completion: nil)
            }
            self.dismiss(animated: false, completion: nil)
        }
    }
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        DispatchQueue.init(label: "saveImages").async(execute: {
            LQLoadingView().SVPwillSuccessShowAndHide("图片已保存")
        })
    }
    
}
extension SZYLNShareGoodsViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if goodsShareModel != nil {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! SZYgoodsShareCell
            cell.selectionStyle = .none
            cell.setupValuse(model: GoodsInformationModel, goodsModel: goodsShareModel, goodsImage: goodsImages)
            cell.callBackPhoneNum { (s) in
                if self.goodsImages.contains(s) {
                    for index in 0..<self.goodsImages.count {
                        if self.goodsImages[index] == s {
                            self.goodsImages.remove(at: index)
                            break
                        }
                    }
                } else {
                    self.goodsImages.append(s)
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! SZYgoodsInformationCell
            cell.selectionStyle = .none
            
            cell.setupValuse(model: GoodsInformationModel)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable2, for: indexPath) as! SZYgoodsShareCopyCell
            cell.selectionStyle = .none
            
            cell.setupValuse(model: goodsShareModel)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 10
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = kBGColor()
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = UIView.init()
        foot.backgroundColor = kBGColor()
        return foot
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
