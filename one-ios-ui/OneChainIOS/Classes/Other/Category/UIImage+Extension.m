//
//  UIImage+Extension.m
//  
//
//  Created by nacker on 15-3-9.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImage:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

+ (UIImage *)clipImage:(UIImage *)image
{
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    //画圆：正切于上下文
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //设为裁剪区域
    [path addClip];
    //画图片
    [image drawAtPoint:CGPointZero];
    //生成一个新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)clipImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius
{
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    //画圆：正切于上下文
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height) cornerRadius:cornerRadius];
    //设为裁剪区域
    [path addClip];
    //画图片
    [image drawAtPoint:CGPointZero];
    //生成一个新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    KLog(@"上传头像压缩头像width=%f,height=%f",newImage.size.width, newImage.size.height);
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    if (!image) {
        return image;
    }
    if (kb<1) {
        return image;
    }
    
    kb *= 1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}
+ (UIImage *)imageFromColor:(UIColor *)color withCGRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageFromView:(UIView *)view
{
    CGSize s = view.bounds.size;
        
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
        
}
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

- (UIImage *)gtm_imageByResizingToSize:(CGSize)targetSize
                   preserveAspectRatio:(BOOL)preserveAspectRatio
                             trimToFit:(BOOL)trimToFit {
    CGSize imageSize = [self size];
    if (imageSize.height < 1 || imageSize.width < 1) {
        return nil;
    }
    if (targetSize.height < 1 || targetSize.width < 1) {
        return nil;
    }
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGFloat targetAspectRatio = targetSize.width / targetSize.height;
    CGRect projectTo = CGRectZero;
    if (preserveAspectRatio) {
        if (trimToFit) {
            // Scale and clip image so that the aspect ratio is preserved and the
            // target size is filled.
            if (targetAspectRatio < aspectRatio) {
                // clip the x-axis.
                projectTo.size.width = targetSize.height * aspectRatio;
                projectTo.size.height = targetSize.height;
                projectTo.origin.x = (targetSize.width - projectTo.size.width) / 2;
                projectTo.origin.y = 0;
            } else {
                // clip the y-axis.
                projectTo.size.width = targetSize.width;
                projectTo.size.height = targetSize.width / aspectRatio;
                projectTo.origin.x = 0;
                projectTo.origin.y = (targetSize.height - projectTo.size.height) / 2;
            }
        } else {
            // Scale image to ensure it fits inside the specified targetSize.
            if (targetAspectRatio < aspectRatio) {
                // target is less wide than the original.
                projectTo.size.width = targetSize.width;
                projectTo.size.height = projectTo.size.width / aspectRatio;
                targetSize = projectTo.size;
            } else {
                // target is wider than the original.
                projectTo.size.height = targetSize.height;
                projectTo.size.width = projectTo.size.height * aspectRatio;
                targetSize = projectTo.size;
            }
        } // if (clip)
    } else {
        // Don't preserve the aspect ratio.
        projectTo.size = targetSize;
    }
    
    projectTo = CGRectIntegral(projectTo);
    // There's no CGSizeIntegral, so we fake our own.
    CGRect integralRect = CGRectZero;
    integralRect.size = targetSize;
    targetSize = CGRectIntegral(integralRect).size;
    
    // Resize photo. Use UIImage drawing methods because they respect
    // UIImageOrientation as opposed to CGContextDrawImage().
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:projectTo];
    UIImage* resizedPhoto = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedPhoto;
}

- (UIImage *)addContextToImage:(NSString *)text
{
    UIImage *sourceImage = self;
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    CGFloat nameFont = 12.f;
    //画 自己想要画的内容
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]};
    CGRect sizeToFit = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, nameFont) options:NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
    NSLog(@"图片: %f %f",imageSize.width,imageSize.height);
    NSLog(@"sizeToFit: %f %f",sizeToFit.size.width,sizeToFit.size.height);
    CGContextSetFillColorWithColor(context, RGBACOLOR(30, 30, 30, 1).CGColor);
    [text drawAtPoint:CGPointMake((imageSize.width-sizeToFit.size.width)/2,imageSize.height - 19 - sizeToFit.size.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]}];
    //返回绘制的新图形
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)defaultImageWithSize:(CGSize)size
{
    return [UIImage imageFromColor:KRandomColor withCGRect:CGRectMake(0, 0, size.width, size.height)];
}

+ (UIImage *)defaultAvaterImage
{
    return [UIImage imageNamed:@"EaseUIResource.bundle/user"];
}

- (UIImage *)scaleImageWithSize:(CGSize)size
{
    
    if (CGSizeEqualToSize(size, self.size)) {
        return self;
    }
    
    //创建上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    
    //绘图
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
