//
//  UIView+Animation.h
//  CancerDo
//
//  Created by chunzheng wang on 2017/5/8.
//  Copyright © 2017年 hepingtianxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void)animationStartPoint:(CGPoint)start endPoint:(CGPoint)end didStopAnimation:(void(^)(void)) event;

@end
