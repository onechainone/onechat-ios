//
//  LZSettingThingsTableViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/14.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZSettingThingsTableViewController.h"
#import "NSArray+Addition.h"
#import "LZSettingThingsTableViewCell.h"
#import "LZExchangeRateTableViewController.h"
#import "LZRegistViewController.h"
#import "LZNavigationController.h"
#import "PreRegisterController.h"
#import "NetworkStatusController.h"
#import "ONEThemeChangeController.h"
#import "SYSContactManager.h"
#import "LZChooseNetWorkViewController.h"
#import "ONENetworkTool.h"
static NSString*const tablecellID = @"tablecellID";
#define CellCount 6
#define LOCAL_LOGOOFFTOPSPEACE 284
#define LOCAL_TIPLABELFRONT 16
@interface LZSettingThingsTableViewController ()
@property (nonatomic, strong) NSArray *SettingOtherData;

@property (nonatomic, strong) UIView *footerV;

@end

@implementation LZSettingThingsTableViewController

- (UIView *)footerV
{
    if (!_footerV) {
        
        _footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 100)];
        _footerV.themeMap = @{
                              BGColorName:@"bg_white_color"
                              };
        UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_SPACE, BTN_HEIGHT, _footerV.width - 2 * LEFT_SPACE, BTN_HEIGHT)];
        [logoutBtn setTitle:NSLocalizedString(@"exit_wallet", @"Delete wallet") forState:UIControlStateNormal];
        logoutBtn.themeMap = @{
                               TextColorName:@"theme_title_color",
                               BGColorName:@"theme_color"
                               };
        [logoutBtn addTarget:self action:@selector(logoffBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_footerV addSubview:logoutBtn];
    }
    return _footerV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //action_settings 设置
    self.title = NSLocalizedString(@"action_settings", nil);
    _SettingOtherData = [NSArray objectListWithPlistName:@"LZSettingThings.plist" clsName:@"LZSettingThingsModel"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.tableFooterView = self.footerV;
    UINib *TableviewNib = [UINib nibWithNibName:@"LZSettingThingsTableViewCell" bundle:nil];
    [self.tableView registerNib:TableviewNib forCellReuseIdentifier:tablecellID];
    self.tableView.themeMap = @{
                                BGColorName:@"bg_white_color",
                                TableSepColorName:@"conversation_line_color"
                                };
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReLoadData:) name:NOTIFICATION_TIME_OUT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeDidChangeNotification object:nil];
    
}

- (void)themeChanged
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:THMImage(@"nav_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)ReLoadData:(NSNotification *)noti {
    //加载提现列表 3个列表都要走这个方法
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
//    return CellCount;
    return _SettingOtherData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZSettingThingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tablecellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.SettingOtherData[indexPath.row];
    

    return cell;
}
-(void)logoffBtnClick {
    //exit_wallet_warning_message
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"override_wallet_warning_title", nil) message:NSLocalizedString(@"exit_wallet_warning_message", nil) preferredStyle:UIAlertControllerStyleAlert];
    ///取消 button_cancel
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
    //确认 button_confirm
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"exit_wallet_warning_message_second", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"exit_wallet_warning_message_second", nil)];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:THEME_COLOR] range:NSMakeRange(0, [[alertControllerMessageStr string] length])];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:LOCAL_TIPLABELFRONT] range:NSMakeRange(0, [[alertControllerMessageStr string] length])];
        [alertVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        ///取消 button_cancel
        UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
        //确认 button_confirm
        UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确定");
            [[ONEChatClient sharedClient] clearContext];
            [ONEThemeManager resetTheme];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUSERDEFAULT_KEY_EXPORT_ENCRYPT_SEED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SWITCHROOT object:@(RootControllerTypeRegister)];


            
        }];
        
        [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
        
        [alertVC addAction:confirmAction];
        
        [alertVC addAction:cancelAction];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }];
    
    [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
    
    [alertVC addAction:confirmAction];
    
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LZSettingThingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        LZExchangeRateTableViewController *exchangeVC = [LZExchangeRateTableViewController new];
        [self.navigationController pushViewController:exchangeVC animated:YES];
        exchangeVC.passValue = cell.titleLabel.text;
        
        exchangeVC.type = CHAGELANGUAGE;
    } else if (indexPath.row == 1) {
        
        ONEThemeChangeController *vc = [[ONEThemeChangeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        
        NetworkStatusController *network = [[NetworkStatusController alloc] init];
        [self.navigationController pushViewController:network animated:YES];
    }else if (indexPath.row == 4) {
        
        [self sychorinizeAddressBook];
    } else if (indexPath.row == 5) {
        [self checkVersion];
    } else if (indexPath.row == 3) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZChooseNetWorkViewController" bundle:nil];
        LZChooseNetWorkViewController *chooseVC = [sb instantiateViewControllerWithIdentifier:@"LZChooseNetWorkViewController"];
        [self.navigationController pushViewController:chooseVC animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)showAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"address_book_need_auth", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
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
                [self showHint:NSLocalizedString(@"app_not_need_update", nil)];
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


- (void)sychorinizeAddressBook
{
    [self showHudInView:self.view hint:nil];
    __weak typeof(self) weakself = self;
    
    [[SYSContactManager manager] uploadSystemAddressBookListWithCompletion:^(NSError *error) {
        
        [weakself hideHud];
        if (!error) {
            
            [weakself showHint:NSLocalizedString(@"success", @"")];
        } else if (error.code == 1005) {
            
            [weakself showAlert];
        } else {
            
            [weakself showHint:NSLocalizedString(@"error", @"")];
        }
    }];
    
}



@end
