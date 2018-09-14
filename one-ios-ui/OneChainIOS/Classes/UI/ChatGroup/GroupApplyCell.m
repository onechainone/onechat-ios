//
//  GroupApplyCell.m
//  OneChainIOS
//
//  Created by lifei on 2018/3/6.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "GroupApplyCell.h"

#define kAVATAR_LEFT 18
#define kAVATAR_SIZE 44
#define kNICK_FONT_SIZE 14.f
#define kNICK_COLOR RGBACOLOR(48, 48, 48, 1)
#define kNICK_LEFT 11
#define kNICK_WIDTH WidthScale(166)
#define kUSERNAME_FONT_SIZE 12.f
#define kUSERNAME_COLOR RGBACOLOR(131, 131, 131, 1)
#define kAGREE_BTN_RIGHT WidthScale(12)
#define kREJECT_BTN_RIGHT WidthScale(8)

@interface GroupApplyCell()

@end

@implementation GroupApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self _initUI];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)_initUI
{
    _avatarView = [[UIImageView alloc] init];
    _avatarView.layer.cornerRadius = kAVATAR_SIZE / 2;
    _avatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarView];

    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(WidthScale(kAVATAR_LEFT));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kAVATAR_SIZE, kAVATAR_SIZE));
    }];

    _nickLbl = [[UILabel alloc] init];
    _nickLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kNICK_FONT_SIZE];
    _nickLbl.textColor = kNICK_COLOR;
    _nickLbl.textAlignment = NSTextAlignmentLeft;
    _nickLbl.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_nickLbl];
    
    [_nickLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_avatarView.mas_right).offset(kNICK_LEFT);
        make.top.equalTo(_avatarView);
        make.width.mas_equalTo(@(kNICK_WIDTH));
    }];

    _usernameLbl = [[UILabel alloc] init];
    _usernameLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kUSERNAME_FONT_SIZE];
    _usernameLbl.textColor = kUSERNAME_COLOR;
    _usernameLbl.textAlignment = NSTextAlignmentLeft;
    _usernameLbl.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_usernameLbl];
    
    [_usernameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.width.equalTo(_nickLbl);
        make.bottom.equalTo(_avatarView);
    }];
    
    _timeLbl = [[UILabel alloc] init];
    _timeLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kUSERNAME_FONT_SIZE];
    _timeLbl.textColor = kUSERNAME_COLOR;
    _timeLbl.textAlignment = NSTextAlignmentRight;
    _timeLbl.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_timeLbl];
    
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.nickLbl);
    }];
    
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"Group_Apply_Agree"] forState:UIControlStateNormal];
    _agreeBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LIGHT size:kUSERNAME_FONT_SIZE];
    [_agreeBtn setTitle:NSLocalizedString(@"button_agree", @"Agree") forState:UIControlStateNormal];
    [_agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    [_agreeBtn sizeToFit];
    [self.contentView addSubview:_agreeBtn];

    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-kAGREE_BTN_RIGHT);
        make.centerY.equalTo(self.usernameLbl);
        
    }];
    
    _rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rejectBtn setBackgroundImage:[UIImage imageNamed:@"Group_Apply_Reject"] forState:UIControlStateNormal];
    _rejectBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LIGHT size:kUSERNAME_FONT_SIZE];
    [_rejectBtn setTitle:NSLocalizedString(@"reject", @"reject") forState:UIControlStateNormal];
    [_rejectBtn addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rejectBtn];
    
    [_rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_agreeBtn.mas_left).offset(-kREJECT_BTN_RIGHT);
        make.centerY.equalTo(_agreeBtn);
    }];
}

- (void)setModel:(ONENotification *)model
{
    _model = model;

}

- (void)agreeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(didAgreedJoinGroup:)]) {
        [_delegate didAgreedJoinGroup:_model];
    }
}

- (void)rejectAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(didRejectJoinGroup:)]) {
        [_delegate didRejectJoinGroup:_model];
    }
}

@end
