//
//  ONEGroupInviteController.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/6.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEGroupInviteController.h"
#import "ONENormalApplyCell.h"
#import "ChatViewController.h"
#import "GroupChatSegmentController.h"
@interface ONEGroupInviteController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasources;

@end

@implementation ONEGroupInviteController

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
//        _tableView.backgroundColor = [UIColor whiteColor];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    [self.view addSubview:self.tableView];
    [self loadDatasources];
}


- (void)loadDatasources
{
    [self showHudInView:self.view hint:nil];
    [self.datasources removeAllObjects];
    kWeakSelf
    
    [[ONEChatClient sharedClient] getGroupInvitationListWithCompletion:^(ONEError *error, NSArray *list) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            
            if (!error) {
                [weakself.datasources addObjectsFromArray:list];
                [weakself.tableView reloadData];
            } else {
                [weakself showHint:NSLocalizedString(@"error", @"")];
            }

        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *applyCellId = @"ApplyCellIdentifier";
    ONENormalApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:applyCellId];
    if (!cell) {
        cell = [[ONENormalApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:applyCellId];
    }
    id model = self.datasources[indexPath.row];
    cell.applyModel = model;
    kWeakSelf
    cell.acceptBlock = ^(id model) {
        if ([model isKindOfClass:[ONEGroupInvitation class]]) {
            [weakself agreeWithGroupInvitation:(ONEGroupInvitation *)model];
        }
    };
    cell.rejectBlock = ^(id model) {
        
        if ([model isKindOfClass:[ONEGroupInvitation class]]) {
            [weakself rejectGroupInvitation:(ONEGroupInvitation *)model];
        }
    };
    return cell;
}

- (void)agreeWithGroupInvitation:(ONEGroupInvitation *)invitation
{
    if (!invitation || [invitation.group_uid length] == 0) {
        return;
    }
    [self showHudInView:self.view hint:nil];
    kWeakSelf
    
    [[ONEChatClient sharedClient] agreeToJoinGroup:invitation.group_uid completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                [weakself refreshUI:invitation];
                [weakself _joinedGroup:invitation];
            } else {
                if (error.errorCode == ONEErrorJoinGroupNeedAudit) {
                    [weakself showHint:NSLocalizedString(@"pls_wait_examine", @"")];
                    [weakself refreshUI:invitation];
                } else {
                    [weakself showHint:NSLocalizedString(@"error", @"error")];
                }
            }
        });
    
    }];

}

- (void)_joinedGroup:(ONEGroupInvitation *)invitation
{
    if (!invitation) {
        return;
    }
    
    [[ONEChatClient sharedClient] syncGroupChatInfo:^(ONEError *error) {
       
        if (!error) {
            ONEChatGroup *group = [[ONEChatClient sharedClient] groupChatWithGroupId:invitation.group_uid];
            if (group) {
                ONEMessage *msg = [EaseSDKHelper sendTextMessage:[NSString stringWithFormat:@"%@%@",[ONEChatClient homeAccountInfo].nickname , @"加入了群"] to:invitation.group_uid messageType:ONEChatTypeGroupChat messageExt:nil];
                [[ONEChatClient sharedClient] sendMessage:msg progress:nil completion:^(ONEMessage *message, ONEError *error) {
                    if (!group.isPublicGroup) {
                        ChatViewController *chat = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:ONEConversationTypeGroupChat];
                        [self.navigationController pushViewController:chat animated:YES];
                    } else {
                        GroupChatSegmentController *seg = [[GroupChatSegmentController alloc] initWithConversationChatter:group.groupId conversationType:ONEConversationTypeGroupChat];
                        [self.navigationController pushViewController:seg animated:YES];
                    }
                }];
            }
        }
    }];
}

- (void)rejectGroupInvitation:(ONEGroupInvitation *)invitation
{
    if (!invitation || [invitation.group_uid length] == 0) {
        return;
    }
    [self showHudInView:self.view hint:nil];
    
    kWeakSelf
    [[ONEChatClient sharedClient] disAgreeToJoinGroup:invitation.group_uid completion:^(ONEError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                [weakself refreshUI:invitation];
            } else {
                [weakself showHint:NSLocalizedString(@"error", @"error")];
            }
        });
    }];
}

- (void)refreshUI:(ONEGroupInvitation *)invitation
{
    __block NSInteger index = -1;
    [self.datasources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ONEGroupInvitation class]]) {
            
            ONEGroupInvitation *gObj = (ONEGroupInvitation *)obj;
            if ([gObj.group_uid isEqualToString:invitation.group_uid] && [gObj.account_id isEqualToString:invitation.account_id]) {
                
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


@end
