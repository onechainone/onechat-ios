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

#import "EaseUserCell.h"

#import "EaseImageView.h"
#import "UIImageView+EMWebCache.h"

CGFloat const EaseUserCellPadding = 10;

@interface EaseUserCell()

@property (nonatomic) NSLayoutConstraint *titleWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *titleWithoutAvatarLeftConstraint;

@end

@implementation EaseUserCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseUserCell *cell = [self appearance];
//    cell.titleLabelColor = [UIColor blackColor];
    cell.titleLabelFont = [UIFont systemFontOfSize:18];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        [self _setupSubview];
        
        UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:headerLongPress];
    }
    
    return self;
}

#pragma mark - private layout subviews

- (void)_setupSubview
{
    _avatarView = [[EaseImageView alloc] init];
    [_avatarView setImageCornerRadius:15.f];
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_avatarView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 2;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = _titleLabelFont;
//    _titleLabel.textColor = _titleLabelColor;
    _titleLabel.themeMap = @{
                             TextColorName:@"common_text_color"
                             };
    [self.contentView addSubview:_titleLabel];
    
    _unreadLabel = [[UILabel alloc] init];
    _unreadLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:12];
//    _unreadLabel.textColor = [UIColor whiteColor];
//    _unreadLabel.backgroundColor = [UIColor redColor];
    _unreadLabel.themeMap = @{
                              TextColorName:@"unread_text_color",
                              BGColorName:@"unread_bg_color"
                              };
    _unreadLabel.layer.cornerRadius = 10;
    _unreadLabel.textAlignment = NSTextAlignmentCenter;
    _unreadLabel.layer.masksToBounds = YES;
    _unreadLabel.hidden = YES;
    [self.contentView addSubview:_unreadLabel];
    
    [self _setupAvatarViewConstraints];
    [self _setupTitleLabelConstraints];
}

#pragma mark - Setup Constraints

- (void)_setupAvatarViewConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseUserCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseUserCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseUserCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    [_unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(39, 19));
    }];
}

- (void)_setupTitleLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseUserCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseUserCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseUserCellPadding]];
    
    self.titleWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseUserCellPadding];
    self.titleWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseUserCellPadding];
    [self addConstraint:self.titleWithAvatarLeftConstraint];
}

#pragma mark - setter

- (void)setShowAvatar:(BOOL)showAvatar
{
    if (_showAvatar != showAvatar) {
        _showAvatar = showAvatar;
        self.avatarView.hidden = !showAvatar;
        if (_showAvatar) {
            [self removeConstraint:self.titleWithoutAvatarLeftConstraint];
            [self addConstraint:self.titleWithAvatarLeftConstraint];
        }
        else{
            [self removeConstraint:self.titleWithAvatarLeftConstraint];
            [self addConstraint:self.titleWithoutAvatarLeftConstraint];
        }
    }
}

- (void)setModel:(id<IUserModel>)model
{
    _model = model;
    
    if ([_model.to_alias length] > 0) {
        self.titleLabel.text = _model.to_alias;
    } else if ([_model.nickname length] > 0){
       self.titleLabel.text = _model.nickname;
    } else {
        self.titleLabel.text = _model.buddy;
    }
    
    if ([_model.avatarURLPath length] > 0){
        [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[ONEUrlHelper userAvatarPrefix], _model.avatarURLPath]] placeholderImage:_model.avatarImage];
    } else {
        if (_model.avatarImage) {
            self.avatarView.image = _model.avatarImage;
        }
    }
}

- (void)setFriendModel:(ONEFriendModel *)friendModel
{
    _friendModel = friendModel;
    self.titleLabel.text = _friendModel.showName;
    [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:_friendModel.avatar_url] placeholderImage:[UIImage defaultAvaterImage]];
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor
{
    _titleLabelColor = titleLabelColor;
    _titleLabel.textColor = _titleLabelColor;
}

#pragma mark - class method

+ (NSString *)cellIdentifierWithModel:(id)model
{
    return @"EaseUserCell";
}

+ (CGFloat)cellHeightWithModel:(id)model
{
    return EaseUserCellMinHeight;
}

#pragma mark - action
- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellLongPressAtIndexPath:)])
        {
            [_delegate cellLongPressAtIndexPath:self.indexPath];
        }
    }
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
    if (!_unreadLabel.hidden) {
        
        _unreadLabel.themeMap = @{
                                 TextColorName:@"unread_text_color",
                                 BGColorName:@"unread_bg_color"
                                 };
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
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
    if (!_unreadLabel.hidden) {
        
        _unreadLabel.themeMap = @{
                                  TextColorName:@"unread_text_color",
                                  BGColorName:@"unread_bg_color"
                                  };
    }
}

@end
