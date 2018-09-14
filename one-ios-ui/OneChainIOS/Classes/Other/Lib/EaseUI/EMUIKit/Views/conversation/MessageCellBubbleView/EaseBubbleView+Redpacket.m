//
//  EaseBubbleView+Redpacket.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/20.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "EaseBubbleView+Redpacket.h"

static const CGFloat kMsg_left = 45.f;
static const CGFloat kMsg_top = 22.f;
static const CGFloat kMsg_right = 5.f;
static const CGFloat kMsg_height = 40.f;
static const CGFloat kCheck_bottom = 2.f;
static const CGFloat kBanner_left = 11.5;
static const CGFloat kBanner_bottom = 3;
static const CGFloat kRedBG_width = /**227.f*/120;
static const CGFloat kRedBG_height = /**80.f*/177;
#define kMsg_font [UIFont fontWithName:@"PingFangSC-Regular" size:9.6]
#define kCheck_font [UIFont fontWithName:@"PingFangSC-Regular" size:10.f]
#define kBanner_font [UIFont fontWithName:@"PingFangSC-Regular" size:8.f]

@implementation EaseBubbleView (Redpacket)

- (void)setupRedpacketBubbleView
{
    self.redBgView = [[UIImageView alloc] init];

    [self.backgroundImageView addSubview:self.redBgView];
    self.backgroundImageView.image = nil;
    [self.redBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.backgroundImageView);
        make.width.mas_equalTo(@(kRedBG_width));
        make.height.mas_equalTo(@(kRedBG_height));
    }];
    
    self.msgLabel = [[UILabel alloc] init];
    self.msgLabel.font = kMsg_font;
    self.msgLabel.textColor = RGBACOLOR(255, 221, 174, 1);
    self.msgLabel.numberOfLines = 2;
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
    [self.redBgView addSubview:self.msgLabel];

    [self _setupRedpacketConstraints];
}

- (void)_setupRedpacketConstraints
{

    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.redBgView.mas_top).offset(kMsg_top);
        make.centerX.equalTo(self.redBgView);
        make.width.lessThanOrEqualTo(self.redBgView);
        make.height.equalTo(@(kMsg_height));
    }];
}
@end
