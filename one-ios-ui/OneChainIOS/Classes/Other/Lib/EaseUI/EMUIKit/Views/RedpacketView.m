//
//  RedpacketView.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/20.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "RedpacketView.h"

#define kCommon_text_color  [UIColor colorWithRed:255/255.0 green:221/255.0 blue:174/255.0 alpha:1/1.0]

static const CGFloat kAvatar_width = 36.f;
static const CGFloat kNick_lbl_font = 16.f;
static const CGFloat kSend_red_font = 10.f;
static const CGFloat kMsg_font = 20.f;
static const CGFloat kRedpacket_origin_x = 63;
static const CGFloat kRedpacket_origin_y = 166;
static const CGFloat kRedpacket_size_width = 250;
static const CGFloat kRedpacket_size_height = 368;
static const CGFloat kAvatar_top = 32;
static const CGFloat kNick_top = 4;
static const CGFloat kNick_left_right = 5;
static const CGFloat kMsg_top = 108;
static const CGFloat kMsg_left_right_bottom = 38;

@interface RedpacketView()

@property (nonatomic, strong) id<IMessageModel> model;
@property (nonatomic, strong) UIImageView *redpacketView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *send_redLabel;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIButton *clickBtn;

@end

@implementation RedpacketView

- (UIImageView *)redpacketView
{
    if (!_redpacketView) {
        
        _redpacketView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"Red_bg"];
        _redpacketView.image = image;
    }
    return _redpacketView;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        
        _avatarView = [[UIImageView alloc] init];
        _avatarView.layer.cornerRadius = kAvatar_width/2;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kNick_lbl_font];
        _nickLabel.textColor = kCommon_text_color;
        _nickLabel.adjustsFontSizeToFitWidth = YES;
        _nickLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nickLabel;
}

- (UILabel *)send_redLabel
{
    if (!_send_redLabel) {
        
        _send_redLabel = [[UILabel alloc] init];
        _send_redLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kSend_red_font];
        _send_redLabel.textColor = kCommon_text_color;
        _send_redLabel.text = NSLocalizedString(@"red_packet_text", @"Send A Packet");
        _send_redLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _send_redLabel;
}

- (UILabel *)msgLabel
{
    if (!_msgLabel) {
        
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kMsg_font];
        _msgLabel.textColor = kCommon_text_color;
        _msgLabel.numberOfLines = 0;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _msgLabel;
}

- (UIButton *)clickBtn
{
    if (!_clickBtn) {
        
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickBtn setImage:[UIImage imageNamed:@"Red_click"] forState:UIControlStateNormal];
        [_clickBtn setImage:[UIImage imageNamed:@"Red_click"] forState:UIControlStateHighlighted];
        [_clickBtn addTarget:self action:@selector(clickRedbag) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}


- (instancetype)initWithModel:(id<IMessageModel>)model
{
    self = [super initWithFrame:CGRectMake(WidthScale(kRedpacket_origin_x), HeightScale(kRedpacket_origin_y), WidthScale(kRedpacket_size_width), HeightScale(kRedpacket_size_height))];
    if (self) {
        
        _model = model;
        
        [self _layoutSubviews];
        [self setupViewData:_model];
    }
    return self;
}

- (void)setupViewData:(id<IMessageModel>)model
{
    if (!model) {
        
        return;
    }
    [self.avatarView sd_setImageWithURL:model.avatarURLPath placeholderImage:model.avatarImage completed:nil];
    self.nickLabel.text = model.nickname;
    self.msgLabel.text = model.red_msg;
}

- (void)_layoutSubviews
{
    _coverView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_coverView];
    [_coverView addSubview:self.redpacketView];
    [_coverView addSubview:self.avatarView];
    [_coverView addSubview:self.nickLabel];
    [_coverView addSubview:self.send_redLabel];
    [_coverView addSubview:self.msgLabel];
    [_coverView addSubview:self.clickBtn];
    
    self.redpacketView.userInteractionEnabled = YES;
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    [self.redpacketView addGestureRecognizer:cancelTap];
    [self.redpacketView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(_coverView);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.redpacketView.mas_top).offset(HeightScale(kAvatar_top));
        make.centerX.equalTo(self.redpacketView);
        make.width.height.equalTo(@(kAvatar_width));
    }];
    

    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.avatarView.mas_bottom).offset(kNick_top);
        make.centerX.equalTo(self.avatarView);
        make.left.lessThanOrEqualTo(self.redpacketView.mas_left).offset(kNick_left_right);
        make.right.lessThanOrEqualTo(self.redpacketView.mas_right).offset(-kNick_left_right);
    }];
    
    [self.send_redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nickLabel.mas_bottom);
        make.centerX.equalTo(self.nickLabel);

    }];
    
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.send_redLabel.mas_bottom).offset(HeightScale(kMsg_top));
        make.centerX.equalTo(self.send_redLabel);
        make.left.lessThanOrEqualTo(self.redpacketView.mas_left).offset(WidthScale(kMsg_left_right_bottom));
        make.right.lessThanOrEqualTo(self.redpacketView.mas_right).offset(-WidthScale(kMsg_left_right_bottom));
        make.bottom.lessThanOrEqualTo(self.redpacketView.mas_bottom).offset(-HeightScale(kMsg_left_right_bottom));
    }];
    
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(HeightScale(108));
        make.width.height.mas_equalTo(@(WidthScale(103)));
    }];
    
    
}

- (void)clickRedbag {
    
    [UIView beginAnimations:@"doflip" context:nil];
    
    [UIView setAnimationDuration:.5];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.clickBtn cache:YES];
        
    [UIView commitAnimations];
    
    !_clickRedbag ?: _clickRedbag(_model);
}

- (void)cancelClick {
    
    !_clickCancel ?: _clickCancel();
}

@end
