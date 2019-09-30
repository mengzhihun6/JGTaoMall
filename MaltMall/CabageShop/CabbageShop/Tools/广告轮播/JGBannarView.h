//
//  JGBannarView.h
//  ZJBL-SJ
//
//  Created by 郭军 on 2017/10/13.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BannarTypePageControl = 0, //带PageControl
    BannarTypeNoPageControl  = 1,//不带PageControl
    BannarTypeUnknown,
} BannarType;


@interface JGBannarView : UIView

- (id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize Type:(BannarType)type;

@property (strong, nonatomic) NSArray *items;

@property (copy, nonatomic) void(^imageViewClick)(JGBannarView *barnerview,NSInteger index);

@property (copy, nonatomic) void(^DidEndDraggingImageView)(JGBannarView *barnerview,int index);
//图片切换 -------
@property (copy, nonatomic) void(^DidChangeImageView)(UIImage *image);


//点击图片
- (void)imageViewClick:(void(^)(JGBannarView *barnerview,NSInteger index))block;
//拖拽图片结束
- (void)DidEndDraggingImageView:(void(^)(JGBannarView *barnerview,int index))block;
//图片切换 -------
- (void)DidChangeImageView:(void(^)(UIImage *image))block;

NS_ASSUME_NONNULL_END
@end
