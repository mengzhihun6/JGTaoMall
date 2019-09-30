//
//  superCollectionViewCell.m
//  MyNewProject
//
//  Created by 赵马刚 on 2018/12/19.
//  Copyright © 2018 sun. All rights reserved.
//

#import "superCollectionViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define SKColorWithHex(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

@interface superCollectionViewCell()

@property(nonatomic,strong)UIImageView *iconImageview;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *identifyingImageview;

@end
@implementation superCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:255];
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    _iconImageview = [UIImageView new];
    //_iconImageview.backgroundColor = [UIColor redColor];
    _iconImageview.image = [UIImage imageNamed:@"icon"];
    [self.contentView addSubview:_iconImageview];
    [_iconImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.height.mas_equalTo(40);
      make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-10);
    }];
    _titleLabel = [UILabel new];
    _titleLabel.text = @"红包大回馈";
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self->_iconImageview.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(1);
        make.top.mas_equalTo(self->_iconImageview.mas_bottom).offset(9);
        make.height.mas_equalTo(17);
    }];
    _identifyingImageview = [UIImageView new];
    _identifyingImageview.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_identifyingImageview];
    [_identifyingImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.width.height.mas_equalTo(29);
    }];
    _identifyingImageview.hidden = YES;
}
- (void)setEntranceDic:(NSDictionary *)entranceDic{
    _entranceDic = entranceDic;
    [_iconImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_entranceDic[@"Privillogo"]]] placeholderImage:[UIImage imageNamed:@"icon"]];
    _titleLabel.text = entranceDic[@"Privilname"];

}
-(void)setBorderWithDirection:(SYCellBorderDirection)direction{
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.lineWidth = 1;
    layer.borderWidth =1;
    CGRect rect = self.contentView.bounds;
    layer.strokeColor = SKColorWithHex(0xDEDEDE).CGColor;
    
    
    UIBezierPath*path = [[UIBezierPath alloc]init];
    
    // SYCellBorderDirection *dir = SYCellBorderDirectionTop|SYCellBorderDirectionBottom|SYCellBorderDirectionRight|SYCellBorderDirectionLeft
    if (direction & SYCellBorderDirectionTop) {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(rect.size.width, 0)];
        
        layer.path = path.CGPath;
        
        [self.contentView.layer addSublayer:layer];
        
    }
    if (direction & SYCellBorderDirectionBottom) {
        [path moveToPoint:CGPointMake(0, rect.size.height)];
        
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        
        layer.path = path.CGPath;
        
        [self.contentView.layer addSublayer:layer];
        
    }
    if (direction & SYCellBorderDirectionRight) {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(0, rect.size.height)];
        
        layer.path = path.CGPath;
        
        [self.contentView.layer addSublayer:layer];
        
    }
    if (direction & SYCellBorderDirectionLeft) {
        [path moveToPoint:CGPointMake(rect.size.width, 0)];
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        
        layer.path = path.CGPath;
        
        [self.contentView.layer addSublayer:layer];
        
    }
    
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    NSLog(@"===============%ld",(long)self.tag);
    if ((self.tag/3)==0) {
        [self setBorderWithDirection:SYCellBorderDirectionBottom|SYCellBorderDirectionRight|SYCellBorderDirectionTop];
    }
    if ((self.tag/3)>0) {
        [self setBorderWithDirection:SYCellBorderDirectionBottom|SYCellBorderDirectionRight];
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
