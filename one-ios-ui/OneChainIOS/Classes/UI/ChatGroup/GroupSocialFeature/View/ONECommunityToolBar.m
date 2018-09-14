//
//  ONECommunityToolBar.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONECommunityToolBar.h"

#define kCHANGEBUTTON_WIDTH 51
#define kCOMMUNITYBUTTON_FONT_SIZE 16.f
#define kCOMMUNITYBUTTON_COLOR RGBACOLOR(73, 73, 73, 1)

@interface ONECommunityToolBar()

@property (nonatomic, strong) UIButton *styleChangeButton;
@property (nonatomic, strong) UIButton *communityButton;
@property (nonatomic, strong) UIButton *subjectButton;
@end

@implementation ONECommunityToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1.0];
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    CGRect bounds = self.bounds;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 0.6)];
    lineView.backgroundColor = RGBACOLOR(191, 191, 191, 1);
    [self addSubview:lineView];
    _styleChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_styleChangeButton setImage:[UIImage imageNamed:@"show_keyboard"] forState:UIControlStateNormal];
    [_styleChangeButton addTarget:self action:@selector(styleChangeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_styleChangeButton setFrame:CGRectMake(0, 0, WidthScale(kCHANGEBUTTON_WIDTH), bounds.size.height)];
    [self addSubview:_styleChangeButton];
    UIView *verticelLine = [[UIView alloc] initWithFrame:CGRectMake(_styleChangeButton.width, 1, 1, _styleChangeButton.height)];
    verticelLine.backgroundColor = RGBACOLOR(234, 234, 234, 1);
    [self addSubview:verticelLine];
    
    CGFloat kWidth = (bounds.size.width - _styleChangeButton.width);
    CGFloat kHeight = bounds.size.height;
    _communityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_communityButton setImage:[UIImage imageNamed:@"toobar_icon"] forState:UIControlStateNormal];
    [_communityButton setTitle:NSLocalizedString(@"group_community", @"") forState:UIControlStateNormal];
    _communityButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kCOMMUNITYBUTTON_FONT_SIZE];
    [_communityButton setTitleColor:kCOMMUNITYBUTTON_COLOR forState:UIControlStateNormal];
    [_communityButton setFrame:CGRectMake(_styleChangeButton.width, 0, kWidth, kHeight)];
    [_communityButton addTarget:self action:@selector(communityButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_communityButton];
    
//    _subjectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_subjectButton setImage:[UIImage imageFromColor:KRandomColor withCGRect:CGRectMake(0, 0, 8, 8)] forState:UIControlStateNormal];
//    [_subjectButton setTitle:@"专题" forState:UIControlStateNormal];
//    _subjectButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:16];
//    [_subjectButton setTitleColor:RGBACOLOR(73, 73, 73, 1) forState:UIControlStateNormal];
//    [_subjectButton setFrame:CGRectMake(CGRectGetMaxX(_communityButton.frame), 0, kWidth, kHeight)];
//    [_subjectButton addTarget:self action:@selector(subjectButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_subjectButton];
}

#pragma mark - Selectors

- (void)styleChangeButtonAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(didChangeToChatStyle:)]) {
        [_delegate didChangeToChatStyle:self];
    }
}

- (void)communityButtonAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(didCommunityButtonClicked:)]) {
        [_delegate didCommunityButtonClicked:self];
    }
}

- (void)subjectButtonAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSubjectButtonClicked:)]) {
        [_delegate didSubjectButtonClicked:self];
    }
}

@end
