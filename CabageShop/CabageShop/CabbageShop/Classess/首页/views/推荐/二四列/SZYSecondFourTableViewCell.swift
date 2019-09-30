

import UIKit

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
//        bg_ImageView.sd_setImage(with: OCTools.getEfficientAddress("fddd"), placeholderImage: UIImage.init(named: "goodImage_1"))
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
//        bg_ImageView.sd_setImage(with: OCTools.getEfficientAddress("fddd"), placeholderImage: UIImage.init(named: "goodImage_1"))
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
//        bg_ImageView.sd_setImage(with: OCTools.getEfficientAddress("fddd"), placeholderImage: UIImage.init(named: "goodImage_1"))
        bg_ImageView.backgroundColor = kSetRGBColor(r: 246, g: 246, b: 246)
        for index in 0..<4 {
            let bun = UIButton.init(type: .custom)
            bun.tag = 100 + index
//            bun.sd_setImage(with: OCTools.getEfficientAddress(model[index].imageUrl), for: .normal)
            bun.addTarget(self, action: #selector(button3(sender:)), for: .touchUpInside)
            bg_ImageView.addSubview(bun)
            
            switch index {
            case 0:
                bun.frame = CGRect.init(x: 6, y: 0, width: (kSCREEN_WIDTH - 17) * 118 / 358, height: (kSCREEN_WIDTH - 17) * 118 / 358 * 170 / 118)
                break
            case 1:
                bun.frame = CGRect.init(x: 6 + 5 + (kSCREEN_WIDTH - 17) * 118 / 358, y: 0, width: (kSCREEN_WIDTH - 17) * 240 / 358, height: (kSCREEN_WIDTH - 17) * 240 / 358 * 82 / 240)
                break
            case 2:
                bun.frame = CGRect.init(x: 6 + 5 + (kSCREEN_WIDTH - 17) * 118 / 358, y: (kSCREEN_WIDTH - 17) * 240 / 358 * 82 / 240 + 6, width: (kSCREEN_WIDTH - 17) * 118 / 358, height: (kSCREEN_WIDTH - 17) * 118 / 358 * 82 / 118)
                break
            case 3:
                bun.frame = CGRect.init(x: 6 + 5 + (kSCREEN_WIDTH - 17) * 118 / 358 + (kSCREEN_WIDTH - 17) * 118 / 358 + 5, y: (kSCREEN_WIDTH - 17) * 240 / 358 * 82 / 240 + 6, width: (kSCREEN_WIDTH - 17) * 118 / 358, height: (kSCREEN_WIDTH - 17) * 118 / 358 * 82 / 118)
                break
            default:
                break
            }
            
            let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: bun.width, height: bun.height))
            imageView.sd_setImage(with: OCTools.getEfficientAddress(model[index].imageUrl), placeholderImage: UIImage.init(named: "goodImage_1"))
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            bun.addSubview(imageView)
            
//            switch index {
//            case 0:
//                bun.frame = CGRect.init(x: 6, y: 7, width: (kSCREEN_WIDTH - 17) * 240 / 358, height: (kSCREEN_WIDTH - 17) * 240 / 358 * 82 / 240)
//                break
//            case 1:
//                bun.frame = CGRect.init(x: 6 + (kSCREEN_WIDTH - 17) * 240 / 358 + 5, y: 7, width: (kSCREEN_WIDTH - 17) * 118 / 358, height: (kSCREEN_WIDTH - 17) * 118 / 358 * 170 / 118)
//                break
//            case 2:
//                bun.frame = CGRect.init(x: 6, y: 7 + (kSCREEN_WIDTH - 17) * 240 / 358 * 82 / 240 + 6, width: (kSCREEN_WIDTH - 17) * 118 / 358, height: (kSCREEN_WIDTH - 17) * 118 / 358 * 82 / 118)
//                break
//            case 3:
//                bun.frame = CGRect.init(x: 6 + (kSCREEN_WIDTH - 17) * 118 / 358 + 5, y: 7 + (kSCREEN_WIDTH - 17) * 240 / 358 * 82 / 240 + 6, width: (kSCREEN_WIDTH - 17) * 118 / 358, height: (kSCREEN_WIDTH - 17) * 118 / 358 * 82 / 118)
//                break
//            default:
//                break
//            }
        }
        bg_imageView_height.constant = (kSCREEN_WIDTH - 17) * 118 / 358 * 170 / 118
    }
    @objc func button3(sender: UIButton) {
        let vc = self.viewContainingController() as? SZYMainViewController  //推荐
        vc!.moduleIdentifier(str: modelFour[sender.tag - 100].url, vc: superViewController!)
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
