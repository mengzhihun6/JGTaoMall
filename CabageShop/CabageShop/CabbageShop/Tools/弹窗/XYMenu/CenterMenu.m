//
//  CenterMenu.m
//  弹窗菜单
//
//  Created by EastSun on 2017/12/21.
//  Copyright © 2017年 EastSun. All rights reserved.
//

#import "CenterMenu.h"

@interface CenterMenu ()<UITableViewDelegate, UITableViewDataSource>

/**
 菜单项
 */
@property (nonatomic, strong) UITableView *menuTableView;

/**
 标题数组
 */
@property (nonatomic, strong) NSArray *titleArray;

/**
 图表数组
 */
@property (nonatomic, strong) NSArray *iconArray;

/**
 菜单字体
 */
@property (nonatomic, strong) UIFont *font;

/**
 菜单字体颜色
 */
@property (nonatomic, strong) UIColor *fontColor;

/**
 菜单背景颜色
 */
@property (nonatomic, strong) UIColor *menuBackColor;

/**
 菜单分割线的颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 菜单遮罩层颜色
 */
@property (nonatomic, strong) UIColor *menuMaskColor;

/**
 菜单项目的位置
 */
@property (nonatomic, assign) CGRect menuItemRect;

/**
 菜单圆角半径
 */
@property (nonatomic, assign) CGFloat menuRoundedRadius;

/**
 菜单项目单元格高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation CenterMenu

#pragma mark- 实例化菜单
- (instancetype)initDefaultCenterMenuWithTitle:(NSArray<NSString *> *)titleArray icon:(NSArray<NSString *> *)iconArray {
    return [self initCustomCenterMenuWithTitle:titleArray icon:iconArray menuUnitSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/2, 44) menuCornerRadius:5 menuFont:[UIFont fontWithName:@"Helvetica" size:18.f] menuFontColor:[UIColor blackColor] menuBackColor:[UIColor colorWithWhite:1 alpha:0.8] menuSegmentingLineColor:[UIColor colorWithRed:192/255.f green:196/255.f blue:201/255.f alpha:1] menuMaskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
}

#pragma mark- 自定义风格
- (instancetype)initCustomCenterMenuWithTitle:(NSArray<NSString *> *)titleArray icon:(NSArray<NSString *> *)iconArray menuUnitSize:(CGSize)size menuCornerRadius:(CGFloat)menuRoundedRadius menuFont:(UIFont *)font menuFontColor:(UIColor *)fontColor menuBackColor:(UIColor *)menuBackColor menuSegmentingLineColor:(UIColor *)separatorColor menuMaskColor:(UIColor * _Nullable)menuMaskColor {
    
    self = [super init];
    if (self) {
        
        self.titleArray = titleArray;
        self.iconArray = iconArray;
        self.cellHeight = size.height;// 菜单单元格高度
        self.menuRoundedRadius = menuRoundedRadius;
        self.font = font;
        self.fontColor = fontColor;
        self.menuBackColor = menuBackColor;
        self.separatorColor = separatorColor;
        self.menuMaskColor = menuMaskColor;
        
        ;
        self.menuItemRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - size.width)/2, ([UIScreen mainScreen].bounds.size.height-size.height*titleArray.count)/2, size.width, size.height*titleArray.count);
    }
    return self;
}

#pragma mark- 定制并展示菜单
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 1、设置菜单遮罩层颜色
    self.view.backgroundColor = self.menuMaskColor;
    
    // 2、设置展示动态展示动画
    self.menuTableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    [UIView animateWithDuration:0.2 animations:^{
        [self.view addSubview:self.menuTableView];
        self.menuTableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

#pragma mark- 移除菜单
- (void)removeMenuView {
    [UIView animateWithDuration:0.2 animations:^{
        self.menuTableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self.menuTableView removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark- 菜单TableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 1、通知代理处理点击事件
    if ([self.delegate respondsToSelector:@selector(menu:didClickedItemUnitWithTag:andItemUnitTitle:)]) {
        [self.delegate menu:self didClickedItemUnitWithTag:indexPath.row andItemUnitTitle:self.titleArray[indexPath.row]];
    }
    // 2、移除菜单
    [self removeMenuView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%lu-+%lu", indexPath.row, indexPath.section]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%lu-+%lu", indexPath.row, indexPath.section]];
        // 设置标题格式
        cell.textLabel.font = self.font;
        cell.textLabel.textColor = self.fontColor;
        cell.backgroundColor = [UIColor clearColor];
        // 设置菜单点击背景
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        // 移除最后一个cell的分割线
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        }
        
        // 设置菜单图标
        if (self.iconArray) {
            cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        // 设置菜单标题
        cell.textLabel.text = self.titleArray[indexPath.row];
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark- 懒加载
- (UITableView *)menuTableView {
    
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:self.menuItemRect style:UITableViewStylePlain];
        _menuTableView.center = self.view.center;
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.bounces = NO;
        _menuTableView.showsVerticalScrollIndicator = NO;
        _menuTableView.tableFooterView = [[UIView alloc] init];
        
        _menuTableView.backgroundColor = self.menuBackColor;
        _menuTableView.layer.cornerRadius = self.menuRoundedRadius;
        _menuTableView.layer.masksToBounds = YES;
        
        // 分割线颜色
        _menuTableView.separatorColor = self.separatorColor;
        // 调整cell的分割线的位置
        _menuTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _menuTableView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    
    return _menuTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
