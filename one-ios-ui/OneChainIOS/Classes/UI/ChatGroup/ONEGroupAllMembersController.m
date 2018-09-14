//
//  ONEGroupAllMembersController.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/29.
//  Copyright © 2018 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEGroupAllMembersController.h"
#import <MJRefresh/MJRefresh.h>
#import "ONEGroupMemberCell.h"
#import "EMSDImageCache.h"
#import <SDWebImage/SDImageCache.h>
#import "LZContactsDetailTableViewController.h"
#import "ONEAddMemberViewController.h"
#import "ONEGroupManager.h"
#define kNumberOfCol 4
#define kMargin 10
#define kPageCount 50
static NSString *collectionID = @"AllMemberCell";
@interface ONEGroupAllMembersController ()<UICollectionViewDelegate, UICollectionViewDataSource, ONEGroupMemberCellDelegate>

@property (nonatomic, strong) ONEChatGroup *groupInfo;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSMutableArray *allMemberList;
@property (nonatomic, strong) NSMutableSet *allMemberSet;

@property (nonatomic, strong) NSMutableSet *adminsSet;
@end

@implementation ONEGroupAllMembersController

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [super init];
    if (self) {
        
        _groupInfo = [[ONEChatClient sharedClient] groupChatWithGroupId:groupId];
    }
    return self;
}

- (NSMutableSet *)adminsSet
{
    if (!_adminsSet) {
        
        _adminsSet = [NSMutableSet set];
    }
    return _adminsSet;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.title = [NSString stringWithFormat:@"%@(%lu)",NSLocalizedString(@"group_members", @""),(unsigned long)self.groupInfo.memberSize];
    [self fetchMembers];
    [self setupMJFooter];
    [self getAdmins];
}

- (void)getAdmins {
    
    [self.adminsSet removeAllObjects];

    kWeakSelf
    
    [[ONEChatClient sharedClient] getGroupAdminList:self.groupInfo.groupId completion:^(ONEError *error, NSArray *list) {
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([list count] > 0) {
                    [ONEGroupManager cacheGroupAdmis:list groupId:weakself.groupInfo.groupId];

                    [weakself.adminsSet addObjectsFromArray:list];
                    [weakself.collectionView reloadData];
                }
            });
        }
    }];

}

- (void)setupMJFooter
{
    __weak typeof(self) weakself = self;
    self.collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [[EMSDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        [weakself handleWithLoadMoreAction];
    }];
}

- (void)handleWithLoadMoreAction
{
    if ([self.allMemberList count] == 0) {
        
        [self.collectionView.mj_footer endRefreshing];
        return;
    }
    NSArray *page = nil;
    if ([self.allMemberList count] > kPageCount) {
        
        page = [[self.allMemberList subarrayWithRange:NSMakeRange(0, kPageCount)] copy];
        [self.allMemberList removeObjectsInRange:NSMakeRange(0, kPageCount)];
    } else {
        page = [self.allMemberList copy];
        [self.allMemberList removeAllObjects];
    }
    NSArray *completeList = [self fetchMemberInfoWithMemberList:page];
    [self refreshMemberList:completeList];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)setupUI {
    
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    [self.view addSubview:self.collectionView];
}

#pragma mark - fetch members

- (void)fetchMembers
{
    [self.allMemberList removeAllObjects];
    [self showHudInView:self.view hint:nil];
    kWeakSelf
    [[ONEChatClient sharedClient] getMemberListFromGroup:self.groupInfo.groupId completion:^(ONEError *error, NSArray *list) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                
                if ([list count] > 0) {
                    [weakself.allMemberList addObjectsFromArray:list];
                    [weakself.allMemberSet addObjectsFromArray:list];
                    NSArray *firstPage = nil;
                    if ([weakself.allMemberList count] > kPageCount) {
                        firstPage = [[self.allMemberList subarrayWithRange:NSMakeRange(0, kPageCount)] copy];
                        [weakself.allMemberList removeObjectsInRange:NSMakeRange(0, kPageCount)];
                    } else {
                        firstPage = [weakself.allMemberList copy];
                        [weakself.allMemberList removeAllObjects];
                    }
                    NSArray *completeList = [self fetchMemberInfoWithMemberList:firstPage];
                    [weakself refreshMemberList:completeList];
                    [weakself hideHud];
                } else {
                    [weakself hideHud];
                }
            } else {
                [weakself hideHud];
                [weakself showHint:NSLocalizedString(@"group_member_list_fail", @"获取群成员失败")];
            }
        });
    }];
}

- (NSArray *)fetchMemberInfoWithMemberList:(NSArray *)memberList
{
    if ([memberList count] == 0) {
        return @[];
    }
    NSArray *needFetchList = [self serverGroupMemberList:memberList];
    if ([needFetchList count] == 0) {
        return [memberList copy];
    }
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [[ONEChatClient sharedClient] pullAccountInfosWithAccountIdList:needFetchList completion:^(ONEError *error) {
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)));
    return [memberList copy];
}

- (NSArray *)serverGroupMemberList:(NSArray *)datasource
{
    if (datasource.count == 0) return @[];
    
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:datasource];
    
    [mArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSString class]]) {
            
            NSString *account_uid = (NSString *)obj;
            
            WSAccountInfo *info = [ONEChatClient accountInfoWithId:account_uid];
            if (info) {
                
                [mArray removeObject:account_uid];
            }
        }
    }];
    return [NSArray arrayWithArray:mArray];
}

- (void)refreshMemberList:(NSArray *)completeList
{
    if ([completeList count] == 0) {
        return;
    }
    if ([self.datasource count] > 0) {
        
        [self.datasource removeLastObject];
    }
    [self.datasource addObjectsFromArray:completeList];
    [self.datasource addObject:@"group_add"];
    [self.collectionView reloadData];
}





#pragma mark - Getters

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (KScreenW - (kNumberOfCol + 1) * kMargin) / kNumberOfCol;
        CGFloat itemH = itemW;
        _layout.itemSize = CGSizeMake(itemW, itemH);
        _layout.sectionInset = UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) collectionViewLayout:self.layout];
        _collectionView.themeMap = @{
                                     BGColorName:@"bg_white_color"
                                     };
//        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ONEGroupMemberCell class] forCellWithReuseIdentifier:collectionID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

/**
 *  界面显示的群成员
 */
- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
// 未展示群成员
- (NSMutableArray *)allMemberList
{
    if (!_allMemberList) {
        _allMemberList = [NSMutableArray array];
    }
    return _allMemberList;
}

- (NSMutableSet *)allMemberSet
{
    if (!_allMemberSet) {
        _allMemberSet = [NSMutableSet set];
    }
    return _allMemberSet;
}



#pragma mark - UICollectionViewDelegate、UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ONEGroupMemberCell *memberCell = (ONEGroupMemberCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    
    NSString *accountId = self.datasource[indexPath.row];
    memberCell.remark = accountId;
    if ([self isGroupOwner:accountId]) {
        memberCell.roleType = GroupRoleType_Owner;
    } else if ([self isGroupAdmin:accountId]) {
        memberCell.roleType = GroupRoleType_Admin;
    } else {
        memberCell.roleType = GroupRoleType_Member;
    }
    memberCell.delegate = self;
    return memberCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *remark = self.datasource[indexPath.row];
    if ([remark isEqualToString:@"group_add"]) {
        // 添加成员
        [self inviteFriendsToGroup];
    } else {
        // 跳转个人中心
        [self jumpToPersonalInfoVC:remark];
    }
}


- (BOOL)isGroupOwner:(NSString *)accountId
{
    if ([accountId length] == 0) {
        return NO;
    }
    if ([accountId isEqualToString:_groupInfo.owner]) {
        return YES;
    }
    return NO;
}

- (BOOL)isGroupAdmin:(NSString *)accountId
{
    if ([accountId length] == 0 || [self.adminsSet count] == 0) {
        return NO;
    }
    if ([self.adminsSet containsObject:accountId]) {
        return YES;
    }
    return NO;
}

#pragma mark - ONEGroupMemberCellDelegate

- (void)didLongPressItem:(NSString *)remark
{
    if ([remark length] == 0 || [remark isEqualToString:[ONEChatClient homeAccountId]] || ![self.groupInfo.owner isEqualToString:[ONEChatClient homeAccountId]]) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete", @"deleting member...") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self deleteMember:remark];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - private method

- (void)jumpToPersonalInfoVC:(NSString *)account_id
{
    if ([account_id length] == 0 || [account_id isEqualToString:[ONEChatClient homeAccountId]]) {
        return;
    }
    LZContactsDetailTableViewController *contact = [[LZContactsDetailTableViewController alloc] initWithBuddy:account_id];
    contact.canSendMsg = YES;
    [self.navigationController pushViewController:contact animated:YES];
}

- (void)deleteMember:(NSString *)memberId
{
    if ([memberId length] == 0 || [memberId isEqualToString:[ONEChatClient homeAccountId]] || ![self.groupInfo.owner isEqualToString:[ONEChatClient homeAccountId]]) {
        return;
    }
    [self showHudInView:self.view hint:nil];
    __weak typeof(self)weakself = self;
    
    [[ONEChatClient sharedClient] removeOccupants:@[memberId] fromGroup:self.groupInfo.groupId completion:^(ONEError *error, NSArray *removedOccupants) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakself hideHud];
            if (!error) {
                [weakself.datasource removeObject:memberId];
                [weakself.allMemberSet removeObject:memberId];
                [weakself.collectionView reloadData];
                [weakself updateTitle];
                !weakself.deleteMember ?: weakself.deleteMember(memberId);
            } else {
                [weakself showHint:NSLocalizedString(@"group_deletecontact_failed", @"Delete members failed")];
            }
        });
    }];
}

- (void)inviteFriendsToGroup
{

    ONEAddMemberViewController *oneC = [[ONEAddMemberViewController alloc] initWithBlockSelectedUsernames:self.allMemberSet];
    __weak typeof(self)weakSelf = self;
    oneC.addContact = ^(NSArray *sources) {
        
        [weakSelf showHudInView:weakSelf.view hint:nil];
        
        [[ONEChatClient sharedClient] addOccupants:sources intoGroup:weakSelf.groupInfo.groupId completion:^(ONEError *error, NSArray *newOccupants) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (!error) {
                    if ([newOccupants count] == 0) {
                        [weakSelf showHint:NSLocalizedString(@"pls_wait_apply", @"")];
                    } else {
                        [weakSelf.allMemberSet addObjectsFromArray:newOccupants];
                        [weakSelf refreshMemberList:newOccupants];
                        !weakSelf.addMember ?: weakSelf.addMember(newOccupants);
                    }
                    [weakSelf updateTitle];
                } else {
                    [weakSelf showHint:NSLocalizedString(@"group_addcontact_failed", @"Add members failed")];
                }
            });
        }];

    };
    [self.navigationController pushViewController:oneC animated:YES];
}

- (void)updateTitle
{
    self.title = [NSString stringWithFormat:@"%@(%lu)",NSLocalizedString(@"group_members", @""),[self.allMemberSet count]];
}

- (void)dealloc
{
    [[EMSDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}


@end
