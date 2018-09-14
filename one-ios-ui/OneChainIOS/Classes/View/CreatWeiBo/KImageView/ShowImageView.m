//
//  ShowImageView.m
//  CancerDo
//
//  Created by hugaowei on 16/8/11.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "ShowImageView.h"

#define KButtonAbsY 18.0f// 行间隔
#define KButton_Height 26
#define KKOriginX 22
#define KRowsOfImage   3 // 行数
#define KColumnOfImage 3 // 列数
#define KBlackSpace    4

#define MaxNumberOfImages 9

@implementation ShowImageView

@synthesize imageViewsArray;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        imageViewsArray = [[NSMutableArray alloc] init];
        _imagesArray    = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        [self createNinePics];
    }
    
    return self;
}

- (void)createNinePics{
    CGFloat width = ((ScreenWidth-40) - (KColumnOfImage - 1)*KBlackSpace)/KColumnOfImage;
    
    CGFloat originX = 20;
    CGFloat originY = 0;
    
    for (int i = 0; i < MaxNumberOfImages; i++) {
        
        NSInteger k = i % KRowsOfImage;
        NSInteger m = i / KRowsOfImage;
        if (k == 0) {
            originX = 20;
        }else{
            originX = 20 + k*(width+KBlackSpace);
        }
        
        if (m == 0) {
            originY = 0;
        }else{
            originY = 0 + m*(width+KBlackSpace);
        }
        
        KImageView *imageView = [[KImageView alloc] initWithFrame:CGRectMake(originX, originY, width, width)];
        imageView.delegate = self;
        imageView.hidden = YES;
        imageView.showDeleteButton = YES;
        [imageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:imageView];
        [imageViewsArray addObject:imageView];
    }
}

- (void)reloadImages{
    for (int i = 0; i < imageViewsArray.count; i++) {
        KImageView *imageView = [imageViewsArray objectAtIndex:i];
        if (i < self.imagesArray.count) {
            NoteImageModel *image = [self.imagesArray objectAtIndex:i];
            imageView.kImage = image;
            imageView.hidden = NO;
        }else{
            imageView.hidden = YES;
        }
    }
    
    [UIView animateWithDuration:0
                     animations:^{
                         CGFloat height = 0;
                         if (self.imagesArray.count > 0) {
                             KImageView *imageView = [imageViewsArray objectAtIndex:(self.imagesArray.count - 1)];
                             height = CGRectGetMaxY(imageView.frame);
                         }
                         self.frame = CGRectMake(0, self.frame.origin.y, ScreenWidth, height);
                     }
                     completion:^(BOOL finished) {
                         if (self.delegate && [self.delegate respondsToSelector:@selector(superViewReload)]) {
                             [self.delegate superViewReload];
                         }
                     }];
}

#pragma mark KImageViewDelegate 删除图片
- (void)deleteImageFromImageView:(KImageView*)imageView{
    
    if ([self.imagesArray containsObject:imageView.kImage]) {
        [self.imagesArray removeObject:imageView.kImage];
    }
    
    [self reloadImages];
}

- (void)setShowDeleteButton:(BOOL)showDelete{
    if (_showDeleteButton != showDelete) {
        _showDeleteButton = showDelete;
    }
    
    for (KImageView *imageView in imageViewsArray) {
        imageView.showDeleteButton = _showDeleteButton;
    }
}

#pragma mark 浏览图片
- (void)scanImageView:(KImageView *)imageView{
    NSInteger index = [self.imageViewsArray indexOfObject:imageView];
    NSInteger total = self.imagesArray.count;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanImageView:withCurrentIndex:withTotalImageCount:)]) {
        [self.delegate scanImageView:imageView withCurrentIndex:index withTotalImageCount:total];
    }
}

+(CGFloat)getImagesHeightWithCount:(NSInteger)count{
    
    ShowImageView *showImageView = [[ShowImageView alloc] initWithFrame:CGRectZero];
    CGFloat height = 0;
    if (count > 0) {
        KImageView *imageView = [showImageView.imageViewsArray objectAtIndex:(count - 1)];
        height = CGRectGetMaxY(imageView.frame);
    }
    
    return height;
}

@end
