//
//  ONEUserInfoView.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/23.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEUserInfoView.h"
#import "ExtendedButton.h"
#import "CoinInfoMngr.h"
@interface ONEUserInfoView()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nickNameLbl;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *inviteCodeLbl;
@property (nonatomic, strong) ExtendedButton *qrCodeBtn;
@property (nonatomic, strong) ExtendedButton *settingBtn;
@property (nonatomic, strong) ONEUserAssetView *leftView;
@property (nonatomic, strong) ONEUserAssetView *centerView;
@property (nonatomic, strong) ONEUserAssetView *rightView;
@end

@implementation ONEUserInfoView


#pragma mark - getters

- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.themeMap = @{
                             ImageName:@"user_info_bg"
                             };
    }
    return _bgView;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.layer.cornerRadius = 26.5;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nickNameLbl
{
    if (!_nickNameLbl) {
        _nickNameLbl = [[UILabel alloc] init];
        _nickNameLbl.font = [UIFont fontWithName:FONT_NAME_SEMIBOLD size:18.f];
        _nickNameLbl.themeMap = @{
                                  TextColorName:@"setting_user_nick",
                                  };
        _nickNameLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLbl;
}

- (UILabel *)nameLbl
{
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:12];
        _nameLbl.textColor = [UIColor whiteColor];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLbl;
}

- (UILabel *)inviteCodeLbl
{
    if (!_inviteCodeLbl) {
        _inviteCodeLbl = [[UILabel alloc] init];
        _inviteCodeLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:12];
        _inviteCodeLbl.textColor = [UIColor whiteColor];
        _inviteCodeLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _inviteCodeLbl;
}

- (ExtendedButton *)qrCodeBtn
{
    if (!_qrCodeBtn) {
        _qrCodeBtn = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        _qrCodeBtn.themeMap = @{
                                NormalImageName:@"setting_item_qr_code"
                                };
        [_qrCodeBtn addTarget:self action:@selector(qrcodeTappedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrCodeBtn;
}

- (ExtendedButton *)settingBtn
{
    if (!_settingBtn) {
        _settingBtn = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        _settingBtn.themeMap = @{
                                 NormalImageName:@"setting_item_more_setting"
                                 };
        [_settingBtn addTarget:self action:@selector(settingTappedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

- (ONEUserAssetView *)leftView
{
    if (!_leftView) {
        
        _leftView = [[ONEUserAssetView alloc] initWithTitle:nil subTitle:@"ONEGOOD"];
    }
    return _leftView;
}

- (ONEUserAssetView *)centerView
{
    if (!_centerView) {
        _centerView = [[ONEUserAssetView alloc] initWithTitle:nil subTitle:@"ONEBAD"];
    }
    return _centerView;
}

- (ONEUserAssetView *)rightView
{
    if (!_rightView) {
        _rightView = [[ONEUserAssetView alloc] initWithTitle:nil subTitle:NSLocalizedString(@"chat_asset_num", @"")];
    }
    return _rightView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _layoutSubviews];
        [self _initActions];

    }
    return self;
}

#pragma mark - Update Data

- (void)updateAccountInfo:(WSAccountInfo *)info
{
    if (info) {
        _accountInfo = info;
        [self _updateUIWithAccountInfo:_accountInfo];
    }
}


- (void)_updateUIWithAccountInfo:(WSAccountInfo *)info
{
    if (!info) {
        return;
    }
    [self _updateAvatarWithAccountInfo:info];
    NSString *accountNick = [info nickname];
    if (![accountNick isEqual:[NSNull null]] && [accountNick length] > 0) {
        self.nickNameLbl.text = accountNick;
    } else {
        self.nickNameLbl.text = [info name];
    }
    self.nameLbl.text = [NSString stringWithFormat:@"ID: %@",info.name];
    self.inviteCodeLbl.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"invitation_code", @""),[[info.ID componentsSeparatedByString:@"."] lastObject]];
    [self updateAssetInfoWithAccountInfo:info];
    
}

- (void)updateAssetInfoWithAccountInfo:(WSAccountInfo *)info
{
    if ([[ONEChatClient sharedClient] myAssetBalanceDic]) {
        NSInteger intcount = [[[ONEChatClient sharedClient] myAssetBalanceDic][ONE_CHATID] integerValue]/ONECHATMULTIPLE;
        NSString *finalCount = [NSString stringWithFormat:@"%zd",intcount];
        [self.rightView updateAssetView:finalCount];
    }
    NSDictionary *oneGoodDic = [[ONEChatClient sharedClient] informationFromAssetCode:ONE_GOOD_ASSET_CODE];

    [self.leftView updateAssetView:[self assetCountFromDic:oneGoodDic]];
    
    NSDictionary *oneBadDic = [[ONEChatClient sharedClient] informationFromAssetCode:ONE_BAD_ASSET_CODE];
    [self.centerView updateAssetView:[self assetCountFromDic:oneBadDic]];
}



- (NSString *)assetCountFromDic:(NSDictionary *)dic
{
    if (!dic) {
        return nil;
    }
    NSDictionary *amountDic = [[ONEChatClient sharedClient] myAssetBalanceDic];
    id amount = amountDic[dic[@"asset_id"]];
    NSString *ta = nil;
    if ([amount isKindOfClass:[NSNumber class]]) {
        NSNumber *na = (NSNumber *)amount;
        ta = [na stringValue];
    } else {
        ta = amount;
    }
    NSNumber *p = [NSNumber numberWithInt:3];
    int min_prece = [p intValue];
    WSBigNumber* n = [[WSBigNumber alloc] initWithDecimalString:ta];
    NSString* strAmount =  [n stringWithRShiftDec:min_prece];
    
    return strAmount;
}

- (void)_updateAvatarWithAccountInfo:(WSAccountInfo *)info
{
    UIImage *defaultImage = nil;
    if (info.sex == AccountMan) {
        defaultImage = [UIImage imageNamed:@"maniconplaceholder"];
    } else if (info.sex == AccountWoman) {
        defaultImage = [UIImage imageNamed:@"womaniconpalceholder"];
    } else {
        defaultImage = [UIImage imageNamed:@"peopleicon"];
    }
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString addURLStr:info.avatar_url]] placeholderImage:defaultImage];
}


#pragma mark - Init Actions

- (void)_initActions
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wholeAction:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Selectors

- (void)wholeAction:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if ([_delegate respondsToSelector:@selector(userInfoViewDidTapped:)]) {
            
            [_delegate userInfoViewDidTapped:self];
        }
    }
}

- (void)qrcodeTappedAction
{
    if ([_delegate respondsToSelector:@selector(userInfoView:didQRCodeClicked:)]) {
        
        [_delegate userInfoView:self didQRCodeClicked:_accountInfo];
    }
}

- (void)settingTappedAction
{
    if ([_delegate respondsToSelector:@selector(userInfoViewSettingClicked:)]) {
        
        [_delegate userInfoViewSettingClicked:self];
    }
}

#pragma mark - Layout UI
- (void)_layoutSubviews
{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        CGFloat top = 33;
        if (IS_IPHONE_X) {
            top += 20;
        }
        make.top.equalTo(self.mas_top).offset(top);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.height.mas_equalTo(@53);
    }];
    
    [self addSubview:self.nickNameLbl];
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.top.equalTo(self.avatarView);
    }];
    
    
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.nickNameLbl);
        make.top.equalTo(self.nickNameLbl.mas_bottom).offset(2);
    }];
    
    [self addSubview:self.inviteCodeLbl];
    [self.inviteCodeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(2);
    }];

    [self addSubview:self.settingBtn];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.avatarView);
        make.right.equalTo(self.mas_right).offset(-18);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self addSubview:self.qrCodeBtn];
    [self.qrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.settingBtn.mas_left).offset(-20);
        make.top.equalTo(self.settingBtn);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self);
        make.width.equalTo(self.mas_width).dividedBy(3);
        make.top.equalTo(self.avatarView.mas_bottom).offset(16);
        make.bottom.equalTo(self.mas_bottom).offset(-35);
    }];
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftView.mas_right);
        make.top.bottom.width.equalTo(self.leftView);
    }];
    
    [self addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.centerView.mas_right);
        make.top.bottom.equalTo(self.centerView);
        make.right.equalTo(self);
    }];
    
}



@end

@implementation ONEUserAssetView

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super init];
    if (self) {
        _assetCount = title;
        _assetType = subTitle;
        [self setupSubviews];
    }
    return self;
}

- (void)updateAssetView:(NSString *)title
{
    if ([title length] > 0) {
        _assetCount = title;
        _titleLbl.text = _assetCount;
    } else {
        _assetCount = @"0";
        _titleLbl.text = _assetCount;
    }
}

- (void)setupSubviews
{
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.font = [UIFont fontWithName:@"Avenir-Black" size:16.f];
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.textColor = [UIColor whiteColor];
    _titleLbl.text = _assetCount;
    [self addSubview:_titleLbl];
    
    _subLbl = [[UILabel alloc] init];
    _subLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:11.f];
    _subLbl.textAlignment = NSTextAlignmentCenter;
    _subLbl.textColor = [UIColor whiteColor];
    _subLbl.text = _assetType;
    [self addSubview:_subLbl];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.width.equalTo(self);
    }];
    [_subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.width.equalTo(_titleLbl);
        make.bottom.equalTo(self);
    }];
}
@end
