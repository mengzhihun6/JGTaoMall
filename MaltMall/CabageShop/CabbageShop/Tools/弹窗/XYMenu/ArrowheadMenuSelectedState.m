//
//  ArrowheadMenuSelectedState.m
//  Pop-upMenu
//
//  Created by EastSun on 2018/3/19.
//  Copyright © 2018年 EastSun. All rights reserved.
//

#import "ArrowheadMenuSelectedState.h"

@interface ArrowheadMenuSelectedState ()<UITableViewDelegate, UITableViewDataSource>

/**
 菜单背景图
 */
@property (nonatomic, strong, ) UIView *menuBackView;

/**
 菜单项
 */
@property (nonatomic, strong) UITableView *menuTableView;

/**
 常态下标题数组
 */
@property (nonatomic, strong) NSArray *normalTitleArray;

/**
 选中状态下标题数组
 */
@property (nonatomic, strong) NSArray *selectedTitleArray;

/**
 常态下图标数组
 */
@property (nonatomic, strong) NSArray *normalIconArray;

/**
 选中状态下图标数组
 */
@property (nonatomic, strong) NSArray *selectedIconArray;

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
 常态下菜单字体颜色
 */
@property (nonatomic, strong) NSArray *normalTitleColor;

/**
 选中状态下菜单字体颜色
 */
@property (nonatomic, strong) NSArray *selectedTitleColor;

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

/**
 单选记录cell
 */
@property (nonatomic, strong) UITableViewCell *singleRecordCell;

@end

@implementation ArrowheadMenuSelectedState

- (instancetype)initDefaultArrowheadStatusMenuWithNormalTitle:(NSArray<NSString *> *)normalTitleArray selectedTitle:(NSArray<NSString *> *)selectedTitleArray normalIcon:(NSArray<NSString *> *)normalIconArray selectedIcon:(NSArray<NSString *> *)selectedIconArray menuNormalTitleColor:(UIColor *)normalTitleColor menuSelectedTitleColor:(UIColor *)selectedTitleColor menuPlacements:(MenuPlacements)placements {
    
    return [self initCustomArrowheadStatusMenuWithNormalTitle:normalTitleArray selectedTitle:selectedTitleArray normalIcon:normalIconArray selectedIcon:selectedIconArray menuNormalTitleColor:normalTitleColor menuSelectedTitleColor:selectedTitleColor menuUnitSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/3, 38) menuFont:[UIFont fontWithName:@"Helvetica" size:15.f] menuBackColor:[UIColor whiteColor] menuSegmentingLineColor:[UIColor colorWithRed:192/255.f green:196/255.f blue:201/255.f alpha:1] distanceFromTriggerSwitch:0 menuArrowStyle:MenuArrowStyleTriangle menuPlacements:placements showAnimationEffects:ShowAnimationZoom];
}

- (instancetype)initCustomArrowheadStatusMenuWithNormalTitle:(NSArray<NSString *> *)normalTitleArray selectedTitle:(NSArray<NSString *> *)selectedTitleArray normalIcon:(NSArray<NSString *> *)normalIconArray selectedIcon:(NSArray<NSString *> *)selectedIconArray menuNormalTitleColor:(UIColor *)normalTitleColor menuSelectedTitleColor:(UIColor *)selectedTitleColor menuUnitSize:(CGSize)size menuFont:(UIFont *)font menuBackColor:(UIColor *)menuBackColor menuSegmentingLineColor:(UIColor *)separatorColor distanceFromTriggerSwitch:(CGFloat)interval menuArrowStyle:(MenuArrowStyle)arrowStyle menuPlacements:(MenuPlacements)placements showAnimationEffects:(MenuShowAnimationStyle)animation {
    
    NSMutableArray *nTitleColorArray = [NSMutableArray array];
    NSMutableArray *sTitleColorArray = [NSMutableArray array];
    for (NSInteger i = 0; i < normalTitleArray.count; i ++) {
        [nTitleColorArray addObject:normalTitleColor];
        [sTitleColorArray addObject:selectedTitleColor];
    }
    
    return [self initCustomArrowheadStatusMenuWithNormalTitle:normalTitleArray selectedTitle:selectedTitleArray normalIcon:normalIconArray selectedIcon:selectedIconArray menuNormalTitleColorArray:nTitleColorArray menuSelectedTitleColorArray:sTitleColorArray menuUnitSize:size menuFont:font menuBackColor:menuBackColor menuSegmentingLineColor:separatorColor distanceFromTriggerSwitch:interval menuArrowStyle:arrowStyle menuPlacements:placements showAnimationEffects:animation];
}

- (instancetype)initCustomArrowheadStatusMenuWithNormalTitle:(NSArray<NSString *> *)normalTitleArray selectedTitle:(NSArray<NSString *> *)selectedTitleArray normalIcon:(NSArray<NSString *> *)normalIconArray selectedIcon:(NSArray<NSString *> *)selectedIconArray menuNormalTitleColorArray:(NSArray<UIColor *> *)normalTitleColorArray menuSelectedTitleColorArray:(NSArray<UIColor *> *)selectedTitleColorArray menuUnitSize:(CGSize)size menuFont:(UIFont *)font menuBackColor:(UIColor *)menuBackColor menuSegmentingLineColor:(UIColor *)separatorColor distanceFromTriggerSwitch:(CGFloat)interval menuArrowStyle:(MenuArrowStyle)arrowStyle menuPlacements:(MenuPlacements)placements showAnimationEffects:(MenuShowAnimationStyle)animation {
    
    self = [super init];
    if (self) {
        
        self.font = font;// 菜单字体
        self.separatorColor = separatorColor;
        self.menuBackColor = menuBackColor;// 菜单背景颜色
        self.normalTitleColor = normalTitleColorArray;// 常态下字体颜色
        self.selectedTitleColor = selectedTitleColorArray;// 选中状态下
        self.cellHeight = size.height;// 菜单单元格高度
        self.menuItemWidth = size.width;// 菜单项目宽度
        self.menuItemHeight = size.height*normalTitleArray.count;// 菜单项目高度
        self.interval = interval;// 菜单和触发按钮的间隔
        self.normalTitleArray = normalTitleArray;// 常态下标题
        self.selectedTitleArray = selectedTitleArray;// 选中状态下标题
        self.normalIconArray = normalIconArray;// 常态下图标
        self.selectedIconArray = selectedIconArray;// 选中状态下图标
        self.arrowStyle = arrowStyle;// 箭头风格
        self.placements = placements;// 展示位置
        self.animationStyle = animation; // 展示动画
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

#pragma mark- 定制并展示菜单
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 1、设置菜单遮罩层颜色
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
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

#pragma mark- 菜单TableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"\n\n\n点击菜单后的状态:%d", cell.selected);
    if (!self.allowsMultipleSelection && self.singleRecordCell == cell) {// 如果是单选菜单，且点击了处于选中状态下的单元，就把该单元的选中状态设置为NO
        [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
        self.singleRecordCell = nil;//置空
        return;
    } else if (!self.allowsMultipleSelection && self.singleRecordCell != cell) {// 记录cell
        self.singleRecordCell = cell;
    }

    cell.textLabel.textColor = self.selectedTitleColor[indexPath.row];
    if (self.selectedIconArray) {
        cell.imageView.image = [UIImage imageNamed:self.selectedIconArray[indexPath.row]];
    }
    
    // 1、通知代理处理点击事件
    if ([self.delegate respondsToSelector:@selector(menu:didClickedMenuItemUnitWithTag:andItemUnitTitle:itemiUnitPostClickState:)]) {
        [self.delegate menu:self didClickedMenuItemUnitWithTag:indexPath.row andItemUnitTitle:self.normalTitleArray[indexPath.row] itemiUnitPostClickState:YES];
    }
    // 2、移除菜单
    [self removeMenuView];
}

// 当点击处于选中状态下的cell时，调用该方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    
    NSLog(@"\n\n\n点击菜单后,cell变成非选中状态:%d", cell.selected);
    
    cell.textLabel.textColor = self.normalTitleColor[indexPath.row];
    if (self.normalIconArray) {
        cell.imageView.image = [UIImage imageNamed:self.normalIconArray[indexPath.row]];
    }
    // 1、通知代理处理点击事件
    if ([self.delegate respondsToSelector:@selector(menu:didClickedMenuItemUnitWithTag:andItemUnitTitle:itemiUnitPostClickState:)]) {
        [self.delegate menu:self didClickedMenuItemUnitWithTag:indexPath.row andItemUnitTitle:self.normalTitleColor[indexPath.row] itemiUnitPostClickState:NO];
    }
    // 2、移除菜单
    [self removeMenuView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%lu-+%lu", indexPath.row, indexPath.section]];
    cell.textLabel.font = self.font;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%lu-+%lu", indexPath.row, indexPath.section]];
        // 移除最后一个cell的分割线
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        }
        cell.backgroundColor = [UIColor clearColor];
        // 设置菜单点击背景
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 设置标题格式（默认为未选状态）
        cell.textLabel.textColor = self.normalTitleColor[indexPath.row];
        // 设置菜单图标（默认为未选状态）
        if (self.normalIconArray) {
            cell.imageView.image = [UIImage imageNamed:self.normalIconArray[indexPath.row]];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        // 设置菜单标题（默认为未选状态）
        cell.textLabel.text = self.normalTitleArray[indexPath.row];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.normalTitleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//MARK: 点击后去除自己的选中状态
- (void)whenClickedUncheckOwnStatus:(NSInteger)tag {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    UITableViewCell *cell = [self.menuTableView cellForRowAtIndexPath:indexPath];
    if (cell.selected) {
        cell.selected = NO;
        cell.textLabel.textColor = self.normalTitleColor[tag];
        if (self.normalIconArray) {
            cell.imageView.image = [UIImage imageNamed:self.normalIconArray[tag]];
        }
    }
    
}

#pragma mark- 控件懒加载
- (UIView *)menuBackView {
    if (!_menuBackView) {
        _menuBackView = [[UIView alloc] init];
        _menuBackView.backgroundColor = self.menuBackColor;
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
        _menuTableView.separatorColor = self.separatorColor;
        // 调整cell的分割线的位置
        _menuTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _menuTableView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _menuTableView.allowsMultipleSelection = self.allowsMultipleSelection;
        
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
