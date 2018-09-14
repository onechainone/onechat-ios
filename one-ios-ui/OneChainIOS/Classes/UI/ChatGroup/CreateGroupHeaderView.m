//
//  CreateGroupHeaderView.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/16.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "CreateGroupHeaderView.h"

static const CGFloat kDefaultFont = 15.f;
static const CGFloat kPadding = 10.f;

@implementation CreateGroupHeaderView

- (UIButton *)publicButton
{
    if (!_publicButton) {
        
        _publicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publicButton setImage:[UIImage imageNamed:@"rb_set_sex_normal"] forState:UIControlStateNormal];
        [_publicButton setImage:[UIImage imageNamed:@"rb_set_sex_selected"] forState:UIControlStateSelected];
        [_publicButton setTitle:NSLocalizedString(@"group_public", @"Public Group") forState:UIControlStateNormal];
        [_publicButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal && UIControlStateSelected];
        _publicButton.titleLabel.font = [UIFont systemFontOfSize:kDefaultFont];
        [_publicButton addTarget:self action:@selector(publicGroupChoosen:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publicButton;
}

- (UIButton *)privateButton
{
    if (!_privateButton) {
        
        _privateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_privateButton setImage:[UIImage imageNamed:@"rb_set_sex_normal"] forState:UIControlStateNormal];
        [_privateButton setImage:[UIImage imageNamed:@"rb_set_sex_selected"] forState:UIControlStateSelected];
        [_privateButton setTitle:NSLocalizedString(@"group_private", @"Private Group") forState:UIControlStateNormal];
        [_privateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal && UIControlStateSelected];
        _privateButton.titleLabel.font = [UIFont systemFontOfSize:kDefaultFont];
        [_privateButton addTarget:self action:@selector(privateGroupChoosen:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privateButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    UILabel *groupLabel = [[UILabel alloc] init];
    groupLabel.font = [UIFont systemFontOfSize:kDefaultFont];
    groupLabel.textColor = [UIColor grayColor];
    groupLabel.text = NSLocalizedString(@"group_type", @"Group Type");
    [self addSubview:groupLabel];
    
    [groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(kPadding);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(@((CGRectGetWidth(self.frame)- 2 * kPadding) / 3));
    }];
    
    [self addSubview:self.publicButton];
    [self.publicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(groupLabel.mas_right);
        make.top.bottom.width.equalTo(groupLabel);
    }];
    [self addSubview:self.privateButton];
    [self.privateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.publicButton.mas_right);
        make.top.bottom.width.equalTo(self.publicButton);
    }];
    
    [self.publicButton layoutIfNeeded];
    [self.privateButton layoutIfNeeded];
    
    [self.publicButton setSelected:YES];
}

- (void)publicGroupChoosen:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    self.privateButton.selected = !self.privateButton.isSelected;
}

- (void)privateGroupChoosen:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    self.publicButton.selected = !self.publicButton.isSelected;
}


@end
