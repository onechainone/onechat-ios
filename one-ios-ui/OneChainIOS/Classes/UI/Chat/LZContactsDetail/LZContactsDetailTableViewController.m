//
//  LZContactsDetailTableViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/30.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZContactsDetailTableViewController.h"
#import "SettingInfoTableViewCell.h"
#import "LZContactsTableViewCell.h"
#import "LZContactsMessageTableViewCell.h"
#import "LZContactsThingsModel.h"
#import "NSArray+Addition.h"
#import "ChatViewController.h"

#import "CoinTools.h"


#define SectionCount 2
#define CellCount 2
#define BtnTopSpece 120
#define InfoHeight 160
#define MessageHeight 46
#define TableHeight 60

@interface LZContactsDetailTableViewController ()
@property (nonatomic,strong)LZContactsTableViewCell *tableCell;
@property (nonatomic,strong)NSArray *SettingOtherData;
//头像
@property (nonatomic,copy)NSString *icon;
///修改的昵称
@property (nonatomic,copy)NSString *nicknameStr;

//笑脸钱数
@property (nonatomic,copy)NSString *goodMoneyCount;
//哭脸钱数
@property (nonatomic,copy)NSString *badMoneyCount;

@property (nonatomic) BOOL changedNick;

@property (nonatomic, strong) WSAccountInfo *accountInfo;

@property (nonatomic, strong) UIButton *contactButton;

@property (nonatomic, strong) UIButton *deleteButton;

@end
static NSString*const infoID = @"infoID";
static NSString*const messageID = @"messageID";
static NSString*const tablecellID = @"tablecellID";

@implementation LZContactsDetailTableViewController

- (instancetype)initWithBuddy:(NSString *)buddy
{
    self = [super init];
    if (self) {
        _buddy = buddy;
        _canSendMsg = YES;
        if ([_buddy length] > 0) {
            
            if ([_buddy isAccountId]) {
                _accountInfo = [ONEChatClient accountInfoWithId:_buddy];
            } else {
                _accountInfo = [ONEChatClient accountInfoWithName:_buddy];
            }
        }
    }
    return self;
}

- (void)setupTableViewFooter
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 240)];
//    footer.backgroundColor = [UIColor whiteColor];
    footer.themeMap = @{
                        BGColorName:@"bg_white_color"
                        };
    _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_contactButton setBackgroundColor:[UIColor colorWithHex:GREEN_COLOR]];
//    _contactButton.themeMap = @{
//                                BGColorName:@"button_true_color"
//                                };
    [_contactButton addTarget:self action:@selector(sendMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_contactButton];
    [_contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.left.offset(LEFT_SPACE);
        make.top.equalTo(footer.mas_top).offset(BtnTopSpece);
        make.height.offset(BTN_HEIGHT);
    }];
    if (!_canSendMsg) {
        _contactButton.hidden = YES;
    }
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteButton setBackgroundColor:[UIColor colorWithHex:THEME_COLOR]];
    [_deleteButton setHidden:YES];
    [_deleteButton setTitle:NSLocalizedString(@"delete_friend", @"") forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_deleteButton];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.left.offset(LEFT_SPACE);
        make.top.equalTo(_contactButton.mas_bottom).offset(5);
        make.height.offset(BTN_HEIGHT);
    }];
    
    self.tableView.tableFooterView = footer;
}

- (void)deleteFriend
{
    kWeakSelf
    [self showHudInView:self.view hint:nil];
    
    [[ONEChatClient sharedClient] deleteFriend:_accountInfo.name completion:^(ONEError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakself hideHud];
            if (!error) {
                if (weakself.deleteAction) {
                    weakself.deleteAction(weakself.accountInfo.name);
                }
                [weakself.navigationController popViewControllerAnimated:YES];
            } else {
                [weakself showHint:NSLocalizedString(@"error", @"")];
            }
        });
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _changedNick = NO;
    _SettingOtherData = [NSArray objectListWithPlistName:@"Contacts.plist" clsName:@"LZContactsThingsModel"];
    ///个人信息
    self.title = NSLocalizedString(@"user_info", nil);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    self.tableView.themeMap = @{
                                BGColorName:@"bg_white_color",
                                TableSepColorName:@"conversation_line_color"
                                };
    [self setupTableViewFooter];
    ///注册xib
    UINib *infoNib = [UINib nibWithNibName:@"SettingInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:infoNib forCellReuseIdentifier:infoID];
    
    UINib *MessageTableviewNib = [UINib nibWithNibName:@"LZContactsMessageTableViewCell" bundle:nil];
    [self.tableView registerNib:MessageTableviewNib forCellReuseIdentifier:messageID];
    
    UINib *TableviewNib = [UINib nibWithNibName:@"LZContactsTableViewCell" bundle:nil];
    [self.tableView registerNib:TableviewNib forCellReuseIdentifier:tablecellID];
    kWeakSelf
    [self fetchFriendInfo];
    
//    if (_accountInfo) {
//        [self fetchAccountInfo];
//    } else {
//        __weak typeof(self)weakself = self;
//        [self fetchFriendInfo:^(BOOL success) {
//            [weakself.tableView reloadData];
//            [weakself updateActionButton];
//        }];
//    }

    
//    [self donwloadAvatar];
    [self loadGoodOrBad];

    
    ///余额重新加载
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BalancereloadData:) name:BALANCERELOAD object:nil];
}

- (void)updateActionButton:(WSAccountInfo *)info
{
    if (info.type == AccountTypeFriend) {
        [_contactButton setTitle:NSLocalizedString(@"send_msg", @"") forState:UIControlStateNormal];
        [_deleteButton setHidden:NO];
    } else {
        [_contactButton setTitle:NSLocalizedString(@"action_add_friend", @"") forState:UIControlStateNormal];
        [_deleteButton setHidden:YES];
    }
}

- (void)fetchFriendInfo
{
    NSString *accId = _buddy;
    if (![accId isAccountId]) {
        
        kWeakSelf
        [self showHudInView:self.view hint:nil];
        // 先拉取账号信息,
        [[ONEChatClient sharedClient] pullAccountInfoWithAccountName:accId completion:^(ONEError *error, WSAccountInfo *accountInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself hideHud];
                WSAccountInfo *aInfo = accountInfo;
                if (aInfo) {
                    [[ONEChatClient sharedClient] getFriendInfo:aInfo.ID completion:^(ONEError *error, WSAccountInfo *accountInfo) {
                        
                        if (!error) {
                            WSAccountInfo *newInfo = accountInfo;
                            if (newInfo) {
                                self.accountInfo = newInfo;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.tableView reloadData];
                                    [self updateActionButton:newInfo];
                                });
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.tableView reloadData];
                                    [self updateActionButton:aInfo];
                                });

                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self updateActionButton:accountInfo];
                            });
                        }
                    }];
                } else {
                    [self.tableView reloadData];
                    [self updateActionButton:accountInfo];

                }
            });
        }];
    } else {
        __weak typeof(self)weakself = self;
        [self showHudInView:self.view hint:nil];
        
        [[ONEChatClient sharedClient] getFriendInfo:accId completion:^(ONEError *error, WSAccountInfo *accountInfo) {
            [weakself hideHud];
            if (!error) {
                WSAccountInfo *newInfo = accountInfo;
                if (newInfo) {
                    weakself.accountInfo = newInfo;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself.tableView reloadData];
                        [weakself updateActionButton:newInfo];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself.tableView reloadData];
                        [weakself updateActionButton:_accountInfo];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.tableView reloadData];
                    [weakself updateActionButton:_accountInfo];
                });
            }
        }];
    }
}

- (void)updateAccountInfoWithMap:(NSDictionary *)map
{
    if (!map) {
        return;
    }
    NSString *accountId = [map objectForKey:@"account_id"];
    if ([accountId length] > 0 && [accountId isEqualToString:self.accountInfo.ID]) {
        
        NSString *avatarUrl = [map objectForKey:@"avatar_url"];
        if ([avatarUrl length] > 0) {
            self.accountInfo.avatar_url = avatarUrl;
        }
        NSString *is_haoyou = [map objectForKey:@"is_haoyou"];
        if ([is_haoyou length] > 0) {
            
            if ([is_haoyou isEqualToString:@"1"]) {
                self.accountInfo.type = AccountTypeFriend;
            } else if ([is_haoyou isEqualToString:@"2"]) {
                self.accountInfo.type = AccountTypeStranger;
            }
        }
        NSString *to_alias = [map objectForKey:@"to_alias"];
        if ([to_alias length] > 0) {
            self.accountInfo.mark = to_alias;
        }
    }
    [ONEChatClient saveAccountInfo:self.accountInfo];
}

- (NSString *)inviteCodeFromBuddy:(NSString *)buddy
{
    if (buddy == nil) {
        return nil;
    }
    if ([[buddy componentsSeparatedByString:@"."] count] == 3) {
        
        return buddy;
    } else {
        
        NSString *account_id = [ONEChatClient accountIdWithName:buddy];
        return account_id;
    }
}
-(void)BalancereloadData:(NSNotification *)noti {
    

    
    [self updateCreditAsset];
    
//    //不为空的时候进行执行
//    if (oneBadCountDic&&oneGoodCountDic) {
//        WSBigNumber* bad = [[WSBigNumber alloc] initWithDecimalString:oneBadCountDic[BALANCE_AMOUNT]];
//        //这个方法传 精度和个数
//        self.badMoneyCount =  [bad stringWithRShiftDec:oneBadCountDic[BALANCE_PRECISION]];
//
//        WSBigNumber* good = [[WSBigNumber alloc] initWithDecimalString:oneGoodCountDic[BALANCE_AMOUNT]];
//        //这个方法传 精度和个数
//        self.self.goodMoneyCount =  [good stringWithRShiftDec:oneGoodCountDic[BALANCE_PRECISION]];
//    } else {
//        self.badMoneyCount = COUNT_ZERO;
//        self.goodMoneyCount = COUNT_ZERO;
//    }
    
    [self.tableView reloadData];
    
}


- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        
        if (_changedNick) {
            
            !_remarkChanged ?: _remarkChanged();
            !_alisChanged ?:_alisChanged(self.accountInfo.ID, self.accountInfo.accountNickName);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return SectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return CellCount;
    }
    if (section == 1) {
        return CellCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            
            SettingInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            WSAccountInfo *buddyInfo = _accountInfo;
            NSString *nick = buddyInfo.accountNickName;
            cell.type = EMPTY_STR;
            cell.invitationCode = buddyInfo.ID;
            cell.name =nick;
            cell.account = buddyInfo.name;
            cell.sex = buddyInfo.sex;
            cell.icon = buddyInfo.avatar_url;
            cell.intro = buddyInfo.intro;
            return cell;
        }
        LZContactsMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.goodCount = self.goodMoneyCount;
        cell.badCount = self.badMoneyCount;
        
        return cell;
    }
    LZContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tablecellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.model = self.SettingOtherData[indexPath.row];
    
    WSAccountInfo *info = _accountInfo;
    cell.subtitles = [info accountNickName];

    self.tableCell = cell;
    
    return cell;
    
}
- (void)sendMessageBtnClick {

    if (_accountInfo.type == AccountTypeFriend) {
        ChatViewController *chatController = [[ChatViewController alloc]
                                              initWithConversationChatter:[self handleWithBuddy:self.buddy] conversationType:ONEConversationTypeChat];
        
        NSString *title = [_accountInfo accountNickName];
        chatController.title = title;
        
        [self.navigationController pushViewController:chatController animated:YES];
    } else {
        
        [[UIAlertController shareAlertController] showTextFeildWithTitle:nil andMsg:NSLocalizedString(@"input_apply_msg", @"") andLeftBtnStr:nil andRightBtnStr:nil andRightBlock:^(NSString *str) {
            
            if (str == nil) {
                str = @"";
            }
            if (str) {
                [self showHudInView:self.view hint:nil];
                kWeakSelf
                
                [[ONEChatClient sharedClient] addFriend:_accountInfo.name message:str completion:^(ONEError *error) {
                   
                    [weakself hideHud];
                    if (!error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                           [weakself showHint:NSLocalizedString(@"pls_wait_apply", @"")];
                        });
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (error.errorCode == ONEErrorFriendRequestHasSend) {
                                [weakself showHint:NSLocalizedString(@"send_add_success", @"")];
                            } else {
                                [weakself showHint:NSLocalizedString(@"error", @"")];
                            }
                        });
                    }
                }];
            }
            
        } defaultStr:NSLocalizedString(@"i_am", @"") controller:self];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if (indexPath.row == 0) {
            return InfoHeight;
        }
        return MessageHeight;
    }
    return TableHeight;
}
//下载用户头像
- (void)donwloadAvatar {
    
    NSString *account_id = EMPTY_STR;
    if ([[self.buddy componentsSeparatedByString:@"."] count] == 3) {
        account_id = self.buddy;
    } else {
        account_id = [ONEChatClient accountIdWithName:self.buddy];
    }
    if (account_id == nil) {
        
        return;
    }
    
    [[ONEChatClient sharedClient] fetchUserAvatarUrl:account_id completion:^(ONEError *error, NSString *newAvatarUrl) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                WSAccountInfo *info = [ONEChatClient accountInfoWithName:[self handleWithBuddy:self.buddy]];
                self.icon = newAvatarUrl;
                info.avatar_url = newAvatarUrl;
                [ONEChatClient saveAccountInfo:info];
                [self.tableView reloadData];
            }
        });
    }];
    
}


- (void)loadGoodOrBad {
    //loadAtomicBalance
    //首先请求网络加载
//    [[CoinInfoMngr sharedCoinInfoMngr] loadAtomicBalance];
    
    [self updateCreditAsset];
    
    
    [self.tableView reloadData];
    
    
}

-(void) updateCreditAsset {
    
    
}
-(NSString *)getOneBadCountWith:(NSDictionary *)badDic {
    id amount = [badDic objectForKey:BALANCE_AMOUNT];
    
    NSString* ta = nil;
    
    if( [amount isKindOfClass:[NSNumber class]] ) {
        
        NSNumber* na = amount;
        
        ta = [na stringValue];
        
    } else {
        
        ta = amount;
    }
    
    
    //这个方法传 精度和个数
    
    NSNumber* p = [[NSNumber alloc] initWithInt:3];

    int  min_prece = [p intValue];
    
    WSBigNumber* n = [[WSBigNumber alloc] initWithDecimalString:ta];
    
    NSString* strAmount =  [n stringWithRShiftDec:min_prece];
    return strAmount;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.accountInfo.type != AccountTypeFriend) {
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
            self.tableCell = [tableView cellForRowAtIndexPath:indexPath];
            //change_user_local_name 修改好友备注
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"change_user_local_name", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
            ///取消 button_cancel
            UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
            [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
            
            //确认 button_confirm
            UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                KLog(@"点击了确定");
                
                [[ONEChatClient sharedClient] changeFriendRemark:_accountInfo.name remark:self.nicknameStr completion:^(ONEError *error) {
                   
                    if (!error) {
                        _accountInfo.mark = self.nicknameStr;
                        BOOL changed = [ONEChatClient saveAccountInfo:_accountInfo];
                        _changedNick = YES;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [tableView reloadData];
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (error.errorCode == ONEErrorFriendRemarkLengthExceed) {
                                [self showHint:NSLocalizedString(@"remark_length_exceed", @"")];
                            } else {
                                [self showHint:NSLocalizedString(@"setting.saveFailed", @"")];
                            }
                        });
                    }
                }];
            }];
            
            [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
            
            [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                
                textField.text =               self.tableCell.titleLabel.text;
                NSLog(@"%@",textField.text);
                [textField addTarget:self action:@selector(buyTextFieldChange:) forControlEvents:(UIControlEventEditingChanged)];
            }];
            [alertVC addAction:confirmAction];
            
            [alertVC addAction:cancelAction];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        if (indexPath.row == 1) {
            //clear_mesage_tip 确认清除聊天记录
            UIAlertController *alterConter = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"clear_mesage_tip", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
            //确认 button_confirm
            UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击确认");

                NSString* name = [self handleWithBuddy:self.buddy];
                
                [[ONEChatClient sharedClient] deleteConversationFromUser:name];
                
                [self showHint:NSLocalizedString(@"clear_mesage_success", @"")];
                
                [self removeChat];
                [self performSelector:@selector(updateConversationList) withObject:nil afterDelay:2];
                
            }];
            
            [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
            //取消 button_cancel
            UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
            
            [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
            
            [alterConter addAction:confirmAction];
            
            [alterConter addAction:cancelAction];
            
            [self presentViewController:alterConter animated:YES completion:nil];
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)removeChat {
    
    NSMutableArray *vcs = [self.navigationController.viewControllers mutableCopy];
    [vcs enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ChatViewController class]] && ((ChatViewController *)obj).conversation.type == ONEConversationTypeChat) {
            
            [vcs removeObject:(ChatViewController *)obj];
        }
    }];
    self.navigationController.viewControllers = vcs;
}

-(void) updateConversationList {
    
    [[ONEChatClient sharedClient] updateConversationList];

}

- (void)buyTextFieldChange:(UITextField *)textfiled {
    self.nicknameStr = textfiled.text;
    NSLog(@"%@",self.nicknameStr);
    
}

- (NSString *)handleWithBuddy:(NSString *)buddy
{
    if (buddy == nil || buddy.length == 0) {
        
        return EMPTY_STR;
    }
    
    if ([[buddy componentsSeparatedByString:@"."] count] == 3) {
        
        WSAccountInfo *info = [ONEChatClient accountInfoWithId:buddy];
        if (info) {
            
            return info.name;
        } else {
            
            return EMPTY_STR;
        }
    } else {
        
        return buddy;
    }
}

- (void)dealloc
{
    
}
@end
