//
//  UIImage+Extension.h
//  
//
//  Created by nacker on 15-3-9.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithName:(NSString *)name;

+ (UIImage *)resizedImage:(NSString *)name;

+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/* 裁剪圆形图片 */
+ (UIImage *)clipImage:(UIImage *)image;

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

+ (UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb;
+ (UIImage *)imageFromColor:(UIColor *)color withCGRect:(CGRect)rect;

+ (UIImage *)imageFromView:(UIView *)view;

+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

+ (UIImage *)clipImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius;

- (UIImage *)gtm_imageByResizingToSize:(CGSize)targetSize
                   preserveAspectRatio:(BOOL)preserveAspectRatio
                             trimToFit:(BOOL)trimToFit;

- (UIImage *)addContextToImage:(NSString *)a_text;

+ (UIImage *)defaultImageWithSize:(CGSize)size;

+ (UIImage *)defaultAvaterImage;
- (UIImage *)scaleImageWithSize:(CGSize)size;
@end
