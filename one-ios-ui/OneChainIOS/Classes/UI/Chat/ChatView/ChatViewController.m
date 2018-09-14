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

#import "ChatViewController.h"

#import "ChatGroupDetailViewController.h"
#import "UserProfileManager.h"
#import "ContactListSelectViewController.h"
#import "EMChooseViewController.h"
#import "ContactSelectionViewController.h"
#import "LZContactsDetailTableViewController.h"
#import "NetworkStatusController.h"
#import "ONEPaymentController.h"
// 本地群消息数限制
#define kGroup_max_msg_count 6000
// 剩余群消息数
#define kGroup_left_min_msg_count 1000

@interface ChatViewController ()<UIAlertViewDelegate, EMChooseViewDelegate, UIActionSheetDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    UIMenuItem *_likeMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;

@property (nonatomic, strong) id<IMessageModel>pressedModel;

@property (nonatomic, strong) UIButton *tipButton;

@property (nonatomic, strong) ONEChatGroup *oneGroup;

//@property (nonatomic, strong) UIView *coverView;
//@property (nonatomic, strong) RedpacketView *redpacketView;

@end


@implementation ChatViewController


- (UIButton *)tipButton
{
    if (!_tipButton) {
        
        _tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_tipButton setBackgroundColor:[UIColor whiteColor]];
        _tipButton.themeMap = @{
                                BGColorName:@"bg_white_color",
                                TextColorName:@"conversation_title_color"
                                };
        _tipButton.frame = self.chatToolbar.frame;
        [_tipButton setTitle:NSLocalizedString(@"pls_add_friend", @"") forState:UIControlStateNormal];
        [_tipButton addTarget:self action:@selector(gotoPersonInfo) forControlEvents:UIControlEventTouchUpInside];
//        [_tipButton setTitleColor:DEFAULT_BLACK_COLOR forState:UIControlStateNormal];
        _tipButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:14.f];
    }
    return _tipButton;
}

- (void)gotoPersonInfo
{
    LZContactsDetailTableViewController *detail = [[LZContactsDetailTableViewController alloc] initWithBuddy:self.conversation.conversationId];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [self _setupBarButtonItem];

    self.tableView.themeMap = @{
                                BGColorName:@"bg_normal_color"
                                };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTitle:) name:NOTIFICATION_GROUPSUBJECT_UPDATED object:nil];
    // 根据是否为好友更新页面
    [self updateChatterStatus];
}

- (void)updateChatterStatus
{
    if (self.conversation.type == ONEConversationTypeChat) {
        
        NSString *chatter = self.conversation.conversationId;
        if (![chatter isAccountId]) {
            chatter = [ONEChatClient accountIdWithName:chatter];
        }
        if (chatter) {
            
            [[ONEChatClient sharedClient] getFriendInfo:chatter completion:^(ONEError *error, WSAccountInfo *accountInfo) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error && accountInfo) {
                        if (accountInfo.type != AccountTypeFriend) {
                            
                            self.chatToolbar.hidden = YES;
                            [self.view addSubview:self.tipButton];
                        }
                    }
                });
            }];
        }
    } else {
        
        long msgCount = [self.conversation allMessagesCount];
        if (msgCount > kGroup_max_msg_count) {
            
            long needDeleteCount = msgCount - kGroup_left_min_msg_count;
            [self.conversation deleteExceedMessages:needDeleteCount];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_needLoopGroupMsg) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_TABBAR_NOTSELECTED object:nil];
    }

}


- (void)reloadTitle:(NSNotification *)notification
{
    [self updateGroupTitle];

}


- (void)dealloc
{

}


- (void)clearAction
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"SHOWLINK_%@",[ONEChatClient homeAccountId]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self showHint:@"OK"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.conversation.type == ONEConversationTypeGroupChat) {
        [self updateGroupTitle];
    }
}



#define KCHECK_BTN_TITLE_SIZE 14.f
- (void)initNodeCheck
{
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:KCHECK_BTN_TITLE_SIZE];
    [checkBtn setFrame:CGRectMake(0, 0, 80,40)];
    checkBtn.themeMap = @{
                          TextColorName:@"common_text_color"
                          };
    [checkBtn setTitle:NSLocalizedString(@"switch_service_node", @"") forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkNode:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)checkNode:(UIButton *)sender {
    
    NetworkStatusController *networkStatus = [[NetworkStatusController alloc] init];
    [self.navigationController pushViewController:networkStatus animated:YES];
}

- (void)_setupBarButtonItem
{
    //单聊
    if (self.conversation.type == ONEConversationTypeChat) {

        [self initNodeCheck];
    }
    else{//群聊
        
        [self updateGroupTitle];
    
        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        detailButton.accessibilityIdentifier = @"detail";
        [detailButton setImage:THMImage(@"group_detail_icon") forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    }
    
}


- (void)updateGroupTitle
{
    _oneGroup = [[ONEChatClient sharedClient] groupChatWithGroupId:self.conversation.conversationId];
    
    self.title = [NSString stringWithFormat:@"%@(%lu)",_oneGroup.name,_oneGroup.memberSize];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}

#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}
#pragma mark - 头像点击、长按
- (void)messageViewController:(EaseMessageViewController *)viewController
   didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    if (messageModel.isSender) return;
    if (self.conversation.type == ONEConversationTypeChat) {
        
        LZContactsDetailTableViewController *detailVC = [[LZContactsDetailTableViewController alloc] initWithBuddy:self.conversation.conversationId];
        detailVC.canSendMsg = NO;
        kWeakSelf
        detailVC.remarkChanged = ^{
            [weakself.dataArray removeAllObjects];
            [weakself.messsagesSource removeAllObjects];
            [weakself tableViewDidTriggerHeaderRefresh];
        };
        
        detailVC.deleteAction = ^(NSString *account_name) {
            
            [weakself updateChatterStatus];
        };
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}





#pragma mark - EaseMessageViewControllerDataSource

/** 构造MessageModel */
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(ONEMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.nickname];
    if (profileEntity) {
        model.avatarURLPath = profileEntity.imageUrl;
        model.nickname = profileEntity.nickname;
    }
    model.failImageName = @"imageDownloadFail";
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

#pragma mark - 群组详情
- (void)showGroupDetailAction
{
    
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;

    if (self.conversation.type == ONEConversationTypeGroupChat) {
        self.scrollToBottomWhenAppear = NO;
        ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:self.conversation.conversationId];
        detailController.sendGroupMsg = ^(NSString *msg, NSString *groupId) {
            
            if (![groupId isEqualToString:weakSelf.conversation.conversationId]) {
                
                return;
            }
            [weakSelf sendTextMessage:msg];
        };
        [weakSelf.navigationController pushViewController:detailController animated:YES];
    }
}


#pragma mark - notification
- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 复制、删除、转发

- (void)showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(ONEMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
    }
    
    if (_likeMenuItem == nil) {
        
        _likeMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"reward_message", @"") action:@selector(likeMenuAction:)];
    }
    

    if (self.conversation.type == ONEConversationTypeGroupChat) {
        if (messageType == ONEMessageBodyTypeText) {
            
            [self.menuController setMenuItems:@[_likeMenuItem ,_copyMenuItem, _deleteMenuItem,_transpondMenuItem]];

        } else if (messageType == ONEMessageBodyTypeImage){
            [self.menuController setMenuItems:@[_likeMenuItem,_deleteMenuItem,_transpondMenuItem]];
        } else {
            [self.menuController setMenuItems:@[_likeMenuItem,_deleteMenuItem]];
        }
    } else {
        
        if (messageType == ONEMessageBodyTypeText) {
            
            [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem,_transpondMenuItem]];
        } else if (messageType == ONEMessageBodyTypeImage){
            
            [self.menuController setMenuItems:@[_deleteMenuItem,_transpondMenuItem]];
        } else {
            
            [self.menuController setMenuItems:@[_deleteMenuItem]];
        }
    }
    
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}


- (void)transpondMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        ContactListSelectViewController *listViewController = [[ContactListSelectViewController alloc] initWithNibName:nil bundle:nil];
        listViewController.messageModel = model;
        [listViewController tableViewDidTriggerHeaderRefresh];
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    self.menuIndexPath = nil;
}

- (void)likeMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        ONEPaymentController *paymentVC = [[ONEPaymentController alloc] initWithMessage:model];
        __weak typeof(self)weakself = self;
        paymentVC.groupMsgRewarded = ^{
            [weakself showHint:NSLocalizedString(@"success", @"")];
        };
        [self.navigationController pushViewController:paymentVC animated:YES];
    }
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        
        [self.tableView reloadData];

//        [self.tableView beginUpdates];
//        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}





@end
