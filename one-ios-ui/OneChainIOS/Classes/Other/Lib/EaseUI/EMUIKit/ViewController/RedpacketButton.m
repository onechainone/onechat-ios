//
//  RedpacketButton.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/21.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "RedpacketButton.h"

static const CGFloat KBUTTON_IMAGE_WIDTH = 30;
static const CGFloat KBUTTON_TITTLE_LEFT = 35;
#define KBUTTON_TITTLE_COLOR [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1/1.0]
@implementation RedpacketButton


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, KBUTTON_IMAGE_WIDTH, KBUTTON_IMAGE_WIDTH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(KBUTTON_TITTLE_LEFT, contentRect.origin.y, contentRect.size.width, contentRect.size.height);
}

@end
