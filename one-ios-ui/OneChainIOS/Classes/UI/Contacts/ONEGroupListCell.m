//
//  ONEGroupListCell.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEGroupListCell.h"
@implementation ONEGroupListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    _avatarView = [[UIImageView alloc] init];
    _avatarView.layer.cornerRadius = 20.f;
    _avatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarView];
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    _nameLbl = [[UILabel alloc] init];
    _nameLbl.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:14.f];
    _nameLbl.themeMap = @{
                          TextColorName:@"conversation_title_color"
                          };
    _nameLbl.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLbl];
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_avatarView.mas_right).offset(15);
        make.centerY.equalTo(_avatarView);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.themeMap = @{
                      BGColorName:@"conversation_line_color"
                      };
//    line.backgroundColor = RGBACOLOR(233, 233, 239, 1);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@(0.5));
        make.width.mas_equalTo(@(KScreenW));
    }];
}

- (void)setInfo:(ONEChatGroup *)info
{
    _info = info;
    
    [_avatarView sd_setImageWithURL:_info.groupAvatarUrl placeholderImage:[UIImage imageNamed:@"group_default_avatar"]];
    _nameLbl.text = [NSString stringWithFormat:@"%@(%d)",_info.name, (int)_info.memberSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.themeMap = @{
                          BGColorName:@"bg_color"
                          };
    } else {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:highlighted];
    if (highlighted) {
        self.themeMap = @{
                          BGColorName:@"bg_color"
                          };
    } else {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
    }
}


@end
