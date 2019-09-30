//
//  NSString+Expland.m
//  CorrectsPapers
//
//  Created by RongXing on 2017/11/23.
//  Copyright © 2017年 Fu Yaohui. All rights reserved.
//

#import "NSString+Expland.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"

@implementation NSString (Expland)

//- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
//    CGSize resultSize = CGSizeZero;
//    if (self.length <= 0) {
//        return resultSize;
//    }
//    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
//    style.lineBreakMode = NSLineBreakByWordWrapping;
//    resultSize = [self boundingRectWithSize:CGSizeMake(floor(size.width), floor(size.height))//用相对小的 width 去计算 height / 小 heigth 算 width
//                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
//                                 attributes:@{NSFontAttributeName: font,
//                                              NSParagraphStyleAttributeName: style}
//                                    context:nil].size;
//    resultSize = CGSizeMake(floor(resultSize.width + 1), floor(resultSize.height + 1));//上面用的小 width（height） 来计算了，这里要 +1
//    return resultSize;
//}


@end
