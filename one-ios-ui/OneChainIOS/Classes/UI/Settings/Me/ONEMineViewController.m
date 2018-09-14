//
//  ONEMineViewController.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/23.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEMineViewController.h"
#import "ONEUserInfoView.h"
#import "MyQRCodeViewController.h"
#import "LZSettingThingsTableViewController.h"
#import "LZChageUserInfoViewController.h"
#import "ONEMainToolBar.h"
#import "ONEWebController.h"
#import "LZDecryptWalletViewController.h"
#import "ONEMyToolBar.h"
#import "NetworkStatusController.h"

#define kTHIRD_NEWS_URL @"https://m.jinse.com"
#define kTHIRD_FLASH_URL @"https://m.jinse.com/lives"
#define kTHIRD_MARKET_URL @"https://app.mytoken.io"

@interface ONEMineViewController ()<ONEUserInfoViewDelegate, ONEMainToolBarDelegate>

@property (nonatomic, strong) ONEUserInfoView *userInfoView;
@property (nonatomic, strong) ONEMainToolBar *mainToolBar;
@property (nonatomic, strong) ONEMyToolBar *myToolBar;
@property (nonatomic, strong) ONEMyToolBar *thirdToolBar;
@end

@implementation ONEMineViewController

#pragma mark - getters

- (ONEUserInfoView *)userInfoView
{
    if (!_userInfoView) {
        
        CGFloat height = 174;
        if (IS_IPHONE_X) {
            height += 20;
        }
        _userInfoView = [[ONEUserInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, height)];
        _userInfoView.delegate = self;
    }
    return _userInfoView;
}

- (ONEMainToolBar *)mainToolBar
{
    if (!_mainToolBar) {
        _mainToolBar = [[ONEMainToolBar alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(self.userInfoView.frame) - 21, self.view.width - 24, 69) items:[self mainToolBarResources]];
        _mainToolBar.themeMap = @{
                                  BGColorName:@"setting_main_bg_color"
                                  };
        _mainToolBar.delegate = self;
        _mainToolBar.layer.cornerRadius = 10;
        _mainToolBar.layer.masksToBounds = YES;
    }
    return _mainToolBar;
}


- (CGFloat)heightFromResources:(NSArray *)resources
{
    int tmp = ([resources count]) % 4;
    int row = (int)([resources count]) / 4;
    row += tmp == 0 ? 0 : 1;
    return 67 * row + 39;
}

- (NSArray *)mainToolBarResources
{
    return @[
             @{
                 @"title":NSLocalizedString(@"switch_service_node", @""),
                 @"image":@"setting_item_node"
                 },
             @{
                 @"title":NSLocalizedString(@"title_activity_backup_seed", @""),
                 @"image":@"setting_item_backup"
                 },
             @{
                 @"title":NSLocalizedString(@"announcement", @""),
                 @"image":@"setting_item_announcement"
                 },
             @{
                 @"title":NSLocalizedString(@"red_packet_account", @""),
                 @"image":@"icon_redbag_mine"
                 }
             ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    WSAccountInfo *accountInfo = [ONEChatClient homeAccountInfo];
    [self.userInfoView updateAccountInfo:accountInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView) {
        CGFloat offY = scrollView.contentOffset.y;
        if (offY < 0) {
            scrollView.contentOffset = CGPointZero;
        }
    }
}
- (void)setupSubviews {
    
    self.view.themeMap = @{
                           BGColorName:@"setting_bg_color"
                           };

    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.delegate = self;
    scroll.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor clearColor];
    [scroll addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(scroll);
        make.width.equalTo(scroll.mas_width);
    }];
    [container addSubview:self.userInfoView];
    [container addSubview:self.mainToolBar];
    [self.view bringSubviewToFront:self.mainToolBar];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(container.mas_top).offset(0);
        make.left.right.equalTo(container);
        CGFloat height = 174;
        if (IS_IPHONE_X) {
            height += 20;
        }
        make.height.mas_equalTo(@(height));
    }];
    [self.mainToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(container.mas_left).offset(12);
        make.right.equalTo(container.mas_right).offset(-12);
        make.top.equalTo(self.userInfoView.mas_bottom).offset(-21);
        make.height.mas_equalTo(@(69));
        make.bottom.equalTo(container.mas_bottom).offset(-12);
    }];


    

}

#pragma mark - ONEUserInfoViewDelegate

- (void)userInfoViewDidTapped:(ONEUserInfoView *)view
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZChageUserInfoViewController" bundle:nil];
    LZChageUserInfoViewController *HSQShowWindowVC = [sb instantiateViewControllerWithIdentifier:@"LZChageUserInfoViewController"];
    
    kWeakSelf
    HSQShowWindowVC.backBlock = ^() {
        [weakself.userInfoView updateAccountInfo:[ONEChatClient homeAccountInfo]];
    };
    [self.navigationController pushViewController:HSQShowWindowVC animated:YES];
}

- (void)userInfoView:(ONEUserInfoView *)view didQRCodeClicked:(WSAccountInfo *)accountInfo
{
    MyQRCodeViewController *qr = [[MyQRCodeViewController alloc] initWithName:accountInfo.name nickName:accountInfo.nickname avatarUrl:accountInfo.avatar_url];
    qr.navigationItem.title = NSLocalizedString(@"my_qr_code", @"My QR code");
    [self.navigationController pushViewController:qr animated:YES];
}

- (void)userInfoViewSettingClicked:(ONEUserInfoView *)view
{
    LZSettingThingsTableViewController *settingVC = [LZSettingThingsTableViewController new];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - ONEMainToolBarDelegate

- (void)toolBar:(ONEMainToolBar *)toolBar didItemClick:(NSString *)itemTitle
{
    if ([itemTitle length] == 0) {
        return;
    }
    [self gotoNextVCWithTitle:itemTitle];
}

- (void)gotoNextVCWithTitle:(NSString *)title
{
    UIViewController *vc = nil;
     if ([title isEqualToString:NSLocalizedString(@"switch_service_node", @"")]) {
        NetworkStatusController *netVC = [[NetworkStatusController alloc] init];
        vc = netVC;
     } else if ([title isEqualToString:NSLocalizedString(@"announcement", @"")]) {
         DKSHTMLController *h5 = [[DKSHTMLController alloc] init];
         h5.htmlUrl = [ONEUrlHelper announcementH5Url];
         vc = h5;
     } else if ([title isEqualToString:NSLocalizedString(@"red_packet_account", @"")]) {
         
         DKSHTMLController *h5 = [[DKSHTMLController alloc] init];
         h5.htmlUrl = [ONEUrlHelper walletAccountH5Url];
         vc = h5;
     }  else if ([title isEqualToString:NSLocalizedString(@"title_activity_backup_seed", @"")]) {
         LZDecryptWalletViewController *DecryptVC = [LZDecryptWalletViewController new];
         vc = DecryptVC;
     }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
