//
//  SZYInviterViewController.m
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/14.
//  Copyright © 2019 付耀辉. All rights reserved.
//

#define JkScreenHeight [UIScreen mainScreen].bounds.size.height
#define JkScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SZYInviterViewController.h"
#import "HQFlowView.h"
#import "HQImagePageControl.h"

#import "Masonry.h"   //加约束
//#import <ShareSDK/ShareSDK.h>
//#import <Toast/UIView+Toast.h>
#import "CabbageShop-Swift.h"


//设置RGB颜色
#define kSetRGBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface SZYInviterViewController () <HQFlowViewDelegate, HQFlowViewDataSource>

/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *advArray;
/**
 *  轮播图
 */
@property (nonatomic, strong) HQImagePageControl *pageC;
@property (nonatomic, strong) HQFlowView *pageFlowView;
@property (nonatomic, strong) UIScrollView *scrollView; // 轮播图容器


@end

@implementation SZYInviterViewController

- (NSMutableArray *)advArray {
    if (!_advArray) {
        _advArray = [NSMutableArray arrayWithObjects: @"placeholder_1", @"placeholder_1", @"placeholder_1", @"placeholder_1", @"placeholder_1", @"placeholder_1", @"placeholder_1", @"placeholder_1", @"placeholder_1", nil];
    }
    return _advArray;
}
#pragma mark -- 轮播图
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, JkScreenWidth, (JkScreenWidth - 2 * 50) * 1334 / 750)];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}
- (HQFlowView *)pageFlowView {
    if (!_pageFlowView) {
        _pageFlowView = [[HQFlowView alloc] initWithFrame:CGRectMake(0, 0, JkScreenWidth, (JkScreenWidth - 2 * 50) * 1334 / 750)];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.3;
        _pageFlowView.leftRightMargin = 15;
        _pageFlowView.topBottomMargin = 20;
        _pageFlowView.isOpenAutoScroll = NO;
        _pageFlowView.isCarousel = YES;
        _pageFlowView.orginPageCount = _advArray.count;
        _pageFlowView.autoTime = 3.0;
        _pageFlowView.orientation = HQFlowViewOrientationHorizontal;
    }
    return _pageFlowView;
}
- (HQImagePageControl *)pageC {
    if (!_pageC) {
        //初始化pageControl
        if (!_pageC) {
            _pageC = [[HQImagePageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - 15, self.scrollView.frame.size.width, 7.5)];
        }
        [self.pageFlowView.pageControl setCurrentPage:0];
        self.pageFlowView.pageControl = _pageC;
    }
    return _pageC;
}
#pragma mark JQFlowViewDelegate
- (CGSize)sizeForPageInFlowView:(HQFlowView *)flowView { // 750  1334
    return CGSizeMake( JkScreenWidth - 2 * 50, (JkScreenWidth - 2 * 50) * 1334 / 750 - 2 * 3 );
}
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击第%ld个广告",(long)subIndex);
}
#pragma mark JQFlowViewDatasource
- (NSInteger)numberOfPagesInFlowView:(HQFlowView *)flowView {
    return self.advArray.count;
}
- (HQIndexBannerSubview *)flowView:(HQFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    HQIndexBannerSubview *bannerView = (HQIndexBannerSubview *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[HQIndexBannerSubview alloc] initWithFrame:CGRectMake(0, 0, self.pageFlowView.frame.size.width, self.pageFlowView.frame.size.height)];
        bannerView.layer.cornerRadius = 5;
        bannerView.layer.masksToBounds = YES;
        bannerView.coverView.backgroundColor = [UIColor darkGrayColor];
    }
    //在这里下载网络图片
    //    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.advArray[index]] placeholderImage:nil];
    //加载本地图片
    bannerView.mainImageView.image = [UIImage imageNamed:self.advArray[index]];
    
    return bannerView;
}
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(HQFlowView *)flowView {
    [self.pageFlowView.pageControl setCurrentPage:pageNumber];
}
#pragma mark --旋转屏幕改变JQFlowView大小之后实现该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        [coordinator animateAlongsideTransition:^(id context) { [self.pageFlowView reloadData];
        } completion:NULL];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)dealloc {
    self.pageFlowView.delegate = nil;
    self.pageFlowView.dataSource = nil;
    [self.pageFlowView stopTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat height = 64;
    if (self.view.height>800) {
        height = 88;
    }
    UIView *headView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, self.view.width, height))];
    headView.backgroundColor = kSetRGBColor(243, 66, 56);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, height)];
//    imageView.image = [UIImage imageNamed: @"Rectangle"];
    imageView.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:13 / 255.0 blue:68 / 255.0 alpha:1];
    [headView addSubview:imageView];
    
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
        make.width.mas_equalTo(JkScreenWidth / 2 - 24);
        make.right.mas_equalTo(centerView.mas_left);
    }];
    
    [sharePosters mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(centerView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(JkScreenWidth / 2 - 30);
        make.left.mas_equalTo(centerView.mas_right);
    }];
    
    
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pageFlowView];
    [self.pageFlowView addSubview:self.pageC];
    [self.pageFlowView reloadData];//刷新轮播
}
-(void) popAction{
    [self.navigationController popViewControllerAnimated:true];
}
/**
 * 复制邀请码
 */
- (void)shareWithLink {
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = _inviteCode;
//    [self setToast:@"已复制到粘贴板"];
}
/**
 * 分享海报
 */
- (void)shareWithposters {
//    if (imageArray.count == 0) {
//        [self setToast:@"暂无数据"];
//        return;
//    }
//    [[OCTools new] presnet:self imageUrl:imageArray[currentIndex] callback:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
