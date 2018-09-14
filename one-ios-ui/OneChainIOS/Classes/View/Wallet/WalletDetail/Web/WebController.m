//
//  WebController.m
//  Service
//
//  Created by edz on 2017/8/14.
//  Copyright © 2017年 qlzhx. All rights reserved.
//

#import "WebController.h"
#import "RedPacketMngr.h"
#import <WebKit/WebKit.h>
#define KRELOAD_STRING @"oneapp://onechain.one?a=fast_transfer"

@interface WebController ()<UIWebViewDelegate,WKNavigationDelegate>

@property (nonatomic, strong) UIWebView *webView;

//MBProgressHUD
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation WebController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isRed) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:REDPACKET_TITLE_COLOR];
    }
    [self loadRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.webtitlte;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    //创建WebView
    [self setupWebView];
}

-(void)setupWebView
{

    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, self.view.height - 64)];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
//    [self.webView scalesPageToFit];
    [self.view addSubview:self.webView];
    
#if as_is_test_mode
    [self showCopyUrlBtn];
#endif
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)loadRequest
{
    NSURL *url = [[NSURL alloc ]initWithString:self.weburl];
#if as_is_dev_mode
    NSString *urlString = url.absoluteString;
    showMsg(urlString);    
#endif
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)showCopyUrlBtn
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"复制URL" style:UIBarButtonItemStylePlain target:self action:@selector(copyUrl)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
- (void)copyUrl
{
    if (self.weburl.length > 0) {
        
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        [board setString:self.weburl];
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


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isRed) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:THEME_COLOR];

    }
    
}
@end
