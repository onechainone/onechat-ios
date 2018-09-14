//
//  LXDScrollView.m
//  LXDScrollView
//
//  Created by 林欣达 on 15/11/4.
//  Copyright © 2015年 sindri lin. All rights reserved.
//

#import "LXDScrollView.h"

@interface LXDScrollView ()

@property (nonatomic, assign) CGPoint maxOffset;   /*! scrollView最大滚动偏移坐标*/

@end


@implementation LXDScrollView

- (instancetype)initWithFrame: (CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.layer.masksToBounds = YES;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(scroll:)];
        [self addGestureRecognizer: pan];
    }
    return self;
}

- (void)scroll: (UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint move = [pan translationInView: pan.view];
        if (_contentSize.width == 0) { move.x = 0; }
        if (_contentSize.height == 0) { move.y = 0; }
        self.contentOffset = CGPointMake(self.bounds.origin.x - move.x, self.bounds.origin.y - move.y);
        [pan setTranslation: CGPointZero inView: pan.view];
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGRect bounds = self.bounds;
        bounds.origin.x = MAX(-_contentInsets.left, MIN(bounds.origin.x, _maxOffset.x + _contentInsets.right));
        bounds.origin.y = MAX(-_contentInsets.top, MIN(bounds.origin.y, _maxOffset.y + _contentInsets.bottom));
        if (!CGRectEqualToRect(bounds, self.bounds)) {
            [self restoreWithOffset: bounds.origin];
        }
    }
}

- (void)restoreWithOffset: (CGPoint)point
{
    CGFloat maxOffsetLength = MAX(fabs(self.bounds.origin.x - point.x), fabs(self.bounds.origin.y - point.y));
    [UIView animateWithDuration: maxOffsetLength * 0.0024f animations: ^{
        self.contentOffset = point;
    }];
}


#pragma mark - setter
/**
 *  设置偏移坐标
 */
- (void)setContentOffset: (CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    CGRect bounds = self.bounds;
    bounds.origin = contentOffset;
    self.bounds = bounds;
}

/**
 *  设置可滚动尺寸
 */
- (void)setContentSize: (CGSize)contentSize
{
    _contentSize = contentSize;
    _maxOffset = CGPointMake(MAX(-_contentInsets.left, contentSize.width - CGRectGetWidth(self.bounds)), MAX(-_contentInsets.top, contentSize.height - CGRectGetHeight(self.bounds)));
}

/**
 *  设置内容显示偏差
 */
- (void)setContentInsets: (UIEdgeInsets)contentInsets
{
    _contentInsets = contentInsets;
    self.contentOffset = CGPointMake(-contentInsets.left, -contentInsets.top);
}


@end
