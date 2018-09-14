//
//  ImageManager.m
//  CancerDo
//
//  Created by hugaowei on 16/6/14.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

static ImageManager *imageManager;

+(id)sharedImageManager{
    
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        imageManager = [[ImageManager alloc] init];
    });
    
    return imageManager;
}

- (UIImage *)getThumbnailImage:(UIImage*)image withSize:(CGSize)size{
    return [imageManager thumbnailImage:image withSize:size];
}

- (UIImage*)thumbnailImage:(UIImage*)image withSize:(CGSize)size{
    
    UIImage *newImage = nil;
    
    if (image != nil) {
        //打开上下文
        UIGraphicsBeginImageContext(size);
        //图片绘制到上下文上
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        //从上下文上取出新的图片
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

- (NSArray*)getThumbnailImageArrayFromArray:(NSArray*)imageArray withSize:(CGSize)size{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (UIImage *image in imageArray) {
        UIImage *thumbnailImage = [imageManager thumbnailImage:image withSize:size];
        [array addObject:thumbnailImage];
    }
    
    return array;
}

- (UIImage*)getThumbnailImageWithScale:(UIImage*)image withSize:(CGSize)size{
    return [imageManager thumbnailImageWithScale:image withSize:size];
}

- (UIImage*)thumbnailImageWithScale:(UIImage*)image withSize:(CGSize)size{
    UIImage *newImage = nil;
    if (image != nil) {
        CGSize oldSize = image.size;
        CGRect rect;
        if (size.width/size.height > oldSize.width/oldSize.height) {
            rect.size.width = size.height * (oldSize.width/oldSize.height);
            rect.size.height = size.height;
            rect.origin.x = (size.width - rect.size.width)/2;
            rect.origin.y = 0;
        }else{
            rect.size.width = size.width;
            rect.size.height = size.width * (oldSize.height/oldSize.width);
            rect.origin.x = 0;
            rect.origin.y = (size.height - rect.size.height)/2;
        }
        
        UIGraphicsBeginImageContext(size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        
        [image drawInRect:rect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

- (NSArray*)getThumbnailWithArrayWithScale:(NSArray*)imageArray withSize:(CGSize)size{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (UIImage *image in imageArray) {
        UIImage *thumbnailImage = [self thumbnailImageWithScale:image withSize:size];
        [array addObject:thumbnailImage];
    }
    
    return array;
}

- (UIImage*)rotationImage:(UIImage*)image{
    UIImage *newImage = nil;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if (image.imageOrientation == UIImageOrientationUp) {
        newImage = image;
    }else{
        switch (image.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
            {
                transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
            }
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            {
                transform = CGAffineTransformTranslate(transform, image.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
            }
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
            {
                transform = CGAffineTransformTranslate(transform, 0, image.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
            }
                break;
                
            default:
                break;
        }
        
        
        switch (image.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
            {
                transform = CGAffineTransformTranslate(transform, image.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
            }
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
            {
                transform = CGAffineTransformTranslate(transform, image.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
            }
                break;
                
            default:
                break;
        }
        
        CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height, CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), CGImageGetBitmapInfo(image.CGImage));
        CGContextConcatCTM(ctx, transform);
        
        switch (image.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
            {
                CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.height, image.size.width), image.CGImage);
            }
                break;
                
            default:
            {
                CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
            }
                break;
        }
        
        CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
        newImage = [UIImage imageWithCGImage:cgImage];
        CGContextRelease(ctx);
        CGImageRelease(cgImage);
    }
    
    return newImage;
}

- (UIImage*)imageWithOriginImage:(UIImage*)image withSize:(CGSize)size{
    if (image.size.width >= size.width || image.size.height >= size.height) {
        CGSize kSize = CGSizeZero;
        if (image.size.width/image.size.height >= 1) {
            CGFloat width;
            if (image.size.width > size.width) {
                width = size.width;
            }else{
                width = image.size.width;
            }
            
            CGFloat height = (width * image.size.height)/image.size.width;
            
            kSize = CGSizeMake(width, height);
        }else{
            CGFloat height;
            if (image.size.height > size.height) {
                height = size.height;
            }else{
                height = image.size.height;
            }
            
            CGFloat width = (height*image.size.width)/image.size.height;
            
            kSize = CGSizeMake(width, height);
        }
        
        return [self getThumbnailImageWithScale:image withSize:kSize];
    }else{
        return image;
    }
}


@end
