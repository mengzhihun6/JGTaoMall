//
//  ArrowheadMenu.m
//  弹窗菜单
//
//  Created by EastSun on 2017/12/21.
//  Copyright © 2017年 EastSun. All rights reserved.
//

#import "ArrowheadMenu.h"
#define kSetRGBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define kSetRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ArrowheadMenu ()<UITableViewDelegate, UITableViewDataSource>

/**
 菜单背景图
 */
@property (nonatomic, strong, ) UIView *menuBackView;

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
 开始位置
 */
@property (nonatomic, assign) CGRect startFrame;

/**
 菜单的位置
 */
@property (nonatomic, assign) CGRect menuRect;

/**
 菜单项目的位置
 */
@property (nonatomic, assign) CGRect menuItemRect;

/**
 箭头开始的点
 */
@property (nonatomic, assign) CGPoint arrowStartPoint;

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
 菜单和触发按钮的间隔
 */
@property (nonatomic, assign) CGFloat interval;

/**
 菜单项目单元格高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 菜单宽度
 */
@property (nonatomic, assign) CGFloat menuWidth;

/**
 菜单高度
 */
@property (nonatomic, assign) CGFloat menuHeight;

/**
 菜单项目高度
 */
@property (nonatomic, assign) CGFloat menuItemHeight;

/**
 菜单项目宽度
 */
@property (nonatomic, assign) CGFloat menuItemWidth;

/**
 展示动画风格
 */
@property (nonatomic, assign) MenuShowAnimationStyle animationStyle;

/**
 位置
 */
@property (nonatomic, assign) MenuPlacements placements;

/**
 箭头风格
 */
@property (nonatomic, assign) MenuArrowStyle arrowStyle;

/**
 动画锚点
 */
@property (nonatomic, assign) CGPoint anchorPoint;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation ArrowheadMenu

#pragma mark- 默认风格创建菜单
- (instancetype)initDefaultArrowheadMenuWithTitle:(NSArray<NSString *> *)titleArray icon:(NSArray<NSString *> *)iconArray menuPlacements:(MenuPlacements)placements {

    return [self initCustomArrowheadMenuWithTitle:titleArray icon:iconArray menuUnitSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/3, 38) menuFont:[UIFont fontWithName:@"Helvetica" size:15.f] menuFontColor:[UIColor grayColor] menuBackColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] menuSegmentingLineColor:[UIColor colorWithRed:192/255.f green:196/255.f blue:201/255.f alpha:1] distanceFromTriggerSwitch:0 menuArrowStyle:MenuArrowStyleTriangle menuPlacements:placements showAnimationEffects:ShowAnimationZoom];
}

#pragma mark- 自定义风格创建菜单
- (instancetype)initCustomArrowheadMenuWithTitle:(NSArray<NSString *> *)titleArray icon:(NSArray<NSString *> *)iconArray menuUnitSize:(CGSize)size menuFont:(UIFont *)font menuFontColor:(UIColor *)fontColor menuBackColor:(UIColor *)menuBackColor menuSegmentingLineColor:(UIColor *)separatorColor distanceFromTriggerSwitch:(CGFloat)interval menuArrowStyle:(MenuArrowStyle)arrowStyle menuPlacements:(MenuPlacements)placements showAnimationEffects:(MenuShowAnimationStyle)animation {
    
    self = [super init];
    if (self) {
        
        self.font = font;// 菜单字体
        self.separatorColor = separatorColor;// 分割线颜色
        self.menuBackColor = menuBackColor;// 菜单背景颜色
        self.fontColor = fontColor;// 字体颜色和背景颜色形成对比
        self.cellHeight = size.height;// 菜单单元格高度
        self.menuItemWidth = size.width;// 菜单项目宽度
        self.menuItemHeight = size.height*titleArray.count;// 菜单项目高度
        self.interval = interval;// 菜单和触发按钮的间隔
        self.titleArray = titleArray;// 标题
        self.iconArray = iconArray;// 图标
        self.arrowStyle = arrowStyle;// 箭头风格
        self.placements = placements;// 展示位置
        self.animationStyle = animation; // 展示动画
        self.selectIndex = 100;
    }
    
    return self;
    
}

#pragma mark- 菜单位置和大小计算，并跟新菜单frame
- (void)calculateMenuPositionAccordingTo:(NSObject *)tSwitch menuPlacements:(MenuPlacements)placementsStyle {
    // 1、将开关的frame转换绝对坐标
    [self calculateSwitchPosition:tSwitch];
    
    // 2、计算菜单的位置
    switch (placementsStyle) {
        case 0:// 菜单在触发按钮上部显示
        {
            self.menuWidth = self.menuItemWidth;// 菜单宽度
            self.menuHeight = self.menuItemHeight + ARROWHEIGHT;// 菜单高度
            CGFloat centerX = self.startFrame.origin.x+self.startFrame.size.width/2;// 按钮水平方向中心点
            // 判断触发按钮位置
            if ( centerX - self.menuWidth/2 <0) {// 触发按钮太靠左了。
                self.menuRect = CGRectMake(ARROWHEIGHT, CGRectGetMinY(self.startFrame) - (self.menuHeight+self.interval), self.menuWidth, self.menuHeight);
                
            } else if ( centerX + self.menuWidth/2 > [UIScreen mainScreen].bounds.size.width) {// 触发按钮太靠右了
                self.menuRect = CGRectMake([UIScreen mainScreen].bounds.size.width - ARROWHEIGHT - self.menuWidth, CGRectGetMinY(self.startFrame) - (self.menuHeight+self.interval), self.menuWidth, self.menuHeight);
                
            } else {
                self.menuRect = CGRectMake(centerX  - self.menuWidth/2, CGRectGetMinY(self.startFrame) - (self.menuHeight+self.interval), self.menuWidth, self.menuHeight);
            }
            
            self.arrowStartPoint = CGPointMake(centerX - self.menuRect.origin.x, self.menuHeight);
            
            self.menuItemRect = CGRectMake(0, 0, self.menuItemWidth, self.menuItemHeight);
            
            self.menuBackView.frame = self.menuRect;
            self.anchorPoint = CGPointMake(self.arrowStartPoint.x/self.menuWidth, 1.f);// 动画开始时的锚点
            
            switch (self.arrowStyle) {
                case 0:// 圆角箭头
                {
                    [self.menuBackView getBottomRoundedArrowWitharrowHeight:ARROWHEIGHT radianRadius:MENUCORNERRADIUS startPoint:self.arrowStartPoint];
                }
                    break;
                case 1:// 尖角箭头
                {
                    [self.menuBackView getBottomArrowWitharrowHeight:ARROWHEIGHT radianRadius:MENUCORNERRADIUS startPoint:self.arrowStartPoint];
                }
                    break;
                    
            }
            
        }
            break;
        case 1:// 菜单在触发按钮左侧显示
        {
            self.menuWidth = self.menuItemWidth+ARROWHEIGHT;// 菜单宽度
            self.menuHeight = self.menuItemHeight;// 菜单高度
            CGFloat centerY = self.startFrame.origin.y+self.startFrame.size.height/2;// 按钮水平方向中心点
            // 判断触发按钮位置
            if ( centerY - self.menuHeight/2 <0) {// 触发按钮太靠上了。
                self.menuRect = CGRectMake(self.startFrame.origin.x-(self.menuWidth+self.interval), 0, self.menuWidth, self.menuHeight);
                
            } else if ( centerY + self.menuWidth/2 > [UIScreen mainScreen].bounds.size.width) {// 触发按钮太靠下了
                self.menuRect = CGRectMake(self.startFrame.origin.x-(self.menuWidth+self.interval), [UIScreen mainScreen].bounds.size.height - self.menuHeight, self.menuWidth, self.menuHeight);
                
            } else {
                self.menuRect = CGRectMake(self.startFrame.origin.x-(self.menuWidth+self.interval), centerY - self.menuHeight/2, self.menuWidth, self.menuHeight);
            }
            
            self.arrowStartPoint = CGPointMake(self.menuWidth, centerY-self.menuRect.origin.y);
            
            self.menuItemRect = CGRectMake(0, 0, self.menuItemWidth, self.menuItemHeight);
            
            self.menuBackView.frame = self.menuRect;
            self.anchorPoint = CGPointMake(1.f, self.arrowStartPoint.y/self.menuHeight);// 动画开始时的锚点
            
            [self.menuBackView getRightArrowWitharrowHeight:ARROWHEIGHT radianRadius:MENUCORNERRADIUS startPoint:self.arrowStartPoint];
            
        }
            break;
        case 2:// 菜单在触发按钮底部显示
        {
            self.menuWidth = self.menuItemWidth;// 菜单宽度
            self.menuHeight = self.menuItemHeight + ARROWHEIGHT;// 菜单高度
            CGFloat centerX = self.startFrame.origin.x+self.startFrame.size.width/2;// 按钮水平方向中心点
            // 判断触发按钮位置
            if ( centerX - self.menuWidth/2 <0) {// 触发按钮太靠左了。
                self.menuRect = CGRectMake(ARROWHEIGHT, CGRectGetMaxY(self.startFrame)+self.interval, self.menuWidth, self.menuHeight);
                
            } else if ( centerX + self.menuWidth/2 > [UIScreen mainScreen].bounds.size.width) {// 触发按钮太靠右了
                self.menuRect = CGRectMake([UIScreen mainScreen].bounds.size.width - ARROWHEIGHT - self.menuWidth, CGRectGetMaxY(self.startFrame)+self.interval, self.menuWidth, self.menuHeight);
                
            } else {
                self.menuRect = CGRectMake(centerX  - self.menuWidth/2, CGRectGetMaxY(self.startFrame)+self.interval, self.menuWidth, self.menuHeight);
            }
            
            self.arrowStartPoint = CGPointMake(centerX - self.menuRect.origin.x, 0);
            
            self.menuItemRect = CGRectMake(0, ARROWHEIGHT, self.menuItemWidth, self.menuItemHeight);
            
            self.menuBackView.frame = self.menuRect;
            self.anchorPoint = CGPointMake(self.arrowStartPoint.x/self.menuWidth, 0.f);// 动画开始时的锚点
            
            switch (self.arrowStyle) {
                case 0:// 圆角箭头
                {
                    [self.menuBackView getTopRoundedArrowWitharrowHeight:ARROWHEIGHT radianRadius:MENUCORNERRADIUS startPoint:self.arrowStartPoint];
                }
                    break;
                case 1:// 尖角箭头
                {
                    [self.menuBackView getTopArrowWitharrowHeight:ARROWHEIGHT radianRadius:MENUCORNERRADIUS startPoint:self.arrowStartPoint];
                }
                    break;
                    
            }
        }
            break;
        case 3:// 菜单在触发按钮右侧显示
        {
            self.menuWidth = self.menuItemWidth+ARROWHEIGHT;// 菜单宽度
            self.menuHeight = self.menuItemHeight;// 菜单高度
            CGFloat centerY = self.startFrame.origin.y+self.startFrame.size.height/2;// 按钮水平方向中心点
            // 判断触发按钮位置
            if ( centerY - self.menuHeight/2 <0) {// 触发按钮太靠上了。
                self.menuRect = CGRectMake(CGRectGetMaxX(self.startFrame)+self.interval, 0, self.menuWidth, self.menuHeight);
                
            } else if ( centerY + self.menuWidth/2 > [UIScreen mainScreen].bounds.size.width) {// 触发按钮太靠下了
                self.menuRect = CGRectMake(CGRectGetMaxX(self.startFrame)+self.interval, [UIScreen mainScreen].bounds.size.height - self.menuHeight, self.menuWidth, self.menuHeight);
                
            } else {
                self.menuRect = CGRectMake(CGRectGetMaxX(self.startFrame)+self.interval, centerY - self.menuHeight/2, self.menuWidth, self.menuHeight);
            }
            
            self.arrowStartPoint = CGPointMake(0, centerY-self.menuRect.origin.y);
            self.menuItemRect = CGRectMake(ARROWHEIGHT, 0, self.menuItemWidth, self.menuItemHeight);
            
            self.menuBackView.frame = self.menuRect;
            self.anchorPoint = CGPointMake(0.f, self.arrowStartPoint.y/self.menuHeight);// 动画开始时的锚点
            
            [self.menuBackView getLeftArrowWitharrowHeight:ARROWHEIGHT radianRadius:MENUCORNERRADIUS startPoint:self.arrowStartPoint];
            
        }
            break;
    }
}

#pragma mark- 绝对坐标转换
- (void)calculateSwitchPosition:(NSObject *)tSwitch {
    UIView *view;
    if ([tSwitch isKindOfClass:[UIView class]]) {// 是view类，转换成绝对坐标
        view = (UIView *)tSwitch;
    } else if ([tSwitch isKindOfClass:[UIBarItem class]]) {// 导航栏或标签按钮
        view = [tSwitch valueForKey:@"view"];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.startFrame = [view convertRect:view.bounds toView:window];// 转成相对于self.view的绝对坐标，因为传过来的控件不一定是self.view的直接子视图
}

#pragma mark- 弹出方法
- (void)presentMenuView:(NSObject *)sender {
    // 1、根据触发控件sender的位置，计算菜单的位置
    [self calculateMenuPositionAccordingTo:sender menuPlacements:self.placements];
    // 2、展示菜单
    [self presentMenuView];
}

#pragma mark- 移除菜单
- (void)removeMenuView {
    
    // 根据动画风格移除菜单
    switch (self.animationStyle) {
        case 0:// 无动画效果
        {
            [self.menuBackView removeFromSuperview];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
            break;
            
        case 1:// 缩放效果
        {
            [UIView animateWithDuration:0.25f animations:^{
                self.menuBackView.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
                [self dismissViewControllerAnimated:NO completion:nil];
            } completion:^(BOOL finished) {
                [self.menuBackView removeFromSuperview];
                self.menuBackView.transform = CGAffineTransformIdentity;// 还原回来，否则会影响下次弹出
            }];
        }
            break;
    }
}

#pragma mark- 定制并展示菜单
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    // 1、设置菜单遮罩层颜色
    self.view.backgroundColor = kSetRGBAColor(0, 0, 0, 0.5);

    // 2、根据动画风格展示菜单
    switch (self.animationStyle) {
        case 0:// 无动画效果
            {
                [self.view addSubview:self.menuBackView];
            }
            break;
            
        case 1:// 缩放效果
        {
            self.menuBackView.layer.anchorPoint = self.anchorPoint;
            self.menuBackView.frame = self.menuRect;// 设置锚点后，会影响frme的origin,所以需要重新赋值
            self.menuBackView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
            [UIView animateWithDuration:0.25f animations:^{
                [self.view addSubview:self.menuBackView];
                self.menuBackView.transform = CGAffineTransformIdentity;
            }];
        }
            break;
    }
}

#pragma mark- 菜单TableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 1、通知代理处理点击事件
    if ([self.delegate respondsToSelector:@selector(menu:didClickedItemUnitWithTag:andItemUnitTitle:)]) {
        [self.delegate menu:self didClickedItemUnitWithTag:indexPath.row andItemUnitTitle:self.titleArray[indexPath.row]];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = kSetRGBColor(236, 101, 90);
    
    if (_selectIndex != 100 && _selectIndex != indexPath.row) {
        UITableViewCell *cellLast = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
        cellLast.textLabel.textColor = kSetRGBColor(39, 39, 39);
    }

    _selectIndex = indexPath.row;

    // 2、移除菜单
    [self removeMenuView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%lu-+%lu", indexPath.row, indexPath.section]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%lu-+%lu", indexPath.row, indexPath.section]];
        // 设置标题格式
        cell.textLabel.textColor = kSetRGBColor(39, 39, 39);
        cell.textLabel.font = self.font;
        cell.backgroundColor = [UIColor clearColor];
        // 设置菜单点击背景
//        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        // 移除最后一个cell的分割线
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        }
        
        // 设置菜单图标
        if (self.iconArray.count>0) {
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

#pragma mark- 控件懒加载
- (UIView *)menuBackView {
    if (!_menuBackView) {
        _menuBackView = [[UIView alloc] init];
        _menuBackView.backgroundColor = UIColor.whiteColor;
        // 添加菜单项
        [_menuBackView addSubview:self.menuTableView];
    }
    
    return _menuBackView;
}

- (UITableView *)menuTableView {
    
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:self.menuItemRect style:UITableViewStylePlain];
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.bounces = NO;
        _menuTableView.showsVerticalScrollIndicator = NO;
        _menuTableView.tableFooterView = [[UIView alloc] init];
        _menuTableView.backgroundColor = [UIColor clearColor];
        
        // 分割线颜色
//        _menuTableView.separatorColor = self.separatorColor;
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
