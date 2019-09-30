//
//  SKRequest.h
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 Joinwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKResponse.h"
#import <UIKit/UIKit.h>
@interface SKRequest : NSObject

/**
 *  添加请求参数
 *
 *  @param param 参数值
 *  @param key   参数名
 */
-(void)setParam:(NSObject *)param forKey:(NSString *)key;
/**
 *  获取参数值
 *
 *  @param key 参数名
 *
 *  @return 参数值
 */
-(NSObject *)getParamForKey:(NSString *)key;
/**
 *  根据参数
 *
 *  @param key 参数名
 */
-(void)removeParamForKey:(NSString *)key;
/**
 *  移除所有参数
 */
-(void)removeAllParams;

//get
-(void) callGETWithUrl:(NSString *)url withCallBack:(void (^)(SKResponse* response))callback;
-(void) callGETWithUrl1:(NSString *)url withCallBack:(void (^)(SKResponse* response))callback;

//post
-(void) callPOSTWithUrl:(NSString *)url withCallBack:(void (^)(SKResponse* response))callback;
//put
-(void) callPUTWithUrl:(NSString *)url withCallBack:(void (^)(SKResponse* response))callback;
//delete
-(void) callDELETEWithUrl:(NSString *)url withCallBack:(void (^)(SKResponse* response))callback;

/**
 网络监测
 */
//+ (void)netWorkingReachability;h

-(void)postJsonStringWithUrl:(NSString *)url andParams:(NSDictionary *)params withCallBack:(void (^)(SKResponse* response))callback;

-(void) postImageWithUrl:(NSString *)url andImageData:(NSData *)imageData withCallBack:(void (^)(SKResponse* response))callback;

-(void)postJson:(NSDictionary *)dic withUrl:(NSString *)url callback:(void(^)(SKResponse* response))callback;

//获取视频第一帧图片
- (void)videoImageWithvideoURL:(NSURL *)videoURL success:(void(^)(UIImage* image))callback;


- (NSDictionary *)convertjsonStringToDict:(NSString *)jsonString;

-(void)gotoWechat;


@end
