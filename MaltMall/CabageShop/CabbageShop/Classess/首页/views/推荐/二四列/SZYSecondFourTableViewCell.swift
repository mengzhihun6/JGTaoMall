

import UIKit
import SwiftyUserDefaults

class SZYSecondFourTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bg_ImageView: UIImageView!
    @IBOutlet weak var bg_imageView_height: NSLayoutConstraint!
    
    weak var superViewController : UIViewController?
    
    
    var twoModel = [dataDiyModel]()
    var fourModel = [dataDiyModel]()
    var modelFour = [dataDiyModel]()
    var oneModel = [dataDiyModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bg_ImageView.isUserInteractionEnabled = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //两列多行
    func setModel(model: [dataDiyModel]) {
        twoModel = model
        for views in bg_ImageView.subviews {
            views.removeFromSuperview()
        }
        bg_ImageView.backgroundColor = kSetRGBColor(r: 246, g: 246, b: 246)
        let kuan = (kSCREEN_WIDTH - 30) / 2, gao = kuan * 90 / 172.5
        var xx = 10, yy = 0
        
        for index in 0..<model.count {
            kDeBugPrint(item: index)
            let bun = UIButton.init(type: .custom)
            bun.frame = CGRect.init(x: CGFloat(xx), y: CGFloat(yy), width: kuan, height: gao)
//            bun.sd_setImage(with: OCTools.getEfficientAddress(model[index].imageUrl), for: .normal)
            bun.tag = index + 100
            bun.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
            bg_ImageView.addSubview(bun)
            
            let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: bun.width, height: bun.height))
            imageView.sd_setImage(with: OCTools.getEfficientAddress(model[index].imageUrl), placeholderImage: UIImage.init(named: "goodImage_1"))
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            bun.addSubview(imageView)
            
            xx = xx + 10 + Int(kuan)
            if xx + Int(kuan) > Int(kSCREEN_WIDTH) {
                xx = 10
                yy = yy + 10 + Int(gao)
            }
        }
        var section = model.count / 2
        if model.count % 2 > 0 {
            section += 1
        }
        bg_imageView_height.constant = CGFloat(section) * (gao + 10) - 10
    }
    @objc func buttonClick(sender: UIButton) {
        let vc = self.viewContainingController() as? SZYMainViewController  //推荐
        vc!.moduleIdentifier(str: twoModel[sender.tag - 100].url, vc: superViewController!)
        
    }
    
    //四列多行
    func setModelFour(model: [dataDiyModel]) {
        fourModel = model
        for views in bg_ImageView.subviews {
            views.removeFromSuperview()
        }
        
        bg_ImageView.backgroundColor = kSetRGBColor(r: 246, g: 246, b: 246)
        let kuan = (kSCREEN_WIDTH - 35) / 4, gao = kuan * 150 / 85
        var xx = 10, yy = 0
        
        for index in 0..<model.count {
            kDeBugPrint(item: index)
            let bun = UIButton.init(type: .custom)
//            bun.sd_setImage(with: OCTools.getEfficientAddress(model[index].imageUrl), for: .normal)
            bun.frame = CGRect.init(x: CGFloat(xx), y: CGFloat(yy), width: kuan, height: gao)
            bun.tag = index + 100
            bun.addTarget(self, action: #selector(buttonC(sender:)), for: .touchUpInside)
            bg_ImageView.addSubview(bun)
            
            let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: bun.width, height: bun.height))
            imageView.sd_setImage(with: OCTools.getEfficientAddress(model[index].imageUrl), placeholderImage: UIImage.init(named: "goodImage_1"))
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            bun.addSubview(imageView)
            
            xx = xx + 5 + Int(kuan)
            if xx + Int(kuan) > Int(kSCREEN_WIDTH) {
                xx = 10
                yy = yy + 5 + Int(gao)
            }
        }
        
        var section = model.count / 4
        if model.count % 4 > 0 {
            section += 1
        }
        bg_imageView_height.constant = CGFloat(section) * (gao + 5) - 5
    }
    
    @objc func buttonC(sender: UIButton) {
        let vc = self.viewContainingController() as? SZYMainViewController  //推荐
        vc!.moduleIdentifier(str: fourModel[sender.tag - 100].url, vc: superViewController!)
    }
    
    func setFourModel(model: [dataDiyModel]) {
        modelFour = model
        for views in bg_ImageView.subviews {
            views.removeFromSuperview()
        }
        
        bg_ImageView.backgroundColor = UIColor.hex("#F2F2F2")

        let topY = CGFloat(10)

        for index in 0..<4 {
            let bun = UIButton.init(type: .custom)
            bun.tag = 100 + index
            bun.addTarget(self, action: #selector(button3(sender:)), for: .touchUpInside)
            bg_ImageView.addSubview(bun)
            
            
//            var adIcon :String =  ""
            switch index {
            case 0:
//                adIcon = "home_one"
                bun.frame = CGRect(x: 10, y: topY, width: kWidthScale(112), height: kWidthScale(190) + 10)
                break
            case 1:
//                adIcon = "home_two"
                bun.frame = CGRect(x: 30 + kWidthScale(224), y: topY + kWidthScale(95) + 10, width:kWidthScale(112), height: kWidthScale(95))
                break
            case 2:
//                adIcon = "home_three"
                bun.frame = CGRect(x: 10 + kWidthScale(112) + 10, y: topY + kWidthScale(95) + 10, width: kWidthScale(112), height: kWidthScale(95))
                break
            case 3:
//                adIcon = "home_four"
                bun.frame = CGRect(x: 10 + kWidthScale(112) + 10 , y: topY, width: kDeviceWidth - kWidthScale(112) - 30, height: kWidthScale(95))
                break
            default:
                break
            }
            
            let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: bun.width, height: bun.height))
            imageView.sd_setImage(with: OCTools.getEfficientAddress(model[index].imageUrl), placeholderImage: UIImage.init(named: "goodImage_1"))
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            bun.addSubview(imageView)
            
//            let img = UIImageView(frame: CGRect(x: bun.width - 42, y: 0, width: 42, height: 42))
//            img.image = UIImage(named: adIcon)
//            imageView.addSubview(img)
        }
        bg_imageView_height.constant = kWidthScale(190) + topY * 2 + 10
    }
    
    @objc func button3(sender: UIButton) {
        let vc = self.viewContainingController() as? SZYMainViewController  //推荐
        var pageUrl = modelFour[sender.tag - 100].url
        if sender.tag == 100 {
            
            if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
                pageUrl = pageUrl + Defaults[kUserToken]!
            }else {
//                setToast(str: "请先登录")
                vc!.present(loginOut(), animated: true, completion: nil)
                return
            }
        }

        
        vc!.moduleIdentifier(str:pageUrl , vc: superViewController!)
    }
    
    func setOneModel(model: [dataDiyModel]) {
        oneModel = model
        
        for views in bg_ImageView.subviews {
            views.removeFromSuperview()
        }
        bg_imageView_height.constant = 84
        
        let imageView = UIImageView.init()
        imageView.sd_setImage(with: OCTools.getEfficientAddress(model[0].imageUrl), placeholderImage: UIImage.init(named: "goodImage_1"))
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
        bg_ImageView.addSubview(imageView)
        
        let bun = UIButton.init(type: .custom)
        bun.addTarget(self, action: #selector(button4(sender:)), for: .touchUpInside)
        bg_ImageView.addSubview(bun)
        
        imageView.snp.makeConstraints { (ls) in
            ls.left.top.equalToSuperview().offset(10)
            ls.right.bottom.equalToSuperview().offset(-10)
        }
        bun.snp.makeConstraints { (ls) in
            ls.left.top.equalToSuperview().offset(10)
            ls.right.bottom.equalToSuperview().offset(-10)
        }
    }
    
    @objc func button4(sender: UIButton) {
        let vc = self.viewContainingController() as? SZYMainViewController  //推荐
        vc!.moduleIdentifier(str: oneModel[0].url, vc: superViewController!)
    }
}
