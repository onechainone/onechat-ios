//
//  PreRegisterController.m
//  OneChainIOS
//
//  Created by lifei on 2018/1/9.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "PreRegisterController.h"
#import "ZYKeyboardUtil.h"
#import "LZVerifyWordViewController.h"
#import "CoinTools.h"
#import "LZRecoverViewController.h"

#import "LZRegistViewController.h"
#import "ChooseSeedController.h"
#import "CoinTools.h"
#import "LZNavigationController.h"
#import "NetworkStatusController.h"
#import "GuideView.h"

#define MARGIN_KEYBOARD 20
#define KDETAULT_BLK_COLOR RGBACOLOR(48, 48, 48, 1)

#define KCOPY_LBL_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:14.f]
#define KCOPY_LBL_MARGIN_TOP 20
#define KCOPY_LBL_MARGIN_LEFT 16

#define KSEED_LBL_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:18.f]
#define KSEED_LBL_MARGIN_TOP 8
#define KSEED_LBL_MARGIN_RIGHT 16
#define KSEED_LBL_MARGIN_BOTTOM 20

#define KTIP_LBL_COLOR RGBACOLOR(78, 93, 111, 1.0)
#define KTIP_LBL_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:16.f]

#define KINPUT_SEED_VIEW_HEIGHT 140
#define KINPUT_BTN_MARGIN_RIGHT 18

#define KREMIND_LBL_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:10.f]
#define KREMIND_LBL_MARGIN_TOP 4

#define KRECOVER_BTN_COLOR RGBACOLOR(17, 119, 216, 1)
#define KRECOVER_BTN_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:14.f]

#define KBTN_SIZE CGSizeMake(WidthScale(159), 44)
#define KBTN_LARGE_SIZE CGSizeMake(WidthScale(339), 44)

#define KPRODUCE_BTN_TOP 12

#define kColOfRow 5
#define kWordBtnWidth (CGRectGetWidth(_seedTextView.frame) / 5)
#define kWordBtnHeight 30

#define KWORD_BTN_COLOR [UIColor blackColor]
#define KWORD_BTN_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:14.f]
#define KWORD_BTN_CORNERRADIUS 2.f

#define KCHECK_BTN_TITLE_SIZE 14.f
#define LOCAL_TIP_LABEL_COLOR 0x303030
#define LOCAL_SEEDVIEW_BORDER_COLOR 0xe6e6e6
#define LOCAL_TIP2_LABEL_COLOR 0x838383

static const CGFloat KTIPLBL_TOP = 16.f;
static const CGFloat KTIPLBL_W_PADDING = 10.f;

static const CGFloat SEED_TV_PLACEH_FONT = 12.f;
static const CGFloat SEED_TV_TEXT_FONT = 16.f;

static const CGFloat SEED_TV_ROUNDRADIUS = 3.f;
static const CGFloat SEED_TV_BORDERWIDTH = 1.f;

static const CGFloat SEED_TV_MARGIN_TOP = 24.f;
static const CGFloat SEED_TV_MARGIN_W = 17;
static const CGFloat SEED_TV_MARGIN_BTM = 20;


@interface PreRegisterController ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *tipLbl;
// 已保存助记词
@property (nonatomic, strong) UIButton *savedBtn;
// 生成助记词
@property (nonatomic, strong) UIButton *produceBtn;
// 输入助记词
@property (nonatomic, strong) UIButton *inputBtn;

@property (nonatomic, strong) UILabel *remindLbl;
// 恢复账号
@property (nonatomic, strong) UIButton *recoverBtn;

@property (nonatomic, strong) UITextView *seedTextView;

@property (nonatomic, strong) UIView *inputSeedView;
@property (nonatomic, strong) UIView *produceSeedView;

@property (nonatomic, strong) UILabel *seedLbl;

@property (nonatomic, assign) SeedStatus seedStatus;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;

//@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *words;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *haveSeedBtn;

@property (nonatomic, strong) GuideView *guideView;

@end

@implementation PreRegisterController

- (UIView *)inputSeedView
{
    if (!_inputSeedView) {
        
        _inputSeedView = [[UIView alloc] init];
        _inputSeedView.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
        _seedTextView = [[UITextView alloc] init];
        _seedTextView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:SEED_TV_PLACEH_FONT];
        _seedTextView.textColor = [UIColor lightGrayColor];
        _seedTextView.text = NSLocalizedString(@"accountname_restore_key_tips", @"");
        _seedTextView.delegate = self;
        _seedTextView.layer.cornerRadius = SEED_TV_ROUNDRADIUS;
        _seedTextView.layer.borderColor = [[UIColor colorWithHex:THEME_COLOR] CGColor];
        _seedTextView.layer.borderWidth = SEED_TV_BORDERWIDTH;
        [_inputSeedView addSubview:_seedTextView];
        [_seedTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_inputSeedView.mas_top).offset(SEED_TV_MARGIN_TOP);
            make.left.equalTo(_inputSeedView.mas_left).offset(SEED_TV_MARGIN_W);
            make.right.equalTo(_inputSeedView.mas_right).offset(-SEED_TV_MARGIN_W);
            make.bottom.equalTo(_inputSeedView.mas_bottom).offset(-SEED_TV_MARGIN_BTM);
        }];
    }
    return _inputSeedView;
}

- (UIView *)produceSeedView
{
    if (!_produceSeedView) {
        
        _produceSeedView = [[UIView alloc] init];
//        _produceSeedView.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
        _produceSeedView.backgroundColor = [UIColor whiteColor];
        
        _produceSeedView.layer.borderWidth = 1;
        _produceSeedView.layer.borderColor = [UIColor colorWithHex:LOCAL_SEEDVIEW_BORDER_COLOR].CGColor;
        
        
        _produceSeedView.layer.cornerRadius = 3.f;
        _produceSeedView.layer.masksToBounds = YES;

        
        _seedLbl = [[UILabel alloc] init];
//        _seedLbl.backgroundColor = RGBACOLOR(239, 242, 249, 1);
//        _seedLbl.textColor = [UIColor colorWithHex:THEME_COLOR];
        _seedLbl.textColor = [UIColor colorWithHex:LOCAL_TIP_LABEL_COLOR];

//        _seedLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20.f];
        _seedLbl.font = [UIFont boldSystemFontOfSize:KINPUT_BTN_MARGIN_RIGHT];
//        _seedLbl.font = [UIFont sy]
        
        _seedLbl.numberOfLines = 0;
        _seedLbl.layer.cornerRadius = SEED_TV_ROUNDRADIUS;
        
        _seedLbl.layer.masksToBounds = YES;
        [_produceSeedView addSubview:_seedLbl];
        
        [_seedLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_produceSeedView.mas_left).offset(KCOPY_LBL_MARGIN_LEFT);
            make.top.equalTo(_produceSeedView.mas_top).offset(KSEED_LBL_MARGIN_TOP);
            //            make.left.equalTo(label);
            //            make.top.equalTo(label.mas_bottom).offset(KSEED_LBL_MARGIN_TOP);
            make.right.equalTo(_produceSeedView.mas_right).offset(-KSEED_LBL_MARGIN_RIGHT);
            make.height.mas_greaterThanOrEqualTo(@96);
            make.bottom.equalTo(_produceSeedView.mas_bottom).offset(-KSEED_LBL_MARGIN_BOTTOM);
        }];
        
//        _label = [[UILabel alloc] init];
//        _label.textColor = KDETAULT_BLK_COLOR;
//        _label.font = KCOPY_LBL_FONT;
//        _label.text = NSLocalizedString(@"click_copy", @"");
//        [_produceSeedView addSubview:_label];
//        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(_seedLbl.mas_bottom).offset(KCOPY_LBL_MARGIN_TOP);
//            make.left.equalTo(_seedLbl);
//            make.bottom.equalTo(_produceSeedView.mas_bottom).offset(-KSEED_LBL_MARGIN_BOTTOM);
//        }];
        
#if as_is_dev_mode
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copySeedAction)];
        [_produceSeedView addGestureRecognizer:tap];
#endif
    }
    return _produceSeedView;
}

- (GuideView *)guideView
{
    if (!_guideView) {
        
        _guideView = [[GuideView alloc] initWithGuideStyle:GuideStyleFirst];
        _guideView.backgroundColor = [UIColor whiteColor];
    }
    return _guideView;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"seed", @"");
    
    if (self.type) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back_old"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    }
    [self setupForDismissKeyboard];
    [self configKeyBoardRespond];
    self.view.backgroundColor = [UIColor whiteColor];
    _seedStatus = SeedStatus_Default;
    self.navigationItem.rightBarButtonItem = nil;
    [self _layoutSubviews];
    [self produceSeedAction];
//    [self initNodeCheck];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    if (self.VerifySeed) {
        self.guideView.hidden = YES;
    } else {
        self.guideView.hidden = NO;
    }
}
- (void)userDidTakeScreenshot:(NSNotification *)notification
{
    [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"no_screen_shoot", @"") controller:self];
    
    ///// 这个地方 更换助记词
}
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_layoutSubviews
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_containerView];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    _tipLbl = [[UILabel alloc] init];
    _tipLbl.textColor = [UIColor colorWithHex:LOCAL_TIP_LABEL_COLOR];
    
//    _tipLbl.textColor = KTIP_LBL_COLOR;
//    _tipLbl.font = KTIP_LBL_FONT;
    _tipLbl.font = [UIFont boldSystemFontOfSize:LABEL_FRONT];
    _tipLbl.numberOfLines = 0;
//    _tipLbl.text = NSLocalizedString(@"save_key_tip", @"The following 15 private key mnemonic words are extremely important!!! \nOnce it leaks, you will lose all the digital assets in the wallet! \n Once it loses, you will not be able to recover all your digital assets in your wallet! \n\nHighly recommended:\nhandwrite mnemonic words, backup multiple copies and put them in different safe areas!！\n\nMust be noted:\nplease do not create under the circumstances of being photographed, camera-watching or peeking!\nt is strictly forbidden to transmit the words on Internet and other unsafe environments such as network disk.");
    _tipLbl.text = NSLocalizedString(@"please_rember_the_key", @"Please save these 15 mnemonics on paper(order is important).");
    
    [_containerView addSubview:_tipLbl];
    
    [_tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_containerView.mas_top).offset(KTIPLBL_TOP);
//        make.centerX.offset(0);
        make.left.equalTo(_containerView.mas_left).offset(KTIPLBL_W_PADDING);
        make.right.equalTo(_containerView.mas_right).offset(-KTIPLBL_W_PADDING);
        
    }];
    _tipLbl.textAlignment = NSTextAlignmentCenter;

    UILabel *tipLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:LOCAL_TIP2_LABEL_COLOR] andTextFont:LITTLE_LABEL_FRONT andContentText:NSLocalizedString(@"you_just_do_this", @"Without the mnemonic we cannot help recover wallet and will result in LOSS of ALL of your assets!")];
    tipLabel.numberOfLines = 0;
    [_containerView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipLbl.mas_bottom).offset(10);
//        make.centerX.offset(0);
        make.left.equalTo(_containerView.mas_left).offset(KTIPLBL_W_PADDING);
        make.right.equalTo(_containerView.mas_right).offset(-KTIPLBL_W_PADDING);
    }];
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [_containerView addSubview:self.inputSeedView];
    
    [self.inputSeedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tipLabel.mas_bottom);
        make.left.right.equalTo(_containerView);
        make.height.mas_equalTo(@(KINPUT_SEED_VIEW_HEIGHT));
    }];
    
    [_containerView addSubview:self.produceSeedView];
    
    [self.produceSeedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tipLabel.mas_bottom).offset(20);
        make.left.equalTo(_containerView.mas_left).offset(WidthScale(KINPUT_BTN_MARGIN_RIGHT));
        make.right.equalTo(_containerView.mas_right).offset(-WidthScale(KINPUT_BTN_MARGIN_RIGHT));
        
    }];
    
//    _savedBtn = [self createButton:NSLocalizedString(@"action_have_saved", @"")];
    _savedBtn = [self createButton:NSLocalizedString(@"next_step", @"")];
    
    [_savedBtn addTarget:self action:@selector(savedSeedAction) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_savedBtn];
    
    
    
    UILabel *safeTipLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:LOCAL_TIP2_LABEL_COLOR] andTextFont:TWELFTH_FRONT andContentText:NSLocalizedString(@"safe_tip",@"Security Tips:")];
    [_containerView addSubview:safeTipLabel];

    [safeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.produceSeedView.mas_bottom).offset(12);
        make.left.equalTo(self.produceSeedView.mas_left).offset(0);
        
    }];
    //red1_tip *Write it down or save on offline devices
    UILabel *redTipLabel1 = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:THEME_COLOR] andTextFont:TWELFTH_FRONT andContentText:NSLocalizedString(@"red1_tip",@"*Write it down or save on offline devices")];
                                                                                                                                                          [_containerView addSubview:redTipLabel1];
    [redTipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(safeTipLabel.mas_bottom).offset(5);
        make.left.equalTo(self.produceSeedView.mas_left).offset(0);
    }];
    
    UILabel *redTipLabel2 = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:THEME_COLOR] andTextFont:TWELFTH_FRONT andContentText:NSLocalizedString(@"red2_tip",@"*Restore once after registry to ensure security")];
    [_containerView addSubview:redTipLabel2];
    [redTipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redTipLabel1.mas_bottom).offset(5);
        make.left.equalTo(self.produceSeedView.mas_left).offset(0);
    }];
    
    [self seedStatusChanged:SeedStatus_Produce];
}

- (void)seedStatusChanged:(SeedStatus)status
{
    switch (status) {
        case SeedStatus_Default:
        {
            _seedStatus = SeedStatus_Default;
            [self.inputSeedView setHidden:YES];
            [self.produceSeedView setHidden:NO];
//            [_label setHidden:YES];
            [_savedBtn setHidden:YES];
            
            [_produceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.produceSeedView.mas_bottom).offset(12);
                make.left.equalTo(_containerView.mas_left).offset(WidthScale(KINPUT_BTN_MARGIN_RIGHT));
                make.right.equalTo(_containerView.mas_right).offset(-WidthScale(KINPUT_BTN_MARGIN_RIGHT));
                make.height.mas_equalTo(@44);
            }];
        }
            break;
        case SeedStatus_Produce:
        {
            
            
            _seedStatus = SeedStatus_Produce;
            [self.inputSeedView setHidden:YES];
            [self.produceSeedView setHidden:NO];
            

            
//            [_savedBtn setHidden:NO];
        
            [_savedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.produceSeedView.mas_bottom).offset(89);
                make.centerX.equalTo(_containerView);
                make.size.mas_equalTo(KBTN_LARGE_SIZE);
            }];
            
            [_containerView addSubview:self.guideView];
            
            [self.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(_savedBtn.mas_bottom).offset(HeightScale(100));
                make.left.right.equalTo(_containerView);
                make.bottom.equalTo(_containerView.mas_bottom).offset(-HeightScale(40));
            }];

           
//            [_produceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_savedBtn.mas_bottom).offset(KPRODUCE_BTN_TOP);
//                make.left.equalTo(_containerView.mas_left).offset(WidthScale(KINPUT_BTN_MARGIN_RIGHT));
//                make.size.mas_equalTo(KBTN_SIZE);
//            }];
        }
            break;
        case SeedStatus_Input:
        {
            _seedStatus = SeedStatus_Input;
            [self.inputSeedView setHidden:NO];
            [self.produceSeedView setHidden:YES];
            [_savedBtn setHidden:NO];
            
            [_savedBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.inputSeedView.mas_bottom);
                make.centerX.equalTo(_containerView);
                make.size.mas_equalTo(KBTN_LARGE_SIZE);
            }];
            [_produceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(_savedBtn.mas_bottom).offset(KPRODUCE_BTN_TOP);
                make.left.equalTo(_containerView.mas_left).offset(WidthScale(KINPUT_BTN_MARGIN_RIGHT));
                make.size.mas_equalTo(KBTN_SIZE);
            }];
        }
            break;
        default:
            break;
    }
}

- (UIButton *)createButton:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"Button_BG_big"] forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = KTIP_LBL_FONT;
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}
// 已保存助记词
- (void)savedSeedAction
{
    if (_seedStatus == SeedStatus_Default) return;
    
    if (_seedStatus == SeedStatus_Input) {
        
        if (_seedTextView.text.length > 0 && ![_seedTextView.text isEqualToString:NSLocalizedString(@"accountname_restore_key_tips", @"")]) {
            
            [self judgeSeed:_seedTextView.text];
        } else {
            
            [self showHint:NSLocalizedString(@"please_enter_correct_brainkey", @"")];
            return;
        }
    } else if (_seedStatus == SeedStatus_Produce) {
        
        [self judgeSeed:_seedLbl.text];
    }
    
}

- (void)showWrongSeeds:(NSMutableArray *)wrongSeeds
{
    NSString *seedString = [self seedStringFromSeedArray:wrongSeeds];
    if (seedString.length == 0) {
        
        [self showHint:NSLocalizedString(@"seed_word_wrong", @"")];
        return;
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"seed_word_wrong", @"") message:seedString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self presentViewController:alertC animated:YES completion:nil];
}


- (NSString *)seedStringFromSeedArray:(NSArray *)seedArray
{
    if (seedArray.count == 0) {
        
        return EMPTY_STR;
    }
    NSString *seedString = @"";
    for (NSInteger i = 0; i < seedArray.count; i++) {
        
        if (i == seedArray.count - 1) {
            
            seedString = [seedString stringByAppendingString:seedArray[i]];
        } else {
            seedString = [seedString stringByAppendingString:[NSString stringWithFormat:@"%@ ",seedArray[i]]];
        }
    }
    return seedString;
}


- (void)judgeSeed:(NSString *)seed
{
    if (seed.length == 0) {
        
        [self showHint:NSLocalizedString(@"please_enter_correct_brainkey", @"")];
        return;
    }
    NSMutableArray *invalidSeeds = [NSMutableArray array];
    
    ONEError *error = [ONEChatClient seedIsValid:seed invalidWords:&invalidSeeds];
    if (error != nil) {
        
        if (error.errorCode == ONEErrorSeedIsNull) {
            
            [self showHint:NSLocalizedString(@"seed_is_null", @"")];
        } else if (error.errorCode == ONEErrorSeedCountError) {
            
            [self showHint:NSLocalizedString(@"seed_count_wrong", @"")];
        } else if (error.errorCode == ONEErrorSeedWordError) {
            
            [self showWrongSeeds:invalidSeeds];
        } else {
            
            [self showHint:NSLocalizedString(@"make_sure_seed_error_tip", @"")];
        }
    } else {
        
//#if as_is_dev_mode

        LZRegistViewController *regist = [LZRegistViewController new];
        regist.type = self.type;
        regist.seed = seed;
        [self.navigationController pushViewController:regist animated:YES];

//#else

//        LZVerifyWordViewController *verify = [[LZVerifyWordViewController alloc] init];
//        verify.type = self.type;
//        verify.seed = [seed copy];
//        if (self.VerifySeed) {
//            verify.VerifySeed = @"1";
//        } else {
//
//        }
//        [self.navigationController pushViewController:verify animated:YES];

//#endif
    }
}

// 输入助记词
- (void)inputSeedAction
{
    ChooseSeedController *chooseSeed = [[ChooseSeedController alloc] init];
    chooseSeed.type = self.type;
    if (_seedLbl.text.length > 0) {
        
        chooseSeed.existSeedString = _seedLbl.text;
    }
    chooseSeed.view.backgroundColor = [UIColor whiteColor];
    chooseSeed.selectedSeed = ^(NSString *seedString) {
        
        _seedLbl.text = seedString;
        [self seedStatusChanged:SeedStatus_Produce];
    };
    [self.navigationController pushViewController:chooseSeed animated:YES];
}
// 生成助记词
- (void)produceSeedAction
{
    NSString *seed = @"";
    ///存在就说明是从主页进来要验证
    if (self.VerifySeed) {
        seed = [ONEChatClient seedWithPassword:self.miMa];
    } else {
        seed = [ONEChatClient buildSeed];
    }
    
    if (seed == nil || seed.length == 0) {
        
        [self showHint:NSLocalizedString(@"unable_to_load_brainkey", @"")];
        return;
    }
    _seedLbl.text = seed;

}
// 恢复账号
- (void)recoverAccountAction
{
    LZRecoverViewController *recover = [LZRecoverViewController new];
    [self.navigationController pushViewController:recover animated:YES];
}

// 点击复制
- (void)copySeedAction
{
    if (_seedLbl.text.length > 0) {
        
        BOOL success = [[CoinTools sharedCoinTools] copyToPasteboardWithString:_seedLbl.text];
        NSString *toast = @"";
        if (success) {
            
            toast = NSLocalizedString(@"copied_to_clipboard", @"");
        } else {
            
            toast = NSLocalizedString(@"copy_fail", @"");
        }
        [SVProgressHUD showSuccessWithStatus:toast];
        [SVProgressHUD dismissWithDelay:0.5f];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}


//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:NSLocalizedString(@"accountname_restore_key_tips", @"")]) {
//
//        textView.text = @"";
//        textView.textColor = KTIP_LBL_COLOR;
//        textView.font = KCOPY_LBL_FONT;
//    }
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if (textView.text.length < 1) {
//
//        textView.text = NSLocalizedString(@"accountname_restore_key_tips", @"");
//        textView.textColor = [UIColor lightGrayColor];
//        textView.font = KREMIND_LBL_FONT;
//    }
//}

#pragma mark - Keyboard

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak typeof(self) weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.seedTextView, nil];
    }];
    
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        // KLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}

#pragma mark - ScrollView 刷新

- (void)refreshScrollView
{
    for (UIView *subView in self.seedTextView.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            
            [subView removeFromSuperview];
        }
    }
    int tmp = ([self.words count] + 1) % kColOfRow;
    int row = (int)([self.words count] + 1) / kColOfRow;
    row += tmp == 0 ? 0 : 1;
    self.seedTextView.contentSize = CGSizeMake(self.seedTextView.frame.size.width, row * kWordBtnHeight);
    
    NSInteger i = 0;
    NSInteger j = 0;
    
    for (i = 0; i < row; i++) {
        
        for (j = 0; j < kColOfRow; j++) {
            
            NSInteger index = i * kColOfRow + j;
            if (index <= self.words.count) {
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(j * kWordBtnWidth, i * kWordBtnHeight, kWordBtnWidth, kWordBtnHeight)];
                [button setTitle:[self.words objectAtIndex:index] forState:UIControlStateNormal];
                button.titleLabel.adjustsFontSizeToFitWidth = YES;
                [button setTitleColor:RGBACOLOR(48, 48, 48, 1) forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.f];
                [self.seedTextView addSubview:button];
            }
        }
    }
    
}

#pragma mark - 节点检测

- (void)initNodeCheck
{
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:KCHECK_BTN_TITLE_SIZE];
    UIColor *btn_title_color = nil;
    if ([self.navigationController isKindOfClass:[LZNavigationController class]]) {
        
        btn_title_color = [UIColor blackColor];
    } else {
        
        btn_title_color = [UIColor colorWithHex:THEME_COLOR];
    }
    [checkBtn setFrame:CGRectMake(0, 0, 80,40)];
    [checkBtn setTitleColor:btn_title_color forState:UIControlStateNormal];
    [checkBtn setTitle:NSLocalizedString(@"switch_service_node", @"") forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkNode:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)checkNode:(UIButton *)sender {
    
    NetworkStatusController *networkStatus = [[NetworkStatusController alloc] init];
    [self.navigationController pushViewController:networkStatus animated:YES];
}



@end

