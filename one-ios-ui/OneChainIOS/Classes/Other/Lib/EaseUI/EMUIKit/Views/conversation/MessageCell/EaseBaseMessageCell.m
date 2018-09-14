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

#import "EaseBaseMessageCell.h"

#import "UIImageView+EMWebCache.h"

@interface EaseBaseMessageCell()

@property (strong, nonatomic) UILabel *nameLabel;

@property (nonatomic) NSLayoutConstraint *avatarWidthConstraint;
@property (nonatomic) NSLayoutConstraint *nameHeightConstraint;

@property (nonatomic) NSLayoutConstraint *bubbleWithAvatarRightConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleWithoutAvatarRightConstraint;

@property (nonatomic) NSLayoutConstraint *bubbleWithNameTopConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleWithoutNameTopConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleWithImageConstraint;

@end

@implementation EaseBaseMessageCell

@synthesize nameLabel = _nameLabel;

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseBaseMessageCell *cell = [self appearance];
    cell.avatarSize = 30;
    cell.avatarCornerRadius = 0;
    
    cell.messageNameColor = [UIColor grayColor];
    cell.messageNameFont = [UIFont systemFontOfSize:10];
    cell.messageNameHeight = 15;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        cell.messageNameIsHidden = NO;
    }
    
//    cell.bubbleMargin = UIEdgeInsetsMake(8, 15, 8, 10);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = _messageNameFont;
        _nameLabel.textColor = _messageNameColor;
        
        [self.contentView addSubview:_nameLabel];
        
        [self configureLayoutConstraintsWithModel:model];
        
        if ([UIDevice currentDevice].systemVersion.floatValue == 7.0) {
            self.messageNameHeight = 15;
        }
    }
    
    return self;
}
- (CGFloat)widthFromDuration:(CGFloat)duration
{
    CGFloat minWidth = 4;
    CGFloat maxWidth = 150;
    
    CGFloat singleWidth = (maxWidth - minWidth) / 60;
    
    CGFloat width = singleWidth * duration;
    if (width > maxWidth) {
        width = maxWidth;
    }
    if (width < minWidth) {
        
        width = minWidth;
    }
    return width;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    _bubbleView.backgroundImageView.themeMap = self.model.isSender ? self.sendBubbleBackgroundImageDic : self.recvBubbleBackgroundImageDic;
    _bubbleView.backgroundImageView.image = self.model.isSender ? self.sendBubbleBackgroundImage : self.recvBubbleBackgroundImage;
    switch (self.model.bodyType) {
        case ONEMessageBodyTypeText:
        {
        }
            break;
        case ONEMessageBodyTypeImage:
        {
            CGSize retSize = self.model.thumbnailImageSize;
            if (retSize.width == 0 && retSize.height == 0) {
                
                retSize = self.model.exceedImage.size;
            }
            if (retSize.width == 0 && retSize.height == 0) {
                
                retSize = [[UIImage imageNamed:@"img_download_fail"] size];
            }
            if (retSize.width == 0 || retSize.height == 0) {
                retSize.width = kEMMessageImageSizeWidth;
                retSize.height = kEMMessageImageSizeHeight;
            }
            else if (retSize.width > retSize.height) {
                CGFloat height =  kEMMessageImageSizeWidth / retSize.width * retSize.height;
                retSize.height = height;
                retSize.width = kEMMessageImageSizeWidth;
            }
            else {
                CGFloat width = kEMMessageImageSizeHeight / retSize.height * retSize.width;
                retSize.width = width;
                retSize.height = kEMMessageImageSizeHeight;
            }
            [self removeConstraint:self.bubbleWithImageConstraint];
            
            CGFloat margin = [EaseMessageCell appearance].leftBubbleMargin.left + [EaseMessageCell appearance].leftBubbleMargin.right;
            self.bubbleWithImageConstraint = [NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: retSize.width + margin];
            
            [self addConstraint:self.bubbleWithImageConstraint];
        }
            break;
        case ONEMessageBodyTypeLocation:
        {
        }
            break;
        case ONEMessageBodyTypeVoice:
        {
            [self removeConstraint:self.bubbleWithImageConstraint];
            CGFloat margin = [EaseMessageCell appearance].leftBubbleMargin.left + [EaseMessageCell appearance].leftBubbleMargin.right;
            self.bubbleWithImageConstraint = [NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[self widthFromDuration:self.model.mediaDuration] + 35 + margin];
            
            [self addConstraint:self.bubbleWithImageConstraint];

        }
            break;
        case ONEMessageBodyTypeVideo:
        {
        }
            break;
        case ONEMessageBodyTypeFile:
        {
        }
            break;
            case ONEMessageBodyTypeTransfer:
            case ONEMessageBodyTypeRedpacket:
        {
            _bubbleView.backgroundImageView.image = nil;
        }

        default:
            break;
    }
}

- (void)configureLayoutConstraintsWithModel:(id<IMessageModel>)model
{
    if (model.isSender) {
        [self configureSendLayoutConstraints];
    } else {
        [self configureRecvLayoutConstraints];
    }
}

- (void)configureSendLayoutConstraints
{
    //avatar view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseMessageCellPadding]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseMessageCellPadding]];
    
    self.avatarWidthConstraint = [NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.avatarSize];
    [self addConstraint:self.avatarWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.avatarView.mas_bottom).offset(1);
        make.left.equalTo(self.avatarView.mas_left).offset(-1);
        make.right.equalTo(self.avatarView.mas_right).offset(1);
        make.top.equalTo(self.avatarView.mas_top).offset(-17);
    }];
    
    //name label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
    
    self.nameHeightConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.messageNameHeight];
    [self addConstraint:self.nameHeightConstraint];
    
    //bubble view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    //status button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
    
    //activity
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
    
    //hasRead
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hasRead attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
}

- (void)configureRecvLayoutConstraints
{
    //avatar view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseMessageCellPadding]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseMessageCellPadding]];
    
    self.avatarWidthConstraint = [NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.avatarSize];
    [self addConstraint:self.avatarWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
//    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.equalTo(self.avatarView);
//        make.bottom.equalTo(self.avatarView.mas_bottom).offset(1);
//    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.avatarView.mas_bottom).offset(1);
        make.left.equalTo(self.avatarView.mas_left).offset(-1);
        make.right.equalTo(self.avatarView.mas_right).offset(1);
        make.top.equalTo(self.avatarView.mas_top).offset(-17);
    }];


    //name label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseMessageCellPadding]];
    
    self.nameHeightConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.messageNameHeight];
    [self addConstraint:self.nameHeightConstraint];
    
    //bubble view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

#pragma mark - Update Constraint

- (void)_updateAvatarViewWidthConstraint
{
    if (self.avatarView) {
        [self removeConstraint:self.avatarWidthConstraint];
        
        self.avatarWidthConstraint = [NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.avatarSize];
        [self addConstraint:self.avatarWidthConstraint];
    }
}

- (void)_updateNameHeightConstraint
{
    if (_nameLabel) {
        [self removeConstraint:self.nameHeightConstraint];
        
        self.nameHeightConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.messageNameHeight];
        [self addConstraint:self.nameHeightConstraint];
    }
}

#pragma mark - setter

- (void)setRoleType:(NSInteger)roleType
{
    [super setRoleType:roleType];
    if (roleType == 1) {
        self.tagView.image = [UIImage imageNamed:@"avatar_tag_admin"];
    } else if (roleType == 2) {
        self.tagView.image = [UIImage imageNamed:@"avatar_tag_owner"];
    } else {
        self.tagView.image = nil;
    }

}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
//    if (model.roleType == 1) {
//        self.tagView.image = [UIImage imageNamed:@"avatar_tag_admin"];
//    } else if (model.roleType == 2) {
//        self.tagView.image = [UIImage imageNamed:@"avatar_tag_owner"];
//    } else {
//        self.tagView.image = nil;
//    }
    
    _nameLabel.text = model.nickname;
    
    if (self.model.isSender) {
        _hasRead.hidden = YES;
        switch (self.model.messageStatus) {
            case ONEMessageStatusDelivering:
            {
                _statusButton.hidden = YES;
                [_activity setHidden:NO];
                [_activity startAnimating];
            }
                break;
            case ONEMessageStatusSuccessed:
            {
                _statusButton.hidden = YES;
                [_activity stopAnimating];
                if (self.model.isMessageRead) {
                    _hasRead.hidden = NO;
                }
            }
                break;
            case ONEMessageStatusPending:
            case ONEMessageStatusFailed:
            {
                [_activity stopAnimating];
                [_activity setHidden:YES];
                _statusButton.hidden = NO;
            }
                break;
            default:
                break;
        }
    }
}

- (void)setMessageNameFont:(UIFont *)messageNameFont
{
    _messageNameFont = messageNameFont;
    if (_nameLabel) {
        _nameLabel.font = _messageNameFont;
    }
}

- (void)setMessageNameColor:(UIColor *)messageNameColor
{
    _messageNameColor = messageNameColor;
    if (_nameLabel) {
        _nameLabel.textColor = _messageNameColor;
    }
}

- (void)setMessageNameHeight:(CGFloat)messageNameHeight
{
    _messageNameHeight = messageNameHeight;
    if (_nameLabel) {
        [self _updateNameHeightConstraint];
    }
}

- (void)setAvatarSize:(CGFloat)avatarSize
{
    _avatarSize = avatarSize;
    if (self.avatarView) {
        [self _updateAvatarViewWidthConstraint];
    }
}

- (void)setAvatarCornerRadius:(CGFloat)avatarCornerRadius
{
    _avatarCornerRadius = avatarCornerRadius;
    if (self.avatarView){
        self.avatarView.layer.cornerRadius = avatarCornerRadius;
    }
}

- (void)setMessageNameIsHidden:(BOOL)messageNameIsHidden
{
    _messageNameIsHidden = messageNameIsHidden;
    if (_nameLabel) {
        _nameLabel.hidden = messageNameIsHidden;
    }
}

#pragma mark - public

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    EaseBaseMessageCell *cell = [self appearance];
    
    CGFloat minHeight = cell.avatarSize + EaseMessageCellPadding * 2;
    CGFloat height = cell.messageNameHeight;
    if ([UIDevice currentDevice].systemVersion.floatValue == 7.0) {
        height = 15;
    }
    height += - EaseMessageCellPadding + [EaseMessageCell cellHeightWithModel:model];
    height = height > minHeight ? height : minHeight;
    
    return height;
}

@end
