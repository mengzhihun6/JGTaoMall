//
//  CXsearchController.m
//  搜索页面的封装
//
//  Created by 蔡翔 on 16/7/28.
//  Copyright © 2016年 蔡翔. All rights reserved.
//

#import "CXSearchController.h"
#import "CXSearchSectionModel.h"
#import "CXSearchModel.h"
#import "CXSearchCollectionViewCell.h"
#import "SelectCollectionReusableView.h"
#import "SelectCollectionLayout.h"
#import "CXDBHandle.h"
#import "CXTexeFileBgView.h"
#import "Masonry.h"
#import "CabbageShop-Swift.h"
#import <Toast/UIView+Toast.h>

#import "SKRequest.h"



#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//设置RGB颜色
#define kSetRGBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define kRequest_url @"https://api.baicai.top/v4/taoke/search/hot"
//#define kRequest_url @"https://api.baicai.top/v2/taoke/search/hot"

static NSString *const cxSearchCollectionViewCell = @"CXSearchCollectionViewCell";

static NSString *const headerViewIden = @"HeadViewIden";

@interface CXSearchController()<UICollectionViewDataSource,UICollectionViewDelegate,SelectCollectionCellDelegate,UICollectionReusableViewButtonDelegate,CAAnimationDelegate,UITextFieldDelegate>

/**
 *  存储网络请求的热搜，与本地缓存的历史搜索model数组
 */
@property (nonatomic, strong) NSMutableArray *sectionArray;
/**
 *  存搜索的数组 字典
 */
@property (nonatomic,strong) NSMutableArray *searchArray;
@property (nonatomic,strong) UIView *emptyView;
@property (weak, nonatomic) IBOutlet UICollectionView *cxSearchCollectionView;

@property (weak, nonatomic) IBOutlet UITextField *cxSearchTextField;

@property (weak, nonatomic) IBOutlet UIButton *cancle;


//@property (weak, nonatomic) IBOutlet UIButton *searchApp;
//@property (weak, nonatomic) IBOutlet UIButton *searchAll;
//@property (weak, nonatomic) IBOutlet UIButton *searchPDD;
//@property (weak, nonatomic) IBOutlet UIView *underLine;


//@property (weak, nonatomic) IBOutlet UIButton *searchMark;
//@property (weak, nonatomic) IBOutlet CXTexeFileBgView *backView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIView *headBgView;
//@property (weak, nonatomic) IBOutlet UIView *titleLabel1;

@property (copy, nonatomic) NSString *searchType;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTop;



@end

@implementation CXSearchController


-(NSMutableArray *)sectionArray
{
    if (_sectionArray == nil) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

-(NSMutableArray *)searchArray
{
    if (_searchArray == nil) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addImageWhenEmpty];
    _searchType = @"1";

    [self prepareData];
    
    [self.cxSearchCollectionView setCollectionViewLayout:[[SelectCollectionLayout alloc] init] animated:YES];
    [self.cxSearchCollectionView registerClass:[SelectCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIden];
    [self.cxSearchCollectionView registerNib:[UINib nibWithNibName:@"CXSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cxSearchCollectionViewCell];
    
    self.navigationController.navigationBar.hidden = true;
    
    self.cxSearchTextField.layer.cornerRadius = self.cxSearchTextField.height/2;
    self.cxSearchTextField.clipsToBounds = YES;
    
    /***  可以做实时搜索*/
//    [self.cxSearchTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    

    
    if (_isPresent) {
        _backButton.hidden = NO;
    }else{
        _backButton.hidden = YES;
    }
    
    
    if (KIsiPhoneX || self.view.bounds.size.height == 812) {
        
        _headHeight.constant = 88;
    }
    
    _cxSearchTextField.delegate = self;
    
    SKRequest *request = [SKRequest new];
    [request setParam:@"1" forKey:@"type"];
    [request callGETWithUrl:kRequest_url withCallBack:^(SKResponse *response) {
        if (!response.success) {
            return ;
        }
        
        NSArray *dataArr = response.data[@"data"];
        NSMutableArray *keyWords = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            NSDictionary *saveDic = [NSDictionary dictionaryWithObject:dic[@"keyword"] forKey:@"content_name"];
            [keyWords addObject:saveDic];
        }
        
        [self.searchArray removeAllObjects];
        [self.sectionArray removeAllObjects];
        
        NSDictionary *testDict = @{@"section_id":@"1",@"section_title":@"热搜",@"section_content":keyWords};
        NSMutableArray *testArray = [@[] mutableCopy];
        [testArray addObject:testDict];
        
        /***  去数据查看 是否有数据*/
        NSDictionary *parmDict  = @{@"category":@"1"};
        NSDictionary *dbDictionary =  [CXDBHandle statusesWithParams:parmDict];
        
        if (dbDictionary.count) {
            [testArray addObject:dbDictionary];
            [self.searchArray addObjectsFromArray:dbDictionary[@"section_content"]];
        }
        
        for (NSDictionary *sectionDict in testArray) {
            CXSearchSectionModel *model = [[CXSearchSectionModel alloc]initWithDictionary:sectionDict];
            [self.sectionArray addObject:model];
        }
        [self.cxSearchCollectionView reloadData];

    }];
    
    
}

//    当数据为空的时候，显示提示
-(void)addImageWhenEmpty {
    for (UIView *view in self.emptyView.subviews) {
        [view removeFromSuperview];
    }
    
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.emptyView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 210 * self.view.frame.size.width / 720, 186 * self.view.frame.size.width / 720)];
    imageView.image = [UIImage imageNamed:@"暂无内容"];
    imageView.center = CGPointMake(self.cxSearchCollectionView.centerX, self.cxSearchCollectionView.centerY - 186 * self.view.frame.size.width / 720);
    [self.emptyView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:197 / 255.0 green:197 / 255.0 blue:197 / 255.0 alpha:1];
    label.center = CGPointMake(self.cxSearchCollectionView.centerX, self.cxSearchCollectionView.centerY - 25);
    label.text = @"暂无搜索记录";
    [self.emptyView addSubview:label];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self prepareData];
    [_cxSearchCollectionView reloadData];
}


- (IBAction)searchAppAction:(UIButton *)sender {
    
//    sender.selected = YES;
//    _searchAll.selected = NO;
//    _searchPDD.selected = NO;

//    [UIView animateWithDuration:.3 animations:^{
//
//        self.underLine.center = CGPointMake(sender.center.x, self.underLine.center.y);
//    }];
    _searchType = @"1";
}


- (void)prepareData
{
    /**
     *  测试数据 ，字段暂时 只用一个 titleString，后续可以根据需求 相应加入新的字段
     */
    return;
    [self.searchArray removeAllObjects];
    [self.sectionArray removeAllObjects];

    NSDictionary *testDict = @{@"section_id":@"1",@"section_title":@"猜你喜欢",@"section_content":@[@{@"content_name":@"化妆棉"},@{@"content_name":@"面膜"},@{@"content_name":@"口红"},@{@"content_name":@"眼霜"},@{@"content_name":@"洗面奶"},@{@"content_name":@"防晒霜"},@{@"content_name":@"补水"},@{@"content_name":@"香水"},@{@"content_name":@"眉笔"}]};
    NSMutableArray *testArray = [@[] mutableCopy];
    [testArray addObject:testDict];
    
    /***  去数据查看 是否有数据*/
    NSDictionary *parmDict  = @{@"category":@"1"};
    NSDictionary *dbDictionary =  [CXDBHandle statusesWithParams:parmDict];
    
    if (dbDictionary.count) {
        [testArray addObject:dbDictionary];
        [self.searchArray addObjectsFromArray:dbDictionary[@"section_content"]];
    }
    
    for (NSDictionary *sectionDict in testArray) {
        CXSearchSectionModel *model = [[CXSearchSectionModel alloc]initWithDictionary:sectionDict];
        [self.sectionArray addObject:model];
    }
}


- (IBAction)searchMarkTouched:(UIButton *)sender {

    
//    [UIView transitionWithView:sender duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//        if (!sender.selected) {
//            [sender setImage:[UIImage imageNamed:@"btn_switch_taobao"] forState:(UIControlStateNormal)];
//        }else{
//            [sender setImage:[UIImage imageNamed:@"icon_search_jd"] forState:(UIControlStateNormal)];
//        }
//
//        sender.selected = !sender.selected;
//
//    }completion:^(BOOL finished) {
//
//
//    }];
//
    
    [self simpleLyerRotation];
}

- (void)simpleLyerRotation

{
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    
    // 旋转角度， 其中的value表示图像旋转的最终位置
    
    keyAnimation.values = [NSArray arrayWithObjects:
                           
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                           
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2), 0,1,0)],
                           
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                           
                           nil];
    
    keyAnimation.cumulative = NO;
    
    keyAnimation.duration = .8;
    
    keyAnimation.repeatCount = 1;
    
    keyAnimation.removedOnCompletion = NO;
    
    keyAnimation.delegate = self;
    
//    [_searchMark.layer addAnimation:keyAnimation forKey:@"transform"];
    
    [self performSelector:@selector(changeImg) withObject:nil afterDelay:0.4];
    
}

- (void)changeImg
{
//    if (_searchMark.selected) {
//        [_searchMark setImage:[UIImage imageNamed:@"btn_switch_taobao"] forState:(UIControlStateNormal)];
//        _searchType = @"taobao";
//
//    }else{
//        [_searchMark setImage:[UIImage imageNamed:@"icon_search_jd"] forState:(UIControlStateNormal)];
//        _searchType = @"jingdong";
//
//    }
//
//    _searchMark.selected = !_searchMark.selected;
}


- (IBAction)cancleAction:(UIButton *)sender {
    
//    [self textFieldShouldReturn:_cxSearchTextField];
    [self dismissViewControllerAnimated:false completion:nil];
    [self.navigationController popViewControllerAnimated:NO];


}

- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:false completion:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isPresent) {
        [self.cxSearchTextField becomeFirstResponder];
    }

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CXSearchSectionModel *sectionModel =  self.sectionArray[section];
    return sectionModel.section_contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cxSearchCollectionViewCell forIndexPath:indexPath];
    CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
    CXSearchModel *contentModel = sectionModel.section_contentArray[indexPath.row];
    [cell.contentButton setTitle:contentModel.content_name forState:UIControlStateNormal];
    cell.selectDelegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.sectionArray.count == 0) {
        [self.cxSearchCollectionView addSubview:self.emptyView];
    }else{
        [self.emptyView removeFromSuperview];
    }
    return self.sectionArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]){
        SelectCollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIden forIndexPath:indexPath];
        view.delectDelegate = self;
        CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
        [view setText:sectionModel.section_title];
        /***  此处完全 也可以自定义自己想要的模型对应放入*/
        if(indexPath.section == 0)
        {
            [view setImage:@"cxCool"];
            view.delectButton.hidden = YES;
        }else{
            [view setImage:@"cxSearch"];
            view.delectButton.hidden = NO;
        }
        reusableview = view;
    }
    return reusableview;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
    if (sectionModel.section_contentArray.count > 0) {
        CXSearchModel *contentModel = sectionModel.section_contentArray[indexPath.row];
        return [CXSearchCollectionViewCell getSizeWithText:contentModel.content_name];
    }
    return CGSizeMake(80, 24);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


#pragma mark - SelectCollectionCellDelegate
- (void)selectButttonClick:(CXSearchCollectionViewCell *)cell;
{
    NSIndexPath* indexPath = [self.cxSearchCollectionView indexPathForCell:cell];
    CXSearchSectionModel *sectionModel =  self.sectionArray[indexPath.section];
    CXSearchModel *contentModel = sectionModel.section_contentArray[indexPath.row];
    NSLog(@"您选的内容是：%@",contentModel.content_name);
    
    LQSearchResultViewController *resultVC = [[LQSearchResultViewController alloc] init];
//    resultVC.type = _searchType;
    resultVC.type = self.typeString;
    resultVC.keyword = contentModel.content_name;
    
    [resultVC callKeywordBlockWithBlock:^(NSString * keyword) {
        [self reloadData:keyword];
    }];

    [self.navigationController pushViewController: resultVC animated:YES];

//    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您该去搜索 %@ 的相关内容了",contentModel.content_name] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了！", nil];
//    [al show];
}

#pragma mark - UICollectionReusableViewButtonDelegate
- (void)delectData:(SelectCollectionReusableView *)view;
{
    if (self.sectionArray.count > 1) {
        [self.sectionArray removeLastObject];
        [self.searchArray removeAllObjects];
        [self.cxSearchCollectionView reloadData];
        [CXDBHandle saveStatuses:@{} andParam:@{@"category":@"1"}];
    }
}
#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [self.cxSearchTextField resignFirstResponder];
}

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

#pragma mark - textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSString *keyWord = textField.text;

    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
//        keyWord = textField.placeholder;
        [self setToast:@"请输入关键词"];

        return YES;

//        return NO;
    }
    /***  每搜索一次   就会存放一次到历史记录，但不存重复的*/
    if ([self.searchArray containsObject:[NSDictionary dictionaryWithObject:keyWord forKey:@"content_name"]]) {
        
        LQSearchResultViewController *resultVC = [LQSearchResultViewController new];
        resultVC.keyword = keyWord;
//        resultVC.type = _searchType;
        resultVC.type = self.typeString;
        [resultVC callKeywordBlockWithBlock:^(NSString * keyword) {
            [self reloadData:keyword];
        }];

        [self.navigationController pushViewController: resultVC animated:YES];
        return YES;
    }
    
    LQSearchResultViewController *resultVC = [LQSearchResultViewController new];
    resultVC.keyword = keyWord;
//    resultVC.type = _searchType;
    resultVC.type = self.typeString;
    [resultVC callKeywordBlockWithBlock:^(NSString * keyword) {
        [self reloadData:keyword];
    }];
    
    [self.navigationController pushViewController: resultVC animated:YES];
    
    [self reloadData:keyWord];
    return YES;
}
- (void)reloadData:(NSString *)textString
{
    [self.searchArray addObject:[NSDictionary dictionaryWithObject:textString forKey:@"content_name"]];
    
    NSDictionary *searchDict = @{@"section_id":@"2",@"section_title":@"历史记录",@"section_content":self.searchArray};
    
    /***由于数据量并不大 这样每次存入再删除没问题  存数据库*/
    NSDictionary *parmDict  = @{@"category":@"1"};
    [CXDBHandle saveStatuses:searchDict andParam:parmDict];
    
    CXSearchSectionModel *model = [[CXSearchSectionModel alloc]initWithDictionary:searchDict];
    if (self.sectionArray.count > 1) {
        [self.sectionArray removeLastObject];
    }
    [self.sectionArray addObject:model];
    [self.cxSearchCollectionView reloadData];
    self.cxSearchTextField.text = @"";
}

@end
