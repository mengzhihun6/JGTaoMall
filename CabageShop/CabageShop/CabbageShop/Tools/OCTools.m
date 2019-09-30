//
//  OCTools.m
//  CorrectsPapers
//
//  Created by RongXing on 2017/11/10.
//  Copyright © 2017年 Fu Yaohui. All rights reserved.
//

#import "OCTools.h"
#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
#import "CabbageShop-Swift.h"


@implementation OCTools



- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
}


//加,号
- (NSString *)positiveFormat:(NSString *)text{
    if(!text || [text floatValue] == 0){
        return @"0";
    }
    if (text.floatValue < 1000) {
        return  [NSString stringWithFormat:@"%.2f",text.floatValue];
    };
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###;"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
}


//判断手机号
+ (BOOL)checkoutPhoneNum:(NSString *)phoneNum {
    NSString *regexStr = @"^1[3,8]\\d{9}|14[5,7,9]\\d{8}|15[^4]\\d{8}|17[^2,4,9]\\d{8}$";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) return NO;
    NSInteger count = [regular numberOfMatchesInString:phoneNum options:NSMatchingReportCompletion range:NSMakeRange(0, phoneNum.length)];
    if (count > 0) {
        return YES;
    } else {
        return NO;
    }
}


+(NSURL *)getEfficientAddress:(NSString *)string{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)string,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return [NSURL URLWithString:encodedString];
}

/**
 *  验证身份证号
 *
 *  @param cardNo <#cardNo description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)checkIdentityCardNo:(NSString*)cardNo{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}


-(float)folderSizeAtPath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}
/**
 *  和上面的是连贯在一起的
 */
-(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

#pragma mark--清除缓存
-(void)clearCache{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearMemory];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    
    UIViewController *result = nil;
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    do {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)rootVC;
            UIViewController *vc = [navi.viewControllers lastObject];
            result = vc;
            rootVC = vc.presentedViewController;
            continue;
        } else if([rootVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)rootVC;
            result = tab;
            rootVC = [tab.viewControllers objectAtIndex:tab.selectedIndex];
            continue;
        } else if([rootVC isKindOfClass:[UIViewController class]]) {
            result = rootVC;
            rootVC = nil;
        }
    } while (rootVC != nil);
    
    return result;

}



-(BOOL)judgeTimeByStartAndEnd
{
    //获取当前时间
    NSDate *today = [NSDate date];
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"en"];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,建议大写    HH 使用 24 小时制；hh 12小时制
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    dateFormat.locale = locale;

    //start end 格式 "2016-05-18 9:00"
    NSDate *start = [dateFormat dateFromString:@"2018-06-01"];
    NSDate *expire = [dateFormat dateFromString:@"2019-01-25"];

    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}



- (void)videoImageWithvideoURL:(NSURL *)videoURL AndCallback:(void(^)(UIImage *))callback{

    if (!videoURL) {
        callback([UIImage imageNamed:@"icon_home_like_after"]);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = 1;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
        if(!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
        UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(thumbnailImage);
        });
    });
}



-(NSString *)replaceEnStr:(NSString *)enString withCHStr:(NSString *)CHString inDateStr:(NSString *)dateString {
    
  return [dateString stringByReplacingOccurrencesOfString:enString withString:CHString];
}



-(void)presnet:(UIViewController *)vc imageUrl:(NSString *)imageUrl callback:(void(^)(NSString* result))callback{
    LNShareViewController *shareVc =  [LNShareViewController new];
    
//    shareVc.shareText = @"iG牛逼！！！";
//    shareVc.shareTitle = @"哈哈哈哈";
//    shareVc.shareUrl = [NSURL URLWithString:@"https://github.com/"];
    shareVc.shareImage = imageUrl;
    
    shareVc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    //如果控制器属于navigationcontroller或者tababrControlelr子控制器,不使用UIModalPresentationFullScreen 的话, bar 会盖住你的modal出来的控制器
    [vc presentViewController:shareVc animated:NO completion:nil];
    
}

-(void)presnetMainADs:(UIViewController *)vc withAdModel:(id)model {
    LNMainADsViewController *shareVc =  [LNMainADsViewController new];
    shareVc.model = model;
    shareVc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    //如果控制器属于navigationcontroller或者tababrControlelr子控制器,不使用UIModalPresentationFullScreen 的话, bar 会盖住你的modal出来的控制器
    [vc presentViewController:shareVc animated:NO completion:nil];
    
}

-(void)presnetSearchVc:(UIViewController *)vc andModel:(id)model{
    LNMainADsViewController2 *shareVc =  [LNMainADsViewController2 new];
    shareVc.model = model;
    shareVc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    //如果控制器属于navigationcontroller或者tababrControlelr子控制器,不使用UIModalPresentationFullScreen 的话, bar 会盖住你的modal出来的控制器
    [vc presentViewController:shareVc animated:NO completion:nil];
}




-(NSString *)getStrWithFloatStr:(NSString *)floatStr {
    NSString *string = [floatStr stringByReplacingOccurrencesOfString:@","withString:@""];
    if ([string floatValue]) {
        return [NSString stringWithFormat:@"%.2f",[string floatValue]];
    }else{
        return @"0.00";
    }
    
}
-(NSString *)getStrWithFloatStr2:(NSString *)floatStr {
    NSString *string = [floatStr stringByReplacingOccurrencesOfString:@","withString:@""];
    if ([string floatValue]) {
        return [NSString stringWithFormat:@"%.2f",[string floatValue]];
    }else{
        return @"0.00";
    }
}
-(NSString *)getStrWithFloatStr1:(NSString *)floatStr {
    NSString *string = [floatStr stringByReplacingOccurrencesOfString:@","withString:@""];
    if ([string floatValue]) {
        return [NSString stringWithFormat:@"%.1f",[string floatValue]];
    }else{
        return @"0";
    }
    
}
-(NSString *)getStrWithIntStr:(NSString *)intStr{
    NSString *string = [intStr stringByReplacingOccurrencesOfString:@","withString:@""];
    if ([string integerValue]) {
        return [NSString stringWithFormat:@"%ld",[string integerValue]];
    }else{
        return @"0";
    }
}


-(void)presnetSearchVc:(UIViewController *)vc callback:(void(^)(NSString* result))callback{
    LNPasteSearchViewController *searchVc =  [LNPasteSearchViewController new];
    [searchVc callKeywordBlockWithBlock:^(NSString * type, NSString * ty) {
        callback(type);
    }];
    searchVc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    //如果控制器属于navigationcontroller或者tababrControlelr子控制器,不使用UIModalPresentationFullScreen 的话, bar 会盖住你的modal出来的控制器
    [vc presentViewController:searchVc animated:NO completion:nil];
}


-(void)presnetShareVc2:(UIViewController *)vc withImageUrls:(NSArray <NSString *> *)images andImages:(NSArray <UIImage *> *)shareImages{
    LNShare2ViewController *searchVc =  [LNShare2ViewController new];
    searchVc.shareImage = images;
    searchVc.shareImages = shareImages;
    searchVc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    //如果控制器属于navigationcontroller或者tababrControlelr子控制器,不使用UIModalPresentationFullScreen 的话, bar 会盖住你的modal出来的控制器
    [vc presentViewController:searchVc animated:NO completion:nil];
}
-(void)presnetShareVc2:(UIViewController *)vc withImageUrls:(NSArray <NSString *> *)images andImages:(NSArray <UIImage *> *)shareImages type:(NSString *)typeString {
    LNShare2ViewController *searchVc =  [LNShare2ViewController new];
    searchVc.shareImage = images;
    searchVc.shareImages = shareImages;
    searchVc.typeString = typeString;
    searchVc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    //如果控制器属于navigationcontroller或者tababrControlelr子控制器,不使用UIModalPresentationFullScreen 的话, bar 会盖住你的modal出来的控制器
    [vc presentViewController:searchVc animated:NO completion:nil];
}
-(void)presnetShareVc3:(UIViewController *)vc withImageUrls:(NSArray <NSString *> *)images andImages:(NSArray <UIImage *> *)shareImages{
//    LNShare2ViewController *searchVc =  [LNShare2ViewController new];
//    searchVc.shareImage = images;
//    searchVc.shareImages = shareImages;
//    searchVc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
//    //如果控制器属于navigationcontroller或者tababrControlelr子控制器,不使用UIModalPresentationFullScreen 的话, bar 会盖住你的modal出来的控制器
//    [vc presentViewController:searchVc animated:NO completion:nil];
    SZYTeamViewController *teamVc = [SZYTeamViewController new];
    
    teamVc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    [vc presentViewController:teamVc animated:NO completion:nil];
}
-(void)presnetShareVc3:(UIViewController *)vc Controller:(UIViewController *)NavigationController vip:(NSString *)vipStr {
    SZYTeamViewController *teamVc = [SZYTeamViewController new];
    teamVc.vc = NavigationController;
    teamVc.str = @"";
    teamVc.tishiStr = vipStr;
    teamVc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    [vc presentViewController:teamVc animated:NO completion:nil];
}
+ (NSArray <NSString *> *)filterImage:(NSString *)html isJD:(BOOL)flag
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        
        NSString *Str1 = @"src=\"";
        NSString *Str2 = @"src=";

        if (flag) {
            Str1 = @"data-lazyload=\"";
            Str2 = @"data-lazyload=";
        }
        if ([imgHtml rangeOfString:Str1].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:Str1];
        } else if ([imgHtml rangeOfString:Str2].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:Str2];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                
                if ([src hasPrefix:@"//img"]) {
                    [resultArray addObject:src];
                }
            }
        }
    }
    
    return resultArray;
}


-(NSString *)getSubString:(NSString *)string WithRangeStardIndex:(NSInteger)startIndex andLength:(NSInteger)length{
    
    return [string substringWithRange:(NSMakeRange(startIndex, length))];
    
}


+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

-(CGFloat)getStrWidth:(NSString *)str AndFont:(NSInteger)font {
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]}];//获取宽高CGSize statuseStrSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return size.width;
}

@end
