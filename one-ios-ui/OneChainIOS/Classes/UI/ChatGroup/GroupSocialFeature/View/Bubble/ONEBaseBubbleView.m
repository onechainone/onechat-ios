//
//  ONEBaseBubbleView.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEBaseBubbleView.h"
#define kAVATAR_LEFT 18
#define kAVATAR_SIZE 33
@implementation ONEBaseBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _layoutBasicUI];
    }
    return self;
}

- (void)_layoutBasicUI
{
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.layer.cornerRadius = kAVATAR_SIZE / 2;
    self.avatarView.layer.masksToBounds = YES;
    [self addSubview:self.avatarView];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(WidthScale(kAVATAR_LEFT));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kAVATAR_SIZE, kAVATAR_SIZE));
    }];
    
    self.timestampLbl = [[UILabel alloc] init];
    self.timestampLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:12.f];
    self.timestampLbl.textColor = RGBACOLOR(153, 153, 153, 1);
    self.timestampLbl.textAlignment = NSTextAlignmentRight;
    [self.timestampLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(15);
        make.right.equalTo(self.mas_right).offset(-12);
    }];
}

@end
