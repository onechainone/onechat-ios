/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseConversationCell.h"

#import "UIImageView+EMWebCache.h"

CGFloat const EaseConversationCellPadding = 10;

@interface EaseConversationCell()

@property (nonatomic) NSLayoutConstraint *titleWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *titleWithoutAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithoutAvatarLeftConstraint;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *officalTagView;

@end

@implementation EaseConversationCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseConversationCell *cell = [self appearance];
    cell.themeMap = @{
                      BGColorName:@"bg_white_color"
                      };
    cell.titleLabelColor = [UIColor blackColor];
    cell.titleLabelFont = /**[UIFont systemFontOfSize:17]*/[UIFont fontWithName:FONT_NAME_MEDIUM size:14.f];
    cell.detailLabelColor = [UIColor lightGrayColor];
    cell.detailLabelFont = /**[UIFont systemFontOfSize:15]*/[UIFont fontWithName:FONT_NAME_REGULAR size:14];
    cell.timeLabelColor = [UIColor blackColor];
    cell.timeLabelFont = /**[UIFont systemFontOfSize:13]*/[UIFont fontWithName:FONT_NAME_REGULAR size:13];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showAvatar = YES;
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        [self _setupSubview];
    }
    
    return self;
}

#pragma mark - private layout subviews

- (void)_setupSubview
{
    _avatarView = [[EaseImageView alloc] init];
    [[EaseImageView appearance] setImageCornerRadius:27.5];
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_avatarView];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.themeMap = @{
                                ImageName:@"conversation_group_mark"
                                };
//    UIImage *image = [UIImage imageNamed:@"conversation_group_icon"];
//    _iconImageView.image = image;
    [self.contentView addSubview:_iconImageView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.font = _timeLabelFont;
    _timeLabel.textColor = _timeLabelColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 1;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = _titleLabelFont;
    _titleLabel.textColor = _titleLabelColor;
    [self.contentView addSubview:_titleLabel];
    
    _officalTagView = [[UILabel alloc] init];
    _officalTagView.font = [UIFont fontWithName:FONT_NAME_REGULAR size:10];
    _officalTagView.textAlignment = NSTextAlignmentCenter;
    _officalTagView.text = NSLocalizedString(@"authority", @"");
    _officalTagView.themeMap = @{
                                 BGColorName:@"bg_white_color",
                                 TextColorName:@"theme_color",
                                 BorderColorName:@"theme_color"
                                 };
    _officalTagView.layer.borderWidth = .5f;
    _officalTagView.layer.cornerRadius = 3.f;
    _officalTagView.layer.masksToBounds = YES;
    _officalTagView.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_officalTagView];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = _detailLabelFont;
    _detailLabel.textColor = _detailLabelColor;
    [self.contentView addSubview:_detailLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.themeMap = @{
                           BGColorName:@"conversation_line_color"
                           };
    [self.contentView addSubview:_lineView];
    
    _unreadLbl = [[UILabel alloc] init];
    _unreadLbl.themeMap = @{
                            BGColorName:@"main_color",
                            TextColorName:@"unread_text_color"
                            };
    _unreadLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:12];
    _unreadLbl.layer.cornerRadius = 10;
    _unreadLbl.layer.masksToBounds = YES;
    _unreadLbl.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_unreadLbl];
    
    [self _setupAvatarViewConstraints];
    [self _setupTimeLabelConstraints];
    [self _setupIconImageViewConstraints];
    [self _setupTitleLabelConstraints];
    [self _setupOfficalTagConstraints];

    [self _setupDetailLabelConstraints];
    [self _setupUnreadLblConstraints];
    
}

#pragma mark - Setup Constraints

- (void)_setupOfficalTagConstraints
{
    [_officalTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_titleLabel.mas_right).offset(4);
        make.centerY.equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(27, 15));
    }];
}

- (void)_setupUnreadLblConstraints
{
    [_unreadLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(_detailLabel);
        make.width.mas_equalTo(@(WidthScale(30)));
        make.height.mas_equalTo(@20);
    }];
}

- (void)_setupIconImageViewConstraints
{
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView.mas_top).offset(EaseConversationCellPadding);
        make.left.equalTo(self.avatarView.mas_right).offset(EaseConversationCellPadding);
        make.size.mas_equalTo(CGSizeMake(20, 16));
    }];

}

- (void)_setupAvatarViewConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:18]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}

- (void)_setupTimeLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseConversationCellPadding]];
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
}

- (void)_setupTitleLabelConstraints
{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconImageView.mas_right).offset(2);
        make.centerY.equalTo(self.iconImageView);
        make.width.mas_lessThanOrEqualTo(@(WidthScale(160)));
    }];
    
}

- (void)_setupDetailLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:6]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseConversationCellPadding]];
    
    self.detailWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseConversationCellPadding];
    self.detailWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding];
    [self addConstraint:self.detailWithAvatarLeftConstraint];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(@0.5);
    }];
}

#pragma mark - setter

- (void)setShowAvatar:(BOOL)showAvatar
{
    if (_showAvatar != showAvatar) {
        _showAvatar = showAvatar;
        self.avatarView.hidden = !showAvatar;
        if (_showAvatar) {
            [self removeConstraint:self.titleWithoutAvatarLeftConstraint];
            [self removeConstraint:self.detailWithoutAvatarLeftConstraint];
            [self addConstraint:self.titleWithAvatarLeftConstraint];
            [self addConstraint:self.detailWithAvatarLeftConstraint];
        }
        else{
            [self removeConstraint:self.titleWithAvatarLeftConstraint];
            [self removeConstraint:self.detailWithAvatarLeftConstraint];
            [self addConstraint:self.titleWithoutAvatarLeftConstraint];
            [self addConstraint:self.detailWithoutAvatarLeftConstraint];
        }
    }
}

- (void)setModel:(id<IConversationModel>)model
{
    _model = model;
    
    if ([_model.title length] > 0) {
        self.titleLabel.text = _model.title;
    }
    else{
        self.titleLabel.text = _model.conversation.conversationId;
    }
    
    if (_model.group) {
        
        ONEChatGroup *info = _model.group;
        
        if (info.isOfficialGroup) {
            _officalTagView.hidden = NO;
        } else {
            _officalTagView.hidden = YES;

        }
    } else {
        _officalTagView.hidden = YES;
    }
    if (self.showAvatar) {
        if ([_model.avatarURLPath length] > 0){
            [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:_model.avatarURLPath] placeholderImage:_model.avatarImage];
        } else {
            if (_model.avatarImage) {
                self.avatarView.image = _model.avatarImage;
            }
        }
    }

    if (_model.unreadCount == 0) {
        _unreadLbl.hidden = YES;
    } else {
        _unreadLbl.hidden = NO;
        _unreadLbl.themeMap = @{
                                TextColorName:@"unread_text_color"
                                };
        _unreadLbl.text = [NSString stringWithFormat:@"%ld",_model.unreadCount];

    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_model.conversation.type == ONEConversationTypeChat) {
        
        [self.iconImageView setHidden:YES];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).offset(EaseConversationCellPadding);
            make.top.equalTo(self.contentView.mas_top).offset(EaseConversationCellPadding);
            make.width.mas_lessThanOrEqualTo(@(WidthScale(160)));
            
        }];
    } else {
        [self.iconImageView setHidden:NO];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(2);
            make.centerY.equalTo(self.iconImageView);
            make.width.mas_lessThanOrEqualTo(@(WidthScale(160)));
        }];
    }
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor
{
    _titleLabelColor = titleLabelColor;
//    _titleLabel.textColor = _titleLabelColor;
    _titleLabel.themeMap = @{
                             TextColorName:@"conversation_title_color"
                             };
}

- (void)setDetailLabelFont:(UIFont *)detailLabelFont
{
    _detailLabelFont = detailLabelFont;
    _detailLabel.font = _detailLabelFont;
}

- (void)setDetailLabelColor:(UIColor *)detailLabelColor
{
    _detailLabelColor = detailLabelColor;
    _detailLabel.themeMap = @{
                              TextColorName:@"conversation_detail_color"
                              };
//    _detailLabel.textColor = _detailLabelColor;
}

- (void)setTimeLabelFont:(UIFont *)timeLabelFont
{
    _timeLabelFont = timeLabelFont;
    _timeLabel.font = _timeLabelFont;
}

- (void)setTimeLabelColor:(UIColor *)timeLabelColor
{
    _timeLabelColor = timeLabelColor;
//    _timeLabel.textColor = _timeLabelColor;
    _timeLabel.themeMap = @{
                            TextColorName:@"conversation_time_color"
                            };
}

#pragma mark - class method

+ (NSString *)cellIdentifierWithModel:(id)model
{
    return @"EaseConversationCell";
}

+ (CGFloat)cellHeightWithModel:(id)model
{
    return EaseConversationCellMinHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (_model.unreadCount > 0) {
        self.unreadLbl.themeMap = @{
                                    BGColorName:@"main_color",
                                    TextColorName:@"unread_text_color"
                                    };
    }
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

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (_model.unreadCount > 0) {
        self.unreadLbl.themeMap = @{
                                    BGColorName:@"main_color",
                                    TextColorName:@"unread_text_color"
                                    };
    }
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
