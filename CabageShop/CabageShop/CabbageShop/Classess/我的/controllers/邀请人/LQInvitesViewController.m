//
//  LQInvitesViewController.m
//  LingQuan
//
//  Created by 付耀辉 on 2018/5/15.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

#import "LQInvitesViewController.h"
#import "CardCollectionVIewLayout.h"
#import "CardCollectionViewCell.h"
#import "Healp.h"
#import "UIButton+ImageTitleSpacing.h"
#define ITEMCELLID  @"ITEMCELLID"
#define LZScreenW [UIScreen mainScreen].bounds.size.width
#define LZScreenH [UIScreen mainScreen].bounds.size.height
//#import "RentHouse-Bridging-Header.h"
#import "Masonry.h"
#import <ShareSDK/ShareSDK.h>
#import <Toast/UIView+Toast.h>
#import "SDImageCache.h"
#import "CabbageShop-Swift.h"


//设置RGB颜色
#define kSetRGBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

typedef NS_ENUM(NSUInteger, GradientType) {
    
    GradientTypeTopToBottom = 0,//从上到小
    
    GradientTypeLeftToRight = 1,//从左到右
    
    GradientTypeUpleftToLowright = 2,//左上到右下
    
    GradientTypeUprightToLowleft = 3,//右上到左下
    
};


@interface LQInvitesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIImageView      *bgImageV;
    UICollectionView *cardCollectionVIew;
    NSArray          *imageArray;
    
    CGFloat          startX;
    CGFloat          endX;
    NSInteger        currentIndex;
    
    BOOL              isLoaded;
}
@property (nonatomic, strong) UILabel *titleLB;

@end

@implementation LQInvitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    imageArray = @[@"bg_invation_2",@"bg_invation_3",@"bg_invation"];
    isLoaded = NO;
    //创建视图
    [self createUI];
    
    [self requestImages];
    
    CGFloat height = 64;
    if (self.view.height>800) {
        height = 88;
    }
    UIView *headView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, self.view.width, height))];
    headView.backgroundColor = kSetRGBColor(243, 66, 56);
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;
    label.text = @"邀请合伙人";
    [headView addSubview:label];

    
    UIButton *back = [[UIButton alloc] init];
    [back setImage:[UIImage imageNamed:@"nav_return_white"] forState:(UIControlStateNormal)];
    [back addTarget:self action:@selector(popAction) forControlEvents:(UIControlEventTouchUpInside)];
    [headView addSubview:back];
    
    [self.view addSubview:headView];
    
    CGFloat centery = 10;
    if (self.view.height>800) {
        centery = 20;
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(0);
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.centerY.mas_equalTo(headView.mas_centerY).offset(centery);
    }];

    
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(35);
        make.left.mas_equalTo(headView.mas_left);
        make.centerY.mas_equalTo(headView.mas_centerY).offset(centery);
    }];
    
    [self cellToCenter];
}

-(void)requestImages{
    
    SKRequest *request = [SKRequest new];
//    NSString *url = @"https://api.baicai.top/v3/taoke/qrcode/invite";
    NSString *url = @"https://api.hongtang.online/v4/taoke/qrcode/template";
    [request callGETWithUrl:url withCallBack:^(SKResponse *response) {
        if (!response.success) {
            return ;
        }
        
        NSArray *arr = response.data[@"data"];
        self->imageArray = arr;
        [self->cardCollectionVIew reloadData];
    }];

}

-(void)delayMethod{
    [self->cardCollectionVIew reloadData];
}



-(void) cancelAction {
    [self.navigationController popViewControllerAnimated:true];
}

//  提示弹框
-(void)setToast:(NSString *)str {
    
    UIWindow *kWindow = [UIApplication sharedApplication].keyWindow;
    //第三方框架 Toast

    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    [kWindow makeToast:str duration:0.6 position:CSToastPositionCenter style:style];
    kWindow.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        kWindow.userInteractionEnabled = YES;
    });

}


-(void)createUI{
    
//    bgImageV  = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:bgImageV];
//    bgImageV.image = [UIImage imageNamed:@"1.jpg"];
    //    [Healp blurEffect:bgImageV];//设置毛玻璃效果
    
    CardCollectionVIewLayout *layout = [[CardCollectionVIewLayout alloc]init];
    cardCollectionVIew  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LZScreenW, LZScreenH-15) collectionViewLayout:layout];
    [self.view addSubview:cardCollectionVIew];
    cardCollectionVIew.delegate=self;
    cardCollectionVIew.dataSource=self;
    cardCollectionVIew.backgroundView=bgImageV;
    cardCollectionVIew.showsHorizontalScrollIndicator=NO;
    [cardCollectionVIew registerClass:[CardCollectionViewCell class] forCellWithReuseIdentifier:ITEMCELLID];
    cardCollectionVIew.contentOffset = CGPointMake(1, 0);
    cardCollectionVIew.backgroundColor = [UIColor clearColor];
    
    UIButton *shareLink = [[UIButton alloc] init];
    [shareLink setTitle:@"复制注册口令" forState:(UIControlStateNormal)];
    [shareLink addTarget:self action:@selector(shareWithLink) forControlEvents:UIControlEventTouchUpInside];
    shareLink.backgroundColor = kSetRGBColor(64, 69, 74);
    [shareLink setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    shareLink.layer.cornerRadius = 25;
    shareLink.clipsToBounds = YES;
    shareLink.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:shareLink];

    UIButton *sharePosters = [[UIButton alloc] init];
    [sharePosters setTitle:@"分享专属海报" forState:(UIControlStateNormal)];
    [sharePosters addTarget:self action:@selector(shareWithposters) forControlEvents:UIControlEventTouchUpInside];
    sharePosters.backgroundColor = kSetRGBColor(243, 66, 56);
    [sharePosters setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    sharePosters.layer.cornerRadius = 25;
    sharePosters.clipsToBounds = YES;
    sharePosters.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:sharePosters];
    
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
//    添加约束
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(12);
        make.bottom.mas_equalTo(self.view).mas_offset(-30);
    }];

    [shareLink mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(centerView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(LZScreenW/2-24);
        make.right.mas_equalTo(centerView.mas_left);
    }];

    [sharePosters mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(centerView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(LZScreenW/2-30);
        make.left.mas_equalTo(centerView.mas_right);
    }];


//    UIImage *bgImg1 = [self gradientColorImageFromColors:@[kSetRGBColor(228, 75, 125), kSetRGBColor(125, 89, 236)] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(LZScreenW/2-30, 50)];
    
//    [shareLink setBackgroundImage:bgImg1 forState:(UIControlStateNormal)];

    
//    [sharePosters setBackgroundImage:bgImg2 forState:(UIControlStateNormal)];
//
//    shareLink.layer.cornerRadius = 5;
//    shareLink.clipsToBounds = YES;
//    sharePosters.layer.cornerRadius = 5;
//    sharePosters.clipsToBounds = YES;

    if ([Healp isLightColor:[UIColor colorWithPatternImage:[Healp imageFromView:bgImageV atFrame:CGRectMake(0, 0, LZScreenW, 100)]]]) {
        self.titleLB.textColor = [UIColor blackColor];
    }else{
        self.titleLB.textColor = [UIColor whiteColor];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self cellToCenter];
}

-(void) popAction{
    [self.navigationController popViewControllerAnimated:true];
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if(error != NULL){
        [self setToast:@"保存图片失败"];
    }else{
        [self setToast:@"保存图片成功"];
    }
}

/**
 * 分享链接
 */
- (void)shareWithLink {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _inviteCode;
    [self setToast:@"已复制到粘贴板"];
}
/**
 * 分享海报
 */
- (void)shareWithposters {
    if (imageArray.count == 0) {
        [self setToast:@"暂无数据"];
        return;
    }
    [[OCTools new] presnet:self imageUrl:imageArray[currentIndex] callback:nil];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CardCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:ITEMCELLID forIndexPath:indexPath];
//    cell.imageIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[indexPath.row]]];
    
    __block LQInvitesViewController/*主控制器*/ *weakSelf = self;
    
    // 1.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认设置
    [filter setDefaults];
    // 3.设置数据
    NSString *info = @"http://www.taobao.com";
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:infoData forKey:@"inputMessage"];
    // 4.生成二维码
    CIImage *outputImage = [filter outputImage];
    cell.codeImage.image = [self createNonInterpolatedUIIamgeFormCIImage:outputImage withSize:105];
    [cell.imageIV sd_setImageWithURL:[NSURL URLWithString:imageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"goodImage_1"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_time_t dela = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0));
        dispatch_after(dela, dispatch_get_main_queue(), ^{
            if (!weakSelf->isLoaded) {
                weakSelf->isLoaded = YES;
                
                [weakSelf->cardCollectionVIew setContentOffset:CGPointMake(0, 1) animated:YES];
                [weakSelf delayMethod];
            }
        });
        
    }];

    return cell;
}
/** - 生成清晰的二维码
 *  根据CIImage生成指定大小的UIImage 生成清晰的二维码
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIIamgeFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    
    // 1.创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceCMYK();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(-0, 0, 0, 0);
//}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    startX = scrollView.contentOffset.x;
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    endX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cellToCenter];
    });
}
-(void)cellToCenter{
    //最小滚动距离
    float  dragMinDistance = cardCollectionVIew.bounds.size.width/20.0f;
    if (startX - endX >= dragMinDistance) {
        currentIndex -= 1; //向右
    }else if (endX - startX >= dragMinDistance){
        currentIndex += 1 ;//向左
    }
    NSInteger maxIndex  = [cardCollectionVIew numberOfItemsInSection:0] - 1;
    currentIndex = currentIndex <= 0 ? 0 :currentIndex;
    currentIndex = currentIndex >= maxIndex ? maxIndex : currentIndex;
    
    [bgImageV sd_setImageWithURL:[NSURL URLWithString:imageArray[currentIndex]] placeholderImage:[UIImage imageNamed:@"goodImage_1"] ];
//    bgImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[currentIndex]]];

    [cardCollectionVIew scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if ([Healp isLightColor:[UIColor colorWithPatternImage:[Healp imageFromView:bgImageV atFrame:CGRectMake(0, 0, LZScreenW, 100)]]]) {
        self.titleLB.textColor = [UIColor blackColor];
    }else{
        self.titleLB.textColor = [UIColor whiteColor];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize {
    
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        
        [ar addObject:(id)c.CGColor];
        
    }
    
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    
    CGPoint start;
    
    CGPoint end;
    
    switch (gradientType) {
            
        case GradientTypeTopToBottom:
            
            start = CGPointMake(0.0, 0.0);
            
            end = CGPointMake(0.0, imgSize.height);
            
            break;
            
        case GradientTypeLeftToRight:
            
            start = CGPointMake(0.0, 0.0);
            
            end = CGPointMake(imgSize.width, 0.0);
            
            break;
            
        case GradientTypeUpleftToLowright:
            
            start = CGPointMake(0.0, 0.0);
            
            end = CGPointMake(imgSize.width, imgSize.height);
            
            break;
            
        case GradientTypeUprightToLowleft:
            
            start = CGPointMake(imgSize.width, 0.0);
            
            end = CGPointMake(0.0, imgSize.height);
            
            break;
            
        default:
            
            break;
            
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
