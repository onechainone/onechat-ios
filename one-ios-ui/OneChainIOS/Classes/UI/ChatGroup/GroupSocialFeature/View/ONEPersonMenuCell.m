//
//  ONEPersonMenuCell.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/12.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEPersonMenuCell.h"

@interface ONEPersonMenuCell()

@property (nonatomic, strong) UILabel *menuLbl;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ONEPersonMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    _menuLbl = [[UILabel alloc] init];
    _menuLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:14.f];
    _menuLbl.themeMap = @{
                          TextColorName:@"common_text_color"
                          };
//    _menuLbl.textColor = RGBACOLOR(51, 51, 51, 1);
    _menuLbl.textAlignment = NSTextAlignmentCenter;
    _menuLbl.numberOfLines = 0;
    
    [self.contentView addSubview:_menuLbl];
    [_menuLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.contentView);
    }];
    _lineView = [[UIView alloc] init];
//    _lineView.backgroundColor = RGBACOLOR(194, 194, 194, 1);
    _lineView.themeMap = @{
                           BGColorName:@"conversation_line_color"
                           };
    [self.contentView addSubview:_lineView];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(WidthScale(259));
    }];
}

- (void)setMenuTitle:(NSString *)menuTitle
{
    _menuTitle = menuTitle;
    if ([_menuTitle isEqualToString:NSLocalizedString(@"button_from_group_delete", @"")] || [_menuTitle isEqualToString:NSLocalizedString(@"button_add_blacklist", @"")]) {
        
//        [_menuLbl setTextColor:[UIColor colorWithHex:THEME_COLOR]];
        _menuLbl.themeMap = @{
                              TextColorName:@"theme_color"
                              };
    } else {
        
//        [_menuLbl setTextColor:RGBACOLOR(51, 51, 51, 1)];
       _menuLbl.themeMap = @{
          TextColorName:@"common_text_color"
          };
    }
    if ([_menuTitle isEqualToString:NSLocalizedString(@"button_cancel", @"")]) {
        
        [_lineView setHidden:YES];
    } else {
        [_lineView setHidden:NO];
    }
    _menuLbl.text = _menuTitle;
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
    [super setHighlighted:highlighted animated:animated];
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
