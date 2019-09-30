//
//  ALiTradeSDKShareParam.h
//  NBSDK
//
//  Created by com.alibaba on 16/5/31.
//  Copyright © 2016年 com.alibaba. All rights reserved.
//

#ifndef ALiTradeSDKShareParam_h
#define ALiTradeSDKShareParam_h

@interface ALiTradeSDKShareParam : NSObject
@property(nonatomic,strong) NSMutableDictionary* taoKeParams;
@property(nonatomic,strong) NSMutableDictionary* globalTaoKeParams;
@property(nonatomic,strong) NSMutableDictionary* customParams;
@property(nonatomic,strong) NSMutableDictionary* externParams;
@property (nonatomic, assign) NSInteger openType;
@property (nonatomic, assign) NSInteger linkKey;
@property (nonatomic, assign) BOOL isNeedPush;
@property (nonatomic, assign) BOOL isBindWebview;
@property (nonatomic, assign) NSInteger NativeFailMode;
@property (nonatomic, assign) BOOL isUseTaokeParam;
@property (nonatomic, copy) NSString *backUrl;


+ (instancetype)sharedInstance;

@end

#endif /* ALiTradeSDKShareParam_h */
