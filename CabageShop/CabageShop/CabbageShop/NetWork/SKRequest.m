//
//  SKRequest.m
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 Joinwe. All rights reserved.
//

#import "SKRequest.h"
#import "SKResponse.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "CabbageShop-Swift.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "SDImageCache.h"
#import <AVKit/AVKit.h>
//#import <ALBBLoginSDK/ALBBLoginService.h>
#import "ALiTradeSDKShareParam.h"

#define kWindow [UIApplication sharedApplication].keyWindow

//第三方框架 Toast
#define setToast(str) CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];                            \
[kWindow  makeToast:str duration:0.6 position:CSToastPositionCenter style:style];                               \
kWindow.userInteractionEnabled = NO;                                                                            \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{   \
kWindow.userInteractionEnabled = YES;                                                                       \
});                                                                                                             \

#define kGetToken [[NSUserDefaults standardUserDefaults] valueForKey:@"kUserToken"]

@interface SKRequest()

@property (nonatomic, strong) NSMutableDictionary *dicParams;
@property (nonatomic, assign) NSInteger tipNum;
@end

@implementation SKRequest{
    
}

/**
 *  懒加载
 */
- (NSMutableDictionary *)dicParams{
    if (!_dicParams) {
        _dicParams = [NSMutableDictionary dictionary];
    }
    return _dicParams;
}


//-(void)uploadImage:(NSData *)fileData andCallback:(void (^)(SKResponse* response))callback{
//
//    QNUploadManager *qiniu = [[QNUploadManager alloc] init];
//    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//
//    }];
//    [qiniu putData:fileData key:@"" token:@"" complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//
//    } option:nil] ;
//
//
//}

/**
 *  添加请求参数
 *
 *  @param param 参数值
 *  @param key   参数名
 */
-(void)setParam:(NSObject *)param forKey:(NSString *)key{
    
    //    if ([key isEqualToString:@"token"] && !param) {
    //        NSString *title = NSLocalizedString(@"登录后可开启此功能", nil);
    //        NSString *message = NSLocalizedString(@"是否前往登录", nil);
    //        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    //        NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    //
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //
    //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil];
    //
    //        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //            NewInputViewController *inputPhoneViewController = [[NewInputViewController alloc] init];
    //            [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController pushViewController:inputPhoneViewController animated:YES];
    //        }];
    //
    //        [alertController addAction:cancelAction];
    //        [alertController addAction:otherAction];
    //
    //        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    //    }else{
    [self.dicParams setObject:param forKey:key];
    //    }
    
    
    //    if (key&&param) {
    //    }
}

/**
 *  获取参数值
 *
 *  @param key 参数名
 *
 *  @return 参数值
 */
-(NSObject *)getParamForKey:(NSString *)key{
    return [self.dicParams objectForKey:key];
}

/**
 *  根据参数
 *
 *  @param key 参数名
 */
-(void)removeParamForKey:(NSString *)key{
    [self.dicParams removeObjectForKey:key];
}

/**
 *  移除所有参数
 */
-(void)removeAllParams{
    [self.dicParams removeAllObjects];
}


-(AFHTTPSessionManager *)sharedManager{
    
    //1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    // 客户端是否信任非法证书
    //    securityPolicy.allowInvalidCertificates = YES;
    //    // 是否在证书域字段中验证域名
    //    [securityPolicy setValidatesDomainName:NO];
    //    mgr.securityPolicy = securityPolicy;
    //    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    mgr.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"charset=utf-8",@"text/plain",@"text/html",@"application/x-javascript",nil];
    
    return mgr;
}


-(void) callPOSTWithUrl:(NSString *)url withCallBack:(void (^)(SKResponse* response))callback{
    
    if (kGetToken) {
        [self.dicParams setObject:kGetToken forKey:@"token"];
    }
    NSLog(@"开始请求:%@,参数:", url);
    NSLog(@"%@", self.dicParams);
    
    [[self sharedManager] POST:url parameters:self.dicParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 字典转模型
        SKResponse *response = [[SKResponse alloc] init];
        response.code = [[responseObject objectForKey:@"code"] intValue];
        //        response.success = [[responseObject objectForKey:@"success"] boolValue];
        response.data = responseObject;
        response.message = [responseObject objectForKey:@"message"];
        
        // code值判断
        if (response.code != 1001) {
            response.success = NO;
            if (![response.message isEqualToString:@"success"]) {
//                setToast(response.message);
            }
//            NSLog(@"%@", response.message);
            [self tokenIsError:response.code andMessage:response.message];
        }else{
            response.success = YES;
        }
//        NSLog(@"%@",response.data);
        
        if (callback) {
            callback(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (![url containsString:@"cd.jd.com"]) {
//            [SVProgressHUD showErrorWithStatus:@"请求异常"];
        }
        SKResponse *response = [[SKResponse alloc] init];
        response.success = NO;
//        NSLog(@"%@",error.localizedDescription);
        if (callback) {
            callback(response);
        }
    }];
}


-(void) callPUTWithUrl:(NSString *)url withCallBack:(void (^)(SKResponse* response))callback{
    if (kGetToken) {
        [self.dicParams setObject:kGetToken forKey:@"token"];
    }
    
    NSLog(@"开始请求:%@,参数:", url);
    NSLog(@"%@", self.dicParams);
    
    [[self sharedManager] PUT:url parameters:self.dicParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SKResponse *response = [[SKResponse alloc] init];
        response.code = [[responseObject objectForKey:@"code"] intValue];
        //        response.success = [[responseObject objectForKey:@"success"] boolValue];
        response.data = responseObject;
        response.message = [responseObject objectForKey:@"message"];
        
        // code值判断
        if (response.code != 1001) {
            response.success = NO;
            [self tokenIsError:response.code andMessage:response.message];
            
//            NSLog(@"%@", response.message);
        }else{
            response.success = YES;
        }
//        NSLog(@"%@",response.data);
        
        if (callback) {
            callback(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:@"请求异常"];
        SKResponse *response = [[SKResponse alloc] init];
        response.success = NO;
//        NSLog(@"%@",error.localizedDescription);
        if (callback) {
            callback(response);
        }
    }];
}

-(void) callGETWithUrl:(NSString *)url withCallBack:(void (^)(SKResponse* response))callback{
    if (kGetToken) {
        [self.dicParams setObject:kGetToken forKey:@"token"];
    }
    NSLog(@"开始请求:%@,参数:", url);
    NSLog(@"%@", self.dicParams);
    [[self sharedManager] GET:url parameters:self.dicParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        // 字典转模型
        SKResponse *response = [[SKResponse alloc] init];
        response.code = [[responseObject objectForKey:@"code"] intValue];
        response.data = responseObject;
        response.message = [responseObject objectForKey:@"message"];
        
        // code值判断
        if (response.code != 1001) {
            response.success = NO;
            if (response.code == 4005) {
                [self tokenIsError:response.code andMessage:response.message andData:response.data];
            } else {
                [self tokenIsError:response.code andMessage:response.message];
            }
        }else{
            response.success = YES;
        }
        if (callback) {
            callback(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
        SKResponse *response = [[SKResponse alloc] init];
        if ([[NSString stringWithFormat:@"%@",error.localizedDescription] containsString:@"401"]) {
            [self tokenIsError:401 andMessage:@""];
        }else{
            if (![url containsString:@"cd.jd.com"]) {
//                [SVProgressHUD showErrorWithStatus:@"请求异常"];
            }
        }
        response.success = NO;
        if (callback) {
            callback(response);
        }
    }];
    
}
-(void) callGETWithUrl1:(NSString *)url withCallBack:(void (^)(SKResponse* response))callback {
    if (kGetToken) {
        [self.dicParams setObject:kGetToken forKey:@"token"];
    }
    NSLog(@"开始请求:%@,参数:", url);
    NSLog(@"%@", self.dicParams);
    [[self sharedManager] GET:url parameters:self.dicParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        
        // 字典转模型
        SKResponse *response = [[SKResponse alloc] init];
        response.code = [[responseObject objectForKey:@"code"] intValue];
        response.data = responseObject;
        response.message = [responseObject objectForKey:@"message"];
        
        // code值判断
        if (response.code != 1001) {
            response.success = NO;
//            if (response.code == 4005) {
//                [self tokenIsError:response.code andMessage:response.message andData:response.data];
//            } else {
//                [self tokenIsError:response.code andMessage:response.message];
//            }
        }else{
            response.success = YES;
        }
        if (callback) {
            callback(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SKResponse *response = [[SKResponse alloc] init];
        if ([[NSString stringWithFormat:@"%@",error.localizedDescription] containsString:@"401"]) {
            [self tokenIsError:401 andMessage:@""];
        }else{
            if (![url containsString:@"cd.jd.com"]) {
//                [SVProgressHUD showErrorWithStatus:@"请求异常"];
            }
        }
        response.success = NO;
        if (callback) {
            callback(response);
        }
    }];
}


-(void) callDELETEWithUrl:(NSString *)url withCallBack:(void (^)(SKResponse* response))callback{
    
    if (kGetToken) {
        [self.dicParams setObject:kGetToken forKey:@"token"];
    }
    
    NSLog(@"开始请求:%@,参数:", url);
    NSLog(@"%@", self.dicParams);
    
    [[self sharedManager] DELETE:url parameters:self.dicParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        
        // 字典转模型
        SKResponse *response = [[SKResponse alloc] init];
        response.code = [[responseObject objectForKey:@"code"] intValue];
        response.data = responseObject;
        response.message = [responseObject objectForKey:@"message"];
        
        // code值判断
        if (response.code != 1001) {
            response.success = NO;
            [self tokenIsError:response.code andMessage:response.message];
            
        }else{
            response.success = YES;
        }
        if (callback) {
            callback(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        [SVProgressHUD showErrorWithStatus:@"请求异常"];
        SKResponse *response = [[SKResponse alloc] init];
        response.success = NO;
        if (callback) {
            callback(response);
        }
    }];
    
}





-(void)postJsonStringWithUrl:(NSString *)url andParams:(NSDictionary *)params withCallBack:(void (^)(SKResponse* response))callback{
    
    //    NSString *jsonParam = [self jsonFromDictionary:params];
    //    jsonParam = [jsonParam stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    jsonParam = [jsonParam stringByReplacingOccurrencesOfString:@"\\/"withString:@"/"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"charset=utf-8",@"text/plain",@"text/html",nil];
    //    [sessionManager.requestSerializer setValue:TOKEN forHTTPHeaderField:@"token"];
    
    [[self sharedManager] POST:url parameters:jsonString progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        
        // 字典转模型
        SKResponse *response = [[SKResponse alloc] init];
        response.code = [[responseObject objectForKey:@"code"] intValue];
        response.data = responseObject;
        response.message = [responseObject objectForKey:@"message"];
        
        // code值判断
        if (response.code != 1001) {
            response.success = NO;
            [self tokenIsError:response.code andMessage:response.message];
            
        }else{
            response.success = YES;
        }
        if (callback) {
            callback(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        [SVProgressHUD showErrorWithStatus:@"请求异常"];
        SKResponse *response = [[SKResponse alloc] init];
        response.success = NO;
        if (callback) {
            callback(response);
        }
    }];
}


-(void) postImageWithUrl:(NSString *)url andImageData:(NSData *)imageData withCallBack:(void (^)(SKResponse* response))callback{
    
    NSLog(@"开始请求:%@,参数:", url);
    NSLog(@"%@", self.dicParams);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 200;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    [manager POST:url parameters:self.dicParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 字典转模型
        SKResponse *response = [[SKResponse alloc] init];
        response.code = [[responseObject objectForKey:@"code"] intValue];
        response.data = responseObject;
        response.message = [responseObject objectForKey:@"message"];
        
        // code值判断
        if (response.code != 1001) {
            response.success = NO;
            [self tokenIsError:response.code andMessage:response.message];
            
        }else{
            response.success = YES;
        }
        if (callback) {
            callback(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"上传出现异常"];
        SKResponse *response = [[SKResponse alloc] init];
        response.success = NO;
        if (callback) {
            callback(response);
        }
    }];
}



- (NSString *)jsonFromDictionary:(NSDictionary *)dic {
    
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error =nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:0
                                                         error:&error];
//        NSLog(@"error = %@", error);
        
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    return nil;
}



-(void)postJson:(NSDictionary *)dic withUrl:(NSString *)url callback:(void(^)(SKResponse* response))callback{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
    [SKRequest requestForPitchParam:jsonString withParams:url callback:^(SKResponse* response) {
        callback(response);
    }];
}


+(void)requestForPitchParam:(id)param withParams:(NSString *)path callback:(void(^)(SKResponse* response))callback
{
    
    NSMutableURLRequest *request = [self setupURLRequestAndPath:path param:param requestMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self httpSession:request success:^(SKResponse *response) {
        callback(response);
    }];
}

+(NSMutableURLRequest *)setupURLRequestAndPath:(NSString *)path param:(id)param requestMethod:(NSString *)requestMethod
{
    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    request.timeoutInterval = 30;
    request.HTTPMethod = requestMethod;
    return request;
}

+(void)httpSession:(NSMutableURLRequest *)urlRequest success:(void(^)(SKResponse* response))callback
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
//            NSLog(@"%@",error);
            // 字典转模型
            SKResponse *response = [[SKResponse alloc] init];
            response.success = NO;
            callback(response);
        }
        else
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // 字典转模型
            SKResponse *response = [[SKResponse alloc] init];
            response.code = [[dict objectForKey:@"code"] intValue];
            response.data = dict;
            response.message = [dict objectForKey:@"message"];
            
            if (response.code != 1001) {
                response.success = NO;
                [[SKRequest new] tokenIsError:response.code andMessage:response.message];
                
            }else{
                response.success = YES;
            }
            if (callback) {
                callback(response);
            }
        }
    }]
     resume
     ];
}


- (void)videoImageWithvideoURL:(NSURL *)videoURL success:(void(^)(UIImage* image))callback{
    
    //先从缓存中找是否有图片
    SDImageCache *cache =  [SDImageCache sharedImageCache];
    UIImage *memoryImage =  [cache imageFromMemoryCacheForKey:videoURL.absoluteString];
    if (memoryImage) {
        callback(memoryImage);
        return;
    }else{
        UIImage *diskImage =  [cache imageFromDiskCacheForKey:videoURL.absoluteString];
        if (diskImage) {
            callback(diskImage);
            return;
        }
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
            
            [cache storeImage:thumbnailImage forKey:videoURL.absoluteString toDisk:YES completion:nil];
            
            callback(thumbnailImage);
            
        });
    });
}


- (NSDictionary *)convertjsonStringToDict:(NSString *)jsonString{
    
    NSDictionary *retDict = nil;
    if ([jsonString isKindOfClass:[NSString class]]) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        return  retDict;
    }else{
        return retDict;
    }
}

-(void) tokenIsError:(NSInteger)code andMessage:(NSString *)message andData:(NSDictionary *)data {
    UITabBarController *tabbar =  (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
//    id<ALBBLoginService> loginService=[[ALBBSDK sharedInstance]getService:@protocol(ALBBLoginService)];
//    if(![[TaeSession sharedInstance] isLogin]){
//        [loginService showLogin:self successCallback:^(TaeSession *session){
//            NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@,登录时间:%@",[session getUser],[session getLoginTime]];
//            NSLog(@"%@", tip);
//        } failedCallback:^(NSError *error){
//            NSLog(@"登录失败");
//        }];
//    }else{
//        TaeSession *session=[TaeSession sharedInstance];
//        NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@,登录时间:%@",[session getUser],[session getLoginTime]];
//        NSLog(@"%@", tip);
//    }
    
//    if !ALBBSession.sharedInstance()!.isLogin() {
//        let loginService = ALBBSDK.sharedInstance()  //.setLoginResultHandler
//        loginService?.auth(self.viewContainingController(), successCallback: { (albbsession) in // 成功
//            if (albbsession?.isLogin())! {
//                weakSelf!.qingChu.setBackgroundImage(UIImage.init(named: "开关／开关(开)"), for: .normal)
//            }
//            kDeBugPrint(item: "=============")
//            kDeBugPrint(item: albbsession?.bindCode)
//            kDeBugPrint(item: "=============")
//        }, failureCallback: { (albbsession, error) in   //失败
//
//        })
//    } else { // 阿里百川 取消授权
//        let loginService = ALBBSDK.sharedInstance()
//        loginService?.logout()
//        weakSelf!.qingChu.setBackgroundImage(UIImage.init(named: "开关／开关(关)"), for: .normal)
//    }
    
//    ALBBSession *alb = [[ALBBSession sharedInstance] isLogin];
    
    if (![[ALBBSession sharedInstance] isLogin]) {
        ALBBSDK * loginService = [ALBBSDK sharedInstance];
        [loginService auth:tabbar.childViewControllers[tabbar.selectedIndex] successCallback:^(ALBBSession *session) {
            id<AlibcTradePage> page = [AlibcTradePageFactory page: data[@"data"]];
            //淘客信息
            AlibcTradeTaokeParams *taoKeParams=[[AlibcTradeTaokeParams alloc] init];
            taoKeParams.pid= nil;
            //打开方式
            AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
            showParam.openType = AlibcOpenTypeAuto;
            // YourWebViewController类中,webview的delegate设置不能放在viewdidload里面,必须在init的时候,否则函数调用的时候还是nil
            SZYwebViewController* myView = [[SZYwebViewController alloc] init];
            NSInteger ret = [[AlibcTradeSDK sharedInstance].tradeService show: myView webView:myView.webView page:page showParams:showParam taoKeParams:taoKeParams trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//                NSLog(@"%@", result);
            } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//                NSLog(@"%@", error);
            }];
            //返回1,说明h5打开,否则不应该展示页面
            if (ret == 1) {
                LNNavigationController *nav = [[LNNavigationController alloc] initWithRootViewController:myView];
                nav.navigationBarHidden = YES;
                [tabbar.childViewControllers[tabbar.selectedIndex] presentViewController:nav animated:YES completion:nil];
            }
        } failureCallback:^(ALBBSession *session, NSError *error) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[LNMainTabBarController alloc] init];
        }];
    } else {
        id<AlibcTradePage> page = [AlibcTradePageFactory page: data[@"data"]];
        //淘客信息
        AlibcTradeTaokeParams *taoKeParams=[[AlibcTradeTaokeParams alloc] init];
        taoKeParams.pid= nil;
        //打开方式
        AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
        showParam.openType = AlibcOpenTypeAuto;
        // YourWebViewController类中,webview的delegate设置不能放在viewdidload里面,必须在init的时候,否则函数调用的时候还是nil
        SZYwebViewController* myView = [[SZYwebViewController alloc] init];
        NSInteger ret = [[AlibcTradeSDK sharedInstance].tradeService show: myView webView:myView.webView page:page showParams:showParam taoKeParams:taoKeParams trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//            NSLog(@"%@", result);
        } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//            NSLog(@"%@", error);
        }];
        //返回1,说明h5打开,否则不应该展示页面
        if (ret == 1) {
            LNNavigationController *nav = [[LNNavigationController alloc] initWithRootViewController:myView];
            nav.navigationBarHidden = YES;
            [tabbar.childViewControllers[tabbar.selectedIndex] presentViewController:nav animated:YES completion:nil];
        }
    }
    
}
-(NSString *)convertToJsonData:(NSDictionary *)dict{  // 字典转json字符串
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
//        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
-(void) tokenIsError:(NSInteger)code andMessage:(NSString *)message {
    
    UIViewController *presentVc;
    
    switch (code) {
        case 4002:
        {
            if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[LNLoginViewController class]]) {
                return;
            }else{
                LNLoginViewController * presentVc1 = [[LNLoginViewController alloc] init];
                presentVc1.typeString = @"1";
                presentVc = presentVc1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                setToast(@"请先登录");
            });
        }
            break;
        case 401:
        {
            if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[LNLoginViewController class]]) {
                return;
            }else{
                LNLoginViewController * presentVc1 = [[LNLoginViewController alloc] init];
                presentVc1.typeString = @"1";
                presentVc = presentVc1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                setToast(@"请先登录");
            });
        }
            break;
        case 4003:
            if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[LNBandingPhoneViewController class]]) {
                return;
            }else{
                presentVc = [LNBandingPhoneViewController new];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                setToast(@"请先绑定手机");
            });
            break;
        case 4004:
            if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[LNBandingCodeViewController class]]) {
                return;
            }else{
                presentVc = [LNBandingCodeViewController new];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                setToast(@"请先绑定验证码");
            });
            break;
        default:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
//                setToast(message);
            });
        }
            return;
    }
    
    UITabBarController *tabbar =  (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    LNNavigationController *nav = [[LNNavigationController alloc] initWithRootViewController:presentVc];
    [tabbar.childViewControllers[tabbar.selectedIndex] presentViewController:nav animated:YES completion:nil];
}


@end
