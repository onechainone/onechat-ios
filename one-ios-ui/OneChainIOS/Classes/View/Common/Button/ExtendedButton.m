//
//  ExtendedButton.m
//  OneChainIOS
//
//  Created by lifei on 2018/3/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ExtendedButton.h"

@implementation ExtendedButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds =self.bounds;
    
    CGFloat widthDelta =44.0- bounds.size.width;
    
    CGFloat heightDelta =44.0- bounds.size.height;
    
    bounds = CGRectInset(bounds, -0.5* widthDelta, -0.5* heightDelta);
    
    return CGRectContainsPoint(bounds, point);
}


@end
