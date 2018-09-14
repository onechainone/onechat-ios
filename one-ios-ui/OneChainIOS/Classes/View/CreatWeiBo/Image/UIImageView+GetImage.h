//
//  UIImageView+GetImage.h
//  CancerDo
//
//  Created by hugaowei on 2017/3/4.
//  Copyright © 2017年 hepingtianxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GetImage)

- (UIImage*)getScaleImageFromImage:(UIImage*)image withRect:(CGRect)f;

- (void)clipImageInImage:(UIImage *)image;

- (UIImage*)getImageFromImage:(UIImage*)image fromRect:(CGRect)f;

@end
