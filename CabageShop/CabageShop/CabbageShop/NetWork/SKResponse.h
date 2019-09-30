//
//  SKResponse.h
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 Joinwe. All rights reserved.
//  返回类型

#import <Foundation/Foundation.h>

@interface SKResponse : NSObject


/**
 *  结果数据
 */
@property NSDictionary* data;

/**
 *  请求结果代码
 */
@property int code;


@property BOOL success;

/**
 *  消息
 */
@property NSString* message;



@end
