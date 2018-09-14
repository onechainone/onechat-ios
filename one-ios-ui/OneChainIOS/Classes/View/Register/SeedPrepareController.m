//
//  SeedPrepareController.m
//  OneChainIOS
//
//  Created by lifei on 2018/1/26.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "SeedPrepareController.h"
#import "PreRegisterController.h"
#import "ChooseSeedController.h"
#define KBANNER_TOP 88
#define KSEED_BG_TOP 222
#define KSEED_BG_HEIGHT 292.5
#define KHAVE_SEED_LBL_TOP 179
#define KHAVE_SEED_LBL_LEFT 55

@interface SeedPrepareController ()

@property (nonatomic, strong) UIImageView *seedBgView;

@property (nonatomic, strong) UILabel *bannerLbl;

@property (nonatomic, strong) UILabel *haveSeedLbl;

@property (nonatomic, strong) UILabel *notHaveSeedLbl;

@end

@implementation SeedPrepareController

#pragma mark - getters

- (UILabel *)bannerLbl
{
    if (!_bannerLbl) {
        
        _bannerLbl = [[UILabel alloc] init];
        _bannerLbl.numberOfLines = 0;
        _bannerLbl.textAlignment = NSTextAlignmentCenter;
        [_bannerLbl setAttributedText: [self bannerText]];
    }
    return _bannerLbl;
}

- (UIImageView *)seedBgView
{
    if (!_seedBgView) {
        
        _seedBgView = [[UIImageView alloc] init];
        
        UIImage *img = [UIImage imageNamed:@"Seed_BG"];
        
        _seedBgView.image = img;
        _seedBgView.contentMode = UIViewContentModeScaleAspectFit;
        _seedBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_seedBgView addGestureRecognizer:tap];
    }
    return _seedBgView;
}

- (UILabel *)haveSeedLbl
{
    if (!_haveSeedLbl) {
        
        _haveSeedLbl = [[UILabel alloc] init];
        _haveSeedLbl.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:14.f];
        _haveSeedLbl.textAlignment = NSTextAlignmentCenter;
        _haveSeedLbl.textColor = [UIColor whiteColor];
        _haveSeedLbl.text = NSLocalizedString(@"have_word", @"I have already");
    }
    return _haveSeedLbl;
}

- (UILabel *)notHaveSeedLbl
{
    if (!_notHaveSeedLbl) {
        
        _notHaveSeedLbl = [[UILabel alloc] init];
        _notHaveSeedLbl.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:14.f];
        _notHaveSeedLbl.textAlignment = NSTextAlignmentCenter;
        _notHaveSeedLbl.textColor = [UIColor whiteColor];
        _notHaveSeedLbl.text = NSLocalizedString(@"have_no_seed", @"No yet");
    }
    return _notHaveSeedLbl;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _layoutSubviews];
}

#pragma mark - UI init

- (void)_layoutSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bannerLbl];
    [self.view addSubview:self.seedBgView];
    
    [self.seedBgView addSubview:self.haveSeedLbl];
    [self.seedBgView addSubview:self.notHaveSeedLbl];
    
    [self.bannerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(HeightScale(KBANNER_TOP));
        make.centerX.equalTo(self.view);
    }];
    
    [self.seedBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(HeightScale(KSEED_BG_TOP));
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(@(HeightScale(KSEED_BG_HEIGHT)));
    }];
    
    [self.haveSeedLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.seedBgView.mas_top).offset(HeightScale(KHAVE_SEED_LBL_TOP));
        make.centerX.equalTo(self.seedBgView.mas_centerX).offset(- KScreenW / 4 - WidthScale(5));
    }];
    
    [self.notHaveSeedLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.seedBgView.mas_centerX).offset(KScreenW / 4 + WidthScale(5));
        
        make.top.equalTo(self.haveSeedLbl);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(HeightScale(35));
        make.left.equalTo(self.view.mas_left).offset(WidthScale(18));
        make.size.mas_equalTo(CGSizeMake(20, 14));
    }];
    UILabel *thirdLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:MONEY_COUNT_COLOR] andTextFont:LITTLE_LABEL_FRONT andContentText:NSLocalizedString(@"support_third_party", @"支持第三方钱包助记词注册")];
    [self.view addSubview:thirdLabel];
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(HeightScale(150));
        make.centerX.offset(0);
        make.width.offset(KScreenW);
    }];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    
    thirdLabel.numberOfLines = 0;
    
    
    
    
    
    
}

#pragma mark - Selectors

- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:self.seedBgView];
    if (CGRectContainsPoint(CGRectMake(0, 0, CGRectGetWidth(self.seedBgView.frame) / 2, CGRectGetHeight(self.seedBgView.frame)), tapPoint)) {
        
        ChooseSeedController *chooseSeed = [[ChooseSeedController alloc] init];
        [self.navigationController pushViewController:chooseSeed animated:YES];
        
    } else {
        
        PreRegisterController *preRegister = [[PreRegisterController alloc] init];
        [self.navigationController pushViewController:preRegister animated:YES];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Other

- (NSAttributedString *)bannerText
{
    NSString *seedString = NSLocalizedString(@"seed", @"");
    NSString *bannerString = NSLocalizedString(@"choose_if_have", @"Do you have mnemonics?");
    
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:bannerString attributes:@{NSFontAttributeName: [UIFont fontWithName:FONT_NAME_MEDIUM size:24.f], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF303030]}];
    
    if ([bannerString rangeOfString:seedString].location != NSNotFound) {
        
        NSRange range = [bannerString rangeOfString:seedString];
        
        [mAttr addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0x8FCBFF]} range:range];
    } else if ([bannerString rangeOfString:@"mnemonics"].location != NSNotFound) {
        
        NSRange range = [bannerString rangeOfString:@"mnemonics"];
        
        [mAttr addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0x8FCBFF]} range:range];
    }
    NSAttributedString *string = [[NSAttributedString alloc] initWithAttributedString:mAttr];
    
    return string;
}



@end

