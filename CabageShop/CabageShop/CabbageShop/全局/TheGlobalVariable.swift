//
//  TheGlobalVariable.swift
//  CorrectsPapers
//
//  Created by RongXing on 2017/10/10.
//  Copyright © 2017年 Fu Yaohui. All rights reserved.
//

import UIKit
import Toast
import SwiftyUserDefaults

let kSCREEN_WIDTH = UIScreen.main.bounds.size.width
let kSCREEN_HEIGHT = UIScreen.main.bounds.size.height
let kSCREEN_SIZE = UIScreen.main.bounds.size
let kSCREEN_SCALE = kSCREEN_WIDTH/720
func FIT_SCREEN_WIDTH(_ size: CGFloat) -> CGFloat {
    return size * kSCREEN_WIDTH / 375.0
}

//用户信息
let kUsername = DefaultsKey<String?>("kUsername")
let kUserToken = DefaultsKey<String?>("kUserToken")
let kUserIcon = DefaultsKey<String?>("kUserIcon")
let kUserUiid = DefaultsKey<String?>("kUserUiid")
let kIsSuper_VIP = DefaultsKey<String?>("kIsSuper_VIP")
let kGetTheRandomItemId = DefaultsKey<String?>("kGetTheRandomItemId")

let kBandingPhone = DefaultsKey<String?>("kBandingPhone")
let kBandingInviter = DefaultsKey<String?>("kBandingInviter")

let kLastImage = DefaultsKey<String?>("kLastImage")
let kLastUrl = DefaultsKey<String?>("kLastUrl")

let kSystemDeduct = DefaultsKey<String?>("kSystemDeduct")
let kCommissionRate = DefaultsKey<String?>("kCommissionRate")
let kHashid = DefaultsKey<String?>("kHashid")
let kInviterArray = DefaultsKey<String?>("kInviterArray")

var isBanding = false


let kFont20 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 20)
let kFont22 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 22)
let kFont24 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 24)
let kFont26 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 26)
let kFont28 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 28)
let kFont30 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 30)
let kFont32 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 32)
let kFont34 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 34)
let kFont36 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 36)
let kFont38 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 38)
let kFont40 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 40)
let kFont42 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 42)
let kFont44 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 44)
let kFont46 = UIFont.systemFont(ofSize: kSCREEN_SCALE * 46)

let kStatusBarH = UIApplication.shared.statusBarFrame.height

func getToken() -> (String) {
    return UserDefaults.standard.object(forKey: "token") as! (String)
}

func getUserid() -> (String) {
    return UserDefaults.standard.object(forKey: "userID") as! (String)
}

//MARK:十六进制颜色
func getColorWithNotAlphe(_ seting : CLongLong) -> UIColor {
    
    let red = CGFloat(((seting & 0xFF0000) >> 16)) / 255.0;
    let green = CGFloat(((seting & 0x00FF00) >> 8)) / 255.0;
    let blue = CGFloat(seting & 0x0000FF) / 255.0;
    
    return UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
}

//MARK:快速设置颜色
func kSetRGBColor (r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    
}

//MARK:带透明色的颜色
func kSetRGBAColor (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    
}

func kGaryColorWightAlpha(num:CGFloat,alpha:CGFloat) -> UIColor{
    return UIColor (red: num, green: num, blue: num, alpha: alpha)
}

//MARK: APP主色调
func kMainColor() -> UIColor {
    return kSetRGBColor(r: 236, g: 101, b: 90)
}

//MARK: APP主色调
func kMainColor1() -> UIColor {
    return kSetRGBColor(r: 243, g: 66, b: 56)
}


//MARK: APP主色调
func kUnderLineColor() -> UIColor {
    return kSetRGBColor(r: 185, g: 45, b: 45)
}



//MARK:颜色主色调
func kTextColor() -> UIColor {
    return kSetRGBColor(r: 69, g: 69, b: 69)
}

//MARK:背景主色调
func kBGColor() -> UIColor {
    return kSetRGBColor(r: 246, g: 246, b: 246)
}

//MARK:快速获得灰色
func kGaryColor(num : NSInteger) -> UIColor {
    return kSetRGBColor(r: CGFloat(num), g: CGFloat(num), b: CGFloat(num))
}

//MARK:渐变色
func kGradientColor(num : CGFloat) -> UIColor {
    return UIColor (red: num, green: num, blue: num, alpha: 1)
}

//MARK: 获得渐变背景颜色横向
func getNavigationIMG(_ height: NSInteger,fromColor:UIColor,toColor:UIColor) -> UIImage {
    
    let view = UIView(frame: CGRect(x:0, y:0, width:Int(kSCREEN_WIDTH), height:height))
    view.layer.insertSublayer(getNavigationView(height, fromColor: fromColor, toColor: toColor), at: 0)
    UIGraphicsBeginImageContext(view.bounds.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}

//MARK: 获得渐变背景颜色
func getNavigationView(_ height: NSInteger,fromColor:UIColor,toColor:UIColor) -> CAGradientLayer {
    let gradient = CAGradientLayer()
    gradient.frame = CGRect(x:0, y:0, width:Int(kSCREEN_WIDTH), height:height)
    gradient.colors = [fromColor.cgColor,toColor.cgColor]
    gradient.startPoint = CGPoint.init(x: 0, y: 0.5)
    gradient.endPoint = CGPoint.init(x: 1, y: 0.5)
    return gradient
    
}



//MARK: 获得渐变背景颜色垂直
func getNavigationIMGVertical(_ height: NSInteger,fromColor:UIColor,toColor:UIColor) -> UIImage {
    
    let view = UIView(frame: CGRect(x:0, y:0, width:Int(kSCREEN_WIDTH), height:height))
    view.layer.insertSublayer(getNavigationViewVertical(height, fromColor: fromColor, toColor: toColor), at: 0)
    UIGraphicsBeginImageContext(view.bounds.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}

//MARK: 获得渐变背景颜色
func getNavigationViewVertical(_ height: NSInteger,fromColor:UIColor,toColor:UIColor) -> CAGradientLayer {
    let gradient = CAGradientLayer()
    gradient.frame = CGRect(x:0, y:0, width:Int(kSCREEN_WIDTH), height:height)
    gradient.colors = [fromColor.cgColor,toColor.cgColor]
    gradient.startPoint = CGPoint.init(x: 0, y: 0)
    gradient.endPoint = CGPoint.init(x: 0, y: 1)
    return gradient
    
}



//MARK: 设置一个提醒
func setToast(str:String) {
    
     DispatchQueue.main.async {
        let kWindow = UIApplication.shared.keyWindow
        
        let style = CSToastStyle.init(defaultStyle: ())
        kWindow?.makeToast(str, duration: 2.0, position: CSToastPositionCenter, style: style)
    }
}

//MARK: 设置一个提醒
func setToastTop(str:String) {
    
    DispatchQueue.main.async {
        let kWindow = UIApplication.shared.keyWindow
        
        let style = CSToastStyle.init(defaultStyle: ())
        kWindow?.makeToast(str, duration: 2.0, position: CSToastPositionTop, style: style)
    }
}


//MARK:获取字符串的宽度的封装
func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
    
    let statusLabelText: NSString = labelStr as NSString
    
    let size = CGSize(width: 900, height: height)
    
    let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
    
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
    
    return strSize.width
}


//MARK:获取字符串的宽度的封装
func KGetLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
    
    let statusLabelText: NSString = labelStr as NSString
    
    let size = CGSize(width: 900, height: height)
    
    let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
    
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
    
    return strSize.width + 10
}

//MARK:获取字符串的高度的封装
func KGetLabHeight(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
    
    let statusLabelText: NSString = labelStr as NSString
    
    let size = CGSize(width: width, height: 900)
    
    let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
    
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
    
    return strSize.height
}


//MARK:获取字符串的size
func kGetSizeOnString(_ str: String, _ size:Int) -> CGSize {
    
    let content = str as NSString
    let attributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: CGFloat(size))] as [NSAttributedStringKey: Any]
    
    var size = CGRect()
    size = content.boundingRect(with: CGSize(width: kSCREEN_WIDTH ,
                                             height: CGFloat(MAXFLOAT)),
                                options: .usesLineFragmentOrigin,
                                attributes: attributes,
                                context: nil)
    return size.size
}


//MARK:字符串转float
func StringToFloat(str:String)->(CGFloat){
    
    let string = str
    
    var cgFloat:CGFloat = 0
    
    if let doubleValue = Double(string)
        
    {
        cgFloat = CGFloat(doubleValue)
    }
    
    return cgFloat
}


//MARK:转Utf-8
func StringToUTF_8InUrl(str:String) -> (URL){
    
    let OCString = str as NSString
    
    let urlString = OCString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
    
    return URL(string: urlString!)!
}


//调试模式输出
func kDeBugPrint<T>(item message:T, file:String = #file, function:String = #function,line:Int = #line) {
    #if DEBUG
    //获取文件名
    let fileName = (file as NSString).lastPathComponent
    //打印日志内容
    print("\(fileName):\(line) | \(message)")
    #endif
    
}

//快速获得tableView
func getTableView(frame:CGRect,style:UITableViewStyle,vc:UIViewController) -> UITableView {
    let tableView = UITableView.init(frame: frame, style: style)
    tableView.delegate = vc as? UITableViewDelegate
    tableView.dataSource = vc as? UITableViewDataSource
    tableView.estimatedRowHeight = 150 * kSCREEN_SCALE
    tableView.tableFooterView = UIView()
    vc.automaticallyAdjustsScrollViewInsets = false

    return tableView
}
//快速获得CollectionView
func getCollectionView(frame:CGRect,style:UICollectionViewFlowLayout,vc:UIViewController) -> UICollectionView {
    let mainCollectionView = UICollectionView.init(frame: frame, collectionViewLayout: style)
    mainCollectionView.delegate = vc as? UICollectionViewDelegate
    mainCollectionView.dataSource = vc as? UICollectionViewDataSource
    mainCollectionView.showsHorizontalScrollIndicator = false
    mainCollectionView.showsVerticalScrollIndicator = false
    
    return mainCollectionView
}

func loginOut() -> UINavigationController {
    Defaults.remove(kUserToken)
    Defaults.remove(kUsername)
    Defaults.remove(kUserIcon)
    Defaults.remove(kUserUiid)
    
    ShareSDK.cancelAuthorize(SSDKPlatformType.typeWechat)
    Defaults.removeAll()
    
//    JPUSHService.cleanTags(nil, seq: 1)
    JPUSHService.cleanTags({ (int1, any, int2) in
        kDeBugPrint(item: int1)
        kDeBugPrint(item: any)
        kDeBugPrint(item: int2)
    }, seq: 1)
//    JPUSHService.deleteAlias(nil, seq: 2)
    JPUSHService.deleteAlias({ (int1, str, int2) in
        kDeBugPrint(item: int1)
        kDeBugPrint(item: str)
        kDeBugPrint(item: int2)
    }, seq: 2)
    
    UserDefaults.standard.removeObject(forKey: "kUserToken")
    //注销百川
    let loginService = ALBBSDK.sharedInstance()
    loginService?.logout()
    //    JPUSHService.setnof
//    return LNNavigationController.init(rootViewController: LQLoginViewController())
    return LNNavigationController.init(rootViewController: LNLoginViewController())
}



//MARK:***********************微信支付************************
//MARK:***********************微信支付************************
let kWXAppKey = "wxebe1db15ede2e7e4"
let kWXAppSecret = "bf303dc75d5ec0d83e32adf9283464ec"

//let kQQAppKey = "1106558738"
//let kQQAppSecret = "ixhK8uo7xLQ3NBcE"

//微信支付成功通知
let WXPaySuccessNotification = "WXPaySuccessNotification"



class TheGlobalVariable: NSObject {

}
