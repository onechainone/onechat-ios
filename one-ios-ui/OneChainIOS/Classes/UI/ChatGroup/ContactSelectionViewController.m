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

#import "ContactSelectionViewController.h"

#import "EMSearchBar.h"
#import "EMRemarkImageView.h"
#import "EMSearchDisplayController.h"
#import "RealtimeSearchUtil.h"
static const CGFloat kPadding = 10.f;
@interface ContactSelectionViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>


@property (strong, nonatomic) NSMutableArray *selectedContacts;
@property (strong, nonatomic) NSMutableSet *blockSelectedUsernames;

@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIScrollView *footerScrollView;
@property (strong, nonatomic) UIButton *doneButton;



@end

@implementation ContactSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _contactsSource = [NSMutableArray array];
        _selectedContacts = [NSMutableArray array];
        
        [self setObjectComparisonStringBlock:^NSString *(id object) {
            return object;
        }];
        
        [self setComparisonObjectSelector:^NSComparisonResult(id object1, id object2) {
            NSString *username1 = (NSString *)object1;
            NSString *username2 = (NSString *)object2;
            
            return [username1 caseInsensitiveCompare:username2];
        }];
    }
    return self;
}

- (instancetype)initWithBlockSelectedUsernames:(NSSet *)blockUsernames
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _blockSelectedUsernames = [blockUsernames mutableCopy];
       
    }
    
    return self;
}

- (instancetype)initWithContacts:(NSArray *)contacts
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _presetDataSource = YES;
        [_contactsSource addObjectsFromArray:contacts];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"title.chooseContact", @"select the contact");
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.footerView];
    self.tableView.editing = YES;
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height + kPadding, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height- CGRectGetHeight(self.footerView.frame) - kPadding);
    [self searchController];

}

- (void)getExistMembers
{
    if ([_blockSelectedUsernames count] > 0)
    {
        
        for (ONEFriendModel *model in self.contactsSource)
        {
            
            if ([_blockSelectedUsernames containsObject:model.account_id])
            {
                NSInteger section = [self sectionForString:model.showName];
                NSMutableArray *tmpArray = [self.dataSource objectAtIndex:section];
                if (tmpArray && [tmpArray count] > 0)
                {
                    NSInteger row = [tmpArray indexOfObject:model];
                    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
        }
        if ([self.selectedContacts count] > 0)
        {
            [self reloadFooterView];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - getter

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.editingStyle = UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ContactSelectionViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            ONEFriendModel *model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.friendModel = model;
            
            return cell;
        }];
        
        [_searchController setCanEditRowAtIndexPath:^BOOL(UITableView *tableView, NSIndexPath *indexPath) {
            if ([weakSelf.blockSelectedUsernames count] > 0) {
                
                ONEFriendModel *model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
                return ![weakSelf isBlockUsername:model.account_name];
            }
            
            return YES;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {

            ONEFriendModel *model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            if (![weakSelf.selectedContacts containsObject:model])
            {
                NSInteger section = [weakSelf sectionForString:model.showName];
                if (section >= 0) {
                    NSMutableArray *tmpArray = [weakSelf.dataSource objectAtIndex:section];
                    NSInteger row = [tmpArray indexOfObject:model];
                    [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                [weakSelf.selectedContacts addObject:model];
                [weakSelf reloadFooterView];
            }
        }];
        
        [_searchController setDidDeselectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

            ONEFriendModel *model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            if ([weakSelf.selectedContacts containsObject:model]) {
                NSInteger section = [weakSelf sectionForString:model.showName];
                if (section >= 0) {
                    NSMutableArray *tmpArray = [weakSelf.dataSource objectAtIndex:section];
                    NSInteger row = [tmpArray indexOfObject:model.showName];
                    [weakSelf.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:NO];
                }
                
                [weakSelf.selectedContacts removeObject:model];
                [weakSelf reloadFooterView];
            }
        }];
    }
    
    return _searchController;
}

- (UIView *)footerView
{
    if (self.mulChoice && _footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _footerView.backgroundColor = THMColor(@"bg_color");
        
        _footerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 30 - 70, _footerView.frame.size.height - 5)];
        _footerScrollView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:_footerScrollView];
        
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(_footerView.frame.size.width - 80, 8, 70, _footerView.frame.size.height - 16)];
        _doneButton.accessibilityIdentifier = @"done_button";
        [_doneButton setTitle:NSLocalizedString(@"accept", @"Accept") forState:UIControlStateNormal];
        _doneButton.themeMap = @{
                                 BGColorName:@"theme_color",
                                 TextColorName:@"theme_title_color"
                                 };
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _doneButton.layer.cornerRadius = 5.f;
        _doneButton.layer.masksToBounds = YES;
        [_doneButton setTitle:NSLocalizedString(@"button_ok", @"") forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_doneButton];
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactListCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ONEFriendModel *model = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.friendModel = model;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_blockSelectedUsernames count] > 0) {
        ONEFriendModel *model = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return ![self isBlockUsername:model.account_id];
    }
    
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.mulChoice) {
        if (![self.selectedContacts containsObject:object] && ![self isBlockUsername:((ONEFriendModel *)object).account_name])
        {
            [self.selectedContacts addObject:object];
            [self reloadFooterView];
        }
    }
    else {
        [self.selectedContacts addObject:object];
        [self doneAction:nil];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ONEFriendModel *model = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if ([self.selectedContacts containsObject:model]) {
        [self.selectedContacts removeObject:model];

        [self reloadFooterView];
    }

}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.searchBar setCancelButtonTitle:NSLocalizedString(@"ok", @"OK")];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
                
                for (ONEFriendModel *model in results) {
                    if ([weakSelf.selectedContacts containsObject:model])
                    {
                        NSInteger row = [results indexOfObject:model];
                        [weakSelf.searchController.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    }
                }
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
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

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.editing = YES;
}

#pragma mark - private

- (BOOL)isBlockUsername:(NSString *)username
{
    if (username && [username length] > 0) {
        if ([_blockSelectedUsernames count] > 0) {
            
            if ([_blockSelectedUsernames containsObject:username]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)reloadFooterView
{
    if (self.mulChoice) {
        [self.footerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat imageSize = self.footerScrollView.frame.size.height;
        NSInteger count = [self.selectedContacts count];
        self.footerScrollView.contentSize = CGSizeMake(imageSize * count, imageSize);
        for (int i = 0; i < count; i++) {
            ONEFriendModel *model = [self.selectedContacts objectAtIndex:i];
            EMRemarkImageView *remarkView = [[EMRemarkImageView alloc] initWithFrame:CGRectMake(i * imageSize, 0, imageSize, imageSize)];
            remarkView.image = [UIImage imageNamed:@"chatListCellHead.png"];
            remarkView.remarkLabel.text = model.showName;
            [remarkView.imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage defaultAvaterImage]];
            [self.footerScrollView addSubview:remarkView];
        }
        
        if ([self.selectedContacts count] == 0) {
            [_doneButton setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
        }
        else{
            [_doneButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"done_with_count", @"Ensure(%i)"), [self.selectedContacts count]] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - public

- (void)loadDataSource
{
//    if (!_presetDataSource) {
//        [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
//        [_dataSource removeAllObjects];
//        [_contactsSource removeAllObjects];
//        
//        NSArray *buddyList = [[EMClient sharedClient].contactManager getContacts];
//        for (NSString *username in buddyList) {
//            
//            [self.contactsSource addObject:username];
//        }
//        
//        [_dataSource addObjectsFromArray:[self sortRecords:self.contactsSource]];
//        
//        [self hideHud];
//    }
//    else {
//        _dataSource = [[self sortRecords:self.contactsSource] mutableCopy];
//    }
//    [self.tableView reloadData];
}

- (void)doneAction:(id)sender
{
    BOOL isPop = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:didFinishSelectedSources:)]) {
        if ([_blockSelectedUsernames count] == 0) {
            isPop = [_delegate viewController:self didFinishSelectedSources:self.selectedContacts];
        }
        else{
            NSMutableArray *resultArray = [NSMutableArray array];
            for (ONEFriendModel *model in self.selectedContacts) {
                if(![self isBlockUsername:model.account_name])
                {
                    [resultArray addObject:model];
                }
            }
            isPop = [_delegate viewController:self didFinishSelectedSources:resultArray];
        }
    }
    
    if (isPop) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)backAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewControllerDidSelectBack:)]) {
        [_delegate viewControllerDidSelectBack:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
