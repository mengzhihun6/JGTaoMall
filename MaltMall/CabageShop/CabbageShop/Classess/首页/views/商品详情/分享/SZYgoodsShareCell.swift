//
//  SZYgoodsShareCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/21.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYgoodsShareCell: UITableViewCell {

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var promptView: UIView!
    
    var imageArray = [String]()
    
    var selectedImageArray = [String]()
    //    回调
    typealias swiftBlock = (_ phoneNum:String) -> Void
    var willClick : swiftBlock? = nil
    func callBackPhoneNum(block: @escaping ( _ phoneNum:String) -> Void ) {
        willClick = block
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        
        promptView.clipsToBounds = true
    }
    func setupValuse(model: SZYGoodsInformationModel, goodsModel: SZYGoodsShareModel, goodsImage: [String]) {
        selectedImageArray = goodsImage
        kDeBugPrint(item: goodsImage)
        for views in promptView.subviews {
            views.removeFromSuperview()
        }
        let str = "由于新版微信不支持多图直接分享朋友圈，多图请先保存图片"  //CGFloat
        
        let kuan = getLabWidth(labelStr: str, font: UIFont.systemFont(ofSize: 13), height: 32)
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: kuan, height: 32))
        promptView.addSubview(label)
        label.textColor = kSetRGBColor(r: 255, g: 139, b: 86)
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = str
        
        let label2 = UILabel.init(frame: CGRect.init(x: kuan + 30, y: 0, width: kuan, height: 32))
        promptView.addSubview(label2)
        label2.textColor = kSetRGBColor(r: 255, g: 139, b: 86)
        label2.font = UIFont.systemFont(ofSize: 13)
        label2.text = str
        
        // 动画开始
        UIView.beginAnimations("testAnimation", context: nil)
        UIView.setAnimationDuration(8.8)
        UIView.setAnimationCurve(.linear)
        UIView.setAnimationRepeatCount(MAXFLOAT)
        
        var frame = label.frame
        frame.origin.x = -frame.size.width - 30
        label.frame = frame
        var frame2 = label2.frame
        if kSCREEN_WIDTH - 32 > kuan {
            frame2.origin.x = kSCREEN_WIDTH - 32 - kuan
        } else {
            frame2.origin.x = 0
        }
        label2.frame = frame2
        // 动画结束
        UIView.commitAnimations()
        
        let kHeight:CGFloat = 90
        let kSpace:CGFloat = 10
        imageArray.append(goodsModel.url)
        for index in 0..<model.images.count {
            imageArray.append(model.images[index])
        }
        
        for index in 0..<imageArray.count {
            let imageV = UIImageView.init(frame: CGRect(x: kSpace + (kHeight + kSpace) * CGFloat(index), y:0, width: kHeight, height: kHeight))
            imageV.sd_setImage(with: OCTools.getEfficientAddress(imageArray[index]), placeholderImage: UIImage.init(named: "tabbar_main_select"))
            imageV.contentMode = .scaleAspectFill
            imageV.cornerRadius = 3
            imageV.clipsToBounds = true
            imageV.isUserInteractionEnabled = true
            imageV.tag = 100 + index
            
            let bun = UIButton.init(frame: CGRect.init(x: imageV.width - 35, y: 0, width: 35, height: 35))
            bun.tag = 200 + index
            bun.addTarget(self, action: #selector(buttonClick(bun:)), for: .touchUpInside)
            imageV.addSubview(bun)
            
            let mark = UIButton.init(frame: CGRect(x: bun.width-20, y: 0, width: 20, height: 20))
            mark.setImage(UIImage.init(named: "save_unselect"), for: .normal)
            mark.setImage(UIImage.init(named: "save_select"), for: .selected)
            mark.tag = 10
            mark.isUserInteractionEnabled = false
            bun.addSubview(mark)
            mark.isSelected = selectedImageArray.contains(imageArray[index])
            
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
            singleTap.numberOfTapsRequired = 1
            imageV.addGestureRecognizer(singleTap)
            scrollView.addSubview(imageV)
        }
        scrollView.contentSize = CGSize(width: CGFloat(imageArray.count)*(kHeight+kSpace)+kSpace, height: scrollView.height)
    }
    @objc func buttonClick(bun: UIButton) {
        let imageView = bun.superview as! UIImageView
        let button = imageView.viewWithTag(10) as! UIButton
        
        if selectedImageArray.contains(imageArray[bun.tag - 200]) { //是否含有  是
            if selectedImageArray.count > 1 {
                button.isSelected = !button.isSelected
                if willClick != nil {
                    willClick!(imageArray[bun.tag - 200])
                }
                for index in 0..<selectedImageArray.count {
                    if self.selectedImageArray[index] == imageArray[bun.tag - 200] {
                        self.selectedImageArray.remove(at: index)
                        break
                    }
                }
            } else {
                setToast(str: "至少选择一张图片")
            }
        } else { //是否含有  否
            selectedImageArray.append(imageArray[bun.tag - 200])
            button.isSelected = !button.isSelected
            if willClick != nil {
                willClick!(imageArray[bun.tag - 200])
            }
        }
    }
    @objc  func viewTheBigImage(ges:UITapGestureRecognizer) {
        var images = [KSPhotoItem]()
        for index in 0..<imageArray.count {
            let theView = scrollView.viewWithTag(index+100) as! UIImageView
            let watchIMGItem = KSPhotoItem.init(sourceView: theView, image: theView.image)
            images.append(watchIMGItem!)
        }
        
        let watchIMGView = KSPhotoBrowser.init(photoItems: images, selectedIndex:UInt((ges.view?.tag)!-100))
        watchIMGView?.dismissalStyle = .scale
        watchIMGView?.backgroundStyle = .blurPhoto
        watchIMGView?.loadingStyle = .indeterminate
        watchIMGView?.pageindicatorStyle = .text
        watchIMGView?.bounces = false
        watchIMGView?.show(from: viewContainingController()!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
