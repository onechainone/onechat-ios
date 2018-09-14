//
//  PrepareController.m
//  OneChainIOS
//
//  Created by lifei on 2018/1/26.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "PrepareController.h"
#import "SeedPrepareController.h"
#import "LZRecoverViewController.h"
#import "UIView+DebugMode.h"
#import "LZExchangeRateTableViewController.h"
#import "SeedSegmentController.h"
#import "DecryptWalletSegmentController.h"
#import "LZRegistViewController.h"
#define KRECOVER_BTN_BOTTOM 89
#define KRECOVER_BTN_HOR_PADDING 25
#define KRECOVER_BTN_HEIGHT 44
#define KREGISTER_BTN_BOTTOM 26


static const CGFloat KBUTTON_FONT_SIZE = 16.f;

@interface PrepareController ()

@property (nonatomic, strong) UIImageView *bgView;
// 注册
@property (nonatomic, strong) UIButton *registerBtn;
// 恢复
@property (nonatomic, strong) UIButton *recoverBtn;

@property (nonatomic, assign) NSInteger tapCount;
@end

@implementation PrepareController


#pragma mark - getters

- (UIImageView *)bgView
{
    if (!_bgView) {
        
        _bgView = [[UIImageView alloc] init];
        UIImage *bgImage = nil;
        if (IS_IPHONE_X) {
            bgImage = [UIImage imageNamed:@"Prepare_BG"];
        } else {
            bgImage = [UIImage imageNamed:@"Prepare_BG"];
        }
        _bgView.image = bgImage;
        _bgView.contentMode = UIViewContentModeScaleToFill;
        _bgView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMe:)];
//        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIButton *)registerBtn
{
    if (!_registerBtn) {
        
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:KBUTTON_FONT_SIZE];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"Button_register_new"] forState:UIControlStateNormal];
        [_registerBtn setTitle:NSLocalizedString(@"register_new_account", @"Newbie Registration") forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (UIButton *)recoverBtn
{
    if (!_recoverBtn) {
        
        _recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recoverBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recoverBtn.titleLabel setFont:[UIFont fontWithName:FONT_NAME_REGULAR size:KBUTTON_FONT_SIZE]];
        [_recoverBtn setBackgroundImage:[UIImage imageNamed:@"Button_recover_BG"] forState:UIControlStateNormal];
        [_recoverBtn setTitle:NSLocalizedString(@"accountname_restore_title", @"Restore Account") forState:UIControlStateNormal];
        [_recoverBtn addTarget:self action:@selector(recoverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recoverBtn;
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
    _tapCount = 1;
    [self _layoutSubviews];
    [self switchMode];
}
#pragma mark - 添加手势
- (void)switchMode
{
    [self.bgView setNeedsLayout];
    [self.bgView layoutIfNeeded];
}

#pragma mark - UI init

- (void)_layoutSubviews
{
    [self.view addSubview:self.bgView];
    [self.view sendSubviewToBack:self.bgView];
    
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.recoverBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self.recoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-HeightScale(KRECOVER_BTN_BOTTOM));
        make.left.equalTo(self.view.mas_left).offset(WidthScale(KRECOVER_BTN_HOR_PADDING));
        make.right.equalTo(self.view.mas_right).offset(-WidthScale(KRECOVER_BTN_HOR_PADDING));
        make.height.mas_equalTo(@(KRECOVER_BTN_HEIGHT));
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.recoverBtn);
        make.height.mas_equalTo(@(KRECOVER_BTN_HEIGHT));
        make.bottom.equalTo(self.recoverBtn.mas_top).offset(-KREGISTER_BTN_BOTTOM);
    }];
    //select_langurafe 切换语言按钮
    UIButton *langugeBtn = [UIButton new];
    [langugeBtn setTitle:NSLocalizedString(@"select_langurafe", @"Select language") forState:UIControlStateNormal];
    [langugeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:langugeBtn];
    [langugeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-WidthScale(KRECOVER_BTN_HOR_PADDING));
        make.bottom.offset(-20);
    }];
    [langugeBtn sizeToFit];
    [langugeBtn addTarget:self action:@selector(languageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    ///版本号
    NSString *str =  [NSString stringWithFormat:@"v%@",[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];

    UILabel *banBenLabel = [UILabel makeLabelWithTextColor:[UIColor whiteColor] andTextFont:16 andContentText:str];
    [self.view addSubview:banBenLabel];
    [banBenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recoverBtn);
        make.bottom.offset(-20);
        
    }];
    
    
}

-(void)languageBtnClick{
    LZExchangeRateTableViewController *languageVC = [LZExchangeRateTableViewController new];
    languageVC.type = CHAGELANGUAGE;
    languageVC.shouYe = CHAGELANGUAGE;
    languageVC.passValue = [self yingSheWith:[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE]];
    
    [self.navigationController pushViewController:languageVC animated:YES];
}
-(NSString *)yingSheWith:(NSString *)str {
    
    NSDictionary *dic = @{
                          LANGUAGE_EN:ENGLISH,
                          LANGUAGE_ZH_HANS:JIANTIZHONGWEN,
                          LANGUAGE_DE:DEYU,
                          LANGUAGE_KO:HANWEN,
                          LANGUAGE_IT:YIDALIYU,
                          LANGUAGE_FR:FAYU,
                          LANGUAGE_FIL:FEILVBINYU,
                          LANGUAGE_PT:PUTAOYAYU,
                          LANGUAGE_NL:HELANYU,
                          LANGUAGE_ID:YINDUNIXIYAYU,
                          LANGUAGE_ES:XIBANYAYU,
                          LANGUAGE_AR:ALABOYU,
                          LANGUAGE_HI:YINDUYU,
                          LANGUAGE_JA:RIYU,
                          };
    
    return [dic objectForKey:str];
    
}
#pragma mark - Selectors

// 注册
- (void)registerBtnClick
{
    LZRegistViewController *regist = [[LZRegistViewController alloc] init];
    regist.seed = [ONEChatClient buildSeed];
    [self.navigationController pushViewController:regist animated:YES];
}

- (void)recoverBtnClick
{
    SeedSegmentController *seg = [[SeedSegmentController alloc] init];
    [self.navigationController pushViewController:seg animated:YES];
}



@end
