

import UIKit
import SwiftyUserDefaults

class SZYDiyGoodsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goods_imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var store_imageView: UIImageView!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var zhuanLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUpModel(model: SZYGoodsInformationModel) {
        
        goods_imageView.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        titleLabel.text = model.title
        
        if model.type == "1" { //1淘宝 2京东 3拼多多
            if model.shop_type == "1" {  //1淘宝 2天猫
                store_imageView.image = UIImage.init(named: "miaosha_mark")
            } else if model.shop_type == "2" {
                store_imageView.image = UIImage.init(named: "tianmao_icon")
            }
        } else if model.type == "2" {
            store_imageView.image = UIImage.init(named: "京东")
        } else if model.type == "3" {
            store_imageView.image = UIImage.init(named: "拼多多")
        }
        
        storeLabel.text = model.nick
        priceLabel.text = "¥" + OCTools().getStrWithFloatStr2(model.final_price)
        
        if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
            zhuanLabel.isHidden = true
        } else {
            zhuanLabel.isHidden = false
            let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
            
            zhuanLabel.text = "  约赚\(String(format: "%.2f", jieguo))  "
        }
        oldPriceLabel.text = "¥" + OCTools().getStrWithFloatStr2(model.price)
        salesLabel.text = "销量\(model.volume)"
    }
    
    
}
