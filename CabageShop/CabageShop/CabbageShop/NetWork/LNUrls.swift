//
//  LNUrls.swift
//  TaoKeThird

//
//  Created by 付耀辉 on 2018/10/28.
//  Copyright © 2018年 付耀辉. All rights reserved.
//  api.baicaitop.com

import UIKit
//let BaseUrl = "https://test.baicai.top/v4"
//let BaseUrl1 = "https://test.baicai.top/v3"
let BaseUrl = "https://api.baicai.top/v4"
let BaseUrl1 = "https://api.baicai.top/v3"

//let BaseUrl = "https://api.baicaitop.com/v4"
//let BaseUrl1 = "https://api.baicaitop.com/v3"

class LNUrls: NSObject {
    
    //    #MARK:首页 diy
    public let JTHHomdeDiy = BaseUrl + "/taoke/diy"
    //    #MARK:主页
    public let kMina_page_data = BaseUrl + "/taoke/diy/zhuanti"
    //    #MARK:猜你喜欢
    public let kGuess_like = BaseUrl + "/taoke/guess"
    //    #MARK:主页播报
    public let kRandom = BaseUrl + "/taoke/random"
    //    #MARK:收藏列表
    public let kFavourite = BaseUrl + "/taoke/favourite"
    //    #MARK:添加收藏
    public let kFavourite_add = BaseUrl + "/taoke/favourite"
    //    #MARK:取消收藏
    public let kFavourite_cancle = BaseUrl + "/taoke/favourite/"
    
    //    #MARK:浏览记录
    public let kHistory = BaseUrl + "/taoke/history/"
    //    #MARK:邀请好友
    public let KInvitation = BaseUrl + "/taoke/qrcode/template"


    //    #MARK:搜索
//    public let kSearch = BaseUrl + "/taoke/search"
    public let kSearch = BaseUrl1 + "/taoke/search"

    //    #MARK:轮播
    public let kBanner = BaseUrl + "/image/banner"

    //    #MARK:优惠卷列表
    public let kSwhow_coupon = BaseUrl + "/taoke/coupon"

    //    #MARK:优惠卷详情
    public let kShow_coupon_deltai = BaseUrl + "/taoke/coupon/detail"

    //    #MARK:收益报表
    public let kTuanDui = BaseUrl + "/user/group"
    //    #MARK:消息
    public let kNotification = BaseUrl + "/system/notification"

    //    #MARK:朋友
    public let kFriends = BaseUrl + "/user/friends"
    
    //    #MARK:淘客分类
    public let kCategory = BaseUrl + "/taoke/category"
    
    //    #MARK:订单列表
    public let kOrder = BaseUrl + "/taoke/order"

    
    //    #MARK:商品详情分享
    public let kShare = BaseUrl + "/taoke/qrcode/share"
    
    //    #MARK:获取淘口令和领劵地址
    public let kKouLing = BaseUrl + "/taoke/coupon/detail"
    // 单品 评论复制
    public let jingxuan = BaseUrl + "/taoke/taokouling"
    //    #MARK:会员信息
    public let kMember = BaseUrl + "/user"
    public let kPersonalCenter = BaseUrl + "/user/statistics"
    //  提交订单
    public let kTijiaodingdan = BaseUrl + "/taoke/order/submit"
    //    #MARK:积分余额日志
    public let kCredit_log = BaseUrl + "/user/credit-log"
    //    #MARK:提现记录
    public let WithdrawalRecord = BaseUrl + "/user/withdrawLog"
    //    #MARK:入账记录
    public let kCommissionLog = BaseUrl + "/taoke/commissionLog"
    //    #MARK:提现
    public let kWithdraw = BaseUrl + "/user/withdraw"

    //    #MARK:反馈
    public let kFeedback = BaseUrl + "/system/feedback"
    //    #MARK:转换淘口令
    public let kTaokouling = BaseUrl + "/taoke/qrcode/kouling"
    //    #MARK:文章列表
    public let kArticle = BaseUrl + "/cms/article"

    //    #MARK:快抢列表
    public let kKuaiqiang = BaseUrl + "/taoke/kuaiqiang"

    //    #MARK:数据收益列表
    public let kShouyi = BaseUrl + "/taoke/chart/order"
    
    public let kSuperInterface = BaseUrl+"/taoke/entrance/category"
    //    #MARK:修改手机号
    public let kModifyPhone = BaseUrl+"/user/edit/mobile"
    
     public let kSetting = BaseUrl + "/system/setting"
    public let kUserLevel = BaseUrl + "/user/level"
    public let kUpgrade = BaseUrl + "/system/setting/upgrade"
    //    #MARK:升等级
    public let kCheckUpgrade = BaseUrl + "/user/upgrade"
    //    #MARK:微信支付
    public let kPay = BaseUrl + "/wechat/payment/app"

    //    #MARK:个人中心数据
    public let kChart = BaseUrl + "/taoke/chart/member"
    public let kBind_alipay = BaseUrl + "/user/bind/alipay"
    // 提现 获取验证码
    public let tixian = BaseUrl + "/user/withdrawSms"
    public let kLogin = BaseUrl + "/auth/login"
    public let kRegister = BaseUrl + "/auth/register"
    public let KSendSms = BaseUrl + "/sms"
    public let kLogout = BaseUrl + "/auth/logout"
    public let kReset_password = BaseUrl + "/auth/password/reset"

    public let mobilekBaningMobile = BaseUrl + "/user/bind/mobile"
    
    public let mobilekBaningInviter = BaseUrl + "/user/bind/inviter"
    
    public let kGetInviter = BaseUrl + "/user/inviter"
    public let kRequest_ads = BaseUrl+"/image/banner?search=tag:login;status:1&searchJoin=and&orderBy=sort&sortedBy=desc"

    //    #MARK:判断签到
    public let kIsSign = BaseUrl + "/isSign"
    //   MARK: 版本更新
    public let kVersion = BaseUrl + "/system/version"
    //    MAEK: 修改邀请码
    public let kInviterCode = BaseUrl + "/user/inviterCode"
}
