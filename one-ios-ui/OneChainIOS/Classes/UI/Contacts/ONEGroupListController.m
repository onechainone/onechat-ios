//
//  ONEGroupListController.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEGroupListController.h"
#import "ONEGroupListCell.h"
#import "ChatViewController.h"
#import "GroupChatSegmentController.h"

@interface ONEGroupListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation ONEGroupListController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
//        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.themeMap = @{
                                BGColorName:@"bg_white_color"
                                };
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight =0;
            _tableView.estimatedSectionFooterHeight =0;
        }
    }
    return _tableView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    [self.view addSubview:self.tableView];
    kWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadDatasource];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDatasource];
}

- (void)loadDatasource
{
    [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:[[ONEChatClient sharedClient] groupChatList]];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ONEGROUPLISTCELL";
    ONEGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ONEGroupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ONEChatGroup *info = self.datasource[indexPath.row];
    cell.info = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ONEChatGroup *info = self.datasource[indexPath.row];
    if (!info.isPublicGroup) {
        
        ChatViewController *chat = [[ChatViewController alloc] initWithConversationChatter:info.groupId conversationType:ONEConversationTypeGroupChat];
        [self.navigationController pushViewController:chat animated:YES];
    } else {
        GroupChatSegmentController *seg = [[GroupChatSegmentController alloc] initWithConversationChatter:info.groupId conversationType:ONEConversationTypeGroupChat];
        [self.navigationController pushViewController:seg animated:YES];
    }
}


@end
