//
//  ONECommunityController.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONECommunityController.h"
#import "ONECommunityCell.h"
#import "EaseMessageReadManager.h"
#import "ONEArticleDetailController.h"
#import "ONESelectView.h"
#import "LZChatRefreshHeader.h"
#import "IDOQuanHeaderVeiw.h"
#import "ONEUnreadCommentController.h"
#import "CreateWeiBoViewController.h"
#import "ONEPaymentController.h"
#import "AiDuPlayerViewController.h"
#import "LZContactsDetailTableViewController.h"
#import "ONEGroupManager.h"
@interface ONECommunityController ()<UITableViewDelegate, UITableViewDataSource,ONECommunityCellDelegate,IDOQuanHeaderVeiwDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, strong) ONESelectView *selectView;
@property (nonatomic, strong) IDOQuanHeaderVeiw *unreadView;
@property (nonatomic, copy) NSString *group_uid;
@property (nonatomic, strong) ONEArticlesRequest *articlesRequest;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UIImageView *noDataView;
@end

@implementation ONECommunityController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.themeMap = @{
                                BGColorName:@"bg_white_color"
                                };
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight =0;
            _tableView.estimatedSectionFooterHeight =0;
        }
    }
    return _tableView;
}

- (NSMutableArray *)articles
{
    if (!_articles) {
        
        _articles = [NSMutableArray array];
    }
    return _articles;
}

- (UIImageView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_history"]];
        [_noDataView sizeToFit];
        [self.tableView addSubview:_noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.tableView);
        }];
    }
    return _noDataView;
}


- (instancetype)initWithGroup_uid:(NSString *)group_uid
{
    self = [super init];
    if (self) {
        _group_uid = group_uid;
        _articlesRequest = [[ONEArticlesRequest alloc] initWithGroupId:_group_uid];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"group_community", @"");
    [self setupUI];
    __weak typeof(self) weakself = self;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself loadData];
    }];

    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        weakself.articlesRequest.isMore = YES;
        NSInteger index = weakself.articlesRequest.index;
        if (index <= 0) {
            
            weakself.articlesRequest.index = [weakself.articles count] / 20 + 1;
        }
        
        [[ONEChatClient sharedClient] getArticleList:weakself.articlesRequest completion:^(ONEError *error, NSArray *list) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (!error) {
                    
                    if ([list count] == 0) {
                        
                        [weakself showHint:NSLocalizedString(@"articles_no_more", @"")];
                    } else {
                        
                        weakself.articlesRequest.index += 1;
                        [weakself.articles addObjectsFromArray:list];
                        [weakself.tableView reloadData];
                    }
                    [weakself.tableView.mj_footer endRefreshing];
                } else {
                    
                    [weakself.tableView.mj_footer endRefreshing];
                    [weakself showHint:NSLocalizedString(@"error", @"")];
                }
            });
        }];
    }];
}

- (void)loadData {
    
//    dispatch_group_t group = dispatch_group_create();
    
//    dispatch_group_enter(group);
    _articlesRequest.isMore = NO;
    _articlesRequest.index = 1;
    [self.articles removeAllObjects];
    __weak typeof(self) weakself = self;
    
    [[ONEChatClient sharedClient] getArticleList:_articlesRequest completion:^(ONEError *error, NSArray *list) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                if ([list count] == 0) {
                    [weakself.noDataView setHidden:NO];
                    [weakself.articles removeAllObjects];
                    [weakself.tableView reloadData];
                } else {
                    [weakself.noDataView setHidden:YES];
                    weakself.articlesRequest.index += 1;
                    [weakself.articles addObjectsFromArray:list];
                    [weakself.tableView reloadData];
                }
            } else {
                [weakself.noDataView setHidden:NO];
                [weakself showHint:NSLocalizedString(@"error", @"")];
                [weakself.tableView reloadData];
                
            }
            [self.tableView.mj_header endRefreshing];
        });
    }];

    
    NSString *groupId = [ONEGroupManager sharedInstance].groupId;
    
    [[ONEChatClient sharedClient] getUnreadMsgCount:groupId completion:^(ONEError *error, NSDictionary *map) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                NSDictionary *response = map;
                if ([response isEqual:[NSNull null]] || response == nil) {
                    weakself.unreadView = nil;
                    return;
                }
                NSString *avatar = nil;
                id avatar_url = response[@"avatar_url"];
                if (![avatar isEqual:[NSNull null]] && avatar_url != nil && [avatar_url isKindOfClass:[NSString class]]) {
                    avatar = (NSString *)avatar_url;
                }
                NSInteger unread_count = [response[@"noread_times"] integerValue];
                if (unread_count > 0) {
                    weakself.unreadView = [[IDOQuanHeaderVeiw alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 56)];
                    weakself.unreadView.delegate = self;
                    weakself.unreadView.image_url = [NSString stringWithFormat:@"%@%@",[ONEUrlHelper userAvatarPrefix],avatar];
                    weakself.unreadView.number = [NSString stringWithFormat:@"%ld",unread_count];
                    [weakself.tableView reloadData];
                } else {
                    weakself.unreadView = nil;
                }
            } else {
                weakself.unreadView = nil;
            }
        });
    }];
}

- (void)setupUI {
    
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    CGFloat selectViewHeight = [ONESelectView defaultHeight];
    [self.tableView setFrame:CGRectMake(0, selectViewHeight, self.view.width, self.view.height - 64 - selectViewHeight - iPhoneX_BOTTOM_HEIGHT)];
    [self.view addSubview:self.tableView];
    _selectView = [[ONESelectView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, selectViewHeight)];
    _selectView.themeMap = @{
                                BGColorName:@"bg_white_color"
                            };
    __weak typeof(self) weakself = self;
    _selectView.chooseItemBlock = ^(NSDictionary *dict) {
        if (dict == nil) {
            return;
        }
        [weakself handleArticleRequest:dict];
    };
    [self.view addSubview:_selectView];
    [self showCreateArticleButton];
}

- (void)showCreateArticleButton
{
    _createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_createButton setImage:[UIImage imageNamed:@"shuoshuotubiao"] forState:UIControlStateNormal];
    [_createButton sizeToFit];
    [_createButton addTarget:self action:@selector(createArticle) forControlEvents:UIControlEventTouchUpInside];
    [_createButton setFrame:CGRectMake(KScreenW - _createButton.width - 20, KScreenH - 200 - _createButton.height, _createButton.width, _createButton.height)];
    [self.view addSubview:_createButton];
    [self.view bringSubviewToFront:_createButton];
}

- (void)createArticle {
    
    CreateWeiBoViewController *createWeibo = [[CreateWeiBoViewController alloc] init];
    __weak typeof(self)weakself = self;
    createWeibo.needRefreshBlock = ^{
        
        [weakself loadData];
        
    };
    [self.navigationController pushViewController:createWeibo animated:YES];
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_createButton.y < KScreenH) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [_createButton setY:KScreenH];
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    [UIView animateWithDuration:0.3 animations:^{
        [_createButton setY:KScreenH - 200 - _createButton.height];
    }];
}

#pragma mark - UITableViewDelegate、UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return self.articles.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return _unreadView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return _unreadView ? 56 : 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return nil;
    }
    static NSString *cellIdentifier = @"ArticleCell";
    ONECommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ONECommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.themeMap = @{
                      BGColorName:@"bg_white_color"
                      };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.articles count] > 0) {
        ONEArticle *article = self.articles[indexPath.row];
        cell.delegate = self;
        cell.model = article;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.articles count] > 0) {
        ONEArticle *article = self.articles[indexPath.row];
        return [ONECommunityCell cellHeightForArticleModel:article];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ONEArticle *article = nil;
    if ([self.articles count] > 0) {
       article = self.articles[indexPath.row];
    } else {
        return;
    }
    if ([article.is_pay isEqualToString:@"0"]) {
        __weak typeof(self)weakself = self;
        ONEArticleDetailController *detail = [[ONEArticleDetailController alloc] initWithArticle:article];
        detail.articleUpdated = ^(ONEArticle *oldArticle) {
            
            [[ONEChatClient sharedClient] getArticleDetail:oldArticle.article_id completion:^(ONEError *error, ONEArticle *article) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error && article) {
                        [weakself refreshUIAfterSomeAction:article];
                    }
                });
            }];

        };
        [self.navigationController pushViewController:detail animated:YES];
    } else if ([article.is_pay isEqualToString:@"1"]) {
        
        if ([article.user_is_pay isEqualToString:@"0"]) {
            
            ONEPaymentController *payment = [[ONEPaymentController alloc] initWithAssetCode:article.asset_code amount:article.reward_price];
            payment.articleId = article.article_id;
            payment.groupId = article.group_uid;
            __weak typeof(self) weakself = self;
            payment.articlePayed = ^(ONEArticle *article) {
                [weakself refreshUIAfterSomeAction:article];
            };
            [self.navigationController pushViewController:payment animated:YES];
        } else {
            
            ONEArticleDetailController *detail = [[ONEArticleDetailController alloc] initWithArticle:article];
            __weak typeof(self)weakself = self;
            detail.articleUpdated = ^(ONEArticle *oldArticle) {
                
                __strong ONECommunityController *strongself = weakself;
                
                [[ONEChatClient sharedClient] getArticleDetail:oldArticle.article_id completion:^(ONEError *error, ONEArticle *article) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!error && article) {
                            [strongself refreshUIAfterSomeAction:article];
                        }
                    });
                }];
            };
            [weakself.navigationController pushViewController:detail animated:YES];
        }
        
    }
    

}

#pragma mark - ONECommunityCellDelegate


- (void)avatarViewClicked:(ONEArticle *)model
{
    NSString *accountId = model.account_id;
    if ([accountId length] == 0 || [accountId isEqualToString:[ONEChatClient homeAccountId]]) {
        return;
    }
    LZContactsDetailTableViewController *contact = [[LZContactsDetailTableViewController alloc] initWithBuddy:accountId];
    contact.canSendMsg = YES;
    [self.navigationController pushViewController:contact animated:YES];
}

- (void)likeButtonClicked:(ONEArticle *)model
{
    if (!model) {
        return;
    }
    __weak typeof(self)weakself = self;
    
    [[ONEChatClient sharedClient] likeArticle:model groupId:model.group_uid completion:^(ONEError *error, ONEArticle *newArticle) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                [weakself refreshUIAfterSomeAction:newArticle];
            } else {
                if (error.errorCode == ONEErrorCommunityPayValue) {
                    [weakself showHint:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"to_pay_a_oneluck", @""), error.errorDescription]];
                    [weakself refreshUIAfterSomeAction:newArticle];

                } else if (error.errorCode == ONEErrorCommunityOpeNeedAssetButNotEnough) {
                    [weakself showHint:NSLocalizedString(@"not_enough_money_todo", @"")];
                } else {
                    [weakself showHint:NSLocalizedString(@"error", @"")];
                }
            }
        });
    }];
}

- (void)dislikeButtonClicked:(ONEArticle *)model
{
    if (!model) {
        return;
    }
    __weak typeof(self)weakself = self;
    
    [[ONEChatClient sharedClient] dislikeArticle:model groupId:model.group_uid completion:^(ONEError *error, ONEArticle *newArticle) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                
                [weakself refreshUIAfterSomeAction:newArticle];
            } else {
                
                if (error.errorCode == ONEErrorCommunityPayValue) {
                    
                    [weakself showHint:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"to_pay_a_oneluck", @""), error.errorDescription]];
                    [weakself refreshUIAfterSomeAction:newArticle];

                } else if (error.errorCode == ONEErrorCommunityOpeNeedAssetButNotEnough) {
                    [weakself showHint:NSLocalizedString(@"not_enough_money_todo", @"")];
                } else {
                    [weakself showHint:NSLocalizedString(@"error", @"")];
                }
            }
        });
    }];
}

- (void)refreshUIAfterSomeAction:(ONEArticle *)article
{
    if (article.article_id == nil) {
        return;
    }
    NSString *weibo_id = article.article_id;
    __block NSInteger index = -1;
    [self.articles enumerateObjectsUsingBlock:^(ONEArticle *model, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([model.article_id isEqualToString:weibo_id]) {

            index = idx;
            *stop = YES;
        }
    }];
    if (index >= 0 && index < [self.articles count]) {
        

        [self.articles replaceObjectAtIndex:index withObject:article];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:indexPath, nil];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)imageSelected:(ONEArticle *)model index:(NSUInteger)index
{
    
    if ([model.is_pay isEqualToString:@"1"] && [model.user_is_pay isEqualToString:@"0"]) {
        
        [self gotoPaymentVCWithArticle:model];
    } else {
        
        NSMutableArray *images = [model.img_list_max mutableCopy];
        if (index < 0 || index > [images count] ) {
            
            return;
        }
        NSMutableArray *formalImages = [NSMutableArray array];
        for (NSString *obj in images) {
            if ([obj length] > 0) {
                [formalImages addObject:[obj formalCommunityImageUrl]];
            }
        }
        [[EaseMessageReadManager defaultManager] showBrowserWithImages:formalImages atIndex:index];
    }
    
}

- (void)moreButtonClicked:(ONEArticle *)model
{
//    // 更多
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    "article_set_essence" = "设置精华";
//    "article_report" = "举报";

    __weak typeof(self)weakself = self;
    UIAlertAction *report = [UIAlertAction actionWithTitle:NSLocalizedString(@"report", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 举报
        
        [[ONEChatClient sharedClient] reportArticle:model.article_id groupId:model.group_uid completion:^(ONEError *error) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (!error) {
                    [weakself showHint:NSLocalizedString(@"article_report_success", @"")];
                } else {
                    if (error.errorCode == ONEErrorHasReported) {
                        [weakself showHint:NSLocalizedString(@"article_has_reported", @"")];
                    } else {
                        [weakself showHint:NSLocalizedString(@"error", @"")];
                    }
                }
            });
        }];
        
    }];
    
    UIAlertAction *essence = [UIAlertAction actionWithTitle:NSLocalizedString(@"article_set_essence", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 设置精华
        
        [[ONEChatClient sharedClient] essenceArticle:model groupId:model.group_uid completion:^(ONEError *error, ONEArticle *article) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (!error) {
                    [weakself showHint:NSLocalizedString(@"article_essence_success", @"")];
                    if (article) {
                        
                        [weakself refreshUIAfterSomeAction:article];
                    }
                } else {
                    [weakself showHint:NSLocalizedString(@"error", @"")];
                }

            });
        }];
    }];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_delete", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[ONEChatClient sharedClient] deleteArticle:model.article_id groupId:model.group_uid completion:^(ONEError *error) {
           
            if (!error) {
                
                [weakself refreshUIAfterArticleDelete:model];
            } else {
                [weakself showHint:NSLocalizedString(@"error", @"")];
            }

        }];
    }];
    // 禁言
    UIAlertAction *banAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_banned_to_post", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *memberId = model.account_id;
        if ([memberId length] == 0) {
            return;
        }
        [[ONEChatClient sharedClient] muteMember:memberId groupId:[ONEGroupManager sharedInstance].groupId completion:^(ONEError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    [weakself showHint:NSLocalizedString(@"mute_member_success", @"")];
                } else {
                    if (error.errorCode == ONEErrorInsufficientPrivilege) {
                        [weakself showHint:NSLocalizedString(@"limits_of_authority", @"")];
                    } else {
                        [weakself showHint:NSLocalizedString(@"error", @"")];
                    }
                }
                
            });
        }];

    }];
    // 加入黑名单
    UIAlertAction *blackAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_add_blacklist", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *memberId = model.account_id;
        if ([memberId length] == 0) {
            return;
        }
        [[ONEChatClient sharedClient] addMemberToAdminList:memberId groupId:[ONEGroupManager sharedInstance].groupId completion:^(ONEError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (!error) {
                    [weakself showHint:NSLocalizedString(@"add_member_to_blacklist_success", @"")];
                } else {
                    [weakself showHint:NSLocalizedString(@"error", @"")];
                }
            });
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 取消
    }];
    
    BOOL isCreator = NO;
    NSString *accountName = model.account_name;
    if ([accountName length] > 0 && [accountName isEqualToString:[ONEChatClient homeAccountName]]) {
        isCreator = YES;
    }
    GroupRoleType roleType = [ONEGroupManager sharedInstance].roleType;
    
    [alert addAction:report];
    if (roleType == GroupRoleType_Admin || roleType == GroupRoleType_Owner) {
        [alert addAction:essence];
        [alert addAction:banAction];
        [alert addAction:blackAction];
    }
    
    if (isCreator || roleType == GroupRoleType_Owner) {
        [alert addAction:delete];
    }
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)refreshUIAfterArticleDelete:(ONEArticle *)article
{
    if (!article) {
        return;
    }
    __block NSInteger index = -1;
    [self.articles enumerateObjectsUsingBlock:^(ONEArticle *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.article_id isEqualToString:article.article_id]) {
            
            index = idx;
            *stop = YES;
        }
    }];
    if (index >= 0 && index < [self.articles count]) {
        
        [self.articles removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)videoClicked:(ONEArticle *)model
{
    if ([model.is_pay isEqualToString:@"1"] && [model.user_is_pay isEqualToString:@"0"]) {

        [self gotoPaymentVCWithArticle:model];
    } else {
        NSString *videoUrl = model.video_bofang_url;
        if ([videoUrl length] > 0) {
            AiDuPlayerViewController *playerVC = [[AiDuPlayerViewController alloc] init];
            playerVC.videoURL = [NSString stringWithFormat:@"%@",videoUrl];
            playerVC.nickName = @"123";
            YKPlayNaviController *nav = [[YKPlayNaviController alloc] initWithRootViewController:playerVC];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)gotoPaymentVCWithArticle:(ONEArticle *)article
{
    ONEPaymentController *payment = [[ONEPaymentController alloc] initWithAssetCode:article.asset_code amount:article.reward_price];
    payment.articleId = article.article_id;
    payment.groupId = article.group_uid;
    __weak typeof(self) weakself = self;
    payment.articlePayed = ^(ONEArticle *article) {
        [weakself refreshUIAfterSomeAction:article];
    };
    [self.navigationController pushViewController:payment animated:YES];
}

#pragma mark - IDOQuanHeaderViewDelegate

- (void)tableHeaderViewDidClicked
{
    NSString *groupId = [ONEGroupManager sharedInstance].groupId;
    ONEUnreadCommentController *unreadVC = [[ONEUnreadCommentController alloc] initWithGroupId:groupId];
    [self.navigationController pushViewController:unreadVC animated:YES];
    _unreadView = nil;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 设置请求model

- (void)handleArticleRequest:(NSDictionary *)dict
{
    NSString *type = dict[@"type"];

    if ([type isEqualToString:@"left"]) {
        NSInteger source_type = [dict[@"cmd"] integerValue];
        _articlesRequest.sourceType = source_type;
    } else if ([type isEqualToString:@"right"]) {
        NSInteger sort_method = [dict[@"cmd"] integerValue];
        _articlesRequest.sortMethod = sort_method;
    }
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc
{
    
}


@end
