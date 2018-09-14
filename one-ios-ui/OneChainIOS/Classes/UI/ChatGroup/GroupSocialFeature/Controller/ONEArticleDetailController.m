//
//  ONEArticleDetailController.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEArticleDetailController.h"
#import "ONECommunityCell.h"
#import "ONELikeToolBar.h"
#import "ONECommentCell.h"
#import "ONERewardCell.h"
#import "EaseChatToolbar.h"
#import "EaseMessageReadManager.h"
#import "ONEPaymentController.h"
#import "AiDuPlayerViewController.h"
#import "YKPlayNaviController.h"
@interface ONEArticleDetailController ()<UITableViewDelegate, UITableViewDataSource, ONELikeToolBarDelegate, EMChatToolbarDelegate, ONECommunityCellDelegate>

@property (nonatomic, strong) ONEArticle *article;
@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) ONELikeToolBar *likeToolBar;
@property (nonatomic, strong) NSMutableArray *rewards;
@property (nonatomic, strong) NSMutableArray *datasources;

@property (nonatomic, strong) ONEComment *selectedComment;

@property (nonatomic, strong) EaseChatToolbar *chatToolBar;

@property (nonatomic) BOOL articleHasUpdated;

@property (nonatomic) BOOL respondToComment;

@property (nonatomic, strong) dispatch_group_t articleGroup;

@property (nonatomic, strong) NSMutableArray *articles;

@property (nonatomic, copy) NSString *currentGroupId;

@end

@implementation ONEArticleDetailController

- (instancetype)initWithArticle:(ONEArticle *)article
{
    self = [super init];
    if (self) {
        _article = article;
        _selectedComment = nil;
        _articleHasUpdated = NO;
        _respondToComment = NO;
        _currentGroupId = article.group_uid;
    }
    return self;
}

- (instancetype)initWithArticleId:(NSString *)articleId groupId:(NSString *)groupId
{
    self = [super init];
    if (self) {
        _article = nil;
        _articleId = articleId;
        _selectedComment = nil;
        _articleHasUpdated = NO;
        _respondToComment = NO;
        _currentGroupId = groupId;
    }
    return self;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, self.view.frame.size.height - 84 - [EaseChatToolbar defaultHeight] - iPhoneX_BOTTOM_HEIGHT) style:UITableViewStylePlain];
//        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.themeMap = @{
                                BGColorName:@"bg_white_color",
                                TableSepColorName:@"conversation_line_color"
                                };
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight =0;
            _tableView.estimatedSectionFooterHeight =0;
        }
    }
    return _tableView;
}

- (NSMutableArray *)comments
{
    if (!_comments) {
        
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (NSMutableArray *)rewards
{
    if (!_rewards) {
        
        _rewards = [NSMutableArray array];
    }
    return _rewards;
}

- (NSMutableArray *)datasources
{
    if (!_datasources) {
        
        _datasources = [NSMutableArray array];
    }
    return _datasources;
}

- (ONELikeToolBar *)likeToolBar
{
    if (!_likeToolBar) {
        
        _likeToolBar = [[ONELikeToolBar alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 45)];
//        _likeToolBar.backgroundColor = [UIColor whiteColor];
        _likeToolBar.themeMap = @{
                                  BGColorName:@"bg_white_color"
                                  };
        _likeToolBar.delegate = self;
        [_likeToolBar reloadSubviewsWithArticle:_article];
        [(UIButton *)(_likeToolBar.commentButton) setSelected:YES];
    }
    return _likeToolBar;
}

- (NSMutableArray *)articles
{
    if (!_articles) {
        
        _articles = [NSMutableArray array];
    }
    return _articles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"article_detail", @"");
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
//    self.view.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
    [self setupChatToolBar];
    [self loadData];
    if (_article) {
        [self.articles removeAllObjects];
        [self.articles addObject:_article];
        [self.tableView reloadData];
    } else {
        __weak typeof(self)weakself = self;
        [self.articles removeAllObjects];
        
        [[ONEChatClient sharedClient] getArticleDetail:_articleId completion:^(ONEError *error, ONEArticle *article) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error && article) {
                    
                    weakself.article = article;
                    [weakself.articles addObject:article];
                    [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [weakself.likeToolBar reloadSubviewsWithArticle:article];
                }
            });
        }];
    }
    [self setupForDismissKeyboard];
    
}

- (void)setupChatToolBar
{
    CGFloat chatbarHeight = [EaseChatToolbar defaultHeight];
    EMChatToolbarType barType = EMChatToolBarTypeComment;
    self.chatToolBar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight - iPhoneX_BOTTOM_HEIGHT, self.view.frame.size.width, chatbarHeight) type:barType];
    [self.chatToolBar.lineView setHidden:YES];
    self.chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.chatToolBar.delegate = self;
    self.chatToolBar.inputViewLeftItems = nil;
    UIButton *rewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rewardButton setImage:[UIImage imageNamed:@"reward_button"] forState:UIControlStateNormal];
    [rewardButton addTarget:self action:@selector(rewardArticleAction) forControlEvents:UIControlEventTouchUpInside];
    EaseChatToolbarItem *item = [[EaseChatToolbarItem alloc] initWithButton:rewardButton withView:nil];
    self.chatToolBar.inputViewRightItems = @[item];
    self.chatToolBar.inputTextView.placeHolder = NSLocalizedString(@"reply", @"");
    [self.view addSubview:self.chatToolBar];
}


- (void)loadRewardList
{
    dispatch_group_enter(_articleGroup);
    NSString *articleId = _article ? _article.article_id : _articleId;
    
    [[ONEChatClient sharedClient] getArticleRewardList:articleId groupId:self.currentGroupId completion:^(ONEError *error, NSArray *list) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self.rewards removeAllObjects];
                [self.rewards addObjectsFromArray:list];
            }
            dispatch_group_leave(_articleGroup);

        });
    }];
}

- (void)loadCommentList
{
    
    dispatch_group_enter(_articleGroup);
    NSString *articleId = _article ? _article.article_id : _articleId;
    
    [[ONEChatClient sharedClient] getCommentListFromArticle:articleId group:self.currentGroupId completion:^(ONEError *error, NSArray *list) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error && [list count] > 0) {
                
                [self.comments addObjectsFromArray:list];
            }
            dispatch_group_leave(_articleGroup);
        });
        
    }];
}

- (void)loadData {
    
    [self.datasources removeAllObjects];
    [self.comments removeAllObjects];
    _articleGroup = dispatch_group_create();
    [self loadCommentList];
    [self loadRewardList];
    dispatch_group_notify(_articleGroup, dispatch_get_main_queue(), ^{
        
        [self.datasources addObjectsFromArray:self.comments];
        [self.tableView reloadData];
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.articles.count;
    } else {
        return self.datasources.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [ONECommunityCell cellHeightForArticleModel:_article isShowAll:YES];
    } else {
        
        id model = self.datasources[indexPath.row];
        if ([model isKindOfClass:[ONEComment class]]) {
            ONEComment *comment = (ONEComment *)model;
            return [ONECommentCell commentCellHeightWithComment:comment];
        } else {
            
            return 60;
        }
    }
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return self.likeToolBar;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *articleCell = @"ONEArticleCell";
        ONECommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCell];
        if (!cell) {
            cell = [[ONECommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:articleCell];
        }
        ONEArticle *article = self.articles[indexPath.row];
        cell.isShowAll = YES;
        cell.delegate = self;
        cell.model = article;
        return cell;
    } else {
        
        id model = self.datasources[indexPath.row];
        if ([model isKindOfClass:[ONEComment class]]) {
            static NSString *cellIdentifier = @"ONECommentCell";
            ONECommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[ONECommentCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:cellIdentifier];
            }
            ONEComment *comment = (ONEComment *)model;
            cell.comment = comment;
            __weak typeof(self) weakself = self;
            cell.commentBeLiked = ^(ONEComment *comment) {
                [weakself likeComment:comment];
            };
            return cell;
        } else if ([model isKindOfClass:[ONEReward class]]) {
            
            static NSString *re_cellIdentifier = @"ONERewardCell";
            ONERewardCell *rewardCell = [tableView dequeueReusableCellWithIdentifier:re_cellIdentifier];
            if (!rewardCell) {
                rewardCell = [[ONERewardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:re_cellIdentifier];
            }
            ONEReward *reward = (ONEReward *)model;
            rewardCell.reward = reward;
            return rewardCell;
        }
        return nil;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
        id model = self.datasources[indexPath.row];
        if ([model isKindOfClass:[ONEComment class]]) {
            
            ONEComment *comment = (ONEComment *)model;
            _selectedComment = comment;
            [self showActionSheet];
        }
    }
}

- (void)showActionSheet
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *respondAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"reply", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       // 弹出键盘
        [self commentToSelectedWeiboComment];
    }];
    UIAlertAction *copyAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_copy", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *string = _selectedComment.content;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if ([string length] > 0) {
            [pasteboard setString:string];
            [self showHint:NSLocalizedString(@"copied_to_clipboard", @"")];
        }
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_delete", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self deleteSelectedComment];
    }];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        _selectedComment = nil;
    }];
    [alertVC addAction:respondAc];
    [alertVC addAction:copyAc];
    if (_selectedComment && [_selectedComment.account_name isEqualToString:[ONEChatClient homeAccountName]]) {
        [alertVC addAction:deleteAction];
    }
    [alertVC addAction:cancelAc];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - ONELikeToolBarDelegate

- (void)admireButtonSelected
{
    @synchronized(self) {

        [self.datasources removeAllObjects];
        [self.datasources addObjectsFromArray:self.rewards];
        [self.tableView reloadData];

    }
}

- (void)commentButtonSelected
{
    @synchronized(self) {
        if ([self.datasources count] > 0) {

        }
        [self.datasources removeAllObjects];
        [self.datasources addObjectsFromArray:self.comments];
        [self.tableView reloadData];
    }
}

- (void)updateAfterLikeAction:(ONEArticle *)newArticle
{
    if (newArticle == nil) {
        return;
    }
    _article = newArticle;
    [self.likeToolBar reloadSubviewsWithArticle:_article];
    self.articleHasUpdated = YES;
}

- (void)likeButtonClicked
{
    __weak typeof(self)weakself = self;
    
    [[ONEChatClient sharedClient] likeArticle:_article groupId:self.currentGroupId completion:^(ONEError *error, ONEArticle *newArticle) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                
                [weakself updateAfterLikeAction:newArticle];
            } else {
                
                if (error.errorCode == ONEErrorCommunityPayValue) {
                    
                    [weakself showHint:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"to_pay_a_oneluck", @""), error.errorDescription]];
                    [weakself updateAfterLikeAction:newArticle];
                } else if (error.errorCode == ONEErrorCommunityOpeNeedAssetButNotEnough) {
                    [weakself showHint:NSLocalizedString(@"not_enough_money_todo", @"")];
                } else {
                    [weakself showHint:NSLocalizedString(@"error", @"")];
                }
            }
        });
    }];
}

- (void)dislikeButtonClicked
{
    __weak typeof(self)weakself = self;
    
    [[ONEChatClient sharedClient] dislikeArticle:_article groupId:self.currentGroupId completion:^(ONEError *error, ONEArticle *newArticle) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                
                [weakself updateAfterLikeAction:newArticle];
            } else {
                
                if (error.errorCode == ONEErrorCommunityPayValue) {
                    
                    [weakself showHint:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"to_pay_a_oneluck", @""), error.errorDescription]];
                    [weakself updateAfterLikeAction:newArticle];
                } else if (error.errorCode == ONEErrorCommunityOpeNeedAssetButNotEnough) {
                    [weakself showHint:NSLocalizedString(@"not_enough_money_todo", @"")];
                } else {
                    [weakself showHint:NSLocalizedString(@"error", @"")];
                }
            }
        });
    }];
}



- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        
        if (self.articleHasUpdated) {
            !_articleUpdated ?: _articleUpdated(_article);
        }
    }
}

- (void)dealloc
{
    
}

#pragma mark - EaseChatToolBarDelegate

- (void)didSendText:(NSString *)text
{
    
    if (_respondToComment) {
        
        [[ONEChatClient sharedClient] commentToArticleComment:_selectedComment.weibo_id toAccount:_selectedComment.account_name commentId:_selectedComment.commentId comment:text groupId:self.currentGroupId completion:^(ONEError *error) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!error) {
                    [self loadData];
                    NSInteger comment_count = [_article.comment_count integerValue];
                    comment_count ++;
                    _article.comment_count = [NSString stringWithFormat:@"%ld",comment_count];
                    [self.likeToolBar reloadSubviewsWithArticle:_article];
                    [self.likeToolBar changeToComment:YES];
                    self.articleHasUpdated = YES;
                }
            });
        }];

    } else {
        
        [[ONEChatClient sharedClient] commentArticle:_article.article_id from:_article.account_name comment:text groupId:self.currentGroupId completion:^(ONEError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (!error) {
                    [self loadData];
                    NSInteger comment_count = [_article.comment_count integerValue];
                    comment_count ++;
                    _article.comment_count = [NSString stringWithFormat:@"%ld",comment_count];
                    [self.likeToolBar reloadSubviewsWithArticle:_article];
                    [self.likeToolBar changeToComment:YES];
                    self.articleHasUpdated = YES;
                } else {
                    [self showHint:NSLocalizedString(@"error", @"")];

                }
            });
        }];
    }
    [self.view endEditing:YES];
}

#pragma mark - ONECommunityCellDelegate

- (void)imageSelected:(ONEArticle *)model index:(NSUInteger)index
{
    NSMutableArray *images = [model.img_list_max mutableCopy];
    if (index <= 0 || index > [images count] ) {
        
        return;
    }
    [images enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [images replaceObjectAtIndex:idx withObject:[obj formalCommunityImageUrl]];
    }];
    
    [[EaseMessageReadManager defaultManager] showBrowserWithImages:images atIndex:index];
}

- (void)videoClicked:(ONEArticle *)model
{
    NSString *videoUrl = model.video_bofang_url;
    if ([videoUrl length] > 0) {
        AiDuPlayerViewController *playerVC = [[AiDuPlayerViewController alloc] init];
        playerVC.videoURL = [NSString stringWithFormat:@"%@",videoUrl];
        playerVC.nickName = @"123";
        YKPlayNaviController *nav = [[YKPlayNaviController alloc] initWithRootViewController:playerVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - CommentCell Action

- (void)likeComment:(ONEComment *)comment
{
    
    [[ONEChatClient sharedClient] likeComment:comment groupId:self.currentGroupId completion:^(ONEError *error, NSDictionary *map) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error && [map count] > 0) {
                
                NSInteger is_like = [[map objectForKey:@"is_like"] integerValue];
                id likes_count = [map objectForKey:@"likes_count"];
                NSInteger like_count = 0;
                if (![likes_count isEqual:[NSNull null]] && likes_count != nil) {
                    like_count = [likes_count integerValue];
                }
                NSInteger comment_id = [[map objectForKey:@"comment_id"] integerValue];
                if ([[NSString stringWithFormat:@"%ld",comment_id] isEqualToString:comment.commentId]) {
                    
                    comment.is_like = [NSString stringWithFormat:@"%ld",is_like];
                    comment.likes_count = [NSString stringWithFormat:@"%ld",like_count];
                    [self refreshComment:comment];
                }
            }
        });
    }];
}

- (void)refreshComment:(ONEComment *)comment
{
    __block NSInteger index = -1;
    [self.comments enumerateObjectsUsingBlock:^(ONEComment *comm, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([comm.commentId isEqualToString:comment.commentId]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index >= 0 && index < [self.datasources count]) {
        
        [self.comments replaceObjectAtIndex:index withObject:comment];
        if (self.datasources.count == self.comments.count) {
            
            [self.datasources replaceObjectAtIndex:index withObject:self.comments[index]];
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:indexPath, nil];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)deleteSelectedComment
{
    if (_selectedComment) {
        
        [[ONEChatClient sharedClient] deleteComment:_selectedComment groupId:self.currentGroupId completion:^(ONEError *error, NSString *commentId) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    
                    if ([commentId isEqualToString:_selectedComment.commentId]) {
                        
                        NSInteger index = [self getCommentIndex:commentId];
                        if (index >= 0 && index < [self.comments count]) {
                            
                            if (self.datasources.count == self.comments.count) {
                                _articleHasUpdated = YES;
                                [self.comments removeObjectAtIndex:index];
                                [self.datasources removeObjectAtIndex:index];
                                NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
                                [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
                                NSInteger count = [_article.comment_count integerValue];
                                count --;
                                _article.comment_count = [NSString stringWithFormat:@"%ld",count];
                                [self.likeToolBar reloadSubviewsWithArticle:_article];
                                _selectedComment = nil;
                            }
                        }
                    }
                } else {
                    [self showHint:NSLocalizedString(@"error", @"")];
                }
            });
        }];
    }
}

- (NSInteger)getCommentIndex:(NSString *)commentId
{
    if (!commentId) {
        return -1;
    }
    __block NSInteger index = -1;
    [self.comments enumerateObjectsUsingBlock:^(ONEComment *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.commentId isEqualToString:commentId]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (void)commentToSelectedWeiboComment
{
    if (_selectedComment) {
        
        _respondToComment = YES;
        NSString *placeHolder = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"reply", @"Reply"),_selectedComment.nickname];
        self.chatToolBar.inputTextView.placeHolder = placeHolder;
        [self.chatToolBar.inputTextView becomeFirstResponder];
        
    }
}

- (void)didChatToolBarClose
{
    if (_respondToComment) {
        
        self.chatToolBar.inputTextView.placeHolder = NSLocalizedString(@"reply_weibo", @"");
        _respondToComment = NO;
    }
}

#pragma mark - 打赏

- (void)rewardArticleAction
{
    [self.view endEditing:YES];
    ONEPaymentController *payment = [[ONEPaymentController alloc] init];
    payment.articleId = _article.article_id;
    payment.groupId = _article.group_uid;
    __weak typeof(self)weakself = self;
    payment.articleHasRewarded = ^(NSString *articleId) {
        if (![articleId isEqualToString:weakself.article.article_id]) {
            return;
        }
        NSInteger rewardCount = [weakself.article.reward_count integerValue];
        rewardCount++;
        weakself.article.reward_count = [NSString stringWithFormat:@"%ld",rewardCount];
        [weakself.likeToolBar reloadSubviewsWithArticle:weakself.article];
        [weakself.likeToolBar changeToComment:NO];
        [(UIButton *)(weakself.likeToolBar.commentButton) setSelected:NO];
        __strong typeof(weakself)strongSelf = self;
        
        [[ONEChatClient sharedClient] getArticleRewardList:_article.article_id groupId:_article.group_uid completion:^(ONEError *error, NSArray *list) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    [strongSelf.rewards removeAllObjects];
                    [strongSelf.rewards addObjectsFromArray:list];
                    [strongSelf.datasources removeAllObjects];
                    [strongSelf.datasources addObjectsFromArray:strongSelf.rewards];
                    
                    [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            });
        }];
    };
    [self.navigationController pushViewController:payment animated:YES];
}

@end
