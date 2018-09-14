//
//  ONECommentCell.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONECommentCell.h"

#define kAVATAR_SIZE 38
#define kHORN_PADDING 18
#define kVERT_PADDING 10
#define kNICK_FONT_SIZE 14.f
#define kNICK_LBL_BOTTOM 2
#define kQUOTE_LBL_FONT_SIZE 13.f
#define kQUOTE_LBL_BGCOLOR RGBACOLOR(235, 235, 235, 1)
#define kCONTENT_LBL_FONT_SIZE 16.f
@interface ONECommentCell()


@end

@implementation ONECommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    _avatarView = [[UIImageView alloc] init];
    _avatarView.layer.cornerRadius = kAVATAR_SIZE / 2;
    _avatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarView];
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(kHORN_PADDING);
        make.top.equalTo(self.contentView.mas_top).offset(kVERT_PADDING);
        make.width.height.mas_equalTo(@(kAVATAR_SIZE));
    }];
    
    _nickNameLbl = [[UILabel alloc] init];
    _nickNameLbl.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:kNICK_FONT_SIZE];
//    _nickNameLbl.textColor = DEFAULT_BLACK_COLOR;
    _nickNameLbl.themeMap = @{
                              TextColorName:@"conversation_title_color"
                              };
    [self.contentView addSubview:_nickNameLbl];
    [_nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_avatarView.mas_right).offset(kVERT_PADDING);
        make.bottom.equalTo(_avatarView.mas_centerY).offset(-kNICK_LBL_BOTTOM);
    }];
    [self setupSubviews];
}

- (void)_setupQuoteContentLblConstraint{
    
    [_quoteContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nickNameLbl);
        make.right.equalTo(self.contentView.mas_right).offset(-kHORN_PADDING);
        make.top.equalTo(_avatarView.mas_centerY).offset(kNICK_LBL_BOTTOM);
    }];
}

- (void)_setupContentLblConstraint
{
    [_contentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_quoteContentLbl.mas_bottom).offset(kNICK_LBL_BOTTOM);
        make.left.right.equalTo(_quoteContentLbl);
        make.right.equalTo(self.contentView.mas_right).offset(-kHORN_PADDING);
    }];
}


- (void)setupSubviews
{
    _quoteContentLbl = [[UILabel alloc] init];
    _quoteContentLbl.font = [UIFont fontWithName:FONT_NAME_LIGHT size:kQUOTE_LBL_FONT_SIZE];
//    _quoteContentLbl.backgroundColor = kQUOTE_LBL_BGCOLOR;
    _quoteContentLbl.themeMap = @{
                                  BGColorName:@"bg_color"
                                  };
    _quoteContentLbl.numberOfLines = 0;
    [self.contentView addSubview:_quoteContentLbl];
    [self _setupQuoteContentLblConstraint];
    
    _contentLbl = [[UILabel alloc] init];
    _contentLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kCONTENT_LBL_FONT_SIZE];
    _contentLbl.themeMap = @{
                             TextColorName:@"conversation_detail_color"
                             };
    _contentLbl.numberOfLines = 0;
    [self.contentView addSubview:_contentLbl];
    [self _setupContentLblConstraint];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeButton setImage:[UIImage imageNamed:@"IUQuanZan"] forState:UIControlStateNormal];
    _likeButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:15];
    [_likeButton sizeToFit];
    [_likeButton addTarget:self action:@selector(likeCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_likeButton];
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_nickNameLbl.mas_left);
        make.top.equalTo(_contentLbl.mas_bottom).offset(kVERT_PADDING);
    }];
    
    _subTimeLbl = [[UILabel alloc] init];
    _subTimeLbl.font = [UIFont fontWithName:FONT_NAME_LIGHT size:12.f];
    _subTimeLbl.themeMap = @{
                             TextColorName:@"conversation_time_color"
                             };
    [self.contentView addSubview:_subTimeLbl];
    
    [_subTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_likeButton.mas_right).offset(kHORN_PADDING);
        make.centerY.equalTo(_likeButton);
    }];
}

- (void)setComment:(ONEComment *)comment
{
    _comment = comment;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:comment.avatar_url] placeholderImage:[UIImage defaultAvaterImage] options:nil];
    _nickNameLbl.text = comment.nickname;
    
    NSDictionary *dic = _comment.yuan_comment;
    if (dic != nil && [dic count] > 0) {
        if (_comment.quoteComment) {
            [_quoteContentLbl setHidden:NO];
            ONEQuoteComment *quoteComment = _comment.quoteComment;
            [_quoteContentLbl setAttributedText:quoteComment.real_content];
            [self _setupContentLblConstraint];
        }
    } else {
        [_quoteContentLbl setHidden:YES];
        [_contentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_avatarView.mas_centerY).offset(2);
            make.left.equalTo(_nickNameLbl);
            make.right.equalTo(self.contentView.mas_right).offset(-kHORN_PADDING);
        }];
    }
    [_contentLbl setAttributedText:[NSString getMutableAttributedStringFromString:_comment.content withFont:[UIFont fontWithName:FONT_NAME_REGULAR size:16.f] withTextColor:DEFAULT_BLACK_COLOR withLineSpace:2]];
    
    NSString *is_like = _comment.is_like;
    if ([is_like isEqualToString:@"1"]) {
        [_likeButton setImage:[UIImage imageNamed:@"IUQuanYiZan"] forState:UIControlStateNormal];
        [_likeButton setTitleColor:[UIColor colorWithHex:THEME_COLOR] forState:UIControlStateNormal];
    } else {
        [_likeButton setImage:[UIImage imageNamed:@"IUQuanZan"] forState:UIControlStateNormal];
        [_likeButton setTitleColor:THMColor(@"conversation_detail_color") forState:UIControlStateNormal];
    }
    NSString *like_num = _comment.likes_count;
    if ([like_num isEqual:[NSNull null]] || like_num == nil || [like_num isEqualToString:@"0"]) {
        like_num = @"点赞支持";
    }
    [_likeButton setTitle:[NSString stringWithFormat:@"%@",like_num] forState:UIControlStateNormal];
    
    long long timeInterval = [_comment.create_time longLongValue];
    NSString *timeStr = [NSDate formattedTimeFromTimeInterval:timeInterval];
    [_subTimeLbl setText:timeStr];
}

+ (CGFloat)commentCellHeightWithComment:(ONEComment *)comment
{
    CGFloat vertPadding = 2 * kVERT_PADDING + kAVATAR_SIZE / 2;
    CGFloat height = vertPadding;
    CGFloat width = KScreenW - 2 * kHORN_PADDING - kVERT_PADDING - kAVATAR_SIZE;
    NSDictionary *dic = comment.yuan_comment;
    if (dic != nil && [dic count] > 0) {
        
        ONEQuoteComment *quote = comment.quoteComment;
        height += [NSString heightFromAttributedString:quote.real_content width:width] + 2;
    }
    NSAttributedString *contentAttr = [NSString getMutableAttributedStringFromString:comment.content withFont:[UIFont fontWithName:FONT_NAME_REGULAR size:16.f] withTextColor:DEFAULT_BLACK_COLOR withLineSpace:2];
    CGFloat contentHeight = [NSString heightFromAttributedString:contentAttr width:width] + 2;
    height += contentHeight;
    height += 30;
    return height;
}

- (void)likeCommentAction
{
    !_commentBeLiked ?: _commentBeLiked(_comment);
}


@end
