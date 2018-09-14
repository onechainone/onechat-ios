//
//  UIView+Animation.m
//  CancerDo
//
//  Created by chunzheng wang on 2017/5/8.
//  Copyright © 2017年 hepingtianxia. All rights reserved.
//

#import "UIView+Animation.h"
#import <objc/message.h>

@interface UIView () <CAAnimationDelegate>

@property (nonatomic, copy) void (^animStop)(void);

@end

@implementation UIView (Animation)

- (void)animationStartPoint:(CGPoint)start endPoint:(CGPoint)end didStopAnimation:(void (^)(void))event {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:start];
    [path addCurveToPoint:end controlPoint1:start controlPoint2:CGPointMake(start.x + 150, start.y + 10)];
    
    // 路径
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
//    animation.rotationMode = kCAAnimationRotateAuto;//路线动画加旋转
    
    // 缩放
    CABasicAnimation *scAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scAnimation.fromValue = @1;
    scAnimation.toValue = @0.2;
    scAnimation.autoreverses = YES;
    
    //旋转
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation3.fromValue = @(0);
    animation3.toValue = @(3 * M_PI);
    animation3.repeatCount = CGFLOAT_MAX;
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,scAnimation,animation3];
    groups.duration = 0.7; // 时间
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [self.layer addAnimation:groups forKey:nil];
    
    self.animStop = event;
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    !self.animStop ?: self.animStop();
}

- (void)setAnimStop:(void (^)(void))animStop {
    objc_setAssociatedObject(self, @"animStop", animStop, OBJC_ASSOCIATION_COPY);
}

- (void (^)(void))animStop {
    return objc_getAssociatedObject(self, @"animStop");
}

@end
