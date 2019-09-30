//
//  QJUserGuideViewController.m
//  LH_QJ
//
//  Created by 郭军 on 2018/6/17.
//  Copyright © 2018年 LHYD. All rights reserved.
//

#import "QJUserGuideViewController.h"

//#import "QJAppDelegate.h"
//#import "QJBaseTabbarController.h"

#define kDeviceHight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width


@interface QJUserGuideViewController () <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    CGSize _size;
}


@property (nonatomic, strong)UIPageControl *pageCtrl;


/** 引导图片数组  */
@property (nonatomic, strong)NSArray *guideImages;

//@property (nonatomic, strong)UIButton *startBtn;

@end

@implementation QJUserGuideViewController


//懒加载
- (UIPageControl *)pageCtrl {
    if (!_pageCtrl) {
        _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(_size.width * 0.5, _size.height - 60, 0, 40)];
        _pageCtrl.currentPageIndicatorTintColor = [UIColor clearColor];
        _pageCtrl.pageIndicatorTintColor = [UIColor clearColor];
    }
    return _pageCtrl;
}

//- (UIButton *)startBtn {
//
//    if (!_startBtn) {
//        _startBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2, kDeviceHight - 130, 100, 40)];
//        [_startBtn setBackgroundImage:Image(@"guide_btn") forState:UIControlStateNormal];
////        [_startBtn setTitle:@"前往体验" forState:UIControlStateNormal];
////        _startBtn.backgroundColor = [UIColor colorWithHexCode:@"#dd640b"];
////        _startBtn.titleLabel.font = JGFont(17);
//        //        _startBtn.hidden = YES;
//        //        _startBtn.center = CGPointMake(kDeviceWidth * 0.5, kDeviceHight - 120);
////        _startBtn.layer.cornerRadius = 39 * 0.5;
////        _startBtn.clipsToBounds = YES;
//        [_startBtn addTarget:self action:@selector(showMainUI:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    return _startBtn;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initGuideView];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



- (void)initGuideView {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHight)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    
    NSArray *iPhone5Array = @[@"jg_1",
                              @"jg_2",
                              @"jg_3",
                              @"jg_4",
                              @"jg_5"
                              ];
    
    _scrollView.contentSize = CGSizeMake(kDeviceWidth*iPhone5Array.count, 0);
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton addTarget:self action:@selector(showMainUI:) forControlEvents:UIControlEventTouchUpInside];
    aButton.frame = CGRectMake((iPhone5Array.count-1)*kDeviceWidth, 0, kDeviceWidth, kDeviceHight);
    
    
    for (NSUInteger i = 0; i<iPhone5Array.count; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i*kDeviceWidth, 0, kDeviceWidth, kDeviceHight)];
        iv.image = [UIImage imageNamed:iPhone5Array[i]];
        [_scrollView addSubview:iv];
    }
    
//    aButton.backgroundColor = [UIColor clearColor];
//    [_scrollView addSubview:aButton];
//    [_scrollView bringSubviewToFront:aButton];
//    [self.view addSubview:self.startBtn];
}

#pragma mark - UIScrollViewDelegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
        CGPoint offset = scrollView.contentOffset;
        _pageCtrl.currentPage = round(offset.x / kDeviceWidth);
    
//    self.startBtn.hidden = NO;
//    _pageCtrl.currentPage != _guideImages.count - 1;
    
}



- (void)showMainUI:(UIButton *)sender
{
    
//        [QJAppDelegate shareAppDelegate].window.rootViewController = [[QJBaseTabbarController alloc] init];
    
//    [UIApplication sharedApplication].keyWindow = [[LNMainTabBarController alloc] init];
    
//    [ZJBLAppDelegate shareAppDelegate].window.rootViewController =  [[ZJBLNavigationController alloc] initWithRootViewController:[[ZJBLLoginController alloc] init]];
    
    
    
//        [self presentViewController:TabbarVC animated:YES completion:^{
//            [AppDelegate shareAppDelegate].rootTabbar.viewControllers[2].tabBarItem.badgeValue = @"3";
//
//        }];

}
-(void)dealloc{
//    JGLog(@"HHHH");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
