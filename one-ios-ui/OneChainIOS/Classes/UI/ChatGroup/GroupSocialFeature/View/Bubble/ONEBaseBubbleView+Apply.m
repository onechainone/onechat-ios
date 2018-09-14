//
//  ONEBaseBubbleView+Apply.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEBaseBubbleView+Apply.h"

#define kNICK_FONT_SIZE 14.f
#define kNICK_COLOR RGBACOLOR(48, 48, 48, 1)
#define kNICK_LEFT 11
#define kNICK_TOP 12

#define kNICK_WIDTH WidthScale(166)
#define kUSERNAME_FONT_SIZE 12.f
#define kUSERNAME_COLOR RGBACOLOR(131, 131, 131, 1)
#define kAGREE_BTN_RIGHT WidthScale(12)
#define kREJECT_BTN_RIGHT WidthScale(8)

@implementation ONEBaseBubbleView (Apply)

- (void)setupApplyBubbleView
{

    self.nickLbl = [[UILabel alloc] init];
    self.nickLbl.font = [UIFont fontWithName:FONT_NAME_SEMIBOLD size:kNICK_FONT_SIZE];
    self.nickLbl.textColor = kNICK_COLOR;
    self.nickLbl.textAlignment = NSTextAlignmentLeft;
    self.nickLbl.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.nickLbl];
    [self.nickLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.avatarView.mas_right).offset(kNICK_LEFT);
        make.top.equalTo(self.mas_top).offset(kNICK_TOP);
        make.width.mas_equalTo(@(kNICK_WIDTH));
    }];
    
    self.usernameLbl = [[UILabel alloc] init];
    self.usernameLbl.font = [UIFont fontWithName:FONT_NAME_LIGHT size:kUSERNAME_FONT_SIZE];
    self.usernameLbl.textColor = kUSERNAME_COLOR;
    self.usernameLbl.textAlignment = NSTextAlignmentLeft;
    self.usernameLbl.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.usernameLbl];
    
    [self.usernameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.width.equalTo(self.nickLbl);
        make.bottom.equalTo(self.avatarView);
    }];
    
    
    self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"Group_Apply_Agree"] forState:UIControlStateNormal];
    self.agreeBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LIGHT size:kUSERNAME_FONT_SIZE];
    [self.agreeBtn setTitle:NSLocalizedString(@"button_agree", @"Agree") forState:UIControlStateNormal];
    [self.agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.agreeBtn sizeToFit];
    [self addSubview:self.agreeBtn];
    
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-kAGREE_BTN_RIGHT);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    self.rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rejectBtn setBackgroundImage:[UIImage imageNamed:@"Group_Apply_Reject"] forState:UIControlStateNormal];
    self.rejectBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LIGHT size:kUSERNAME_FONT_SIZE];
    [self.rejectBtn setTitle:NSLocalizedString(@"reject", @"reject") forState:UIControlStateNormal];
    [self.rejectBtn addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rejectBtn];
    
    [self.rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.agreeBtn.mas_left).offset(-kREJECT_BTN_RIGHT);
        make.centerY.equalTo(self.agreeBtn);
    }];
}
@end
