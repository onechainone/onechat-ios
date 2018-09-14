//
//  EaseBubbleView+Transfer.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/18.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "EaseBubbleView+Transfer.h"

static const CGFloat kLabelFont = 22.f;
static const CGFloat kSLabelFont = 9.f;
static const CGFloat kHPadding = 5;
static const CGFloat kLeftPadding = 44;
static const CGFloat kBannerBottomPadding = 2;
static const CGFloat kBannerLeftPadding = 9;
@implementation EaseBubbleView (Transfer)

- (void)setupTransferBubbleView
{
    self.backView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"Group Transfer"];
    self.backView.image = image;
    [self.backView sizeToFit];
    self.backgroundImageView.image = nil;
    [self.backgroundImageView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.backgroundImageView);
    }];
    
    self.amountLabel = [[UILabel alloc] init];
    self.amountLabel.font = [UIFont boldSystemFontOfSize:kLabelFont];
    self.amountLabel.textColor = [UIColor whiteColor];
    self.amountLabel.adjustsFontSizeToFitWidth = YES;
    [self.backView addSubview:self.amountLabel];
    
    self.symbolLabel = [[UILabel alloc] init];
    self.symbolLabel.font = [UIFont boldSystemFontOfSize:kLabelFont];
    self.symbolLabel.textColor = [UIColor colorWithHex:TRANSFER_COLOR];
    [self.backView addSubview:self.symbolLabel];
    
    self.bannerLabel = [[UILabel alloc] init];
    self.bannerLabel.font = [UIFont systemFontOfSize:kSLabelFont];
    self.bannerLabel.text = NSLocalizedString(@"fast_transfer", @"");
    self.bannerLabel.textColor = [UIColor colorWithHex:THEME_COLOR];
    [self.backView addSubview:self.bannerLabel];
    
    [self _setupTransferBubbleMarginConstraints];
}

- (void)_setupTransferBubbleMarginConstraints
{
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backView.mas_left).offset(kLeftPadding);
        make.centerY.equalTo(self.backView.mas_centerY).offset(-kHPadding);
    }];
    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.amountLabel.mas_right).offset(kHPadding);
        make.right.lessThanOrEqualTo(self.backView.mas_right).offset(-kHPadding);
        make.centerY.equalTo(self.amountLabel);
    }];

    [self.symbolLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.amountLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.bannerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.backView.mas_bottom).offset(-kBannerBottomPadding);
        make.left.equalTo(self.backView.mas_left).offset(kBannerLeftPadding);
    }];
}


@end
