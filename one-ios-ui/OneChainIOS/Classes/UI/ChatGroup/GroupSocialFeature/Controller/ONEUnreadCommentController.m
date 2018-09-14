//
//  ONEUnreadCommentController.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEUnreadCommentController.h"
#import "ONEUnreadCell.h"
#import "ONEArticleDetailController.h"
@interface ONEUnreadCommentController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *unreadList;
@property (nonatomic, copy) NSString *groupId;
@end

@implementation ONEUnreadCommentController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
        _tableView.themeMap = @{
                                BGColorName:@"bg_white_color"
                                };
//        _tableView.backgroundColor = [UIColor whiteColor];
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

- (NSMutableArray *)unreadList
{
    if (!_unreadList) {
        
        _unreadList = [NSMutableArray array];
    }
    return _unreadList;
}

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [super init];
    if (self) {
        _groupId = groupId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak typeof(self) weakself = self;
    
    [[ONEChatClient sharedClient] getUnreadMsgList:self.groupId completion:^(ONEError *error, NSArray *list) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error && [list count] > 0) {
                
                [weakself.unreadList removeAllObjects];
                [weakself.unreadList addObjectsFromArray:list];
                [weakself.tableView reloadData];
            }
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"weibo_msg", @"");
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.unreadList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *unreadCell = @"ONEUnreadCell";
    
    ONEUnreadCell *cell = [tableView dequeueReusableCellWithIdentifier:unreadCell];
    if (!cell) {
        cell = [[ONEUnreadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unreadCell];
    }
    ONEUnreadModel *model = self.unreadList[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ONEUnreadModel *model = self.unreadList[indexPath.row];
    return [ONEUnreadCell heightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ONEUnreadModel *model = self.unreadList[indexPath.row];
    NSString *articleId = model.weibo_id;
    if ([articleId length] > 0) {
        
        ONEArticleDetailController *detail = [[ONEArticleDetailController alloc] initWithArticleId:articleId groupId:self.groupId];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}





@end
