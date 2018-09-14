//
//  RedPacketDetailController.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/22.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "RedPacketDetailController.h"
#import "RedPacketMngr.h"
#import <WebKit/WebKit.h>
@interface RedPacketDetailController ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *redBagId;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) NSString *urlString;
@end

@implementation RedPacketDetailController

- (instancetype)initWithRedBagId:(NSString *)redBagId
{
    self = [super init];
    if (self) {
        
        _redBagId = redBagId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0xDB5942];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_SEMIBOLD size:18], NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self loadRedPacketDetail];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [self.navigationController.navigationBar setBackgroundImage:THMImage(@"navigationbar_image") forBarMetrics:UIBarMetricsDefault];
    if (IS_IPHONE_PLUS) {
        [self.navigationController.navigationBar setBackgroundImage:THMImage(@"navigationbar_image_plus") forBarMetrics:UIBarMetricsDefault];
    } else if (IS_IPHONE_X) {
        [self.navigationController.navigationBar setBackgroundImage:THMImage(@"navigationbar_image_x") forBarMetrics:UIBarMetricsDefault];
    }
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_SEMIBOLD size:18], NSForegroundColorAttributeName : THMColor(@"conversation_title_color")};
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor blackColor]};
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"underline"]];
    self.navigationController.navigationBar.barTintColor = THMColor(@"bg_white_color");
    [self.navigationController.navigationBar setShadowImage:THMImage(@"nav_shadow_image")];

//    if(kDevice_Is_iPhoneX) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBG_iphonex"] forBarMetrics:UIBarMetricsDefault];
//
//    } else {
//        if (IS_IPHONE_PLUS) {
//            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBG_plus"] forBarMetrics:UIBarMetricsDefault];
//        } else {
//            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBG"] forBarMetrics:UIBarMetricsDefault];
//        }
//    }

}

- (void)loadRedPacketDetail
{
    NSString *docUrl = [NSString stringWithFormat:@"%@", [ONEUrlHelper redpacketDetailH5FromRedpacketId:_redBagId]];
    NSURL *url = [NSURL URLWithString:docUrl];
    _urlString = url.absoluteString;
#if as_is_dev_mode
    NSString *urlString = url.absoluteString;
    showMsg(urlString);
#endif
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"red_packet_info", @"");

    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-WD_TabBarHeight)];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
#if as_is_test_mode
    [self showCopyUrlBtn];
#endif
}

- (void)showCopyUrlBtn
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"复制URL" style:UIBarButtonItemStylePlain target:self action:@selector(copyUrl)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
- (void)copyUrl
{
    if (_urlString.length > 0) {
        
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        [board setString:_urlString];
        [SVProgressHUD showSuccessWithStatus:@"已复制到剪切板"];
        [SVProgressHUD dismissWithDelay:0.5f];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = url.absoluteString;
    if ([urlString hasPrefix:@"oneapp://onechain.one"]) {

        if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [[UIApplication sharedApplication] openURL:url options:@{}
                                         completionHandler:^(BOOL success) {
                                         }];
            } else {
                BOOL success = [[UIApplication sharedApplication] openURL:url];
            }

        } else{
            bool can = [[UIApplication sharedApplication] canOpenURL:url];
            if(can){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {

        decisionHandler(WKNavigationActionPolicyAllow);
    }
}






@end
