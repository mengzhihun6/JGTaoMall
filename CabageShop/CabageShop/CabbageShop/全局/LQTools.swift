//
//  LQTools.swift
//  
//
//  Created by 付耀辉 on 2018/5/27.
//

import UIKit
import SwiftyUserDefaults

class LQTools: NSObject {
    //MARK:网络请求失败
    let LQNetworkRequestFailed = "LQNetworkRequestFailed"

//    token出错，返回登陆界面
    let LQTokenIsError = "LQTokenIsError"

//    监听粘贴板，刷新商品信息
    let LQReloadGoodInfo = "LQReloadGoodInfo"

//    监听粘贴板消息
    let LQReloadGoodDetail = "LQReloadGoodDetail"

    // 个人信息已更改
    let LNChangePersonalInfo = "LNChangePersonalInfo"

    let JPUSHAppKey = "255098b8357bccdc18dc48d4"
    
    let TAOBAOAppKey = "25316706"
    let JDAppKey = "8ad4ab6589f44cebba1c33816765fa9f"
    let JDAppSecret = "0c1494204ab6468fb24011a3a56c0b12"

    //    轮播图改变
    let LNBannerDidChanged = "LNBannerDidChanged"

    //刷新商品详情
    let LQLoadGoodDeailNification = "LQLoadGoodDeailNification"
    //   刷新H5
    let LQLoadH5DeailNification = "LQLoadGoodDeailNification"
//刷新 商品详情 绑定手机号 邀请码以后
    let SZYGoodsViewController = "SZYGoodsViewController"
    //   MARK: 清除缓存
    func getCacheMamery() -> String {
        // 取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 打印路径,需要测试的可以往这个路径下放东西
        print(cachePath!)
        // 取出文件夹下所有文件数组
        let files = FileManager.default.subpaths(atPath: cachePath!)
        // 用于统计文件夹内所有文件大小
        var big = CGFloat();
        
        // 快速枚举取出所有文件名
        for p in files!{
            // 把文件名拼接到路径中
            let path = cachePath!.appendingFormat("/\(p)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc,bcd) in floder {
                // 只去出文件大小进行拼接
                if abc == FileAttributeKey.size{
                    big += CGFloat(truncating: (bcd as AnyObject) as! NSNumber)
                }
            }
        }
        
        big = big/2
        var mamery:String = ""
        
        if big > 1024*1024 {
            
            mamery = String.init(format: "%.2f", big/1024/1024)+"M"
        }else if big > 1024 && big < 1024*1024 {
            
            mamery = String.init(format: "%.2f", big/1024)+"KB"
        }else{
            
            mamery = "0KB"
        }
        
        return mamery

    }
    
    
    
    func clearCacheMamery() {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        
        // 遍历删除
        for file in fileArr! {
            
            let path = cachePath?.appendingFormat("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                
                do {
                    try FileManager.default.removeItem(atPath: path!)
                } catch {
                    
                }
            }
        }
    }
}
