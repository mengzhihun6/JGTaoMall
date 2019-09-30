//
//  JGPasteSearchViewController.swift
//  CabbageShop
//
//  Created by 郭军 on 2019/9/6.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit

import SwiftyUserDefaults

@objc public protocol JGPasteSearchViewControllerDelegate: NSObjectProtocol {

    @objc func JGPasteSearchViewControllerGoToDetail(goods: SZYGoodsInformationModel)
}


class JGPasteSearchViewController: UIViewController {
    
    @IBOutlet weak var ResultInfoLbl: UILabel!
    
    @IBOutlet weak var GuessLbl: UILabel!
    
    @IBOutlet weak var GoodNameLbl: UILabel!
    
    @IBOutlet weak var TipsView: UIView!
    
    @IBOutlet weak var GoNowBtn: UIButton!
    
    @IBOutlet weak var CloseBtn: UIButton!
    
    var Delegate : JGPasteSearchViewControllerDelegate?
    
    var goods = SZYGoodsInformationModel()
    
    var typeString = ""    // 1,没有查询到商品信息  2,搜索商品
    var neirong = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if typeString == "1" {
            TipsView.isHidden = false
            GoNowBtn.isHidden = true
            ResultInfoLbl.text = "没能帮您找到商品"
            GuessLbl.text = "麦芽智能搜索检测不到商品"
            GoodNameLbl.text = "您复制的商品已下架或未加入淘宝客，暂时无法完成转链!"
            
        } else if typeString == "2" {
            TipsView.isHidden = true
            GoNowBtn.isHidden = false
            ResultInfoLbl.text = "帮您找到商品"
            GuessLbl.text = "麦芽智能搜索猜您搜索以下商品"
            let attributedString = NSMutableAttributedString(string: goods.title)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length))
            GoodNameLbl.attributedText = attributedString
        }

    }

    
    @IBAction func GoNewBtnClick(_ sender: Any) {
        
        Delegate?.JGPasteSearchViewControllerGoToDetail(goods: goods)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func CloseBtnClick(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
