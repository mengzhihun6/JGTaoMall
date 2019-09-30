#import "UIColor+seting.h"

@implementation UIColor (seting)

+ (UIColor *)colorWithSeting:(uint)seting {
    int red, green, blue, alpha;
    
    red = ((seting & 0x00FF0000) >> 16);
    green = ((seting & 0x0000FF00) >> 8);
    blue = seting & 0x000000FF;
    alpha = ((seting & 0xFF000000) >> 24);
    
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha/100.0f];
}

+ (UIColor *)colorWithSetingNotAlpha:(uint)seting {
    
    int red, green, blue;
    
    red = ((seting & 0xFF0000) >> 16);
    green = ((seting & 0x00FF00) >> 8);
    blue = seting & 0x0000FF;
    
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                           blue:blue/255.0f
                           alpha:1.0];
}

@end
