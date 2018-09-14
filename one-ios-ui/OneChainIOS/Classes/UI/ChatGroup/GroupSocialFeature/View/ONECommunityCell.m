//
//  ONECommunityCell.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONECommunityCell.h"
#import "NSString+Extension.h"
#import "ONEArticleImageView.h"
#import "ExtendedButton.h"
#define kCONTENTMAXH 160
#define kVIDEODEFAULT_WIDTH 100
@interface ONECommunityCell()


@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *personInfoView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nickLbl;
@property (nonatomic, strong) UILabel *personDescLbl;
@property (nonatomic, strong) ExtendedButton *moreButton;

@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) ExtendedButton *likeButton;
@property (nonatomic, strong) ExtendedButton *commentButton;
@property (nonatomic, strong) ExtendedButton *browseButton;

@property (nonatomic, strong) UILabel *contentLbl;

@property (nonatomic, strong) UIImageView *videoDisplayView;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) ONEArticleImageView *imagesView;

@property (nonatomic, strong) UILabel *personalTimeLbl;

@property (nonatomic, strong) ExtendedButton *dislikeButton;

@property (nonatomic, strong) NSMutableArray *matchs;

@end

@implementation ONECommunityCell

#define kAVATAR_WIDTH 38
#define kPADDING 18
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 6)];
        _lineView.themeMap = @{
                               BGColorName:@"conversation_section_color"
                               };
//        _lineView.backgroundColor = RGBACOLOR(233, 233, 239, 1);
    }
    return _lineView;
}

- (UIView *)personInfoView
{
    if (!_personInfoView) {
        
        _personInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineView.height, KScreenW, 50)];
        _personInfoView.themeMap = @{
                                     BGColorName:@"bg_white_color"
                                     };
        _avatarView = [[UIImageView alloc] init];
        _avatarView.layer.cornerRadius = kAVATAR_WIDTH / 2;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClicked:)];
        [_avatarView addGestureRecognizer:tap];
        [_personInfoView addSubview:_avatarView];
        [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_personInfoView.mas_left).offset(kPADDING);
            make.centerY.equalTo(_personInfoView);
            make.size.mas_equalTo(CGSizeMake(kAVATAR_WIDTH, kAVATAR_WIDTH));
        }];
        
        _nickLbl = [[UILabel alloc] init];
        _nickLbl.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:14.f];
//        _nickLbl.textColor = DEFAULT_BLACK_COLOR;
        _nickLbl.themeMap = @{
                              TextColorName:@"conversation_title_color"
                              };
        [_personInfoView addSubview:_nickLbl];
        [_nickLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarView);
            make.left.equalTo(_avatarView.mas_right).offset(10);
        }];
        _personDescLbl = [[UILabel alloc] init];
        _personDescLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:12.f];
//        _personDescLbl.textColor = DEFAULT_GRAY_COLOR;
        _personDescLbl.themeMap = @{
                                    TextColorName:@"conversation_detail_color"
                                    };
        [_personInfoView addSubview:_personDescLbl];
        [_personDescLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_personInfoView);
            make.left.equalTo(_nickLbl);
            make.right.equalTo(_personInfoView.mas_right).offset(-kPADDING);
        }];
        if (_isShowAll) {
            
            _personalTimeLbl = [[UILabel alloc] init];
            _personalTimeLbl.font = [UIFont fontWithName:FONT_NAME_LIGHT size:12.f];
//            _personalTimeLbl.textColor = DEFAULT_GRAY_COLOR;
            _personalTimeLbl.themeMap = @{
                                          TextColorName:@"conversation_time_color"
                                          };
            _personalTimeLbl.textAlignment = NSTextAlignmentLeft;
            [_personInfoView addSubview:_personalTimeLbl];
            
            [_nickLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_avatarView);
                make.left.equalTo(_avatarView.mas_right).offset(10);
                make.width.lessThanOrEqualTo(@200);
            }];
            [_personalTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_nickLbl.mas_right).offset(10);
                make.centerY.equalTo(_nickLbl);
            }];
        } else {
            
            _moreButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
            [_moreButton setImage:[UIImage imageNamed:@"jubao"] forState:UIControlStateNormal];
            [_moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
            [_moreButton sizeToFit];
            [_personInfoView addSubview:_moreButton];
            [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(_nickLbl);
                make.right.equalTo(_personInfoView.mas_right).offset(-kPADDING);
            }];
        }
    }
    return _personInfoView;
}

- (UIView *)toolView
{
    if (!_toolView) {
        
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
        _toolView.themeMap = @{
                               BGColorName:@"bg_white_color"
                               };
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.font = [UIFont fontWithName:FONT_NAME_LIGHT size:12.f];
//        _timeLbl.textColor = DEFAULT_GRAY_COLOR;
        _timeLbl.themeMap = @{
                              TextColorName:@"conversation_time_color"
                              };
        _timeLbl.textAlignment = NSTextAlignmentLeft;
        [_toolView addSubview:_timeLbl];
        [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_toolView.mas_left).offset(kPADDING);
            make.centerY.equalTo(_toolView);
        }];
        // 打赏
        _browseButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        _browseButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LIGHT size:15.f];
//        [_browseButton setTitleColor:DEFAULT_GRAY_COLOR forState:UIControlStateNormal];
        _browseButton.themeMap = @{
                                   TextColorName:@"golden_text_color"
                                   };
        [_browseButton setImage:[UIImage imageNamed:@"IUQuanShang"] forState:UIControlStateNormal];
        _browseButton.enabled = NO;

        [_toolView addSubview:_browseButton];
        [_browseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_toolView.mas_right).offset(-kPADDING);
            make.centerY.equalTo(_toolView);
        }];
        
        // 利空
        _dislikeButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        [_dislikeButton setImage:[UIImage imageNamed:@"article_dislike"] forState:UIControlStateNormal];
//        [_dislikeButton setTitleColor:DEFAULT_GRAY_COLOR forState:UIControlStateNormal];
        _dislikeButton.themeMap = @{
                                    TextColorName:@"golden_text_color"
                                    };
        _dislikeButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LIGHT size:15];
        [_dislikeButton addTarget:self action:@selector(dislikeAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_toolView addSubview:_dislikeButton];
        [_dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_toolView);
            make.right.equalTo(_browseButton.mas_left).offset(-20);
        }];
        _likeButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"article_like"] forState:UIControlStateNormal];
//        [_likeButton setTitleColor:DEFAULT_GRAY_COLOR forState:UIControlStateNormal];
        _likeButton.themeMap = @{
                                 TextColorName:@"golden_text_color"
                                 };
        _likeButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LIGHT size:15];
        [_likeButton sizeToFit];
        [_likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:_likeButton];
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_dislikeButton.mas_left).offset(-20);
            make.centerY.equalTo(_dislikeButton);
        }];
        
        _commentButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"IUQuanPing"] forState:UIControlStateNormal];
//        [_commentButton setTitleColor:DEFAULT_GRAY_COLOR forState:UIControlStateNormal];
        _commentButton.themeMap = @{
                                    TextColorName:@"golden_text_color"
                                    };
        _commentButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LIGHT size:15];
        _commentButton.enabled = NO;
        [_commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_toolView addSubview:_commentButton];
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_toolView);
            make.right.equalTo(_likeButton.mas_left).offset(-20);
        }];
        

    }
    return _toolView;
}

- (UILabel *)contentLbl
{
    if (!_contentLbl) {
        
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:17.f];
//        _contentLbl.textColor = DEFAULT_BLACK_COLOR;
        _contentLbl.themeMap = @{
                                 BGColorName:@"bg_white_color",
                                 TextColorName:@"conversation_detail_color"
                                 };
        _contentLbl.numberOfLines = 0;
        [_contentLbl setLineBreakMode:NSLineBreakByTruncatingTail];

    }
    return _contentLbl;
}

- (UIImageView *)videoDisplayView
{
    if (!_videoDisplayView) {
        
        _videoDisplayView = [[UIImageView alloc] init];
        _videoDisplayView.contentMode = UIViewContentModeScaleAspectFill;
        _videoDisplayView.clipsToBounds = YES;
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"IDoQuanPlayButton"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];
        [_playButton sizeToFit];
        _playButton.enabled = NO;
        _videoDisplayView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideoAction)];
        [_videoDisplayView addGestureRecognizer:tap];
        [_videoDisplayView addSubview:_playButton];
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.center.equalTo(_videoDisplayView);
        }];
    }
    return _videoDisplayView;
}

- (ONEArticleImageView *)imagesView
{
    if (!_imagesView) {
        _imagesView = [[ONEArticleImageView alloc] init];
    }
    return _imagesView;
}




- (CGFloat)getImagesViewHeightWithModel:(ONEArticle *)model
{
    NSArray *imageUrls = [model.img_list copy];
    CGFloat imageWidth = self.contentLbl.width / 3;
    int temp = (imageUrls.count) % 3;
    int num = (imageUrls.count) / 3;
    num += temp == 0 ? 0 : 1;
    
    CGFloat height = (imageWidth * num) + 10 * (num - 1);
    return height;
}


- (CGFloat)getContentLblHeightWithModel:(ONEArticle *)model
{
    NSString *content = model.content;
    NSMutableAttributedString *contentAttr = [NSString getMutableAttributedStringFromString:content withFont:[UIFont fontWithName:FONT_NAME_REGULAR size:17] withTextColor:DEFAULT_BLACK_COLOR withLineSpace:HeightScale(6)];
    CGRect contentFrame = [contentAttr boundingRectWithSize:CGSizeMake(KScreenW - 2 * kPADDING, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat height = contentFrame.size.height;
    if (!self.isShowAll && height > kCONTENTMAXH) {
        height = kCONTENTMAXH;
    }
    return height;
}

+ (CGFloat)cellHeightForArticleModel:(ONEArticle *)model
{
    return [self cellHeightForArticleModel:model isShowAll:NO];
}

+ (CGFloat)cellHeightForArticleModel:(ONEArticle *)model isShowAll:(BOOL)showAll
{
    CGFloat padding = 50 + 40;
    if (showAll) {
        padding = 50;
    }
    NSString *content = model.content;
    NSMutableAttributedString *contentAttr = [NSString getMutableAttributedStringFromString:content withFont:[UIFont fontWithName:FONT_NAME_REGULAR size:17] withTextColor:THMColor(@"conversation_detail_color") withLineSpace:HeightScale(6)];
    CGRect contentFrame = [contentAttr boundingRectWithSize:CGSizeMake(KScreenW - 2 *kPADDING, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat height = contentFrame.size.height;
    if (!showAll && height > kCONTENTMAXH) {
        height = kCONTENTMAXH;
    }
    CGFloat contentHeight = height;
    CGFloat cellHeight = padding + contentHeight;
    if ([model.type isEqualToString:@"video"]) {
        cellHeight = cellHeight + kVIDEODEFAULT_WIDTH + 10;
    } else if ([model.type isEqualToString:@"image"]) {
        NSArray *imageUrls = [model.img_list copy];
        CGFloat imageWidth = (KScreenW - 2 *kPADDING) / 3;
        int temp = (imageUrls.count) % 3;
        int num = (imageUrls.count) / 3;
        num += temp == 0 ? 0 : 1;
        CGFloat height = (imageWidth * num) + 10 * (num - 1);
        cellHeight = cellHeight + height + 20;
    }
    
    return cellHeight + 6;
}

- (void)setModel:(ONEArticle *)model
{
    _model = model;
    
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    [self.contentView addSubview:self.lineView];
    
    if (_isShowAll) {
        [self.lineView setFrame:CGRectZero];
        self.lineView.hidden = YES;
    } else {
        [self.lineView setFrame:CGRectMake(0, 0, KScreenW, 6)];
        self.lineView.hidden = NO;
    }
    [self.contentView addSubview:self.personInfoView];

    NSURL *url = [NSURL URLWithString:_model.avatar_url];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:_model.avatar_url] placeholderImage:[UIImage defaultAvaterImage]];
    self.nickLbl.text = _model.nickname;
    self.personDescLbl.text = _model.intro;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] init];
    NSString *enssenceTag = model.weibo_jinghua;
    if (enssenceTag && [enssenceTag isEqualToString:@"1"]) {
        
        UIImage *image = [UIImage imageNamed:@"article_enssence"];
        NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
        attchment.image = image;
        attchment.bounds = CGRectMake(0, 0, attchment.image.size.width, attchment.image.size.height);
        [att appendAttributedString:[NSAttributedString attributedStringWithAttachment:attchment]];
        [att appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        NSMutableAttributedString *contentAttr = [NSString getMutableAttributedStringFromString:_model.content withFont:[UIFont fontWithName:FONT_NAME_REGULAR size:17] withTextColor:THMColor(@"conversation_detail_color") withLineSpace:HeightScale(6)];
        if ([contentAttr length] == 0) {
            contentAttr = [[NSAttributedString alloc] initWithString:@""];
        }
        [att appendAttributedString:contentAttr];

        
        self.contentLbl.attributedText = att;
    } else {
        self.contentLbl.attributedText = [NSString getMutableAttributedStringFromString:_model.content withFont:[UIFont fontWithName:FONT_NAME_REGULAR size:17] withTextColor:THMColor(@"conversation_detail_color") withLineSpace:HeightScale(6)];
    }
    
    [self.contentLbl setLineBreakMode:NSLineBreakByTruncatingTail];
    
    if ([self.contentLbl.attributedText length] == 0) {
        self.contentLbl.hidden = YES;
    } else {
        self.contentLbl.hidden = NO;
    }
    
    [self.contentLbl setFrame:CGRectMake(kPADDING, CGRectGetMaxY(self.personInfoView.frame), KScreenW - 2 * kPADDING, [self getContentLblHeightWithModel:_model])];
    [self.contentView addSubview:self.contentLbl];

    CGRect toolFrame = CGRectMake(0, CGRectGetMaxY(self.contentLbl.frame), KScreenW, 40);

    if ([model.type isEqualToString:@"image"]) {
        
        NSMutableArray *images = [NSMutableArray array];
        if ([_model.img_list count] > 0) {
            
            for (NSString *url in _model.img_list) {
                
                NSString *completeUrl = [url formalCommunityImageUrl];
                [images addObject:completeUrl];
            }
        }
        
        self.imagesView = [[ONEArticleImageView alloc] initWithFrame:CGRectMake(kPADDING, CGRectGetMaxY(self.contentLbl.frame), self.contentLbl.width, [self getImagesViewHeightWithModel:_model]) images:_model.img_list];
        self.imagesView.imageSelectBlock = ^(NSInteger index) {
            if (_delegate && [_delegate respondsToSelector:@selector(imageSelected:index:)]) {
                
                [_delegate imageSelected:_model index:index];
            }
        };
        [self.contentView addSubview:self.imagesView];
        [self.imagesView reloadImages:images];
        toolFrame = CGRectMake(0, CGRectGetMaxY(self.imagesView.frame), KScreenW, 40);

    } else if ([model.type isEqualToString:@"video"]) {
        self.videoDisplayView.hidden = NO;
        [self.contentView addSubview:self.videoDisplayView];
        [self.videoDisplayView setFrame:CGRectMake(kPADDING, CGRectGetMaxY(self.contentLbl.frame), 200, 100)];
        __weak typeof(self)weakself = self;
        [self.videoDisplayView sd_setImageWithURL:[NSURL URLWithString:_model.video_jietu_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {

        }];
        toolFrame = CGRectMake(0, CGRectGetMaxY(self.videoDisplayView.frame), KScreenW, 40);
    }
    if (!_isShowAll) {
        [self.contentView addSubview:self.toolView];
        [self.toolView setFrame:toolFrame];
        NSTimeInterval timeInterval = [[NSString stringWithFormat:@"%@",_model.create_time] doubleValue];
        NSString *timestr = [NSDate formattedTimeFromTimeInterval:timeInterval];
        self.timeLbl.text = timestr;
        NSString *isLike = _model.is_like;
        NSString *likeNum = _model.likes_count ? _model.likes_count : @"0";
        NSString *dislikeNum = _model.dislikes_count ? _model.dislikes_count : @"0";
        NSString *reward_count = _model.reward_count ? _model.reward_count : @"0";
        [self.browseButton setTitle:reward_count forState:UIControlStateNormal];
        if ([isLike isEqualToString:@"1"]) {
            [self.likeButton setImage:[UIImage imageNamed:@"article_like_selected"] forState:UIControlStateNormal];
            [self.likeButton setTitleColor:[UIColor colorWithHex:THEME_COLOR] forState:UIControlStateNormal];
        } else if ([isLike isEqualToString:@"2"]) {
            [self.dislikeButton setImage:[UIImage imageNamed:@"article_dislike_selected"] forState:UIControlStateNormal];
            [self.dislikeButton setTitleColor:[UIColor colorWithHex:THEME_COLOR] forState:UIControlStateNormal];
        } else {
            [self.likeButton setImage:[UIImage imageNamed:@"article_like"] forState:UIControlStateNormal];
            [self.dislikeButton setImage:[UIImage imageNamed:@"article_dislike"] forState:UIControlStateNormal];
        }
        [self.likeButton setTitle:likeNum forState:UIControlStateNormal];
        [self.dislikeButton setTitle:dislikeNum forState:UIControlStateNormal];
        NSString *comment_count = [NSString stringWithFormat:@"%@",_model.comment_count];
        [self.commentButton setTitle:comment_count forState:UIControlStateNormal];
    } else {
        NSTimeInterval timeInterval = [[NSString stringWithFormat:@"%@",_model.create_time] doubleValue];
        NSString *timestr = [NSDate formattedTimeFromTimeInterval:timeInterval];
        self.personalTimeLbl.text = timestr;
    }
    
//    self.matchs = [NSMutableArray arrayWithArray:[self regularExpression]];
//    if (self.matchs.count > 0) {
//        [self highlightLinksWithMatchs];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentLblTapped:)];
//        [self.contentLbl addGestureRecognizer:tap];
//    }
}

- (void)contentLblTapped:(UITapGestureRecognizer *)tap
{
    
}

#pragma mark - Selectors


- (void)avatarClicked:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(avatarViewClicked:)]) {
            
            [_delegate avatarViewClicked:_model];
        }
    }
}

- (void)likeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(likeButtonClicked:)]) {
        
        [_delegate likeButtonClicked:_model];
    }
}

- (void)dislikeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(dislikeButtonClicked:)]) {
        
        [_delegate dislikeButtonClicked:_model];
    }
}

- (void)moreAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreButtonClicked:)]) {
        
        [_delegate moreButtonClicked:_model];
    }
}

- (void)playVideoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(videoClicked:)]) {
        
        [_delegate videoClicked:_model];
    }
}

#pragma mark - URL 识别

- (NSArray *)regularExpression
{
    NSString *regular = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSString *linkString = self.contentLbl.attributedText.string;
    if (linkString.length == 0) {
        return nil;
    }
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *match = [exp matchesInString:linkString options:NSMatchingReportProgress range:NSMakeRange(0, linkString.length)];
    
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSTextCheckingResult *result in match) {
        NSString *str = [_model.content substringWithRange:result.range];
        NSURL *url = [NSURL URLWithString:str];
        //为不包含http/https的url添加前缀http
        if ([str rangeOfString:@"http"].location == NSNotFound &&
            [str rangeOfString:@"https"].location == NSNotFound) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",str]];
        }
        [results addObject:[NSTextCheckingResult linkCheckingResultWithRange:result.range URL:url]];
    }
    return results;
}

- (void)highlightLinksWithMatchs {
    
    NSMutableAttributedString* attributedString = [self.contentLbl.attributedText mutableCopy];
    
    for (NSTextCheckingResult *match in self.matchs) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            NSRange matchRange = [match range];
            
//            UIColor *color = [UIColor colorWithRed:(30)/255.0 green:(167)/255.0 blue:(252)/255.0 alpha:(1)];
            UIColor *color = DEFAULT_BLACK_COLOR;
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:color range:matchRange];
//            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    self.contentLbl.attributedText = attributedString;
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range
{
    return index >= range.location && index < range.location+range.length;
}

- (void)prepareForReuse
{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    self.videoDisplayView = nil;
    self.imagesView = nil;
    self.contentLbl = nil;
    self.personInfoView = nil;
    self.toolView = nil;
    self.lineView = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.themeMap = @{
                          BGColorName:@"bg_color"
                          };
        self.contentLbl.themeMap = @{
                                     BGColorName:@"bg_color"
                                     };
        self.toolView.themeMap = @{
                                   BGColorName:@"bg_color"
                                   };
        self.personInfoView.themeMap = @{
                                         BGColorName:@"bg_color"
                                         };
    } else {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        self.contentLbl.themeMap = @{
                                     BGColorName:@"bg_white_color"
                                     };
        self.toolView.themeMap = @{
                                   BGColorName:@"bg_white_color"
                                   };
        self.personInfoView.themeMap = @{
                                         BGColorName:@"bg_white_color"
                                         };
    }

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted){
        self.themeMap = @{
                          BGColorName:@"bg_color"
                          };
        self.contentLbl.themeMap = @{
                                     BGColorName:@"bg_color"
                                     };
        self.toolView.themeMap = @{
                                   BGColorName:@"bg_color"
                                   };
        self.personInfoView.themeMap = @{
                                         BGColorName:@"bg_color"
                                         };
    } else {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        self.contentLbl.themeMap = @{
                                     BGColorName:@"bg_white_color"
                                     };
        self.toolView.themeMap = @{
                                   BGColorName:@"bg_white_color"
                                   };
        self.personInfoView.themeMap = @{
                                         BGColorName:@"bg_white_color"
                                         };
    }

}

- (void)dealloc
{
    
}



@end
