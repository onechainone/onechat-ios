//
//  MyQRCodeView.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/15.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "MyQRCodeView.h"

static const CGFloat kPadding = 20;
static const CGFloat kAvatarWidth = 70;
static const CGFloat kLabelFont = 15;
@interface MyQRCodeView()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UIImageView *qrCodeView;
@property (nonatomic, strong) UILabel *bannerLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation MyQRCodeView

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        
        _avatarView = [[UIImageView alloc] init];
        _avatarView.layer.cornerRadius = kAvatarWidth / 2;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:kLabelFont];
        _nameLabel.themeMap = @{
                                TextColorName:@"conversation_title_color"
                                };
//        _nameLabel.textColor = [UIColor grayColor];
    }
    return _nameLabel;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.font = [UIFont systemFontOfSize:kLabelFont];
        _nickLabel.themeMap = @{
                      TextColorName:@"conversation_title_color"
                      };
//        _nickLabel.textColor = [UIColor grayColor];
    }
    return _nickLabel;
}

- (UIImageView *)qrCodeView
{
    if (!_qrCodeView) {
        
        _qrCodeView = [[UIImageView alloc] init];
    }
    return _qrCodeView;
}

- (UILabel *)bannerLabel
{
    if (!_bannerLabel) {
        
        _bannerLabel = [[UILabel alloc] init];
        _bannerLabel.font = [UIFont systemFontOfSize:13.f];
        _bannerLabel.themeMap = @{
                                  TextColorName:@"golden_text_color"
                                  };
//        _bannerLabel.textColor = [UIColor grayColor];
        _bannerLabel.textAlignment = NSTextAlignmentCenter;
        _bannerLabel.adjustsFontSizeToFitWidth = YES;
        _bannerLabel.text = NSLocalizedString(@"my_qr_code_tip", @"Scan the QR code to add me.");
    }
    return _bannerLabel;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = /**[UIImage imageNamed:@"Rectangle 105"]*/ THMImage(@"offset_bg_image");
    }
    return _backgroundImageView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    [self addSubview:self.backgroundImageView];
    [self sendSubviewToBack:self.backgroundImageView];
    [self addSubview:self.avatarView];
    [self addSubview:self.nickLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.qrCodeView];
    [self addSubview:self.bannerLabel];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(kPadding);
        make.left.equalTo(self.mas_left).offset(kPadding);
        make.width.height.mas_equalTo(@(70));
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.avatarView.mas_centerY).offset(-kPadding/3);
        make.left.equalTo(self.avatarView.mas_right).offset(kPadding);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.avatarView.mas_centerY).offset(kPadding/3);
        make.left.equalTo(self.nickLabel);
    }];
    
    [self.qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.avatarView.mas_bottom).offset(kPadding);
        make.left.equalTo(self.mas_left).offset(3 * kPadding);
        make.right.equalTo(self.mas_right).offset(-3 * kPadding);
        make.height.equalTo(self.qrCodeView.mas_width);
    }];
    
    [self.bannerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.qrCodeView.mas_bottom).offset(kPadding);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-kPadding);
    }];
}

- (void)setName:(NSString *)name
{
    if (name.length > 0) {
        
        self.nameLabel.text = [NSString stringWithFormat:@"ID: %@", name];
        NSString *qrCodeString = [QRCODE_PATH_ADDFRIEND stringByAppendingString:name];
        [self.qrCodeView layoutIfNeeded];
        CGSize size = self.qrCodeView.size;
        UIImage *qrImage = [ONEChatClient qrCodeImageWithString:qrCodeString size:self.qrCodeView.size scale:1.f];
        self.qrCodeView.image = qrImage;
    }
}

- (void)setNick:(NSString *)nick
{
    if (nick.length > 0) {
        
        self.nickLabel.text = nick;
    }
}


- (void)setAvatarUrl:(NSString *)avatarUrl
{
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString addURLStr:avatarUrl]] placeholderImage:[UIImage imageNamed:@"maniconplaceholder"] completed:nil];
}
@end
