


import UIKit
import SwiftyUserDefaults

class LNMainLayoutCell3: UITableViewCell {
    
    @IBOutlet weak var earn_money: UIButton!
    
    @IBOutlet weak var good_icon: UIImageView!
    
    
    @IBOutlet weak var good_title: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var sale_count: UILabel!
    
    @IBOutlet weak var quanLabel: UILabel!
    @IBOutlet weak var now_price: UILabel!
    @IBOutlet weak var old_price: UILabel!
    
    @IBOutlet weak var goodImage: UIButton!
    
    @IBOutlet weak var good_store: UILabel!
    
    @IBOutlet weak var goodImage_Width: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //    MARK: - 我在尝试4
        let searchButton1 = UIButton.init()
        searchButton1.layoutButton(with: .left, imageTitleSpace: 5)
        searchButton1.layer.cornerRadius = 5
        searchButton1.setImage(UIImage.init(named: "com_search_icon_default"), for: .normal)
        searchButton1.setTitle("立即查找独家优惠券", for: .normal)
        searchButton1.setTitleColor(kGaryColor(num: 69), for: .normal)
        searchButton1.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        searchButton1.backgroundColor = UIColor.white
        
        earn_money.backgroundColor = kSetRGBColor(r: 250, g: 85, b: 40)
        earn_money.cornerRadius = 2
        earn_money.clipsToBounds = true
        
        good_icon.cornerRadius = 3
        good_icon.clipsToBounds = true
        
        //        good_store.isHidden = true
        //        goodImage.isHidden = true
    }
    
    
    func setValues(model:LNYHQListModel,type:String) {
        good_title.text = model.title
        //    MARK: - 我在尝试3
        let buna = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        buna.backgroundColor = UIColor.gray
        buna.setImage(UIImage.init(named: ""), for: .normal)
        buna.setTitle("你好,在感受到!", for: .normal)
        buna.setTitleColor(UIColor.white, for: .normal)
        buna.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        switch model.shop_type {
        case "1":
            goodImage.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
        case "2":
            goodImage.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
        //            goodImage.setImage(UIImage.init(named: "jd_mark"), for: .normal)
        case "3":
            break
        //            goodImage.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
        default:
            //            goodImage.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
            break
        }
        //    MARK: - 我在尝试5
        let searchTextfieldsad = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        searchTextfieldsad.borderStyle = .none
        searchTextfieldsad.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-60, height: 34))
        searchTextfieldsad.placeholder = "输入手机号搜索"
        searchTextfieldsad.leftViewMode = .always
        searchTextfieldsad.returnKeyType = .search
        searchTextfieldsad.clearButtonMode = .whileEditing
        searchTextfieldsad.backgroundColor = UIColor.white
        searchTextfieldsad.layer.cornerRadius = 17
        searchTextfieldsad.clipsToBounds = true
        searchTextfieldsad.font = UIFont.systemFont(ofSize: 14)
        searchTextfieldsad.textColor = kSetRGBColor(r: 96, g: 96, b: 96)
        let attrString1 = NSMutableAttributedString.init(string: "输入手机号搜索")
        attrString1.addAttributes([NSAttributedStringKey.foregroundColor: kGaryColor(num: 96)], range: NSMakeRange(0, "输入手机号搜索".count))
        searchTextfieldsad.attributedPlaceholder = attrString1
        let view1 = UIView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 17))
        let leftImage = UIImageView.init(frame: CGRect(x: 12, y: 0, width: 14, height: 14))
        leftImage.image = UIImage.init(named: "search_shape")
        view1.addSubview(leftImage)
        searchTextfieldsad.leftView = view1
        
        if OCTools().getStrWithFloatStr2(model.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model.finalCommission) != "0.00"{
            earn_money.setTitle("  预计赚￥"+OCTools().getStrWithFloatStr2(model.finalCommission)+"  ", for: .normal)
        }else{
            earn_money.isHidden = true
        }
        
        discount.text = OCTools().getStrWithIntStr(model.coupon_price)+"元券"
        sale_count.text = "已售 "+(model.volume)
        now_price.text = OCTools().getStrWithFloatStr2(model.final_price)
        old_price.text = OCTools().getStrWithFloatStr2(model.price)
        good_icon.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
    }
    func setValues1(model: SZYGoodsInformationModel,type:String) {    //  type=5, 收藏列表
        good_title.text = model.title
        
        if model.type == "1" {
            if model.shop_type == "1" {
                goodImage.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
            } else if model.shop_type == "2" {
                goodImage.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
            }
        } else if model.type == "2" {
            goodImage.setImage(UIImage.init(named: "jd_mark"), for: .normal)
        } else if model.type == "3" {
            goodImage.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
        }
        //    MARK: - 我在尝试4
        let searchButton1 = UIButton.init()
        searchButton1.layoutButton(with: .left, imageTitleSpace: 5)
        searchButton1.layer.cornerRadius = 5
        searchButton1.setImage(UIImage.init(named: "com_search_icon_default"), for: .normal)
        searchButton1.setTitle("立即查找独家优惠券", for: .normal)
        searchButton1.setTitleColor(kGaryColor(num: 69), for: .normal)
        searchButton1.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        searchButton1.backgroundColor = UIColor.white
        
        good_store.text = model.nick
        if type == "5" {
            goodImage_Width.constant = 0
            earn_money.isHidden = true
            sale_count.text = "\(model.volume)人购买"
        } else {
            sale_count.text = "\(model.sales)人购买"//(model.volume)
            if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
                earn_money.isHidden = true
            } else {
                earn_money.isHidden = false
                let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
                earn_money.setTitle("  预计赚￥" + String.init(format:"%.2f",jieguo) + "  ", for: .normal)
            }
        }
        //    MARK: - 我在尝试3
        let buna = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        buna.backgroundColor = UIColor.gray
        buna.setImage(UIImage.init(named: ""), for: .normal)
        buna.setTitle("你好,在感受到!", for: .normal)
        buna.setTitleColor(UIColor.white, for: .normal)
        buna.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        discount.text = OCTools().getStrWithIntStr(model.coupon_price)+"元券"
        now_price.text = OCTools().getStrWithFloatStr2(model.final_price)
        old_price.text = OCTools().getStrWithFloatStr2(model.price)
        good_icon.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
    }
    func setValues2(model: SZYGoodsInformationModel,type:String) {    //  type=5, 收藏列表
        good_title.text = model.title
        //    MARK: - 我在尝试3
        let buna = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        buna.backgroundColor = UIColor.gray
        buna.setImage(UIImage.init(named: ""), for: .normal)
        buna.setTitle("你好,在感受到!", for: .normal)
        buna.setTitleColor(UIColor.white, for: .normal)
        buna.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        if model.type == "1" {
            if model.shop_type == "1" {
                goodImage.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
            } else if model.shop_type == "2" {
                goodImage.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
            }
        } else if model.type == "2" {
            goodImage.setImage(UIImage.init(named: "jd_mark"), for: .normal)
        } else if model.type == "3" {
            goodImage.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
        }
        
        good_store.text = model.nick
        if type == "5" {
            earn_money.isHidden = true
            sale_count.text = "\(model.volume)人购买"
        } else {
            sale_count.text = "\(model.volume)人购买"//(model.volume)
            if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
                earn_money.isHidden = true
            } else {
                earn_money.isHidden = false
                let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
                earn_money.setTitle("  预计赚￥" + String.init(format:"%.2f",jieguo) + "  ", for: .normal)
            }
        }
        //    MARK: - 我在尝试5
        let searchTextfieldsad = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        searchTextfieldsad.borderStyle = .none
        searchTextfieldsad.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-60, height: 34))
        searchTextfieldsad.placeholder = "输入手机号搜索"
        searchTextfieldsad.leftViewMode = .always
        searchTextfieldsad.returnKeyType = .search
        searchTextfieldsad.clearButtonMode = .whileEditing
        searchTextfieldsad.backgroundColor = UIColor.white
        searchTextfieldsad.layer.cornerRadius = 17
        searchTextfieldsad.clipsToBounds = true
        searchTextfieldsad.font = UIFont.systemFont(ofSize: 14)
        searchTextfieldsad.textColor = kSetRGBColor(r: 96, g: 96, b: 96)
        let attrString1 = NSMutableAttributedString.init(string: "输入手机号搜索")
        attrString1.addAttributes([NSAttributedStringKey.foregroundColor: kGaryColor(num: 96)], range: NSMakeRange(0, "输入手机号搜索".count))
        searchTextfieldsad.attributedPlaceholder = attrString1
        let view1 = UIView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 17))
        let leftImage = UIImageView.init(frame: CGRect(x: 12, y: 0, width: 14, height: 14))
        leftImage.image = UIImage.init(named: "search_shape")
        view1.addSubview(leftImage)
        searchTextfieldsad.leftView = view1
        
        discount.text = OCTools().getStrWithIntStr(model.coupon_price)+"元券"
        now_price.text = OCTools().getStrWithFloatStr2(model.final_price)
        old_price.text = OCTools().getStrWithFloatStr2(model.price)
        good_icon.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
    }
    func setCollectionValues(model:LNMyCollectionModel,type:String) {
        good_title.text = model.title
        
        switch model.type {
        case "1":
            goodImage.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
        case "2":
            goodImage.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
        //            goodImage.setImage(UIImage.init(named: "jd_mark"), for: .normal)
        case "3":
            break
        //            goodImage.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
        default:
            //            goodImage.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
            break
        }
        //    MARK: - 我在尝试5
        let searchTextfieldsad = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        searchTextfieldsad.borderStyle = .none
        searchTextfieldsad.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-60, height: 34))
        searchTextfieldsad.placeholder = "输入手机号搜索"
        searchTextfieldsad.leftViewMode = .always
        searchTextfieldsad.returnKeyType = .search
        searchTextfieldsad.clearButtonMode = .whileEditing
        searchTextfieldsad.backgroundColor = UIColor.white
        searchTextfieldsad.layer.cornerRadius = 17
        searchTextfieldsad.clipsToBounds = true
        searchTextfieldsad.font = UIFont.systemFont(ofSize: 14)
        searchTextfieldsad.textColor = kSetRGBColor(r: 96, g: 96, b: 96)
        let attrString1 = NSMutableAttributedString.init(string: "输入手机号搜索")
        attrString1.addAttributes([NSAttributedStringKey.foregroundColor: kGaryColor(num: 96)], range: NSMakeRange(0, "输入手机号搜索".count))
        searchTextfieldsad.attributedPlaceholder = attrString1
        let view1 = UIView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 17))
        let leftImage = UIImageView.init(frame: CGRect(x: 12, y: 0, width: 14, height: 14))
        leftImage.image = UIImage.init(named: "search_shape")
        view1.addSubview(leftImage)
        searchTextfieldsad.leftView = view1
        
        earn_money.isHidden = true
        
        discount.text = " "+OCTools().getStrWithIntStr(model.coupon_price)+"元 "
        sale_count.text = "月售 "+(model.volume)
        now_price.text = OCTools().getStrWithFloatStr2(model.final_price)
        old_price.text = OCTools().getStrWithFloatStr2(model.price)
        good_icon.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //    MARK: - 我在尝试5
        let searchTextfieldsad = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        searchTextfieldsad.borderStyle = .none
        searchTextfieldsad.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-60, height: 34))
        searchTextfieldsad.placeholder = "输入手机号搜索"
        searchTextfieldsad.leftViewMode = .always
        searchTextfieldsad.returnKeyType = .search
        searchTextfieldsad.clearButtonMode = .whileEditing
        searchTextfieldsad.backgroundColor = UIColor.white
        searchTextfieldsad.layer.cornerRadius = 17
        searchTextfieldsad.clipsToBounds = true
        searchTextfieldsad.font = UIFont.systemFont(ofSize: 14)
        searchTextfieldsad.textColor = kSetRGBColor(r: 96, g: 96, b: 96)
        let attrString1 = NSMutableAttributedString.init(string: "输入手机号搜索")
        attrString1.addAttributes([NSAttributedStringKey.foregroundColor: kGaryColor(num: 96)], range: NSMakeRange(0, "输入手机号搜索".count))
        searchTextfieldsad.attributedPlaceholder = attrString1
        let view1 = UIView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 17))
        let leftImage = UIImageView.init(frame: CGRect(x: 12, y: 0, width: 14, height: 14))
        leftImage.image = UIImage.init(named: "search_shape")
        view1.addSubview(leftImage)
        searchTextfieldsad.leftView = view1
        // Configure the view for the selected state
    }
    
}
//func StringToFloat(str:String)->(CGFloat){
//    let string = str
//    var cgFloat:CGFloat = 0
//    if let doubleValue = Double(string) {
//        cgFloat = CGFloat(doubleValue)
//    }
//    return cgFloat
//
//}

