//
//  ImageManager.h
//  CancerDo
//
//  Created by hugaowei on 16/6/14.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManager : NSObject

+(id)sharedImageManager;

/*
 * 生成指定大小的图片
 */
- (UIImage *)getThumbnailImage:(UIImage*)image withSize:(CGSize)size;

/*
 * 从图片数组获取一个缩略图片数组
 */

- (NSArray*)getThumbnailImageArrayFromArray:(NSArray*)imageArray withSize:(CGSize)size;

/*
 * 按比例获取一个图片
 */
- (UIImage*)getThumbnailImageWithScale:(UIImage*)image withSize:(CGSize)size;

/*
 * 按比例，从一组图片获取另一组图片
 */
- (NSArray*)getThumbnailWithArrayWithScale:(NSArray*)imageArray withSize:(CGSize)size;

/*
 *图片旋转
 */
- (UIImage*)rotationImage:(UIImage*)image;

/*
 *根据指定的size截取图片
 */

- (UIImage*)imageWithOriginImage:(UIImage*)image withSize:(CGSize)size;

@end






























