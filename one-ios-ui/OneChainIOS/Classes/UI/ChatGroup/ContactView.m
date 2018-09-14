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

#import "ContactView.h"

@interface ContactView()

@property (nonatomic, strong) UIImageView *occupantTagView;
@end


@implementation ContactView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.accessibilityIdentifier = @"contact_view";

        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) - 20, 3, 30, 30)];
        _deleteButton.accessibilityIdentifier = @"delete";
        [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"group_invitee_delete"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        [self addSubview:_deleteButton];
        [self _layoutSubviews];
    }
    
    return self;
}

- (void)_layoutSubviews
{
    CGRect frame = self.bounds;
    CGFloat margin = frame.size.height / 4;
    _occupantTagView = [[UIImageView alloc] init];
    [self addSubview:_occupantTagView];
    
    [self.imageView setFrame:CGRectMake(margin, margin, frame.size.width - 2 * margin, frame.size.width - 2 * margin)];
    self.imageView.layer.cornerRadius = self.imageView.width / 2;
    self.imageView.clipsToBounds = YES;
    
    [self.remarkLabel removeFromSuperview];
    [self addSubview:self.remarkLabel];
    [self.remarkLabel setFrame:CGRectMake(margin / 2, self.height - 20, self.width - margin, 20)];
    self.remarkLabel.textAlignment = NSTextAlignmentCenter;
    self.remarkLabel.backgroundColor = [UIColor clearColor];
    self.remarkLabel.themeMap = @{
                                  TextColorName:@"common_text_color"
                                  };
    [_occupantTagView setFrame:CGRectMake(self.imageView.x - 1, self.imageView.y - 17, self.imageView.width + 2, self.imageView.height + 18)];
    _occupantTagView.hidden = YES;
    [self sendSubviewToBack:_occupantTagView];
}

- (void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        _deleteButton.hidden = !_editing;
    }
}

- (void)deleteAction
{
    if (_deleteContact) {
        _deleteContact(self.index);
    }
}

- (void)setRoleTyle:(GroupRoleType)roleTyle
{
    if (roleTyle == GroupRoleType_Owner) {
        _occupantTagView.hidden = NO;
        _occupantTagView.image = [UIImage imageNamed:@"avatar_tag_owner"];
    } else if (roleTyle == GroupRoleType_Admin) {
        _occupantTagView.hidden = NO;
        _occupantTagView.image = [UIImage imageNamed:@"avatar_tag_admin"];
    } else {
        _occupantTagView.image = nil;
        _occupantTagView.hidden = YES;
    }
}

@end
