//
//  LNArticleDetailCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/20.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNArticleDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!

    @IBOutlet weak var showImage: UIImageView!
    
    
    func setImage(image:String, titleStr:String,content:String) {
        showImage.sd_setImage(with: OCTools.getEfficientAddress(image), placeholderImage: UIImage.init(named: "goodIamge_1"))
        
//        if contentStr.contains("<p>") {
//            contentStr = contentStr.replacingOccurrences(of: "<p>", with: "")
//        }
//        if contentStr.contains("</p>") {
//            contentStr = contentStr.replacingOccurrences(of: "</p>", with: "")
//        }

        let attrStr = try! NSMutableAttributedString(
            data: (content.data(using: .unicode, allowLossyConversion: true)!),
            options:[.documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        //行高
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 8
        attrStr.addAttributes([NSAttributedStringKey.paragraphStyle:paraph],
                              range: NSMakeRange(0, attrStr.length))
        
        self.titleLabel2.attributedText = attrStr
            
//        titleLabel.text = contentStr
//        titleLabel2.text = content

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
