//
//  DKSWebViewController.m
//  DKSWebView
//
//  Created by aDu on 2017/2/14.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "DKSWebViewController.h"
#import "URLHandle.h"
@interface NSURLRequest (InvalidSSLCertificate)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end

@interface DKSWebViewController ()

@property (nonatomic, strong) NSURLRequest *request;
//当前网页的请求
@property (nonatomic, strong) NSURLRequest *nowRequest;

//判断是否是HTTPS的
@property (nonatomic, assign) BOOL isAuthed;



//下面的三个属性是添加进度条的
@property (nonatomic, assign) BOOL theBool;
@property (nonatomic, strong) NSTimer *timer;
//右滑返回
@property(nonatomic,assign)BOOL isCanSideBack;

@end

@implementation DKSWebViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:REDPACKET_TITLE_COLOR];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor] withCGRect:self.navigationController.navigationBar.bounds] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBG"] forBarMetrics:UIBarMetricsDefault];
//    if (IS_IPHONE_PLUS) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBG_plus"] forBarMetrics:UIBarMetricsDefault];
//    } else if (IS_IPHONE_X) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBG_iphonex"] forBarMetrics:UIBarMetricsDefault];
//    }
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_SEMIBOLD size:18], NSForegroundColorAttributeName : [UIColor blackColor]};
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return self.isCanSideBack;
}

 
 - (void)cleanCacheAndCookie{
 
 //清除cookies
 
 NSHTTPCookie *cookie;
 
 NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
 
 for (cookie in [storage cookies]){
 
 [storage deleteCookie:cookie];
 
 }
 
 //清除UIWebView的缓存
 
 [[NSURLCache sharedURLCache] removeAllCachedResponses];
 
 NSURLCache * cache = [NSURLCache sharedURLCache];
 
 [cache removeAllCachedResponses];
 
 [cache setDiskCapacity:0];
 
 [cache setMemoryCapacity:0];
 
 }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    [self addLeftButton];
    [self addRightButton];
    
    //添加进度条（如果没有需要，可以注释掉
    [self addProgressBar];
    [self cleanCacheAndCookie];
}
-(void)addRightButton {
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightBtn.titleLabel.text = NSLocalizedString(@"recharge", nil);
    //    rightBtn.titleLabel.tintColor = [UIColor whiteColor];
    [right setFrame:CGRectMake(0, 0, 40, 40)];
    [right setTitle:NSLocalizedString(@"action_refresh", nil) forState:UIControlStateNormal];
    
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(shuaXinWeb) forControlEvents:UIControlEventTouchUpInside];
    [right sizeToFit];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBut;
    
    
    
}
-(void)shuaXinWeb {

    [self.webView loadRequest:self.nowRequest];
//    [self cleanCacheAndCookie];
    
    //nowRequest
    
}
//加载URL
- (void)loadHTML:(NSString *)htmlString
{
    NSURL *url = [NSURL URLWithString:htmlString];
    self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    [self.webView loadRequest:self.request];
}

#pragma mark - UIWebViewDelegate

//开始加载
- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [[request URL] absoluteString];
    if ([url hasPrefix:@"oneapp://onechain.one"]) {
        [URLHandle handleWithUrl:[request URL]];
        return NO;
    }
    NSString* scheme = [[request URL] scheme];
    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [awebView stopLoading];
            return NO;
        }
    }
    return YES;
}
/*
 - (void)webViewDidFinishLoad:(UIWebView *)webView {
 NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
 }
 
 */
//设置webview的title为导航栏的title

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    self.theBool = true; //加载完毕后，进度条完成
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    ///当前网页
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSURL *url = [NSURL URLWithString:currentURL];
    self.nowRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        self.isAuthed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"网络不给力");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.isAuthed = YES;
    //webview 重新加载请求。
    [self.webView loadRequest:self.request];
    [connection cancel];
}

#pragma mark - 添加关闭按钮

- (void)addLeftButton
{
//    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];

}

//点击返回的方法
- (void)backNative
{
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        [self closeNative];
    }
}

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark - init

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //这是一张“<”的图片，可以让美工给切一张
        UIImage *image = [UIImage imageNamed:@"icon_back"];
        [btn setImage:image forState:UIControlStateNormal];
        //head_return
        [btn setTitle:NSLocalizedString(@"head_return", @"Back") forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont fontWithName:FONT_NAME_REGULAR size:17]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //字体的多少为btn的大小
        [btn sizeToFit];
        //左对齐
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //让返回按钮内容继续向左边偏移15，如果不设置的话，就会发现返回按钮离屏幕的左边的距离有点儿大，不美观
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        btn.frame = CGRectMake(0, 0, 40, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        //string_close 
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"string_close", @"Close") style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
        _closeItem.tintColor = [UIColor blackColor];
    }
    return _closeItem;
}

#pragma mark - 下面所有的方法是添加进度条

- (void)addProgressBar
{
    // 仿微信进度条
    CGFloat progressBarHeight = 0.5f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.progressView.trackTintColor = [UIColor grayColor]; //背景色
    self.progressView.progressTintColor = [UIColor blueColor]; //进度色
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除progressView  because UINavigationBar is shared with other ViewControllers
    [self.progressView removeFromSuperview];
    self.isCanSideBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [self.navigationController.navigationBar setBackgroundImage:THMImage(@"navigationbar_image") forBarMetrics:UIBarMetricsDefault];
    if (IS_IPHONE_PLUS) {
        [self.navigationController.navigationBar setBackgroundImage:THMImage(@"navigationbar_image_plus") forBarMetrics:UIBarMetricsDefault];
    } else if (IS_IPHONE_X) {
        [self.navigationController.navigationBar setBackgroundImage:THMImage(@"navigationbar_image_x") forBarMetrics:UIBarMetricsDefault];
    }
    [self.navigationController.navigationBar setTranslucent:NO];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_SEMIBOLD size:18], NSForegroundColorAttributeName : THMColor(@"conversation_title_color")};
    [ONEThemeManager resetStatusBarStyle];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:THEME_COLOR];
//    [self cleanCacheAndCookie];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.progressView.progress = 0;
    self.theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

- (void)timerCallback
{
    if (self.theBool) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [self.timer invalidate];
            self.timer = nil;
        } else {
            self.progressView.progress += 0.1;
        }
    } else {
        self.progressView.progress += 0.1;
        if (self.progressView.progress >= 0.9) {
            self.progressView.progress = 0.9;
        }
    }
}

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
