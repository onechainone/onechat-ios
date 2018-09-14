//
//  LZConversationViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZConversationViewController.h"
#import "PreRegisterController.h"
#import "KxMenu.h"
#import "LZAddFriendViewController.h"
#import "ONECreatGroupViewController.h"
//二维码
#import "lhScanQCodeViewController.h"
//二维码解析
#import "QRDecoder.h"



#import "NetworkStatusController.h"
#import "ChatViewController.h"
#import "HSQSendSocalRedController.h"
#import "LZNavigationController.h"
#import "CreateWeiBoViewController.h"
#import "DKSHTMLController.h"
#import "ExtendedButton.h"
#import "ContactListViewController.h"
#define kNavItemWidth 30
@interface LZConversationViewController ()
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (nonatomic, strong) UILabel *redLbl;
@property (nonatomic, strong) ExtendedButton *leftButton;
@property (nonatomic, strong) ExtendedButton *searchButton;
@property (nonatomic, strong) ExtendedButton *addButton;

@property (nonatomic, strong) UILabel *titleLbl;


@property (nonatomic, strong) UIView *navItemView;
@end

@implementation LZConversationViewController

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.themeMap = @{
                               TextColorName:@"conversation_title_color",
                               };
        _titleLbl.text = NSLocalizedString(@"title_home", @"");
        _titleLbl.font = [UIFont fontWithName:FONT_NAME_SEMIBOLD size:18.f];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}



- (ExtendedButton *)searchButton
{
    if (!_searchButton) {

        _searchButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        _searchButton.themeMap = @{
                                   NormalImageName:@"icon_search_group"
                                   };
        [_searchButton setFrame:CGRectMake(0, 0, kNavItemWidth, kNavItemWidth)];

        [_searchButton addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (ExtendedButton *)addButton
{
    if (!_addButton) {
        
        _addButton = [ExtendedButton buttonWithType:UIButtonTypeCustom];
        _addButton.themeMap = @{
                                   NormalImageName:@"icon_nav_more_info"
                                   };
        [_addButton setFrame:CGRectMake(0, 0, kNavItemWidth, kNavItemWidth)];

        [_addButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}



- (void)getUnreadApplyCount
{
    
    __block NSInteger friendApplyCount = 0;
    __block NSInteger groupApplyCount = 0;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [[ONEChatClient sharedClient] fetchFriendApplyCount:^(ONEError *error, NSInteger count) {
        
        friendApplyCount = count;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[ONEChatClient sharedClient] fetchGroupApplyCount:^(ONEError *error, NSInteger count) {
        groupApplyCount = count;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSInteger allCount = friendApplyCount + groupApplyCount;
        if (allCount > 0) {
            [self.redLbl setHidden:NO];
            if (allCount > 99) {
                self.redLbl.text = @"...";
            } else {
                self.redLbl.text = [NSString stringWithFormat:@"%ld",allCount];
            }
        } else {
            [self.redLbl setHidden:YES];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUnreadApplyCount];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    
    self.tableView.themeMap = @{
                                BGColorName:@"bg_normal_color"
                                };
    
    [self setupNavigationItem];
    
    
}

- (void)didReceiveFriendApply
{
    [self getUnreadApplyCount];
}

- (void)didReceiveGroupInvitation
{
    [self getUnreadApplyCount];
}

-(void)searchBtnClick {
    
    DKSHTMLController *htmlVC = [[DKSHTMLController alloc] init];
    NSString *str = [ONEUrlHelper searchGroupH5];
    htmlVC.htmlUrl = str;
    [self.navigationController pushViewController:htmlVC animated:YES];
    
}
- (void)addBtnClick:(UIButton *)sender {
    
    if ([self.navigationController isKindOfClass:[LZNavigationController class]]) {
        
        [((LZNavigationController *)self.navigationController) showMenuWithClass:NSStringFromClass([self class])];
    }
}


- (void)contactBtnClick {
    ContactListViewController *contactVC = [ContactListViewController new];
    [self.navigationController pushViewController:contactVC animated:YES];
}

- (void)click:(NSNotification *)notification
{
    PreRegisterController *preVC = [PreRegisterController new];
    preVC.VerifySeed = @"1";
    [self.navigationController pushViewController:preVC animated:YES];
    
}


#pragma mark - navigation item

- (void)setupNavigationItem
{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:self.addButton];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];

    self.navigationItem.rightBarButtonItems = @[addItem, searchItem];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.titleLbl];
    self.navigationItem.title = nil;

    

}


@end
