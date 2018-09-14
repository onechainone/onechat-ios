//
//  LZTabBarController.m
//  LZEasemob3
/**
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
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

#import "LZTabBarController.h"
#import "LZConversationViewController.h"
#import "LZNavigationController.h"
#import "LoadingView.h"
#import "PreRegisterController.h"
#import "EncryptSeedAlertView.h"
#import "EncryptSeedExportController.h"
#import "ONEMineViewController.h"
#import "RedPacketMngr.h"
#import "ONENetworkTool.h"

static const CGFloat COVER_OPACITY = 0.35;
static const CGFloat LOADING_PADDING = 60;
static const CGFloat LOADING_LENGTH = 120;
static const CGFloat LOADING_CORNERRADIUS = 10.f;
static const CGFloat kENCRYPT_ALERT_PADDING = 18.f;

#define SYNC_DATA_WAITING_TIME 30

@interface LZTabBarController ()<UITabBarDelegate, UITabBarControllerDelegate>

@property(nonatomic,strong)NSMutableDictionary *RMBdic;
@property(nonatomic,strong)NSMutableDictionary *tradeTeamArr;


@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) EncryptSeedAlertView *encrytAlert;

@end

@implementation LZTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_TABBAR_SELECTED object:nil userInfo:nil];
    
    // 创建子控制器 title_home
    UIViewController *vc1 = [self createChildViewControllerWithClassName:@"LZConversationViewController" andNavTitle:NSLocalizedString(@"title_home", nil) andTabTitle:NSLocalizedString(@"tab_title_home", nil) andImageName:@"home_normal"];
    
    UIViewController *vc2 = [self createChildViewControllerWithClassName:@"ContactListViewController" andNavTitle:NSLocalizedString(@"contacts", nil) andTabTitle:NSLocalizedString(@"contacts", nil) andImageName:@""];
    
    UIViewController *vc4 = [self createChildViewControllerWithClassName:@"ONEMineViewController" andNavTitle:@"" andTabTitle:NSLocalizedString(@"tab_title_my", nil) andImageName:@"profile_normal"];
    self.viewControllers = @[ vc1,vc2, vc4];
    self.delegate = self;
    // 设置标签栏文字颜色
    //    self.tabBar.tintColor = [UIColor colorWithHex:0x6096D0];
    self.tabBar.tintColor = [UIColor colorWithHex:THEME_COLOR];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showExportSeedAlert];
    });
    [self handleThemeChange];
    [self themeChanged];
    
    [self checkVersion];
}

- (void)tokenGet:(NSNotification *)notification{
    
}


- (UIViewController *)createChildViewControllerWithClassName:(NSString *)className andNavTitle:(NSString *)title andTabTitle:(NSString *)tabTitle andImageName:(NSString *)imageName {
    
    // 把字符串格式类名转换成 class类型
    Class class = NSClassFromString(className);
    
    // 通过过class创建相应的控制器
    UIViewController *vc = [[class alloc] init];
    
    // 设置标签栏上按钮对应的图片
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 拼接选中状态时的图片名称
    NSString *selImageName = [imageName stringByAppendingString:@"pressed"];
    
    // 设置选中状态的图片,并且让图片不渲染
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 给子控制器及标签控制器中间去嵌套导航控制器
    LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:vc];
    vc.tabBarItem.title = tabTitle;
    vc.navigationItem.title = title;
    
    //导航栏和标签栏标题
    //    vc.title = title;
    return nav;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 0) {
        
        [[ONEChatClient sharedClient] startSyncGroupChatMessage];
    } else {
        [[ONEChatClient sharedClient] stopSyncGroupChatMessage];
    }
    
}

//本地存储
- (void)saveInfo:(NSMutableDictionary *)userInfo name:(NSString *)name{
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2、添加储存的文件名
    NSString *path  = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver",name]];
    //3、将一个对象保存到文件中
    [NSKeyedArchiver archiveRootObject:userInfo toFile:path];
}

- (void)saveuserArrInfo:(id)userArrInfo name:(NSString *)name{
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2、添加储存的文件名
    NSString *path  = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver",name]];
    //3、将一个对象保存到文件中
    [NSKeyedArchiver archiveRootObject:userArrInfo toFile:path];
}

- (NSMutableArray *)tradeTeamArr
{
    if (!_tradeTeamArr) {
        _tradeTeamArr = [[NSMutableArray alloc] init];
    }
    return _tradeTeamArr;
}

- (void)showLoading
{
    [self showLoadingView];
}

- (void)hideLoading
{
    [self hideLoadingView];
}


- (void)showLoadingView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    _coverView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.layer.opacity = COVER_OPACITY;
    
    _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(window.centerX - LOADING_PADDING, window.centerY - LOADING_PADDING, LOADING_LENGTH, LOADING_LENGTH)];
    _loadingView.backgroundColor = [UIColor whiteColor];
    _loadingView.layer.cornerRadius = LOADING_CORNERRADIUS;
    _loadingView.clipsToBounds = YES;
    [window addSubview:_coverView];
    [window addSubview:_loadingView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SYNC_DATA_WAITING_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_coverView && _loadingView) {
            
            _coverView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLoading)];
            [_coverView addGestureRecognizer:tap];
            [_loadingView updateBannerText:NSLocalizedString(@"sync_data_timeout", @"")];
        }
    });
    
}

- (void)hideLoadingView
{
    if (_loadingView) {
        
        [_loadingView stopAno];
    }
    if (_encrytAlert) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window bringSubviewToFront:_encrytAlert];
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    } else {
        [_coverView removeFromSuperview];
        [_loadingView removeFromSuperview];
        _coverView = nil;
        _loadingView = nil;
    }
    
    
    //    ConversationListController *conversationList = [((LZNavigationController *)[self.viewControllers firstObject]).viewControllers lastObject];
    //    [conversationList refreshDataSource];
}


#pragma mark - 导出加密助记词提示


- (void)showExportSeedAlert
{
    BOOL needShow = [self needExportEncryptSeed];
    if (!needShow) {
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!_coverView) {
        
        _coverView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.layer.opacity = COVER_OPACITY;
        [window addSubview:_coverView];
    }
    NSArray *titles = @[NSLocalizedString(@"button_dismiss", @"Dismiss"),NSLocalizedString(@"never_remind", @""),NSLocalizedString(@"export_immediately", @"")];
    _encrytAlert = [[EncryptSeedAlertView alloc] initWithTitles:titles message:NSLocalizedString(@"whether_export_immediately", @"")];
    _encrytAlert.backgroundColor = [UIColor whiteColor];
    [window addSubview:_encrytAlert];
    [_encrytAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(window.mas_left).offset(kENCRYPT_ALERT_PADDING);
        make.right.equalTo(window.mas_right).offset(-kENCRYPT_ALERT_PADDING);
        make.center.equalTo(window);
    }];
    
    
    __weak typeof(self)weakself = self;
    _encrytAlert.alertBtnClick = ^(NSInteger index) {
        
        if (index == 0) {
            
            [weakself hideEncryptAlert];
        } else if (index == 1) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:KUSERDEFAULT_KEY_EXPORT_ENCRYPT_SEED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakself hideEncryptAlert];
        } else if (index == 2) {
            
            [weakself hideEncryptAlert];
            EncryptSeedExportController *exportController = [[EncryptSeedExportController alloc] init];
            [[RedPacketMngr topViewController].navigationController pushViewController:exportController animated:YES];
        }
    };
}

- (void)hideEncryptAlert
{
    if (_loadingView && _coverView) {
        
        [_encrytAlert removeFromSuperview];
        _encrytAlert = nil;
    } else {
        
        [_coverView removeFromSuperview];
        [_encrytAlert removeFromSuperview];
        _encrytAlert = nil;
        _coverView = nil;
    }
}

- (BOOL)needExportEncryptSeed
{
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:KUSERDEFAULT_KEY_EXPORT_ENCRYPT_SEED];
    if ([string isEqualToString:@"NO"]) {
        
        return NO;
    } else {
        
        return YES;
    }
}

#pragma mark - 换肤

- (void)handleThemeChange
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeDidChangeNotification object:nil];
}

- (void)themeChanged
{
    [self.tabBar setTintColor:THMColor(@"theme_color")];
    [self.tabBar setShadowImage:[UIImage imageFromColor:THMColor(@"tab_shadow_color") withCGRect:CGRectMake(0, 0, KScreenW, 1)]];
    [self.tabBar setBackgroundImage:[UIImage imageFromColor:THMColor(@"tab_bg_color") withCGRect:self.tabBar.bounds]];
    [self.tabBar setTranslucent:NO];
    
    for (UIViewController *vc in self.viewControllers) {
        
        if ([vc isKindOfClass:[LZNavigationController class]]) {
            
            UIViewController *subVC = [((LZNavigationController *)vc).viewControllers firstObject];
            if (subVC) {
                
                NSString *className = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([subVC class]),@"tab"];
                NSString *className_sel = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([subVC class]),@"tab_sel"];
                [subVC.tabBarItem setImage:THMImage(className)];
                [subVC.tabBarItem setSelectedImage:THMImage(className_sel)];
                
            }
        }
    }
}


- (void)checkVersion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [ONEUrlHelper checkVersionHttpUrl]];
    
    [ONENetworkTool getUrlString:urlString withParam:nil withSuccessBlock:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *code = [NSString stringWithFormat:@"%@",data[@"code"]];
            if ([code isEqualToString:@"100200"]) {
                
                NSDictionary *response = data[@"data"][@"map"];
                if (response == nil)
                    return;
                long is_update = [[response objectForKey:@"is_update"] longValue];
                NSString *upgradeInfo = [response objectForKey:@"app_content"];
                NSString *urlString = [response objectForKey:@"app_url"];
                if (is_update == 1) {
                    
                    [self showUpgradeViewWithInfo:upgradeInfo isForce:NO urlString:urlString];
                    
                } else if (is_update == 2) {
                    
                    [self showUpgradeViewWithInfo:upgradeInfo isForce:YES urlString:urlString];
                    
                }
            } else if ([code isEqualToString:@"100199"]) {
                //app_not_need_update
                //                [self showHint:data[@"msg"]];
//                [self showHint:NSLocalizedString(@"app_not_need_update", nil)];
            }
        });
        
    } withFailedBlock:^(NSError *error) {
        
    } withErrorBlock:^(NSString *message) {
        
    }];
}

- (void)showUpgradeViewWithInfo:(NSString *)upgradeInfo isForce:(BOOL)isForce urlString:(NSString *)urlString
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"upgrade_tip", @"Tips to upgrade") message:upgradeInfo preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *upgradeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"update_ok", @"Upgrade") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:urlString];
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
        
    }];
    [alertC addAction:upgradeAction];
    if (!isForce) {
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:cancelAction];
    }
    [self presentViewController:alertC animated:YES completion:nil];
}


@end

