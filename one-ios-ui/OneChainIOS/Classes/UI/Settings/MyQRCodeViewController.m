//
//  MyQRCodeViewController.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/15.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "MyQRCodeViewController.h"
#import "MyQRCodeView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MOBShareSDKHelper.h"
#import <ShareSDKUI/ShareSDKUI.h>

static const CGFloat QRVIEW_TOP = 50;
static const CGFloat QRVIEW_HORIZ_PADDING = 30;
static const CGFloat URL_BG_TOP = 7;
static const CGFloat URL_BG_HEIGHT = 44;
static const CGFloat TITLE_FONT = 10.f;
static const CGFloat URL_LBL_LEFT = 8;
static const CGFloat URL_LBL_WIDTH = 200;
#define KTITLE_COLOR 0x808080

@interface MyQRCodeViewController ()
@property (nonatomic, strong) MyQRCodeView *qrCodeView;
// 账号用户名
@property (nonatomic, copy) NSString *name;
// 昵称
@property (nonatomic, copy) NSString *nick;
// 头像url
@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, strong) UIImage *avatarImage;

@property (nonatomic, strong) UIImageView *bottomImageView;

@property (nonatomic, strong) UILabel *urlLbl;
@property (nonatomic, strong) UIButton *getUrlBtn;

@end

@implementation MyQRCodeViewController

- (instancetype)initWithName:(NSString *)name nickName:(NSString *)nick avatarUrl:(NSString *)avatarUrl
{
    self = [super init];
    if (self) {
        
        _name = name;
        _nick = nick;
        _avatarUrl = avatarUrl;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    
    [self setupSubviews];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.themeMap = @{
                          TextColorName:@"conversation_title_color"
                          };
    [shareBtn setTitle:NSLocalizedString(@"action_share", @"") forState:UIControlStateNormal];
    [shareBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [shareBtn addTarget:self action:@selector(shareMyCard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupSubviews
{
    _qrCodeView = [[MyQRCodeView alloc] init];
//    _qrCodeView.backgroundColor = [UIColor whiteColor];
    _qrCodeView.themeMap = @{
                             BGColorName:@"bg_white_color"
                             };
    [self.view addSubview:_qrCodeView];
    [_qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(QRVIEW_TOP);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(QRVIEW_HORIZ_PADDING);
        make.right.equalTo(self.view.mas_right).offset(-QRVIEW_HORIZ_PADDING);
    }];
    _qrCodeView.name = _name;
    _qrCodeView.nick = _nick;
    _qrCodeView.avatarUrl = _avatarUrl;
    
    _bottomImageView = [[UIImageView alloc] init];
    _bottomImageView.themeMap = @{
                                  ImageName:@"offset_bg_image"
                                  };
//    _bottomImageView.image = [UIImage imageNamed:@"Rectangle 105"];
    [self.view addSubview:_bottomImageView];
    
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_qrCodeView.mas_bottom).offset(URL_BG_TOP);
        make.centerX.width.equalTo(_qrCodeView);
        make.height.mas_equalTo(URL_BG_HEIGHT);
    }];
    
    _urlLbl = [[UILabel alloc] init];
    _urlLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:TITLE_FONT];
//    _urlLbl.textColor = [UIColor colorWithHex:KTITLE_COLOR];
    _urlLbl.themeMap = @{
                         TextColorName:@"conversation_detail_color"
                         };

    NSString *str = [NSString stringWithFormat:[ONEUrlHelper personalShareHost],_name, [self localLaungage]];
    _urlLbl.text = str;
    
    _urlLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.view addSubview:_urlLbl];
    
    [_urlLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_bottomImageView.mas_left).offset(URL_LBL_LEFT);
        make.centerY.equalTo(_bottomImageView);
        make.width.equalTo(@(WidthScale(URL_LBL_WIDTH)));
        make.height.equalTo(_bottomImageView);
    }];
    
    _getUrlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getUrlBtn setTitle:NSLocalizedString(@"copy_url", @"") forState:UIControlStateNormal];
//    [_getUrlBtn setTitleColor:[UIColor colorWithHex:KTITLE_COLOR] forState:UIControlStateNormal];
    _getUrlBtn.themeMap = @{
                            TextColorName:@"conversation_detail_color"
                            };
    _getUrlBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:TITLE_FONT];
    [_getUrlBtn addTarget:self action:@selector(copyUrl) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_getUrlBtn];
    
    [_getUrlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_urlLbl.mas_right);
        make.centerY.height.equalTo(_urlLbl);
        make.right.equalTo(_bottomImageView.mas_right);
    }];
    
}
- (NSString *)localLaungage
{
    NSString *language = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] && ![[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:@""])
    {
        language = [[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE];
    } else {
        
        language = [[CoinTools sharedCoinTools] getPreferredLanguage];
    }
    return language;
}

- (void)shareMyCard
{
    NSString *shareString = [NSString stringWithFormat:NSLocalizedString(@"user_invite_url_start", @"Tap the link to add me as ONE friends:%@"),_urlLbl.text];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:shareString images:[UIImage imageNamed:@"share_icon1"] url:[NSURL URLWithString:_urlLbl.text] title:nil type:SSDKContentTypeAuto];
    
    [ShareSDK showShareActionSheet:nil items:nil shareParams:params onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        if (state == SSDKResponseStateFail) {
            
            if (error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                });
            }
        }
    }];
}

- (void)copyUrl
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_urlLbl.text.length > 0)
    {
        [pasteboard setString:_urlLbl.text];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"copied_to_clipboard", @"")];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
}

@end
