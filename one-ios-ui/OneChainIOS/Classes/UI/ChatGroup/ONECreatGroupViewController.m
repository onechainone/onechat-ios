//
//  ONECreatGroupViewController.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/16.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONECreatGroupViewController.h"
#import "CreateGroupHeaderView.h"
#import "EaseUserModel.h"
#import "UserProfileManager.h"
#import "UIAlertController+Addition.h"



#define kGroupNick @"Group"
#define kGroupDescription @"Group Description"

@implementation NSString (search)

//根据用户昵称进行搜索
- (NSString*)username
{
    return [[UserProfileManager sharedInstance] getNickNameWithUsername:self];
}

@end
@interface ONECreatGroupViewController ()<EMChooseViewDelegate>

@property (nonatomic, strong) CreateGroupHeaderView *groupHeaderView;
@property (nonatomic, copy) NSString *invitees;
@end

@implementation ONECreatGroupViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"group_create_title", @"");
    _groupHeaderView = [[CreateGroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.tableView.tableHeaderView = _groupHeaderView;
    self.delegate = self;
    
}
// 加载好友数据
- (void)loadDataSource
{
    if (!self.presetDataSource) {
        
        __weak typeof(self) weakSelf = self;
        [self.dataSource removeAllObjects];
        [self.contactsSource removeAllObjects];
        
        [self showHudInView:self.view hint:nil];
        
        [[ONEChatClient sharedClient] getFriendListWithCompletion:^(ONEError *error, NSArray *list) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (!error && list) {
                    [weakSelf.contactsSource addObjectsFromArray:list];
                    [weakSelf.dataSource addObjectsFromArray:[weakSelf sortRecords:weakSelf.contactsSource]];
                    [weakSelf.tableView reloadData];
                }
            });
        }];

    } else {

        self.dataSource = [[self sortRecords:self.contactsSource] mutableCopy];
    }
    [self.tableView reloadData];
}

#pragma mark - EMChooseViewDelegate

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    if (selectedSources == nil || selectedSources.count == 0) {
        
        return NO;
    }
    
    NSMutableArray *accountIds = [NSMutableArray array];
    NSMutableArray *needFetchIds = [NSMutableArray array];
    for (ONEFriendModel *model in selectedSources) {
        
        if ([model.account_id length] > 0) {
            [accountIds addObject:model.account_id];
            WSAccountInfo *info = [ONEChatClient accountInfoWithId:model.account_id];
            if (!info) {
                [needFetchIds addObject:model.account_id];
            }
        }
    }
    [self showHudInView:self.view hint:nil];
    __weak typeof(self) weakself = self;
    //warning 批量拉取用户信息，创建群组时，需要确保传入的用户id相关的用户信息都已经拉取存入到本地。
    
    [[ONEChatClient sharedClient] pullAccountInfosWithAccountIdList:needFetchIds completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSMutableArray *memberIds = [NSMutableArray array];
            for (NSString *account in accountIds) {
                NSString *uid = nil;
                if ([account isAccountId]) {
                    uid = account;
                } else {
                    uid = [ONEChatClient accountIdWithName:account];
                }
                if (uid == nil) {
                    continue;
                }
                [memberIds addObject:uid];
            }
            
            ONEGroupConfiguration *config = [[ONEGroupConfiguration alloc] initWithOccupants:memberIds];
            config.is_public = _groupHeaderView.publicButton.isSelected;
            config.groupName = [self createGroupName:accountIds];
            [[ONEChatClient sharedClient] createGroupWithConfiguration:config completion:^(ONEError *error, ONEChatGroup *group) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakself hideHud];
                    if (!error) {
                        [weakself addDefMsg:group];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        if (error.errorCode == ONEErrorGroupNumCreatedExceed) {
                            [weakself showHint:NSLocalizedString(@"group_created_count_exceed", @"")];
                        } else {
                            [weakself showHint:NSLocalizedString(@"group_creat_failed", @"Create group failed")];
                        }
                    }
                });
            }];
        });
    }];
    return NO;
}

- (NSString *)createGroupName:(NSArray *)selectedSources
{
    NSArray *array = [NSArray array];
    if (selectedSources.count > 3) {
        
        array = [[selectedSources subarrayWithRange:NSMakeRange(0, 2)] copy];
    } else {
        
        array = [selectedSources copy];
    }
    NSString *groupName = [[UserProfileManager sharedInstance] getNickNameWithUsername:[ONEChatClient homeAccountId]];
    for (NSString *str in array) {
        
        NSString *nick = [[UserProfileManager sharedInstance] getNickNameWithUsername:str];
        if (nick.length <= 0) {
            
            nick = str;
        }
        groupName = [groupName stringByAppendingString:[NSString stringWithFormat:@"、%@",nick]];
    }
    
    return groupName;
}

-(void) addDefMsg:(ONEChatGroup*) info {
    
    NSString *groupId = info.groupId;
    NSString *ownerNick = [[UserProfileManager sharedInstance] getNickNameWithUsername:info.owner];
    NSString *text = [NSString stringWithFormat:@"%@%@",ownerNick, NSLocalizedString(@"create_a_group", @"")];
    ONEMessage *msg = [EaseSDKHelper sendTextMessage:text to:groupId messageType:ONEChatTypeGroupChat messageExt:nil];
    [[ONEChatClient sharedClient] sendMessage:msg progress:nil completion:^(ONEMessage *message, ONEError *error) {
        
        [[ONEChatClient sharedClient] updateConversationList];
    }];
}



@end
