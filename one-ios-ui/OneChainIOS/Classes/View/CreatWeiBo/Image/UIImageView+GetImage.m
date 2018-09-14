//
//  UIImageView+GetImage.m
//  CancerDo
//
//  Created by hugaowei on 2017/3/4.
//  Copyright © 2017年 hepingtianxia. All rights reserved.
//

#import "UIImageView+GetImage.h"

@implementation UIImageView (GetImage)

- (UIImage*)getScaleImageFromImage:(UIImage*)image withRect:(CGRect)f{
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(f);
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)clipImageInImage:(UIImage *)image{
    
    CGFloat originWidth  = self.frame.size.width;
    CGFloat originHeight = self.frame.size.height;
    
    CGFloat width_scale  = image.size.width/originWidth;
    CGFloat height_scale = image.size.height/originHeight;
    
    if (width_scale > 1) {
        originWidth = image.size.width;
        originHeight = originWidth *(self.frame.size.height/self.frame.size.width);
        if (originHeight > image.size.height) {
            originHeight = image.size.height;
            originWidth  = originHeight *(self.frame.size.width/self.frame.size.height);
        }
    }else{
        if (height_scale > 1) {
            originHeight = image.size.height;
            originWidth = originHeight*(self.frame.size.width/self.frame.size.height);
            if (originWidth > image.size.width) {
                originWidth = image.size.width;
                originHeight  = originWidth *(self.frame.size.height/self.frame.size.width);
            }
        }
    }
    
    CGFloat originX = (image.size.width - originWidth)*0.5;
    if (originX < 0) {
        originX = 0;
    }
    
    CGFloat originY = (image.size.height - originHeight)*0.5;
    if (originY < 0) {
        originY = 0;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(originX, originY, originWidth, originHeight));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    self.image = thumbScale;
}

- (UIImage*)getImageFromImage:(UIImage*)image fromRect:(CGRect)f{
    
    CGFloat originWidth  = f.size.width;
    CGFloat originHeight = f.size.height;
    
    CGFloat width_scale  = image.size.width/originWidth;
    CGFloat height_scale = image.size.height/originHeight;
    
    if (width_scale > 1) {
        originWidth = image.size.width;
        originHeight = originWidth *(f.size.height/f.size.width);
        if (originHeight > image.size.height) {
            originHeight = image.size.height;
            originWidth  = originHeight *(f.size.width/f.size.height);
        }
    }else{
        if (height_scale > 1) {
            originHeight = image.size.height;
            originWidth = originHeight*(f.size.width/f.size.height);
            if (originWidth > image.size.width) {
                originWidth = image.size.width;
                originHeight  = originWidth *(f.size.height/f.size.width);
            }
        }
    }
    
    CGFloat originX = (image.size.width - originWidth)*0.5;
    if (originX < 0) {
        originX = 0;
    }
    
    CGFloat originY = (image.size.height - originHeight)*0.5;
    if (originY < 0) {
        originY = 0;
    }

    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(originX, originY, originWidth, originHeight));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return thumbScale;
}

@end
