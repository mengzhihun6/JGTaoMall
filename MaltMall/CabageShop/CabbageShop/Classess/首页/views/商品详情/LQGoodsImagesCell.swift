
//
//  LQGoodsImagesCell.swift
//  LingQuan
//
//  Created by 付耀辉 on 2018/6/4.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LQGoodsImagesCell: UITableViewCell {
    @IBOutlet weak var showImage: UIImageView!
    
    @IBOutlet weak var loadView1: UIActivityIndicatorView!
    //    回调
    typealias swiftBlock = (_ content:CGFloat) -> Void
    var willClick : swiftBlock? = nil
    func callReloadCell(block: @escaping ( _ content:CGFloat) -> Void ) {
        willClick = block
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupImage(imageUrl:String)  {
        
        showImage.layer.contentsGravity = kCAGravityResizeAspectFill;
        weak var weakSelf = self
//        kDeBugPrint(item: imageUrl)
        if imageUrl.count == 0 {
            return
        }
        var url = imageUrl
        if !imageUrl.hasPrefix("http:") && !imageUrl.hasPrefix("https:"){
            url = "https:"+imageUrl
        }
        weakSelf?.loadView1.isHidden = false
        loadView1.startAnimating()
//        showImage.fixedWidth = NSNumber.init(value: Float(kSCREEN_WIDTH))
//        showImage.fixedHeight = 0
        showImage.sd_setImage(with: OCTools.getEfficientAddress(url), placeholderImage: UIImage.init(named: "goodImage_1"), options: SDWebImageOptions.cacheMemoryOnly) { (image, error, type, url) in
            
            weakSelf?.loadView1.stopAnimating()
            weakSelf?.loadView1.isHidden = true
            if error != nil {
                return
            }
            
//            kDeBugPrint(item: image?.size)
//            kDeBugPrint(item: (image?.size.width)!/kSCREEN_WIDTH*(image?.size.height)!)
//            kDeBugPrint(item: (image?.size.width))
//
            weakSelf?.showImage.snp.updateConstraints({ (ls) in
                ls.height.equalTo(kSCREEN_WIDTH/(image?.size.width)!*(image?.size.height)!)
            })
            
            if weakSelf?.willClick != nil {
                weakSelf?.willClick!(kSCREEN_WIDTH/(image?.size.width)!*(image?.size.height)!)
            }
            
        }
        self.layoutIfNeeded()
        self.layoutSubviews()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
