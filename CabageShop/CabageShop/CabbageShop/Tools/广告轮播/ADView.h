#import <UIKit/UIKit.h>

typedef void(^GoMainBlock)(NSString *);
typedef void(^didChangeBlock)(NSString *);

@interface ADView : UIView
@property (nonatomic,copy) GoMainBlock block;
@property (nonatomic,copy) didChangeBlock changeBlock;
//传一个frame 和 装有图片名字的数组过来
//参数一：frame
//参数二：装有图片名字的数组
//参数三：BOOL如果是YES，那么自动滚动，如果是NO不滚动
-(id)initWithFrame:(CGRect)frame andImageNameArray:(NSMutableArray *)imageNameArray andIsRunning:(BOOL)isRunning;
-(id)initWithFrame:(CGRect)frame andImageURLArray:(NSMutableArray *)imageNameArray andIsRunning:(BOOL)isRunning;
-(id)initWithFrame:(CGRect)frame andImageURLArray:(NSMutableArray *)imageNameArray;

-(id)initWithFrame:(CGRect)frame andImageURLArray2:(NSMutableArray *)imageNameArray andIsRunning:(BOOL)isRunning;

@end












