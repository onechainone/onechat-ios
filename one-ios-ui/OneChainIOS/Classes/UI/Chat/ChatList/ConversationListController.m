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

#import "ConversationListController.h"

#import "ChatViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
#import "NSString+Extension.h"
#import "ONEGroupManager.h"
#import "GroupChatSegmentController.h"
#define HEADER_BG_COLOR RGBACOLOR(245, 245, 245, 1)
#define HEADER_LBL_COLOR RGBACOLOR(96, 96, 96, 1)
#define HEADER_LBL_VERT HeightScale(10)
#define HEADER_LBL_HORN WidthScale(10)

#define kCENTER_WIDTH WidthScale(321)

static const CGFloat HEADER_LBL_FONT_SIZE = 10.f;

static const CGFloat SECTION_HEADER_HEIGHT = 2.f;


@interface ConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource,UISearchDisplayDelegate, UISearchBarDelegate>
{
    UILabel *_unreadNotiLbl;
    UIView *_coverView;
}

@property (nonatomic, strong) UIView *networkStateView;
@property (nonatomic, strong) EMSearchBar           *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (nonatomic, strong) UIView *sectionHeader;

@property (nonatomic, strong) UIView *notificationBanner;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIWindow *centerWindow;

@end

@implementation ConversationListController

- (UIView *)sectionHeader
{
    if (!_sectionHeader) {
        
        _sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, SECTION_HEADER_HEIGHT)];
        _sectionHeader.themeMap = @{
                                    BGColorName:@"conversation_section_color"
                                    };
    }
    return _sectionHeader;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    [self networkStateView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self tableViewDidTriggerHeaderRefresh];
}


#pragma mark - getter
- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}


#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        ONEConversation *conversation = conversationModel.conversation;
        if (conversation) {
            
            ONEChatGroup *group = [[ONEChatClient sharedClient] groupChatWithGroupId:conversation.conversationId];
            if (conversation.type == ONEConversationTypeGroupChat && group.isPublicGroup) {
                
                GroupChatSegmentController *groupSegVC = [[GroupChatSegmentController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                groupSegVC.title = conversationModel.title;
                [self.navigationController pushViewController:groupSegVC animated:YES];
            } else {
                ChatViewController *chatController = [[ChatViewController alloc]
                                                      initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                
                chatController.title = conversationModel.title;
                
                
                [self.navigationController pushViewController:chatController animated:YES];
            }
        }
        if (conversation.type == ONEConversationTypeGroupChat) {
            [ONEGroupManager markConversationAsHasAt:conversationModel.conversation.conversationId hasAt:NO];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
    }
}


#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(ONEConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == ONEConversationTypeChat) {

            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:conversation.conversationId];
            if (profileEntity) {
                model.title = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
                model.avatarURLPath = profileEntity.imageUrl;
            }
        
    } else if (model.conversation.type == ONEConversationTypeGroupChat) {
        
        ONEChatGroup *group = [[ONEChatClient sharedClient] groupChatWithGroupId:conversation.conversationId];
        model.title = group.name;
        model.group = group;
        if ([group.groupAvatarUrl length] > 0) {
            model.avatarURLPath = group.groupAvatarUrl;
        }
    }
    return model;
}

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    ONEMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        ONEMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case ONEMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"picture", @"[image]");
            } break;
            case ONEMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((ONETextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case ONEMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"voice_msg", @"[voice]");
            } break;
            case ONEMessageBodyTypeLocation: {
                latestMessageTitle =  [NSString stringWithFormat:@"[%@]",NSLocalizedString(@"attach_location", @"[location]")];
            } break;
            case ONEMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case ONEMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            
            case ONEMessageBodyTypeTransfer: {
                
                latestMessageTitle = [NSString stringWithFormat:@"[%@]",NSLocalizedString(@"fast_transfer", @"")];
            }
                break;
            case ONEMessageBodyTypeRedpacket:{
                latestMessageTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"msg_red_packet", @"[Red Packet]")];
            }
                break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == ONEMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:from];
            if (profileEntity) {
                from = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
            }
            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
        }
              
        if ([ONEGroupManager isConversationHasAt:conversationModel.conversation.conversationId]) {
            
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@",[ONEGroupManager atTagMessage], latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [ONEGroupManager atTagMessageColor]} range:NSMakeRange(0, [[ONEGroupManager atTagMessage] length])];
        } else {
            
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }

    }
    
    return attributedStr;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    
    latestMessageTime = [[NSDate dateWithTimeIntervalInMilliSecondSince1970:conversationModel.conversation.timestamp] monthFormattedTime];
    
    return latestMessageTime;
}



#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}


@end
