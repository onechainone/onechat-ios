//
//  LZSocialRedPacketDetailViewController.m
//  OneChainIOS
//
//  Created by chunzheng wang on 2017/12/30.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZSocialRedPacketDetailViewController.h"
#import <ShareSDKUI/ShareSDKUI.h>

#define ScrollViewHeight 750
#define LOCAL_REDIMGBACKGROUNDMERGE 40
#define LOCAL_REDIMGHEIGHT 435
#define LOCAL_REDTOPMERGE 15
#define LOCAL_TIP_TOP_MERGE 76
#define LOCAL_REDUNDERLINE_TOP_MERGE 15
#define LOCAL_URL_LEFT_MERGE 8
@interface LZSocialRedPacketDetailViewController ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *urlLabel;
@property(nonatomic,assign)BOOL isCanSideBack;

@end

@implementation LZSocialRedPacketDetailViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:REDPACKET_TITLE_COLOR];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"social_redpacket", nil);
    //分享 action_share
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"action_share", nil) style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self setupUI];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithHex:REDPACKET_TIP_COLOR]};
    
}
- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, self.view.bounds.size.height)];
    
    self.scrollView = scrollView;
    self.scrollView.bounces = NO;
    self.scrollView.userInteractionEnabled = YES;

    scrollView.backgroundColor = [UIColor whiteColor];
    //    scrollView.center = self.view.center;
    //    scrollView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.contentSize = CGSizeMake(KScreenW, ScrollViewHeight);
    [self.view addSubview: scrollView];
    
    
    UIImageView *redImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"social_redpacketbackground"]];
    [self.scrollView addSubview:redImg];
    [redImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(LOCAL_REDTOPMERGE);
        make.left.offset(LOCAL_REDIMGBACKGROUNDMERGE);
        make.width.offset(KScreenW-LOCAL_REDIMGBACKGROUNDMERGE-LOCAL_REDIMGBACKGROUNDMERGE);
        make.height.offset(LOCAL_REDIMGHEIGHT);
    }];
    //social_redpacket_tip 已经生成红包连接
    UILabel *tipLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:REDPACKET_TIP_COLOR] andTextFont:LITTLE_LABEL_FRONT andContentText:NSLocalizedString(@"social_redpacket_tip", @"Tap the link to get red packet:")];
    tipLabel.numberOfLines = 0;
    [redImg addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(LOCAL_TIP_TOP_MERGE);
        make.centerX.offset(0);
    }];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIImageView *redUnderImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"social_redpacketline"]];
    redUnderImg.userInteractionEnabled = YES;
    
    [self.scrollView addSubview:redUnderImg];
    [redUnderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redImg.mas_left).offset(0);
        make.width.equalTo(redImg.mas_width).offset(0);
        make.top.equalTo(redImg.mas_bottom).offset(LOCAL_REDUNDERLINE_TOP_MERGE);
        make.height.offset(BTN_HEIGHT);
    }];
    //点击复制连接
    UIButton *clickBtn = [UIButton new];
    [clickBtn setTitle:NSLocalizedString(@"tap_copy_url", @"Tap to copy link") forState:UIControlStateNormal];
    [clickBtn sizeToFit];
    [clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clickBtn.titleLabel.font    = [UIFont systemFontOfSize: SMALL_FRONT];
    
    [clickBtn addTarget:self action:@selector(clickBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [redUnderImg addSubview:clickBtn];
    [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-LOCAL_URL_LEFT_MERGE);
        make.centerY.offset(0);
    }];
    
//    NSString *str = [NSString stringWithFormat:SHARE_REDPACKET,self.redid,[self localLaungage]];
    NSString *str = @"";
    UILabel *urlLabel = [UILabel makeLabelWithTextColor:[UIColor whiteColor] andTextFont:SMALL_FRONT andContentText:str];
    self.urlLabel = urlLabel;
    
    [redUnderImg addSubview:urlLabel];
    [urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LOCAL_URL_LEFT_MERGE);
        make.centerY.offset(0);
//        make.right.equalTo(clickBtn.mas_left).offset(0);
        make.width.offset(0.6*redUnderImg.bounds.size.width);
        
    }];
    urlLabel.textAlignment = NSTextAlignmentLeft;
    
    
}
-(void)clickBtnClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.urlLabel.text.length > 0)
    {
        [pasteboard setString:self.urlLabel.text];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"copied_to_clipboard", @"")];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
    
}
-(void)shareBtnClick {
    
    if (self.urlLabel.text.length == 0) {
        
        return;
    }
    
    NSString *shareString = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"social_redpacket_url_start", @"Tap the link to get red packet:"),self.urlLabel.text];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:shareString images:[UIImage imageNamed:@"share_icon"] url:[NSURL URLWithString:self.urlLabel.text] title:nil type:SSDKContentTypeAuto];
    
    [ShareSDK showShareActionSheet:nil items:nil shareParams:params onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        if (state == SSDKResponseStateFail) {
            
            if (error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self showHint:NSLocalizedString(@"group_share_failed", @"Share failed")];
                });
            }
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtnClick {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"quit_social_redpacket_tip", @"Please confirm you've already shared or copied the packet link") preferredStyle:UIAlertControllerStyleAlert];
    ///取消 button_cancel
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
    //确认 button_confirm
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
    
    [alertVC addAction:confirmAction];
    
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.isCanSideBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:THEME_COLOR];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return self.isCanSideBack;
}
- (void)showHint:(NSString *)hint
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = 180;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
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

@end
