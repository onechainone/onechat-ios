//
//  ONELikeToolBar.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONELikeToolBar.h"
#import "ExtendedButton.h"
#define KREDLINE_CENTERX_TWO 135
#define KREDLINE_CENTERX_ONE 45
#define KCHANGE_DURATION 0.5
#define kBUTTONWIDTH 90

@interface ONELikeToolBar()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *redLine;

@property (nonatomic, strong) ExtendedButton *admireButton;


@property (nonatomic, strong) ExtendedButton *likeButton;

@property (nonatomic, strong) ExtendedButton *dislikeButton;
@end

@implementation ONELikeToolBar

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.themeMap = @{
                               BGColorName:@"conversation_section_color"
                               };
//        _lineView.backgroundColor = RGBACOLOR(233, 233, 239, 1);
    }
    return _lineView;
}

- (ExtendedButton *)admireButton
{
    if (!_admireButton) {
        
        _admireButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        _admireButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:15.f];
        
        _admireButton.themeMap = @{
                                   TextColorName:@"conversation_detail_color",
                                   ButtonSelectedTextColor:@"conversation_title_color"
                                   };
//        [_admireButton setTitleColor:DEFAULT_BLACK_COLOR forState:UIControlStateSelected];
//        [_admireButton setTitleColor:DEFAULT_GRAY_COLOR forState:UIControlStateNormal];
        [_admireButton addTarget:self action:@selector(admireAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _admireButton;
}

- (ExtendedButton *)commentButton
{
    if (!_commentButton) {
        
        _commentButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        _commentButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:15.f];
//        [_commentButton setTitleColor:DEFAULT_BLACK_COLOR forState:UIControlStateSelected];
//        [_commentButton setTitleColor:DEFAULT_GRAY_COLOR forState:UIControlStateNormal];
        _commentButton.themeMap = @{
                                  TextColorName:@"conversation_detail_color",
                                  ButtonSelectedTextColor:@"conversation_title_color"
                                  };
        [_commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UIView *)redLine
{
    if (!_redLine) {
        
        _redLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 2)];
//        _redLine.backgroundColor = [UIColor colorWithHex:THEME_COLOR];
        _redLine.themeMap = @{
                              BGColorName:@"segment_bottom_line_color"
                              };
        [self addSubview:_redLine];
    }
    return _redLine;
}

- (ExtendedButton *)likeButton
{
    if (!_likeButton) {
        
        _likeButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"article_like"] forState:UIControlStateNormal];
//        [_likeButton setTitleColor:DEFAULT_GRAY_COLOR forState:UIControlStateNormal];
        _likeButton.themeMap = @{
                                 TextColorName:@"golden_text_color"
                                 };
        _likeButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LIGHT size:15];
//        [_likeButton sizeToFit];
        [_likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}
- (ExtendedButton *)dislikeButton
{
    if (!_dislikeButton) {
        
        _dislikeButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        [_dislikeButton setImage:[UIImage imageNamed:@"article_dislike"] forState:UIControlStateNormal];
//        [_dislikeButton setTitleColor:DEFAULT_GRAY_COLOR forState:UIControlStateNormal];
        _dislikeButton.themeMap = @{
                                    TextColorName:@"golden_text_color"
                                    };
        _dislikeButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LIGHT size:15];
//        [_dislikeButton sizeToFit];
        [_dislikeButton addTarget:self action:@selector(dislikeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dislikeButton;
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
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(6);
    }];
    [self addSubview:self.admireButton];
    [self.admireButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lineView);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(@(kBUTTONWIDTH));
    }];
    
    [self addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.admireButton.mas_right);
        make.top.bottom.width.equalTo(self.admireButton);
    }];
    
    [self addSubview:self.dislikeButton];
    [self.dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self);
    }];
    [self addSubview:self.likeButton];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dislikeButton.mas_left).offset(-20);
        make.centerY.equalTo(self);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.themeMap = @{
                            BGColorName:@"conversation_section_color"
                            };
//    bottomLine.backgroundColor = RGBACOLOR(233, 233, 239, 1);
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(2);
    }];
    [self.redLine setCenter:CGPointMake(KREDLINE_CENTERX_TWO, self.height - 1)];
}

#pragma mark - public method

- (void)reloadSubviewsWithArticle:(ONEArticle *)article
{
    NSString *admireButtonTitle = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"zanshang", @""),article ? article.reward_count : @"0"];
    NSString *commentButtonTitle = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"comment", @""),article ? article.comment_count : @"0"];
    [self.admireButton setTitle:admireButtonTitle forState:UIControlStateNormal];
    [self.admireButton setTitle:admireButtonTitle forState:UIControlStateSelected];
    [self.commentButton setTitle:commentButtonTitle forState:UIControlStateNormal];
    [self. commentButton setTitle:commentButtonTitle forState:UIControlStateSelected];

    NSString *is_like = article.is_like;
    NSString *like_count = article.likes_count ? article.likes_count : @"0";
    NSString *dislike_count = article.dislikes_count ? article.dislikes_count : @"0";
    if ([is_like isEqualToString:@"1"]) {
        [self.likeButton setImage:[UIImage imageNamed:@"article_like_selected"] forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor colorWithHex:THEME_COLOR] forState:UIControlStateNormal];
    } else if ([is_like isEqualToString:@"2"]) {
        [self.dislikeButton setImage:[UIImage imageNamed:@"article_dislike_selected"] forState:UIControlStateNormal];
        [self.dislikeButton setTitleColor:[UIColor colorWithHex:THEME_COLOR] forState:UIControlStateNormal];
    } else {
        [self.likeButton setTitleColor:THMColor(@"golden_text_color") forState:UIControlStateNormal];
        [self.dislikeButton setTitleColor:THMColor(@"golden_text_color") forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"article_like"] forState:UIControlStateNormal];
        [self.dislikeButton setImage:[UIImage imageNamed:@"article_dislike"] forState:UIControlStateNormal];
    }
    [self.likeButton setTitle:like_count forState:UIControlStateNormal];
    [self.dislikeButton setTitle:dislike_count forState:UIControlStateNormal];
}
- (void)changeToComment:(BOOL)isComment
{
    if (isComment) {
        [self.commentButton setSelected:YES];
        [self.admireButton setSelected:NO];
        [UIView animateWithDuration:KCHANGE_DURATION animations:^{
            [self.redLine setCenter:CGPointMake(KREDLINE_CENTERX_TWO, self.height - 1)];
        }];
    } else {
        [self.commentButton setSelected:NO];
        [self.admireButton setSelected:YES];
        [UIView animateWithDuration:KCHANGE_DURATION animations:^{
            [self.redLine setCenter:CGPointMake(KREDLINE_CENTERX_ONE, self.height - 1)];
        }];
    }
}

#pragma mark - Selectors

- (void)admireAction
{
    if (self.admireButton.isSelected == YES) {
        return;
    }
    self.admireButton.selected = !self.admireButton.isSelected;
    [self.commentButton setSelected:!self.admireButton.isSelected];

    if (self.admireButton.isSelected) {
        [UIView animateWithDuration:KCHANGE_DURATION animations:^{
            [self.redLine setCenter:CGPointMake(KREDLINE_CENTERX_ONE, self.height - 1)];
        }];
    } else {
        [UIView animateWithDuration:KCHANGE_DURATION animations:^{
            [self.redLine setCenter:CGPointMake(KREDLINE_CENTERX_TWO, self.height - 1)];
        }];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(admireButtonSelected)]) {
        
        [_delegate admireButtonSelected];
    }
}

- (void)commentAction
{
    if (self.commentButton.isSelected == YES) {
        return;
    }
    self.commentButton.selected = !self.commentButton.isSelected;
    [self.admireButton setSelected:!self.commentButton.isSelected];
    if (self.commentButton.isSelected) {
        [UIView animateWithDuration:KCHANGE_DURATION animations:^{
            [self.redLine setCenter:CGPointMake(KREDLINE_CENTERX_TWO, self.height - 1)];
        }];
    } else {
        [UIView animateWithDuration:KCHANGE_DURATION animations:^{
            [self.redLine setCenter:CGPointMake(KREDLINE_CENTERX_ONE, self.height - 1)];
        }];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(commentButtonSelected)]) {
        
        [_delegate commentButtonSelected];
    }
}

- (void)likeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(likeButtonClicked)]) {
        
        [_delegate likeButtonClicked];
    }
}

- (void)dislikeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(dislikeButtonClicked)]) {
        
        [_delegate dislikeButtonClicked];
    }
}
@end
