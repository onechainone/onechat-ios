//
//  AppDelegate.m
//  LZEasemob3
/**
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻----
 * 　　┃　　　　　　 ┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　  ┃
 * 　　┃　　　　　　 ┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　 ┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>
#import "LZLoginWritePassWordViewController.h"
#import "LZNavigationController.h"
#import "LZTabBarController.h"



//实时监测网络状态
#import "RealReachability.h"
#import "RedPacketMngr.h"
#import "LZBackupWalletViewController.h"


#import "LZRegistViewController.h"


#import "UMMobClick/MobClick.h"

#import "PreRegisterController.h"

#import "LaunchTestView.h"


#import "PrepareController.h"

#import "URLHandle.h"

#define Def_CarshInfoTag @"carsh_info_tag"
#define LAST_LOAD_VERSION @"last_run_version_of_application"
#define DefNetReqExceptionNotifTag @"NetReqExceptionNotifTag"

#define CHECK_LOOP_TIME (30 * 60)


@interface AppDelegate ()<UNUserNotificationCenterDelegate,NetAssociationDelegate, ONEChatClientDelegate>{
    
    NetworkClock *          netClock;           // complex clock
    NetAssociation *        netAssociation;     // one-time server
    
}



@property (nonatomic, strong) LaunchTestView *launchView;

/**
 重新获取token后，上次拉取数据的时间
 */
@property (nonatomic) CFAbsoluteTime lastRequestTime;


@property (nonatomic, weak) LZTabBarController *tab;

@property (nonatomic, copy) dispatch_source_t timer;

@property (nonatomic, strong) NSURL *schemeURL;


@property (nonatomic) BOOL needUpgradeTag;

@end

#define EaseMobAppKey @"nacker#lzeasemob"
#define EMSDKApnsCertName @"lzeasemob"


void uncaughtExceptionHandler(NSException*exception){
    
    NSLog(@"CRASH: %@", exception);
    
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
    
    NSArray* msgList = [exception callStackSymbols];
    
    NSMutableString* s = [NSMutableString new];
    
    for(NSString* msg in msgList) {
        
        [s appendFormat:@"%@\n",msg];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString* smsg = [NSString stringWithFormat:@"%@",s];
    
    [defaults setObject:smsg forKey:Def_CarshInfoTag];
    
    NSLog(@"**********************");
    // Internal error reporting
}

@implementation AppDelegate


-(void)laodGeLinTime {
    
    netClock = [NetworkClock sharedNetworkClock];
    NSTimer * repeatingTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0]
                                                        interval:1.0
                                                          target:self
                                                        selector:@selector(timerFireMethod:)
                                                        userInfo:nil
                                                         repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:repeatingTimer
                                 forMode:NSDefaultRunLoopMode];
    netAssociation = [[NetAssociation alloc] initWithServerName:[NetAssociation ipAddrFromName:@"time.apple.com"]];
    netAssociation.delegate = self;
    [netAssociation sendTimeQuery];
    
    [ONEChatClient setNetworkDate:^NSDate *{
       
        return netClock.networkTime;
    }];
    
}
- (void) timerFireMethod:(NSTimer *) theTimer {

    
}
- (void) reportFromDelegate {
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self exceptionHandle];
    
    _needUpgradeTag = NO;
    [self laodGeLinTime];
    [self judgeLanguge];


    [[ONEChatClient sharedClient] registerSDK];
    
    _lastRequestTime = 0;
    //开始检测网络状态
    [GLobalRealReachability startNotifier];
    // 初始化友盟
    [self umengConfig];
    
    // 注册通知
    [self registerNotifications];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [ONEThemeManager start];
    
    //检测节点
    [self checkNetStatus];
//    self.window.rootViewController = [UIViewController new];
    //调用格林尼治时间
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)judgeLanguge {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] && ![[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:@""]) {
        [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE]];
    }
    else {
        //判断语言
        NSString *languageType = [self getPreferredLanguage];
        
        if([languageType rangeOfString:LANGUAGE_ZH_HANS].location !=NSNotFound)
        {
            [self setLanguageWithName:LANGUAGE_ZH_HANS];
        }
        ///日语
        else if ([languageType rangeOfString:LANGUAGE_JA].location !=NSNotFound) {
            [self setLanguageWithName:LANGUAGE_JA];
            
        }
        ///德语
        else if ([languageType rangeOfString:LANGUAGE_DE].location !=NSNotFound) {
            [self setLanguageWithName:LANGUAGE_DE];
            
        }
        //韩语
        else if ([languageType rangeOfString:LANGUAGE_KO].location !=NSNotFound){
            
            [self setLanguageWithName:LANGUAGE_KO];
            
        }///意大利语
        else if([languageType rangeOfString:LANGUAGE_IT].location !=NSNotFound) {
            [self setLanguageWithName:LANGUAGE_IT];
            
        }
        ///法语
        else if([languageType rangeOfString:LANGUAGE_FR].location !=NSNotFound){
            [self setLanguageWithName:LANGUAGE_FR];
            
        }
        ///菲律宾语
        else if([languageType rangeOfString:LANGUAGE_FIL].location !=NSNotFound){
            [self setLanguageWithName:LANGUAGE_FIL];
            
        }
        //葡萄牙语
        else if([languageType rangeOfString:LANGUAGE_PT].location !=NSNotFound){
            [self setLanguageWithName:LANGUAGE_PT];
            
        }
        //荷兰语
        else if([languageType rangeOfString:LANGUAGE_NL].location !=NSNotFound){
            [self setLanguageWithName:LANGUAGE_NL];
            
        }
        ///印度尼西亚
        else if([languageType rangeOfString:LANGUAGE_ID].location !=NSNotFound){
            [self setLanguageWithName:LANGUAGE_ID];
            
        }
        ///西班牙语
        else if([languageType rangeOfString:LANGUAGE_ES].location !=NSNotFound){
            [self setLanguageWithName:LANGUAGE_ES];
            
        }
        ///阿拉伯语
        else if([languageType rangeOfString:LANGUAGE_AR].location !=NSNotFound){
            [self setLanguageWithName:LANGUAGE_AR];
            
        }
        ///印度语
        else if([languageType rangeOfString:LANGUAGE_HI].location !=NSNotFound){
            [self setLanguageWithName:LANGUAGE_HI];
            
        }
        else
        {
            [self setLanguageWithName:ENGLISHLANGUGETYPE];
        }
        
        
    }
    
}
-(void)setLanguageWithName:(NSString *)str {
    
    [NSBundle setLanguage:str];
    // 然后将设置好的语言存储好，下次进来直接加载
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:MY_LANGUAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void)registerNotifications
{

    [[ONEChatClient sharedClient] addDelegate:self delegateQueue:nil];
    //更换跟控制器
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchRootViewController:) name:NOTIFICATION_SWITCH_ROOT_VIEWCONTROLLER object:nil];
    
    [self registerSwitchRootControllerNotification];
}

- (void)_judgeVC {
    
    if ([ONEChatClient isHomeAccountExist]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SWITCHROOT object:@(RootControllerTypeEnterPwd)];
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SWITCHROOT object:@(RootControllerTypeRegister)];
    }
}





-(void) exceptionHandle {
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
#if as_is_dev_mode
    
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString* msg = [defaults objectForKey:Def_CarshInfoTag];
        
        if( msg != nil ) {
            
            showMsg(msg);
            
            [defaults removeObjectForKey:Def_CarshInfoTag];
            
        }
        
        
        
    }
    
    
#endif
}



- (void)checkAction
{
    __block NSMutableArray *badNodes = [NSMutableArray array];
    __block BOOL hasBad = YES;
    
    [[ONEChatClient sharedClient] initNode:^(ServerInfo *si, BOOL state) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (state == NO) {
                
                hasBad = NO;
            }
            
            BOOL status = state;
            NSDictionary *dic = @{
                                  @"name":[NSString stringWithFormat:@"%@-%@",si.name,[si.activeNode objectForKey:@"service_uuid"]],
                                  @"status":@(status)
                                  };
            [badNodes addObject:dic];
        });
        
    } cb:^(BOOL state, id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (hasBad == YES && state == YES) {
                
                [self _judgeVC];
                [self hideLaunchTestView];
                
            } else {
                
                [self.launchView showNodeInfo:badNodes];
            }
            
            [self startCheckNodeLoop];
            
            [[ONEChatClient sharedClient] updateNodeUrl];
            
        });

    }];
}

- (void)checkNetStatus
{
    BOOL isFirstLoad = [ONEChatClient isHomeAccountExist];

    if (!isFirstLoad) {
        
        [self showLaunchTestView];
        [self checkAction];
        
    } else {

        [[ONEChatClient sharedClient] updateNodeUrl];
       [self _judgeVC];
    }
}




- (void)startCheckNodeLoop
{
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, CHECK_LOOP_TIME * NSEC_PER_SEC);

    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
    
    dispatch_source_set_timer(_timer, start, CHECK_LOOP_TIME * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        [[ONEChatClient sharedClient] initNode:^(ServerInfo *si, BOOL state) {
            
        } cb:^(BOOL state, id data) {
            
        }];
    });
    dispatch_resume(_timer);
    
}

-(void) umengConfig {
    
    ///友盟统计
    UMConfigInstance.appKey = @"5a372678f29d98537a000045";
    
    [MobClick startWithConfigure:UMConfigInstance];
//    [MobClick setLogEnabled:YES];
    
}





//通知切换根控制器
-(void)switchRootViewController:(NSNotification *)noti {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SWITCHROOT object:@(RootControllerTypeShowRoot)];
    
}
//#endif

//// NOTE: iOS9.0之前使用的API接口
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    return YES;
}

// NOTE: iOS9.0之后使用新的API接口
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    if ([ONEChatClient isHomeAccountActive] == FALSE) {
        _schemeURL = [url copy];
    } else {
        [self handleWithUrl:url];
    }
    return YES;
}

- (void)handleWithUrl:(NSURL *)url
{
    if (url == nil) return;
    
    if (_schemeURL) _schemeURL = nil;
    
    NSMutableDictionary *config = [URLHandle configFromUrl:url];
    
    if (config == nil) return;
    
    NSString *action = [config objectForKey:@"a"];
    
    if (action == nil || action.length == 0) return;
    
    if ([action isEqualToString:SCHEME_ACTION_JOIN_GROUP]) {
        // 加入群组
        NSString *groupId = [config objectForKey:@"g"];
        if (groupId.length > 0) {
            
            [URLHandle addGroupWithGroupId:groupId];
            
            return;
        }
    }else if ([action isEqualToString:SCHEME_ACTION_ADD_FRIEND]) {
        // 添加好友
        NSString *username = [config objectForKey:@"n"];
        if (username.length > 0) {
            
            [URLHandle addFriendWithUsername:username];
        }
    }else if ([action isEqualToString:SCHEME_ACTION_DIALOG]) {
        NSString *str = [config objectForKey:@"s"];
        [[UIAlertController shareAlertController] showAlertcWithString:str controller:[RedPacketMngr topViewController]];
    }else if ([action isEqualToString:SCHEME_ACTION_LOGIN]) {
        
        [RedPacketMngr showPasswordVC];
    }
}




#pragma mark - ONEChatClientDelegate

// 账号验证完成
- (void)accountVerificationFinish:(AccountVerifyType)type
{
    NSLog(@"accountVerificationFinish");
    [[ONEChatClient sharedClient] updateFriendAccountInfoWithCompletion:^(ONEError *error) {
       
        [self _accountVerificationFinish:type];
    }];
}

- (void)_accountVerificationFinish:(AccountVerifyType)type
{
    if ([ONEChatClient homeAccountName] == nil) {
        
        
        return;
    }
    if( [ONEChatClient homeAccountId] == nil ) {
    
        
        return;
    }
    // 获取token
    [RedPacketMngr loginWithCompletetion:^(GetTokenStatus status) {
        
        [[ONEChatClient sharedClient] initContext];
        [self syncChatAboutInfo:type];
    }];

}

- (void)syncChatAboutInfo:(AccountVerifyType)type
{
    if (_tab && type == AccountVerifyTypeRecover) {
        
        [_tab showLoading];
    }
    [[ONEChatClient sharedClient] syncChatMessage:^(ONEError *error) {
       
        if (type == AccountVerifyTypeRecover) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tab hideLoading];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_schemeURL) {
                
                [self handleWithUrl:[_schemeURL copy]];
            }
        });
    }];
}

- (void)didLocalTokenExpired
{
    NSLog(@"didLocalTokenExpired");
    [self reloginAction];
}

- (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}
// 进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _needUpgradeTag = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    _schemeURL = nil;
    [[ONEChatClient sharedClient] saveGroupInfo];

}

#pragma mark - For ReWrite Password
- (void)jumpToWritePassword
{
    if (![ONEChatClient isHomeAccountExist]) {
        // 如果账号不存在(即注册界面)，不做处理
        return;
    }
        
    UIViewController *rootVC = self.window.rootViewController;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZLoginWritePassWordViewController" bundle:nil];
    
    LZLoginWritePassWordViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LZLoginWritePassWordViewController"];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    nav.navigationBar.translucent = NO;
    __weak typeof(rootVC) weakRoot = rootVC;

    loginVC.succBlock = ^(NSString *str) {

        [weakRoot dismissViewControllerAnimated:YES completion:nil];
    };

    [rootVC presentViewController:nav animated:YES completion:nil];
}


- (NSString *)getCurrentTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *currentDate = [formatter stringFromDate:datenow];
    return currentDate;
}

- (long long)getDurationStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    
    if (startTime && endTime) {
        NSDateFormatter *strDateStr = [[NSDateFormatter alloc]init];
        [strDateStr setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *startdate = [strDateStr dateFromString:startTime];
        NSDate *enddate = [strDateStr dateFromString:endTime];
        NSTimeInterval aTime = [enddate timeIntervalSinceDate:startdate];
        return (long long)aTime;
    } else {
        return -1;
    }
}

#pragma mark - 第一次安装检测网络

- (LaunchTestView *)launchView
{
    if (!_launchView) {
        
        _launchView = [[LaunchTestView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _launchView.backgroundColor = [UIColor whiteColor];
    }
    return _launchView;
}

- (void)showLaunchTestView
{
    [self rootControllerShouldChange:nil];
    kWeakSelf
    self.launchView.passBlock = ^{
        
        [weakself _judgeVC];
        [weakself hideLaunchTestView];
    };
    self.launchView.refreshBlock = ^{
        
        [weakself checkAction];
    };
    [self.window.rootViewController.view addSubview:self.launchView];
}

- (void)hideLaunchTestView
{
    if (self.launchView) {
        
        [UIView animateWithDuration:0.02 animations:^{
            
            self.launchView.alpha = 0;

        } completion:^(BOOL finished) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.launchView removeFromSuperview];
                self.launchView = nil;
            });
        }];
    }
}

#pragma mark - 根控制器切换

- (void)registerSwitchRootControllerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rootControllerShouldChange:) name:KNOTIFICATION_SWITCHROOT object:nil];
}

- (void)rootControllerShouldChange:(NSNotification *)notification
{
    
    if (notification == nil) {
        
        self.window.rootViewController = [[UIViewController alloc] init];
    } else {
        
        NSInteger style = [notification.object integerValue];
        // 注册
        if (style == RootControllerTypeRegister) {
            PrepareController *prepare = [[PrepareController alloc] init];
            LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:prepare];
            nav.navigationBar.translucent = NO;
            self.window.rootViewController = nav;

            
        } else if (style == RootControllerTypeEnterPwd) {
            // 输入密码
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZLoginWritePassWordViewController" bundle:nil];
            
            LZLoginWritePassWordViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LZLoginWritePassWordViewController"];
            
            loginVC.succBlock = ^(NSString *str) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SWITCHROOT object:@(RootControllerTypeShowRoot)];
            };
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            nav.navigationBar.translucent = YES;
            self.window.rootViewController = nav;
        } else if (style == RootControllerTypeShowRoot) {

            LZTabBarController *tab = [[LZTabBarController alloc] init];
            _tab = tab;
            self.window.rootViewController = tab;
        }
    }
}



- (void)reloginAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([[RedPacketMngr sharedMngr] isGettingToken] == YES) {
            return;
        }
        [RedPacketMngr reLoginWithCompletetion:^(GetTokenStatus status) {
            
            if (status == GetTokenStatusSuccess) {
                
                CFAbsoluteTime currentRe = CFAbsoluteTimeGetCurrent();
                if (_lastRequestTime != 0 && ((currentRe - _lastRequestTime) * 1000 < KCHECKNET_DURATION)) {
                    return;
                }
                _lastRequestTime = currentRe;
            }
        }];
    });

}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.isEable) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end

