//
//  JGBannarView.m
//  ZJBL-SJ
//
//  Created by 郭军 on 2017/10/13.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "JGBannarView.h"
#import "UIImageView+WebCache.h"


#define MaxSections 100
/** 自定义颜色 */
#define JKRGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]



//=============================== Cell =======================================
@interface JGBannerCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation JGBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 图片的添加
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 8;
        _imageView.clipsToBounds = YES;
        
        [self.contentView addSubview:_imageView];
        
        
//        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.top.right.equalTo(self);
//        }];
    }
    return self;
}

@end


//=============================== JGBannarView =======================================
@interface JGBannarView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) UIPageControl *mypageControl;
@property (assign, nonatomic) CGSize viewSize;
@property (nonatomic, assign) BannarType type; //轮播图类型
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int PageIndex;

@property (nonatomic, strong) UIImageView *Imv;
@end


@implementation JGBannarView

- (UIImageView *)Imv {
    if (!_Imv) {
        _Imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_head_bg"]];
    }
    return _Imv;
}


- (void)dealloc{
    _imageViews = nil;
    
    if (self.type == BannarTypePageControl) {
        [self removeNSTimer];
    }
}

- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = @[].mutableCopy;
    }
    
    return _imageViews;
}


- (id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize Type:(BannarType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewSize = viewSize;
        self.PageIndex = -1;
        self.type = type;
        
        if (type == BannarTypePageControl) {
           [self addNSTimer];
        }
    }
    return self;
}
    
- (UICollectionView *)myCollectionView{
    
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.viewSize.width, self.viewSize.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height) collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.backgroundColor = [UIColor clearColor];
        //[_myCollectionView registerNib:[UINib nibWithNibName:@"JKBannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ID"];
        [_myCollectionView registerClass:[JGBannerCollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
        [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MaxSections / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        [self addSubview:_myCollectionView];
        _mypageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.viewSize.width-100)/2, self.viewSize.height-20, 100, 20)];
        _mypageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _mypageControl.pageIndicatorTintColor = JKRGBCOLOR(255, 255, 255, 0.64);
        if (self.type == BannarTypePageControl) {
            [self addSubview:_mypageControl];
        }
    }
    return _myCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return MaxSections;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JGBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_items[indexPath.row]] placeholderImage:[UIImage imageNamed:@"nav_head_bg"]];
    return cell;
}

- (void)setItems:(NSArray *)items{
    _items = items;
    if (_items.count<2) {
        self.myCollectionView.scrollEnabled = YES;
        [self.mypageControl setHidden:YES];
    }else{
        self.myCollectionView.scrollEnabled = YES;
        [self.mypageControl setHidden:NO];
    }
    
    [self.myCollectionView reloadData];
    self.mypageControl.numberOfPages = _items.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % _items.count;
    if (self.PageIndex == page) return;
    self.PageIndex = page;
    
    if (self.DidEndDraggingImageView) {
         self.DidEndDraggingImageView(self, page);
    }

    if (self.DidChangeImageView) {
        
        
        [self.Imv sd_setImageWithURL:_items[page] placeholderImage:[UIImage imageNamed:@"nav_head_bg"]];
        
        
        if (self.Imv.image) {
            self.DidChangeImageView(self.Imv.image);
        }
        
//        UIImage *img = [self getImageFromURL:_items[page]];
    }
    
    self.mypageControl.currentPage = page;
}

/** 通过URL地址从网上获取图片 */
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage *image;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    image = [UIImage imageWithData:data];
    return image;
}


#pragma mark -添加定时器
-(void)addNSTimer{
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)nextPage{
    
    if (_items.count<1 || self.type != BannarTypePageControl) {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.myCollectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathSet = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MaxSections / 2];
    [self.myCollectionView scrollToItemAtIndexPath:currentIndexPathSet atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    NSInteger nextItem = currentIndexPathSet.item + 1;
    NSInteger nextSection = currentIndexPathSet.section;
    if (nextItem == _items.count) {
        nextItem = 0;
        nextSection ++;
    }
    
//    if (self.DidChangeImageView) {
//        UIImage *img = [UIImage imageNamed:_items[nextItem]];
//        self.DidChangeImageView(img);
//    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.myCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.imageViewClick) {
        self.imageViewClick(self,indexPath.row);
    }
}


#pragma mark -删除定时器

-(void)removeNSTimer{
    [_timer invalidate];
    _timer =nil;
}

#pragma mark -当用户开始拖拽的时候就调用移除计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.type == BannarTypePageControl) {
        [self removeNSTimer];
    }
}

#pragma mark -当用户停止拖拽的时候调用添加定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.type == BannarTypePageControl) {
        [self addNSTimer];
    }
}


- (void)imageViewClick:(void (^)(JGBannarView *, NSInteger))block{
    self.imageViewClick = block;
}

//拖拽图片结束
- (void)DidEndDraggingImageView:(void(^)(JGBannarView *barnerview,int index))block {
    self.DidEndDraggingImageView = block;
}

//图片切换 -------
- (void)DidChangeImageView:(void(^)(UIImage *image))block {
    
    self.DidChangeImageView = block;
}


@end
