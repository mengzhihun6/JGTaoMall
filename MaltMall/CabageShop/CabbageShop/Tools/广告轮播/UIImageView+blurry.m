//
//  UIImageView+blurry.m
//  图片的模糊处理
//
//  Created by 梁森 on 2018/3/20.
//  Copyright © 2018年 梁森. All rights reserved.
//

#import "UIImageView+blurry.h"

#import <Accelerate/Accelerate.h>
@implementation UIImageView (blurry)
/**
 *  对图片进行模糊
 *
 *  @param image 要处理图片
 *  @param blur  模糊系数 (0.0-1.0)
 *
 *  @return 处理后的图片
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (!image) {
        return nil;
    }
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 200);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (UIImage *)blurryCoreImage:(UIImage *)image withBlurLevel:(CGFloat)blur{
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //获取一张图片(本地或网络图片)
    CIImage * inputImg = [[CIImage alloc] initWithImage:image];
    //创建滤镜
    CIFilter * filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    //设置滤镜输入图片
    [filter setValue:inputImg forKey:kCIInputImageKey];
    //设置模糊效果大小
    [filter setValue:@10 forKey:@"inputRadius"];
    //获取滤镜输出图片
    CIImage * outputImg = [filter valueForKey:kCIOutputImageKey];
    //通过CIImage创建CGImage  大小如果使用 outputImg.extent结果会有白边
    CGImageRef cgImage = [context createCGImage:outputImg fromRect:inputImg.extent];
    //通过CGImage创建UIImage
    UIImage * resultImg = [UIImage imageWithCGImage:cgImage];
    return resultImg;
}

@end
