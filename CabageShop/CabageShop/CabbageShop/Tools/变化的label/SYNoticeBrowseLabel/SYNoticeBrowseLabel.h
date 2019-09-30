//
//  SYNoticeBrowseLabel.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/5/22.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 公告标题数组播放模式（只有一个标题时，静止不播放，或横向播放；有多个标题时，向上滚动播放）
typedef NS_ENUM(NSInteger, SYNoticeBrowseMode)
{
    /// 公告标题数组播放模式 只有一个标题时，静止不播放
    SYNoticeBrowseDefalut = 0,
    
    /// 公告标题数组播放模式 只有一个标题时，横向播放
    SYNoticeBrowseHorizontalScrollWhileSingle = 1,
    
    /// 公告标题数组播放模式 有多个标题时，向上滚动播放
    SYNoticeBrowseVerticalScrollWhileMore = 2,
};

@interface SYNoticeBrowseLabel : UIView

/// 禁止使用
- (instancetype)init __attribute__((unavailable("init 方法不可用，请用 initWithName:")));
/// 内存释放（避免定时器造成内存泄露）
- (void)releaseNotice;
/// 刷新信息
- (void)reloadData;


/// 图标系统
@property (nonatomic, strong) NSArray <UIImage *> *images;

/// 公告标题数组（默认无）
@property (nonatomic, strong) NSString *title;
/// 公告标题字体大小（默认12.0）
@property (nonatomic, strong) UIFont *titleFont;
/// 公告标题字体颜色（默认黑色）
@property (nonatomic, strong) UIColor *titleColor;

/// 公告标题与内容分割线颜色（默认灰色，当且公当公告标题存在时才有效）
@property (nonatomic, strong) UIColor *lineColor;

/// 公告内容
@property (nonatomic, strong) NSArray <NSString *> *texts;
/// 公告标题数组播放模式（只有一个标题时，静止不播放，或横向播放；有多个标题时，向上滚动播放）
@property (nonatomic, assign) SYNoticeBrowseMode browseMode;
/// 公告内容字体大小（默认13.0）
@property (nonatomic, strong) UIFont *textFont;
/// 公告内容字体颜色（默认黑色）
@property (nonatomic, strong) UIColor *textColor;

/// 点击文本时是否暂停动画（默认不停NO）
@property (nonatomic, assign) BOOL textAnimationPauseWhileClick;
/// 开始动画（默认8.0）
@property (nonatomic, assign) NSTimeInterval durationTime;
/// 延迟动画时间（默认0.0）
@property (nonatomic, assign) NSTimeInterval delayTime;

/// 点击文本响应回调（index多个滚屏轮播时有效）
@property (nonatomic, copy) void (^textClick)(NSInteger index);
/// 更多响应按钮（默认NO，不显示）
@property (nonatomic, assign) BOOL showMoreButton;
/// 更多响应按钮
@property (nonatomic, strong) UIButton *button;
/// 更多响应回调
@property (nonatomic, copy) void (^moreClick)(UIButton *button);

@end
