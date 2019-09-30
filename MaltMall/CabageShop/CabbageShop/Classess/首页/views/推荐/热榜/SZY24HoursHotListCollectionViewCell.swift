

import UIKit

class SZY24HoursHotListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bg_imageView: UIImageView!
    @IBOutlet weak var couponsLable: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var taoyoufenxiangLable: UILabel!
    @IBOutlet weak var xiaoshouView: UIView!
    @IBOutlet weak var xiaoshouBun: UIButton!
    @IBOutlet weak var bg_imageView_height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        taoyoufenxiangLable.cornerRadius = 4
        taoyoufenxiangLable.clipsToBounds = true
        couponsLable.layer.borderColor = kSetRGBColor(r: 213, g: 0, b: 71).cgColor
        couponsLable.layer.borderWidth = 1
        couponsLable.clipsToBounds = true
        couponsLable.cornerRadius = 4
        
    }
    func setUpValues(model: SZYGoodsInformationModel, typeStr:String) {
        bg_imageView_height.constant = (kSCREEN_WIDTH) / 3 - 10
        
        bg_imageView.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        
        titleLable.text = model.title
        priceLable.text = "¥" + OCTools().getStrWithFloatStr2(model.final_price)
        xiaoshouBun.setTitle("销\(model.volume)", for: .normal)
        xiaoshouBun.setImage(UIImage.init(named: "火"), for: .normal)
        xiaoshouBun.layoutButton(with: .left, imageTitleSpace: 3)
        couponsLable.text = "  券 ¥" + OCTools().getStrWithFloatStr2(model.coupon_price) + "  "
        if typeStr == "1" {
            xiaoshouView.isHidden = true
            xiaoshouBun.isHidden = true
            taoyoufenxiangLable.isHidden = false
            couponsLable.isHidden = true
        } else if typeStr == "2" {
            xiaoshouView.isHidden = false
            xiaoshouBun.isHidden = false
            taoyoufenxiangLable.isHidden = true
            couponsLable.isHidden = true
        } else if typeStr == "3" {
            xiaoshouView.isHidden = true
            xiaoshouBun.isHidden = true
            taoyoufenxiangLable.isHidden = true
            couponsLable.isHidden = false
        }
        
    }
    
    
    
}
