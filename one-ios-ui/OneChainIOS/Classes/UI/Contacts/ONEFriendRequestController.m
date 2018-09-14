//
//  ONEFriendRequestController.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/6.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEFriendRequestController.h"
#import "ONENormalApplyCell.h"
#import "ChatViewController.h"
@interface ONEFriendRequestController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasources;
@end

@implementation ONEFriendRequestController

- (NSMutableArray *)datasources
{
    if (!_datasources) {
        _datasources = [NSMutableArray array];
    }
    return _datasources;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
        _tableView.themeMap = @{
                                BGColorName:@"bg_white_color",
                                TableSepColorName:@"conversation_line_color"
                                };
        _tableView.rowHeight = 90;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight =0;
            _tableView.estimatedSectionFooterHeight =0;
        }
    }
    return _tableView;
    
}

- (void)loadDatasources {

    [self.datasources removeAllObjects];
    [self showHudInView:self.view hint:nil];
    __weak typeof(self)weakself = self;
    
    [[ONEChatClient sharedClient] getFriendApplyListWithCompletion:^(ONEError *error, NSArray *list) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                [weakself.datasources addObjectsFromArray:list];
                [weakself.tableView reloadData];
            }
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    [self.view addSubview:self.tableView];
    [self loadDatasources];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasources.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *applyCellId = @"ApplyCellIdentifier";
    ONENormalApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:applyCellId];
    if (!cell) {
        cell = [[ONENormalApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:applyCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id model = self.datasources[indexPath.row];
    cell.applyModel = model;
    kWeakSelf
    cell.acceptBlock = ^(id model) {

        if ([model isKindOfClass:[ONEFriendApply class]]) {
            
            [weakself agreeAction:(ONEFriendApply *)model];
        }
    };
    cell.rejectBlock = ^(id model) {
        if ([model isKindOfClass:[ONEFriendApply class]]) {
            
            [weakself rejectAction:(ONEFriendApply *)model];
        }
    };
    return cell;
}

- (void)agreeAction:(ONEFriendApply *)apply
{
    if (!apply) {
        return;
    }
    kWeakSelf
    [self showHudInView:self.view hint:nil];
    
    [[ONEChatClient sharedClient] approveAddFriendRequest:apply.to_account_name completion:^(ONEError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            
            if (!error) {
                [weakself refreshUI:apply];
                WSAccountInfo *accountInfo = [ONEChatClient accountInfoWithName:apply.to_account_name];
                if (accountInfo == nil) {
    
                    [[ONEChatClient sharedClient] pullAccountInfoWithAccountName:apply.from_account_name completion:^(ONEError *error, WSAccountInfo *accountInfo) {
                        
                        [weakself hideHud];
                        WSAccountInfo *info = [ONEChatClient accountInfoWithName:apply.to_account_name];
                        if (info) {
                            [weakself _jumpToChat:info];
                        }
                    }];
                } else {
                    [weakself hideHud];
                    [weakself _jumpToChat:accountInfo];
                }
            } else {
                
                [weakself hideHud];

                if (error.errorCode == ONEErrorOperationHasDone) {
                    [weakself refreshUI:apply];
                } else {
                    [weakself showHint:NSLocalizedString(@"error", @"")];
                }
            }
        });
    }];
}

- (void)_jumpToChat:(WSAccountInfo *)accountInfo
{
    kWeakSelf
    
    ONEMessage *msg = [EaseSDKHelper sendTextMessage:[NSString stringWithFormat:@"%@",NSLocalizedString(@"default_chat_sentence", @"")] to:accountInfo.name messageType:ONEChatTypeChat messageExt:nil];
    
    [[ONEChatClient sharedClient] sendMessage:msg progress:nil completion:^(ONEMessage *message, ONEError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ChatViewController *chat = [[ChatViewController alloc] initWithConversationChatter:accountInfo.name conversationType:ONEConversationTypeChat];
            chat.title = accountInfo.nickname;
            [weakself.navigationController pushViewController:chat animated:YES];
            [[ONEChatClient sharedClient] updateConversationList];
        });
    }];


}

- (void)rejectAction:(ONEFriendApply *)apply
{
    if (!apply) {
        return;
    }
    kWeakSelf
    [self showHudInView:self.view hint:nil];
    
    [[ONEChatClient sharedClient] rejectFriendRequest:apply.to_account_name completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakself hideHud];
            if (!error) {
                [weakself refreshUI:apply];
            } else {
                if (error.errorCode == ONEErrorOperationHasDone) {
                    [weakself refreshUI:apply];
                } else {
                    [weakself showHint:NSLocalizedString(@"error", @"")];
                }
            }
        });
    }];
}

- (void)refreshUI:(ONEFriendApply *)invitation
{
    __block NSInteger index = -1;
    [self.datasources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ONEFriendApply class]]) {
            
            ONEFriendApply *gObj = (ONEFriendApply *)obj;
            if ([gObj.to_account_name isEqualToString:invitation.to_account_name]) {
                
                index = idx;
                *stop = YES;
            }
        }
    }];
    if (index >= 0 && index < self.datasources.count) {
        [self.datasources removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:indexPath, nil];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ONEFriendApply *apply = self.datasources[indexPath.row];
    if ([apply.remark length] > 0) {
        [[UIAlertController shareAlertController] showTitleAlertcWithString:apply.remark andTitle:nil controller:self];
    }
}
@end
