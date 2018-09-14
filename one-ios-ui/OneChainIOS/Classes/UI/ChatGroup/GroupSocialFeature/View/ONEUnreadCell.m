//
//  ONEUnreadCell.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/12.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEUnreadCell.h"
#define kHORN_PADDING 18
#define kWEIBO_VIEW_WIDTH 50
@interface ONEUnreadCell()

@property (nonatomic, strong) UIImageView *weiboView;
@property (nonatomic, strong) UILabel *weiboLbl;
@end

@implementation ONEUnreadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
    }
    return self;
}

- (void)setupSubviews
{
    [super setupSubviews];
    self.contentLbl.numberOfLines = 1;
    [self.contentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.avatarView.mas_centerY).offset(2);
        make.left.equalTo(self.nickNameLbl);
        make.right.equalTo(self.contentView.mas_right).offset(-(kHORN_PADDING*2 + kWEIBO_VIEW_WIDTH));
    }];
    [self.likeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.avatarView.mas_centerY).offset(2);
        make.left.equalTo(self.nickNameLbl);
    }];
    [self.subTimeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLbl);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    _weiboView = [[UIImageView alloc] init];
    _weiboView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_weiboView];
    
    [_weiboView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-kHORN_PADDING);
        make.top.equalTo(self.avatarView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kWEIBO_VIEW_WIDTH, kWEIBO_VIEW_WIDTH));
    }];
    [self.quoteContentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.weiboView);
        make.top.equalTo(self.avatarView.mas_top);
        make.bottom.equalTo(self.subTimeLbl.mas_top);
        make.height.lessThanOrEqualTo(@60);
    }];
    
    self.quoteContentLbl.themeMap = @{
                                      TextColorName:@"common_text_color"
                                      };
}

- (void)setModel:(ONEUnreadModel *)model
{
    _model = model;
    self.nickNameLbl.text = _model.nickname;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:_model.avatar_url] placeholderImage:[UIImage defaultAvaterImage]];
    self.subTimeLbl.text = [NSDate formattedTimeFromTimeInterval:[_model.create_time integerValue]];
    
    switch (_model.type) {
        case 1:
            {
                [self.contentLbl setHidden:YES];
                [self.likeButton setHidden:NO];
                [self.likeButton setImage:[UIImage imageNamed:@"IUQuanShang"] forState:UIControlStateNormal];
                [self refreshTimeLblConstraints];
            }
            break;
            case 2:
        {
            [self.contentLbl setHidden:YES];
            [self.likeButton setHidden:NO];

            if ([_model.is_like isEqualToString:@"1"]) {
                
                [self.likeButton setImage:[UIImage imageNamed:@"article_like_selected"] forState:UIControlStateNormal];
            } else if ([_model.is_like isEqualToString:@"2"]) {
                [self.likeButton setImage:[UIImage imageNamed:@"article_dislike_selected"] forState:UIControlStateNormal];
            }
            [self refreshTimeLblConstraints];
        }
            break;
            case 4:
        {
            [self.contentLbl setHidden:YES];
            [self.likeButton setHidden:NO];

            [self.likeButton setImage:[UIImage imageNamed:@"IUQuanYiZan"] forState:UIControlStateNormal];
            [self refreshTimeLblConstraints];
        }
            break;
            case 3:
        {
            [self.likeButton setHidden:YES];
            [self.contentLbl setHidden:NO];

            self.contentLbl.text = _model.content;
        }
            break;
            case 5:
        {
            [self.contentLbl setHidden:NO];
            [self.likeButton setHidden:YES];
            self.contentLbl.text = [NSString stringWithFormat:@"%@%@",_model.nickname, NSLocalizedString(@"push_pay_weibo", @"")];
        }
            break;
        default:
            break;
    }
    NSString *weibo_type = _model.weibo_type;
    if ([weibo_type isEqualToString:@"video"]) {
        [self.quoteContentLbl setHidden:YES];
        [self.weiboView sd_setImageWithURL:[NSURL URLWithString:_model.video_jietu_url] placeholderImage:nil];
    } else if ([weibo_type isEqualToString:@"image"]) {
        [self.quoteContentLbl setHidden:YES];
        [self.weiboView sd_setImageWithURL:[NSURL URLWithString:_model.pic_url] placeholderImage:nil];
    } else {
        [self.weiboView setHidden:YES];
        self.quoteContentLbl.text = _model.weibo_content;
    }
}

- (void)refreshTimeLblConstraints
{
    [self.subTimeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.likeButton);
        make.top.equalTo(self.likeButton.mas_bottom).offset(10);
        make.width.equalTo(@(200));
    }];
}

+ (CGFloat)heightWithModel:(ONEUnreadModel *)unreadModel
{
    CGFloat height = 90;
    return height;
    
    switch (unreadModel.type) {
        case 1:
        case 2:
        case 4:
        {
            return 80;
        }
            break;
        case 3:
        case 5:
        {
            NSAttributedString *mAttr = [[NSAttributedString alloc] initWithString:unreadModel.content attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_REGULAR size:14],NSForegroundColorAttributeName:DEFAULT_BLACK_COLOR}];
            CGRect contentFrame = [mAttr boundingRectWithSize:CGSizeMake(KScreenW - 152, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            CGFloat contentHeight = contentFrame.size.height;
            height = height + contentHeight;
        }
            break;
            
            
        default:
            break;
    }
    return height;
}
@end
