//
//  EncryptSeedExportController.m
//  OneChainIOS
//
//  Created by lifei on 2018/3/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "EncryptSeedExportController.h"
#import "EncryptSeedExportTip.h"
#define kTEXTVIEW_BORDER_COLOR [UIColor colorWithHex:0xE6E6E6]
static const CGFloat kTEXTVIEW_BORDER_WIDTH = .5;
static const CGFloat kTEXTVIEW_CORNERRADIUS = 3.f;
static const CGFloat kENCRYPTTIP_PADDING = 20;
static const CGFloat kENCRYPTTIP_TOP = 12;
static const CGFloat kTEXTVIEW_FONT_SIZE = 10.f;
static const CGFloat kTEXTVIEW_TOP = 30;
static const CGFloat kTEXTVIEW_HEIGHT = 131;
static const CGFloat kCOPY_BTN_FONT_SIZE = 16.f;
static const CGFloat kCOPY_BTN_PADDING = 40;
static const CGFloat kCOPY_BTN_HEIGHT = 44;


@interface EncryptSeedExportController ()

@property (nonatomic, strong) EncryptSeedExportTip *tempEncryptTip;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSString *encrypted_seed;
@end

@implementation EncryptSeedExportController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"export_encrypted_seed", @"");
    
    _encrypted_seed = [self getEncryptSeed];

    [self _initUI];
    
    
}

- (NSString *)getEncryptSeed
{
    return [ONEChatClient getEncryptedSeed];
}

- (void)_initUI
{
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.themeMap = @{
                        BGColorName:@"bg_white_color"
                        };
    [self.view addSubview:scroll];
    
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    UIView *container = [[UIView alloc] init];
    container.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    [scroll addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(scroll);
        make.width.equalTo(scroll.mas_width);
    }];
    NSArray *tips = @[
                        @{
                            @"title":NSLocalizedString(@"save_offline_title", @""),
                            @"content":NSLocalizedString(@"save_offline_content", @"")
                        },
                        @{
                            @"title":NSLocalizedString(@"transmission_offline_title", @""),
                            @"content":NSLocalizedString(@"transmission_offline_content", @"")
                        },
                        @{
                            @"title":NSLocalizedString(@"remember_password_title", @""),
                            @"content":NSLocalizedString(@"remember_password_content", @"")
                        }
                    ];
    for (NSInteger i = 0; i < tips.count; i++) {
        
        NSDictionary *tipDic = tips[i];
        EncryptSeedExportTip *encryptTip = [[EncryptSeedExportTip alloc] initWithTitle:tipDic[@"title"] content:tipDic[@"content"]];
        encryptTip.themeMap = @{
                                BGColorName:@"bg_white_color"
                                };
        [container addSubview:encryptTip];

        [encryptTip mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(container.mas_left).offset(kENCRYPTTIP_PADDING);
            make.right.equalTo(container.mas_right).offset(-kENCRYPTTIP_PADDING);
            if (_tempEncryptTip) {
                make.top.equalTo(_tempEncryptTip.mas_bottom).offset(kENCRYPTTIP_TOP);
            } else {
                make.top.equalTo(container.mas_top).offset(kENCRYPTTIP_PADDING);
            }
        }];
        _tempEncryptTip = encryptTip;
    }
    _textView = [[UITextView alloc] init];
    _textView.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kTEXTVIEW_FONT_SIZE];
    _textView.themeMap = @{
                           TextColorName:@"conversation_detail_color",
                           BGColorName:@"bg_white_color"
                           };
    _textView.text = _encrypted_seed;
    _textView.userInteractionEnabled = NO;
    [container addSubview:_textView];

    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_tempEncryptTip.mas_bottom).offset(kTEXTVIEW_TOP);
        make.left.right.equalTo(_tempEncryptTip);
        make.height.mas_equalTo(@(kTEXTVIEW_HEIGHT));
        
    }];

    _textView.layer.borderColor = [THMColor(@"input_text_border_color") CGColor];
    _textView.layer.borderWidth = kTEXTVIEW_BORDER_WIDTH;
    _textView.layer.cornerRadius = kTEXTVIEW_CORNERRADIUS;
    _textView.layer.masksToBounds = YES;
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kCOPY_BTN_FONT_SIZE];
    
    copyBtn.themeMap = @{
                         BGColorName:@"theme_color",
                         TextColorName:@"theme_title_color"
                         };
    
    [copyBtn setTitle:NSLocalizedString(@"copy_encrypted_seed", @"") forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];

    [container addSubview:copyBtn];

    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_textView.mas_bottom).offset(kCOPY_BTN_PADDING);
        make.left.right.equalTo(_textView);
        make.height.mas_equalTo(@(kCOPY_BTN_HEIGHT));
        make.bottom.equalTo(container.mas_bottom).offset(-(2 * kCOPY_BTN_PADDING));
    }];
}

- (void)copyAction
{
    BOOL copied = [[CoinTools sharedCoinTools] copyToPasteboardWithString:_textView.text];
    if (copied) {
        
        [self showHint:NSLocalizedString(@"copied_to_clipboard", @"Copied to clipboard")];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:KUSERDEFAULT_KEY_EXPORT_ENCRYPT_SEED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [self showHint:NSLocalizedString(@"copy_fail", @"Copy failed")];
    }
}
@end
