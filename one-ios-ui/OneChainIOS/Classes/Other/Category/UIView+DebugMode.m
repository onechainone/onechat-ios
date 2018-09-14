//
//  UIView+DebugMode.m
//  OneChainIOS
//
//  Created by lifei on 2018/2/2.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "UIView+DebugMode.h"
#import <objc/runtime.h>
#define KDEBUG_TAP_COUNT 10

static char countKey;
static char rectKey;
static char tapKey;
@interface UIView()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger tapCount;

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation UIView (DebugMode)

- (void)switchToDebugModeWithTapRect:(CGRect)rect
{
//    if (CGRectEqualToRect(rect, CGRectNull)) {
//
//        return;
//    }
//    self.tapCount = 1;
//    self.rect = rect;
//    self.userInteractionEnabled = YES;
//    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    self.tap.delegate = self;
//    [self addGestureRecognizer:self.tap];
    
}

- (void)tapAction:(UITapGestureRecognizer *)gesture
{
//    if (gesture.state == UIGestureRecognizerStateEnded) {
//
//        CGPoint tapPoint = [gesture locationInView:self];
//        if (CGRectContainsPoint(self.rect, tapPoint)) {
//
//            if (self.tapCount == KDEBUG_TAP_COUNT) {
//
//                KLog(@"LF_LOG:点击10次切换模式");
//                [[self findViewController] showHint:@"MODE CHANGED"];
//                [ASMC setObject:@"1" forKey:MORE_ERROR_DESCRIPTION];
//                self.tapCount = 1;
//            } else {
//                KLog(@"LF_LOG:第%d次点击",self.tapCount);
//                self.tapCount ++;
//            }
//        }
//    }
}

- (void)removeDebugModeGesture
{
    [self removeGestureRecognizer:self.tap];
    self.tap = nil;
}

- (UITapGestureRecognizer *)tap
{
    return objc_getAssociatedObject(self, &tapKey);
}

- (void)setTap:(UITapGestureRecognizer *)tap
{
    objc_setAssociatedObject(self, &tapKey, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)tapCount
{
    return [objc_getAssociatedObject(self, &countKey) integerValue];
}

- (void)setTapCount:(NSInteger)tapCount
{
    NSString *s = [NSString stringWithFormat:@"%d",tapCount];
    objc_setAssociatedObject(self, &countKey, s, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)rect
{
    return CGRectFromString(objc_getAssociatedObject(self, &rectKey));
}

- (void)setRect:(CGRect)rect
{
    NSString *rectString = NSStringFromCGRect(rect);
    objc_setAssociatedObject(self, &rectKey, rectString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(UIViewController *)findViewController
{
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}


@end
