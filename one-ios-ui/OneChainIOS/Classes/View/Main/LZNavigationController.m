//
//  LZNavigationController.m
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

#import "LZNavigationController.h"
#import "KxMenu.h"
#import "LZAddFriendViewController.h"
#import "ONECreatGroupViewController.h"
//二维码
#import "lhScanQCodeViewController.h"
//二维码解析
#import "QRDecoder.h"



#import "LZVerifyWordViewController.h"
#import "HSQSendSocalRedController.h"
#import "NetworkStatusController.h"
#import "LZConversationViewController.h"
#import "DKSHTMLController.h"


#import "ChatViewController.h"
#import "LZContactsDetailTableViewController.h"
#import "ExtendedButton.h"

@interface LZNavigationController ()<UIGestureRecognizerDelegate, UINavigationBarDelegate>{
    UIButton *rightBtn;
    
}

@property (nonatomic, strong) ExtendedButton *backButton;

@end

@implementation LZNavigationController

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    if (self.childViewControllers.count > 1) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    return YES;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    if (self.childViewControllers.count == 1) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

//
//+ (void)initialize
//{
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    navBar.tintColor = [UIColor whiteColor];
//    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
//    [navBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];
//
//    NSMutableDictionary *att = [NSMutableDictionary dictionary];
//    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    att[NSFontAttributeName] = [UIFont systemFontOfSize:20];
//    [navBar setTitleTextAttributes:att];
//
//    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
//    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
//    itemAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
//    itemAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
//    [appearance setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
//
//    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:itemAttrs];
//    highTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
//
//    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
//    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
//    [appearance setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
//    [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//}
//
//- (id)initWithRootViewController:(UIViewController *)rootViewController
//{
//    self = [super initWithRootViewController:rootViewController];
//    if (self) {
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    [self handleThemeChange];
//    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_SEMIBOLD size:18], NSForegroundColorAttributeName : THMColor(@"conversation_title_color")};
    [self themeChanged];
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // 去掉导航条下面的阴影线
    //    // 以下两行代码会让导航条完全透明
//            [self.navigationBar setShadowImage:[UIImage new]];
//            [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //
//    // 2.更改导航条背景颜色
//        self.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationBar.tintColor = [UIColor blackColor];
    
//    self.navigationBar.barTintColor = [UIColor colorWithHex:THEME_COLOR];
    //navgationBG_iphonex
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAmount:) name:NOTIFICATION_MESSAGE_TABBAR_SELECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAmount:) name:NOTIFICATION_MESSAGE_TABBAR_NOTSELECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qrcode_receive:) name:@"QRCODE_RECEIVE" object:nil];
//    [self.navigationBar setShadowImage:[UIImage imageNamed:@"underline"]];

//    if(kDevice_Is_iPhoneX) {
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBG_iphonex"] forBarMetrics:UIBarMetricsDefault];
////
//    } else {
//        if(IS_IPHONE_PLUS) {
////            NSLog(@"123");
//            //navgationBG_plus
//            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBG_plus"] forBarMetrics:UIBarMetricsDefault];
//
//        } else {
//           [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBG"] forBarMetrics:UIBarMetricsDefault];
//        }
//
//    }

    
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:0xffbd11]];
    // 让导航条没有半透明效果,会影响子控制器view的尺寸"会让它从导航条下面开始高度少了64"
    self.navigationBar.translucent = NO;
    // 会影响导航条左边右边及返回按钮的颜色
    //    self.navigationBar.tintColor = [UIColor whiteColor];
    
    //
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)handleThemeChange
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeDidChangeNotification object:nil];
}

- (void)themeChanged
{
//    [self.navigationBar setTintColor:THMColor(@"tab_tint_color")];
//    if ([[ONEThemeManager sharedInstance].theme.theme_id isEqualToString:@"2"]) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    } else {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//
//    }
    
    [self.navigationBar setBackgroundImage:THMImage(@"navigationbar_image") forBarMetrics:UIBarMetricsDefault];
    if (IS_IPHONE_X) {
        [self.navigationBar setBackgroundImage:THMImage(@"navigationbar_image_x")  forBarMetrics:UIBarMetricsDefault];
        ;

    } else if (IS_IPHONE_PLUS) {
        [self.navigationBar setBackgroundImage:THMImage(@"navigationbar_image_plus") forBarMetrics:UIBarMetricsDefault];

    }
    [self.navigationBar setShadowImage:THMImage(@"nav_shadow_image")];
    [self.navigationBar setTranslucent:NO];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_SEMIBOLD size:18], NSForegroundColorAttributeName : THMColor(@"conversation_title_color")};
}

//- (ExtendedButton *)backButton
//{
//    ExtendedButton *extendButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
//    extendButton.themeMap = @{
//
//                              };
//}

- (ExtendedButton *)backButton
{
    if (!_backButton) {
        
        _backButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        _backButton.themeMap = @{
                                 NormalImageName:@"nav_back_btn"
                                 };
        [_backButton setFrame:CGRectMake(0, 0, 20, 44)];
        [_backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

// 重写父类方法拦截push过程
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 判断子控制器的个数
    if (self.viewControllers.count > 0) {
        // 设置导航控制器根控制器以外的所有子控制器的此属性是YES
        // 除了导航控制器中的根控制器不隐藏下面的标签栏,其它子控制器全部都要隐藏下面的标签栏
        viewController.hidesBottomBarWhenPushed = YES;
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:THMImage(@"nav_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
        
        CGRect frame = self.tabBarController.tabBar.frame;
        
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        
        self.tabBarController.tabBar.frame = frame;
    }else {
//        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addBtnClick:)];
        CGRect frame = self.tabBarController.tabBar.frame;
        
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        
        self.tabBarController.tabBar.frame = frame;

    }
    
    // push实现还做了添加子控制器的操作
    if (![[super topViewController] isKindOfClass:[viewController class]]) {
        [super pushViewController:viewController animated:animated];
    }
}
- (void)changeAmount:(NSNotification *)notification{
    [KxMenu dismissMenu];
}
- (void)qrcode_receive:(NSNotification *)notification{
    
    NSString *str = notification.userInfo[@"str"];
    [self dealQrCodeWith:str];
}
-(void)dealQrCodeWith:(NSString *)str {
    QRDecoder *qrdecoder = [QRDecoder new];
    BOOL state = [qrdecoder decodeString:str];
    
    //成功的时候
    if (state) {
        //先置位0
        
        NSString *type = qrdecoder.tag;
        NSMutableDictionary *infoDic = qrdecoder.config;
        NSString *action = [infoDic objectForKey:ERWEIMA_TYPE_ACTION];
        NSString *accountName = [infoDic objectForKey:ERWEIMA_YTPE_ACCOUNT_NAME];
        NSString *memo = [infoDic objectForKey:ERWEIMA_TYPE_MEMO];
        
        if (!type||!infoDic) {
            [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"qr_code_nonsupport", nil) controller:self];
            return ;
        }
        ///这个时候是加好友
        if ([[infoDic objectForKey:ERWEIMA_TYPE_ACTION] isEqualToString:ERWEIMA_TYPE_ADDFRIEND]&&([type isEqualToString:ERWEIMA_TYPE_ONEAPP] || [type isEqualToString:@"oneapp"])) {
            
            [self addFriendWithName:[infoDic objectForKey:ERWEIMA_YTPE_ACCOUNT_NAME]];
        }
        else if ([type isEqualToString:@"http"]||[type isEqualToString:@"https"]) {
            
            if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{}
                                             completionHandler:^(BOOL success) {
                                                 
                                             }];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }
                
            } else{
                bool can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]];
                if(can){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }
            }
        } else {
            
            //二维码格式错误
            [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"qr_code_nonsupport", nil) controller:self];
            
        }
    }
    
}
- (void)addBtnClick:(UIButton *)sender {
    
    /*
     //menu_add_coin
     [KxMenuItem menuItem:NSLocalizedString(@"menu_add_coin", nil)
     image:[UIImage imageNamed:@"icon_menu_addcoin"]
     target:self
     action:@selector(pushMenuItem:)],
     
     [KxMenuItem menuItem:NSLocalizedString(@"menu_scan_qrcode", nil)
     image:[UIImage imageNamed:@"icon_menu_sao"]
     target:self
     action:@selector(pushMenuItem:)],
     //添加朋友
     [KxMenuItem menuItem:NSLocalizedString(@"menu_addfriend", nil)
     image:[UIImage imageNamed:@"icon_menu_addfriend"]
     target:self
     action:@selector(pushMenuItem:)],
     [KxMenuItem menuItem:NSLocalizedString(@"default_group_name", nil)
     image:[UIImage imageNamed:@"icon_menu_group"]
     target:self
     action:@selector(pushMenuItem:)],
     
     */
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:NSLocalizedString(@"menu_add_coin", nil)
                     image:[UIImage imageNamed:@"icon_menu_addcoin"]
                    target:self
                    action:@selector(pushMenuItem:)],
      [KxMenuItem menuItem:NSLocalizedString(@"search_all_trade_team",@"搜索交易对")
                     image:[UIImage imageNamed:@"icon_tradeteam"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"menu_scan_qrcode", nil)
                     image:[UIImage imageNamed:@"icon_menu_sao"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      
      [KxMenuItem menuItem:NSLocalizedString(@"menu_addfriend", nil)
                     image:[UIImage imageNamed:@"icon_menu_addfriend"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      
      [KxMenuItem menuItem:NSLocalizedString(@"menu_groupchat", nil)
                     image:[UIImage imageNamed:@"icon_menu_group"]
                    target:self
                    action:@selector(pushMenuItem:)],
      [KxMenuItem menuItem:NSLocalizedString(@"switch_service_node", nil)
                     image:[UIImage imageNamed:@"icon_add_node"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      
      ];
    for (NSInteger i = 0 ; i<6; i++) {
        KxMenuItem *first = menuItems[i];
        first.foreColor = [UIColor blackColor];
        first.alignment = NSTextAlignmentCenter;
    }
    
    
    if (kDevice_Is_iPhoneX) {
        [KxMenu showMenuInView:self.view
                      fromRect:CGRectMake(self.view.bounds.size.width, 5+IPHONEXMARGIN, 50, 50)
                     menuItems:menuItems];
    } else {
        [KxMenu showMenuInView:self.view
                      fromRect:CGRectMake(self.view.bounds.size.width, 10, 50, 45)
                     menuItems:menuItems];
        
    }

    
    //    [KxMenu setTitleFont:[UIFont systemFontOfSize:15]];
    //    KxMenu.titleFont = [UIFont systemFontOfSize:20];
    
    
}
- (void)backBtnClick{
    [self popViewControllerAnimated:YES];
}
- (void) pushMenuItem:(id)sender
{
    
    if ([[sender title] isEqualToString:NSLocalizedString(@"menu_addfriend", nil)]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZAddFriendViewController" bundle:nil];

        LZAddFriendViewController *addFriendVC = [sb instantiateViewControllerWithIdentifier:@"AddFriend"];
        
//        HSQSendSocalRedController *addFriendVC = [HSQSendSocalRedController new];
        
        [self pushViewController:addFriendVC animated:YES];
        return;
        
    }
    if ([[sender title] isEqualToString:NSLocalizedString(@"menu_groupchat", nil)]) {
        
        ONECreatGroupViewController *creatGroupVC = [[ONECreatGroupViewController alloc] init];
        [self pushViewController:creatGroupVC animated:YES];
        return;
    }
    
    
    //节点检测 switch_service_node
    if ([[sender title] isEqualToString:NSLocalizedString(@"switch_service_node", nil)]) {
        
        NetworkStatusController *network = [[NetworkStatusController alloc] init];
        [self pushViewController:network animated:YES];
        
        return ;
    }
    
    if ([[sender title] isEqualToString:NSLocalizedString(@"menu_scan_qrcode", nil)]) {
        lhScanQCodeViewController * sqVC = [[lhScanQCodeViewController alloc]init];
        UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
        [self presentViewController:nVC animated:YES completion:^{
            
        }];
        sqVC.succ = ^(NSString *str) {
            [self dealQrCodeWith:str];
        };
    }
    
    
    
}
- (void)addFriendWithName:(NSString *)name {
    
    if ([name length] == 0) {
        return;
    }
    LZContactsDetailTableViewController *contactDetail = [[LZContactsDetailTableViewController alloc] initWithBuddy:name];
    [self pushViewController:contactDetail animated:YES];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIViewController *vc = [self.viewControllers lastObject];
    if ([vc isKindOfClass:[ChatViewController class]]) {
        
        ChatViewController *chat = (ChatViewController *)vc;
        [chat.view endEditing:YES];
    }
    return YES;
}

- (void)showMenuWithClass:(NSString *)className
{
    if (className == nil || [className length] == 0) {
        return;
    }
    
    NSArray *menuArray = nil;
    if ([className isEqualToString:@"LZConversationViewController"]) {
        
        menuArray = @[
                      @{
                          @"title":NSLocalizedString(@"switch_service_node", @"Node Detection"),
                          @"image":@"new_node_check"
                        },
                      @{
                          @"title":NSLocalizedString(@"menu_scan_qrcode", @"Scan Qr"),
                          @"image":@"new_scan_qr"
                        },
                      @{
                          @"title":NSLocalizedString(@"menu_groupchat", @"Encrypted Group"),
                          @"image":@"new_group"
                        },
                      @{
                          @"title":NSLocalizedString(@"menu_addfriend", @"Add Contacts"),
                          @"image":@"new_add_friend"
                        }
                      ];
    }
    [self createMenuItemWithDatasource:menuArray];
}

- (void)createMenuItemWithDatasource:(NSArray *)menus
{
    if (menus == nil || menus.count == 0) {
        return;
    }
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *menuDic in menus) {
        
        KxMenuItem *item = [KxMenuItem menuItem:menuDic[@"title"] image:[UIImage imageNamed:menuDic[@"image"]] target:self action:@selector(pushMenuItem:)];
        item.foreColor = THMColor(@"common_text_color");
        item.alignment = NSTextAlignmentCenter;
        [items addObject:item];
    }
    
    [KxMenu setTitleFont:[UIFont fontWithName:@"PingFangSC-Light" size:16.f]];
    [KxMenu setTintColor:THMColor(@"bg_white_color")];
    if (kDevice_Is_iPhoneX) {
        [KxMenu showMenuInView:self.view
                      fromRect:CGRectMake(self.view.bounds.size.width, 5+IPHONEXMARGIN, 50, 50)
                     menuItems:items];
    } else {
        [KxMenu showMenuInView:self.view
                      fromRect:CGRectMake(self.view.bounds.size.width, 10, 50, 45)
                     menuItems:items];
        
    }
}



@end
