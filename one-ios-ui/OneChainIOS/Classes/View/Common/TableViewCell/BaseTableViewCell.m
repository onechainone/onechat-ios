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

#import "BaseTableViewCell.h"

#import "UIImageView+HeadImage.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        // Initialization code
        self.accessibilityIdentifier = @"table_cell";

        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.themeMap = @{
                                     BGColorName:@"conversation_section_color"
                                     };
//        _bottomLineView.backgroundColor = [UIColor colorWithRed:207 / 255.0 green:210 /255.0 blue:213 / 255.0 alpha:0.7];
        [self.contentView addSubview:_bottomLineView];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.themeMap = @{
                                    TextColorName:@"common_text_color"
                                    };
        _headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:_headerLongPress];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10, 8, 34, 34);
    self.imageView.layer.cornerRadius = 17.f;
    self.imageView.layer.masksToBounds = YES;
    CGRect rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 10;
    self.textLabel.frame = rect;
    
    _bottomLineView.frame = CGRectMake(0, self.contentView.frame.size.height - .5, self.contentView.frame.size.width, .5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = [UIColor blackColor];
    } else {
        self.textLabel.themeMap = @{
                                    TextColorName:@"common_text_color"
                                    };
    }
}

- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellImageViewLongPressAtIndexPath:)])
        {
            [_delegate cellImageViewLongPressAtIndexPath:self.indexPath];
        }
    }
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    [self.textLabel setTextWithUsername:_username];
    [self.imageView imageWithUsername:_username placeholderImage:self.imageView.image];
}

- (void)setModel:(id<IUserModel>)model
{
    _model = model;
    [self.textLabel setText:_model.nickname];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[ONEUrlHelper userAvatarPrefix], _model.avatarURLPath]] placeholderImage:[UIImage defaultAvaterImage]];
}

- (void)setFriendModel:(ONEFriendModel *)friendModel
{
    _friendModel = friendModel;
    [self.textLabel setText:_friendModel.nickname];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_friendModel.avatar_url] placeholderImage:[UIImage defaultAvaterImage]];
}


@end
