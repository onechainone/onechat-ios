/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ContactListViewController.h"

#import "ChatViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
#import "UserProfileManager.h"
#import "LZContactsDetailTableViewController.h"
#import "ONEGroupInviteController.h"
#import "ONEFriendRequestController.h"
#import "ONEGroupListController.h"
//#define isHideCell 0


@implementation NSString (search)

//根据用户昵称进行搜索
- (NSString*)showName
{
    return [[UserProfileManager sharedInstance] getNickNameWithUsername:self];
}

@end

@interface ContactListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,UIActionSheetDelegate>
{
    NSIndexPath *_currentLongPressIndex;
}

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;

@property (nonatomic) NSInteger unapplyCount;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (nonatomic, assign) NSInteger unreadFriendApply;
@property (nonatomic, assign) NSInteger unreadGroupInvitation;

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    self.showRefreshHeader = YES;
    ///通讯录 contacts
    self.navigationItem.title = NSLocalizedString(@"contacts", nil);
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeDidChangeNotification object:nil];

    [self searchController];
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.view addSubview:self.searchBar];

    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height);
    
    self.tableView.themeMap = @{
                                BGColorName:@"bg_white_color",
                                TableSepColorName:@"conversation_line_color"
                                };
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:THMColor(@"theme_special_color")];
}

- (void)themeChanged
{
    if ([[ONEThemeManager sharedInstance].theme.theme_id isEqualToString:@"2"]) {
        self.searchBar.barStyle = UIBarStyleBlack;
    } else {
        self.searchBar.barStyle = UIBarStyleDefault;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshUnreadCount];
}


#pragma mark - getter
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"accountname_search", @"Search");

    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ContactListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            ONEFriendModel *model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.textLabel.text = model.showName;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage defaultAvaterImage]];
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            ONEFriendModel *model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            [weakSelf.searchController.searchBar endEditing:YES];
            LZContactsDetailTableViewController *contacts = [[LZContactsDetailTableViewController alloc] initWithBuddy:model.account_name];
            
            contacts.deleteAction = ^(NSString *account_name) {
              
                __strong ContactListViewController *strongself = weakSelf;
                [strongself.contactsSource enumerateObjectsUsingBlock:^(ONEFriendModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj.account_name isEqualToString:account_name]) {
                        
                        [strongself.contactsSource removeObject:obj];
                        [strongself _sortDataArray:weakSelf.contactsSource];
                    }
                }];
            };
            [weakSelf.navigationController pushViewController:contacts animated:YES];
        }];
    }
    
    return _searchController;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    

    
    int count = [self.dataArray count] + 1;
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return 3;
    }
    return [[self.dataArray objectAtIndex:(section - 1)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {

        
        NSString *CellIdentifier = @"commonCell";
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.avatarView.image = [UIImage imageNamed:@"friend_apply"];
            cell.titleLabel.text = NSLocalizedString(@"new_friend", @"");
            if (self.unreadFriendApply > 0) {
                cell.unreadLabel.hidden = NO;
                cell.unreadLabel.text = [NSString stringWithFormat:@"%ld",self.unreadFriendApply];
            } else {
                cell.unreadLabel.hidden = YES;
            }
        }
        else if (indexPath.row == 1) {
            cell.avatarView.image = [UIImage imageNamed:@"Group_banner"];
            cell.titleLabel.text = NSLocalizedString(@"group_invitation",@"");
            if (self.unreadGroupInvitation > 0) {
                cell.unreadLabel.hidden = NO;
                cell.unreadLabel.text = [NSString stringWithFormat:@"%ld",self.unreadGroupInvitation];
            } else {
                cell.unreadLabel.hidden = YES;
            }
        } else if (indexPath.row == 2) {
            cell.avatarView.image = [UIImage imageNamed:@"group_invitation_icon"];
            cell.titleLabel.text = NSLocalizedString(@"my_group_chat", @"");
            [cell.unreadLabel setHidden:YES];
        }
        return cell;
    } else {
        NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
        
        ONEFriendModel *model = [userSection objectAtIndex:indexPath.row];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.friendModel = model;
        
        return cell;
    }
    
}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 22;
}

    
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    return self.sectionTitles[section - 1];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    UIView *contentView = [[UIView alloc] init];
//    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    contentView.themeMap = @{
                             BGColorName:@"conversation_section_color"
                             };
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    label.themeMap = @{
                       TextColorName:@"theme_special_color"
                       };
    [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    [contentView addSubview:label];
    return contentView;
}
         
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (indexPath.row == 0) {
            
            ONEFriendRequestController *applyVC = [[ONEFriendRequestController alloc] init];
            applyVC.title = NSLocalizedString(@"new_friend", @"");
            [self.navigationController pushViewController:applyVC animated:YES];
        } else if (indexPath.row == 1) {
            
            ONEGroupInviteController *invitationController = [[ONEGroupInviteController alloc] init];
            invitationController.title = NSLocalizedString(@"group_invitation", @"");
            [self.navigationController pushViewController:invitationController animated:YES];
        } else if (indexPath.row == 2) {
            
            ONEGroupListController *groupList = [[ONEGroupListController alloc] init];
            groupList.title = NSLocalizedString(@"my_group_chat", @"");
            [self.navigationController pushViewController:groupList animated:YES];
        }

    } else {
        ONEFriendModel *model = [[self.dataArray objectAtIndex:(section - 1)] objectAtIndex:row];
        LZContactsDetailTableViewController *detailVC = [[LZContactsDetailTableViewController alloc] initWithBuddy:model.account_name];
        detailVC.canSendMsg = YES;
        kWeakSelf
        detailVC.deleteAction = ^(NSString *account_name) {
            
            [weakself.contactsSource enumerateObjectsUsingBlock:^(ONEFriendModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj.account_name isEqualToString:account_name]) {
                    
                    [weakself.contactsSource removeObject:obj];
                    [weakself _sortDataArray:weakself.contactsSource];
                }
            }];
        };
        
        detailVC.alisChanged = ^(NSString *accountId, NSString *alis) {
            if ([accountId length] > 0) {
                [weakself refreshUIWithaccountId:accountId remark:alis];
            }
        };
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)refreshUIWithaccountId:(NSString *)accountId remark:(NSString *)remark
{
    __block NSInteger index = -1;
    __block ONEFriendModel *newModel = nil;
    [self.contactsSource enumerateObjectsUsingBlock:^(ONEFriendModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.account_id isEqualToString:accountId]) {
            

            newModel = obj;
            newModel.to_alias = remark;
            index = idx;
            *stop = YES;
        }
    }];
    if (index >= 0 && index < self.contactsSource.count) {
        
        [self.contactsSource replaceObjectAtIndex:index withObject:newModel];
        [self _sortDataArray:self.contactsSource];
    }

}
                                                       
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



                                                       

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self updateTableViewFrame];
    return YES;
}

- (void)updateTableViewFrame
{
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height - 20);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}




#pragma mark - private data

- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    NSMutableArray *contactsSource = [NSMutableArray arrayWithArray:buddyList];

    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //按首字母分组
    [self.contactsSource removeAllObjects];
    for (ONEFriendModel *model in contactsSource) {
        
        if (model) {
            
            [self.contactsSource addObject:model];

            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:model.showName];
            
            if (firstLetter == nil || [firstLetter length] == 0) continue;
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:model];
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(ONEFriendModel *obj1, ONEFriendModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.showName];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.showName];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    
    [self.dataArray addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}


#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    kWeakSelf
    
    [[ONEChatClient sharedClient] getFriendListWithCompletion:^(ONEError *error, NSArray *list) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error && list) {
                if ([list count] > 0) {
                    [weakself _sortDataArray:list];
                }
            }
            [weakself.tableView.mj_header endRefreshing];
        });
    }];
}

- (void)refreshUnreadCount
{
    kWeakSelf
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [[ONEChatClient sharedClient] fetchFriendApplyCount:^(ONEError *error, NSInteger count) {
       
        weakself.unreadFriendApply = count;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[ONEChatClient sharedClient] fetchGroupApplyCount:^(ONEError *error, NSInteger count) {
        weakself.unreadGroupInvitation = count;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        [weakself.tableView beginUpdates];
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [weakself.tableView endUpdates];
    });

}

- (void)updateWithZero
{
    self.unreadFriendApply = 0;
    self.unreadGroupInvitation = 0;
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}




@end
