//
//  ONEArticleImageView.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/9.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEArticleImageView.h"
#define kNUMBEROFROW 3
#define kPADDING 10
@interface ONEArticleImageView()

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *imageViews;
@end

@implementation ONEArticleImageView

//
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageViews = [NSMutableArray array];
        _images = images;
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    CGFloat imageWidth = (self.width - 2 * kPADDING) / kNUMBEROFROW;
    NSInteger imageCount = _images.count;

    [self.imageViews removeAllObjects];
    for (NSInteger i = 0; i < imageCount; i++) {
        
        int row = i / kNUMBEROFROW;
        int col = i % kNUMBEROFROW;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(col *(kPADDING + imageWidth), row *(kPADDING + imageWidth), imageWidth, imageWidth)];
//        imageView.image = [UIImage imageNamed:@""];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
    }
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)reloadImages:(NSArray *)images
{
    if ([images count] == 0 || [images count] != [self.imageViews count]) {
        return;
    }
    for (NSInteger i = 0; i < [self.imageViews count]; i ++) {
        
        UIImageView *imageView = self.imageViews[i];
        NSString *url = images[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                UIImage *newImage = [image gtm_imageByResizingToSize:imageView.frame.size preserveAspectRatio:YES trimToFit:YES];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    imageView.image = newImage;
//                });
//
//            });
        }];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint point = [gesture locationInView:self];
        
        __block NSUInteger index = -1;
        [self.imageViews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (CGRectContainsPoint(imageView.frame, point)) {
                
                index = idx;
                *stop = YES;
            }
        }];
        !_imageSelectBlock ?: _imageSelectBlock(index);
    }
}

@end
