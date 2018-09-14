//
//  ONENormalApplyCell.m
//  OneChainIOS
//
//  Created by lifei on 2018/6/1.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONENormalApplyCell.h"
#define kNICK_LEFT 11
#define kNICK_WIDTH WidthScale(166)

@implementation ONENormalApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)_initUI {
    
    [super _initUI];
    self.nickLbl.themeMap = @{
                              TextColorName:@"conversation_title_color"
                              };
    self.usernameLbl.themeMap = @{
                                      TextColorName:@"conversation_detail_color"
                                      };
    self.timeLbl.themeMap = @{
                              TextColorName:@"conversation_time_color"
                              };
    self.nickLbl.adjustsFontSizeToFitWidth = NO;
    self.nickLbl.numberOfLines = 0;
    [self.nickLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.avatarView.mas_right).offset(kNICK_LEFT);
        make.top.equalTo(self.avatarView);
        make.width.mas_equalTo(@(kNICK_WIDTH));
        make.height.lessThanOrEqualTo(@50);
    }];
    [self.timeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.nickLbl);
    }];
    [self.agreeBtn setTitle:NSLocalizedString(@"button_agree", @"") forState:UIControlStateNormal];

    _agreedLabel = [[UILabel alloc] init];
    _agreedLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:12.f];
    _agreedLabel.textColor = DEFAULT_GRAY_COLOR;
    _agreedLabel.textAlignment = NSTextAlignmentLeft;
    [_agreedLabel setHidden:YES];
    [self.contentView addSubview:_agreedLabel];
    [_agreedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.width.equalTo(self.nickLbl);
        make.top.equalTo(self.nickLbl.mas_bottom).offset(2);
        make.height.mas_lessThanOrEqualTo(@30);
    }];
}





- (void)setApplyModel:(id)applyModel
{
    _applyModel = applyModel;
    if ([_applyModel isKindOfClass:[ONEFriendApply class]]) {
        ONEFriendApply *apply = (ONEFriendApply *)_applyModel;
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[ONEUrlHelper userAvatarPrefix],apply.avatar_url]] placeholderImage:[UIImage defaultAvaterImage]];
        self.nickLbl.text = [NSString stringWithFormat:@"%@%@",apply.nickname, NSLocalizedString(@"apply_add_friend", @"")];
        self.timeLbl.text = [NSDate formattedTimeFromTimeInterval:apply.create_time];
        if (apply.status == ApplyStatus_agreed) {
            
            [self.agreeBtn setHidden:YES];
            [self.rejectBtn setHidden:YES];
            [self.timeLbl setHidden:YES];
            [self.agreedLabel setHidden:NO];
        } else {
            
            [self.nickLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.avatarView.mas_right).offset(kNICK_LEFT);
                make.top.equalTo(self.avatarView);
                make.width.mas_equalTo(@(200));
                make.height.lessThanOrEqualTo(@50);
            }];
            [self.agreeBtn setHidden:NO];
            [self.rejectBtn setHidden:NO];
            [self.timeLbl setHidden:YES];
            [self.agreedLabel setHidden:NO];
            self.agreedLabel.text = apply.remark;
        }
    } else if ([_applyModel isKindOfClass:[ONEGroupInvitation class]]) {
        
        ONEGroupInvitation *invation = (ONEGroupInvitation *)_applyModel;
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:invation.avatar_url] placeholderImage:[UIImage defaultAvaterImage]];
        self.nickLbl.text = [NSString stringWithFormat:@"%@%@%@",invation.nickname, NSLocalizedString(@"invite_you_join_group", @""), invation.group_name];
        self.timeLbl.text = [NSDate formattedTimeFromTimeInterval:invation.create_time];
        if ([invation.user_status isEqualToString:@"INIT"]) {
            
            [self.nickLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.avatarView.mas_right).offset(kNICK_LEFT);
                make.top.equalTo(self.avatarView);
                make.width.mas_equalTo(@(kNICK_WIDTH));
                //        make.height.lessThanOrEqualTo(@50);
            }];
            [self.agreeBtn setHidden:NO];
            [self.rejectBtn setHidden:NO];
            [self.timeLbl setHidden:NO];
            [self.agreedLabel setHidden:YES];
        }
    } 
}



- (void)agreeAction
{
    !_acceptBlock ?: _acceptBlock(_applyModel);
}

- (void)rejectAction
{
    !_rejectBlock ?: _rejectBlock(_applyModel);
}

@end
