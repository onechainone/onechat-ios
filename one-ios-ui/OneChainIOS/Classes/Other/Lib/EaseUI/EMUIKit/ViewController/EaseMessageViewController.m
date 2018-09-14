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

#import "EaseMessageViewController.h"

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "NSDate+Category.h"
#import "EaseUsersListViewController.h"
#import "EaseMessageReadManager.h"
#import "EaseEmotionManager.h"
#import "EaseEmoji.h"
#import "EaseEmotionEscape.h"
#import "EaseCustomMessageCell.h"
#import "UIImage+EMGIF.h"
#import "EaseLocalDefine.h"
#import "EaseSDKHelper.h"
#import "LFSendRedController.h"
#import "RedpacketView.h"
#import "RedPacketDetailController.h"
#import "RedPacketMngr.h"
#import "UserProfileManager.h"
#import "NSString+Extension.h"
#import "ONECommunityToolBar.h"
#import "ONECommunityController.h"
#import "ONEPersonMenuView.h"
#import "LZContactsDetailTableViewController.h"
#import "ONEGroupManager.h"
#ifdef Def_DebugCode


#endif


#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#define KHintAdjustY    50

#define IOS_VERSION [[UIDevice currentDevice] systemVersion]>=9.0

#define KMSG_REMIND_BGCOLOR RGBACOLOR(245, 245, 245, 1)
#define KMSG_REMIND_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:12]
#define KMSG_REMIND_CORNERRADIUS 10.f
#define KMSG_REMIND_WIDTH WidthScale(108)
#define KMSG_REMIND_HEIGHT 35
#define KMSG_REMIND_DURATION 0.4
#define KSCROLL_BOTTOM 200
#define kCENTER_WIDTH WidthScale(321)

static const NSInteger kMAXRECORDLENGTH = 60;

@implementation EaseAtTarget
- (instancetype)initWithUserId:(NSString*)userId andNickname:(NSString*)nickname
{
    if (self = [super init]) {
        _userId = [userId copy];
        _nickname = [nickname copy];
    }
    return self;
    
}
@end

@interface EaseMessageViewController ()<EaseMessageCellDelegate, ONECommunityToolBarDelegate, ONEPersonMenuViewDelegate, ONEChatClientDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UILongPressGestureRecognizer *_lpgr;
    NSMutableArray *_atTargets;
    
    dispatch_queue_t _messageQueue;
    NSTimer *_recordTimer;
    UILabel *_unreadNotiLbl;
    UIView *_coverView;
    ONEPersonMenuView *_personMenu;
    UIView *_personMenuCover;
}

@property (strong, nonatomic) id<IMessageModel> playingVoiceModel;
@property (nonatomic) BOOL isKicked;
@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong)RedpacketView *redpacketView;

@property (nonatomic) BOOL currentIsInBottom;
// 新消息提示，点击下滑到底部
@property (nonatomic, strong) UIButton *msgRemind;
// 未读新消息
@property (nonatomic, assign) NSInteger unReadMsgCount;
@property (nonatomic, assign) NSInteger new_unreadMsgCount;
@property (nonatomic, strong) UIButton *new_msgRemind;
// 收到的消息集合，用于UI过滤
@property (nonatomic, strong) NSMutableSet *msgSet;
// 图片消息集合，用于图片浏览
@property (nonatomic, strong) NSMutableArray *imageSources;
// 用于监测系统来电
@property (nonatomic, strong) CTCallCenter *callCenter;

@property (nonatomic, strong) ONECommunityToolBar *communityToolBar;

@property (nonatomic, strong) UIView *notificationBanner;


@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIWindow *centerWindow;

@property (nonatomic, strong) id<IMessageModel>selectedModel;

//@property (nonatomic, strong) GroupInformation *groupInfo;
@property (nonatomic, strong) ONEChatGroup *chatGroup;

@property (nonatomic, strong) NSCache *roleTypeCache;


@end

@implementation EaseMessageViewController

@synthesize conversation = _conversation;
@synthesize deleteConversationIfNull = _deleteConversationIfNull;
@synthesize messageCountOfPage = _messageCountOfPage;
@synthesize timeCellHeight = _timeCellHeight;
@synthesize messageTimeIntervalTag = _messageTimeIntervalTag;

- (NSMutableSet *)msgSet
{
    if (!_msgSet) {
        
        _msgSet = [NSMutableSet set];
    }
    return _msgSet;
}

- (NSMutableSet *)adminSet
{
    if (!_adminSet) {
        
        _adminSet = [NSMutableSet set];
    }
    return _adminSet;
}

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(ONEConversationType)conversationType
{
    if ([conversationChatter length] == 0) {
        return nil;
    }
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _conversation = [[ONEChatClient sharedClient] getConversation:conversationChatter type:conversationType createIfNotExist:YES];
        _userID = conversationChatter;
        _messageCountOfPage = 10;
        _timeCellHeight = 30;
        _deleteConversationIfNull = YES;
        _scrollToBottomWhenAppear = YES;
        _messsagesSource = [NSMutableArray array];
        _unReadMsgCount = 0;
        _new_unreadMsgCount = [_conversation unreadMessagesCount];
        _imageSources = [NSMutableArray array];
        _roleTypeCache = [[NSCache alloc] init];
        [_roleTypeCache setCountLimit:500];
        [_conversation markAllMessagesAsRead:nil];
        if (conversationType == ONEConversationTypeGroupChat) {
            [[ONEGroupManager sharedInstance] setGroupId:conversationChatter];
            _chatGroup = [[ONEChatClient sharedClient] groupChatWithGroupId:conversationChatter];
        }
    }
    
    return self;
}


- (void)getAdminList
{
    [self.adminSet removeAllObjects];
    
    [[ONEGroupManager sharedInstance] setRoleType:GroupRoleType_Member];
    __weak typeof(self)weakself = self;
    
    [[ONEChatClient sharedClient] getGroupAdminList:self.conversation.conversationId completion:^(ONEError *error, NSArray *list) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ONEChatGroup *info = [[ONEChatClient sharedClient] groupChatWithGroupId:weakself.conversation.conversationId];
            NSString *owner = info.owner;
            if ([owner length] > 0 && [owner isEqualToString:[ONEChatClient homeAccountId]]) {
                
                [[ONEGroupManager sharedInstance] setRoleType:GroupRoleType_Owner];
                [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"icon_at_all"] highlightedImage:[UIImage imageNamed:@"icon_at_all"] title:NSLocalizedString(@"group_at_all", @"")];
            }
            if (list) {
                
                [ONEGroupManager cacheGroupAdmis:list groupId:weakself.conversation.conversationId];
                [weakself.adminSet addObjectsFromArray:list];
                [weakself.tableView reloadData];
                if ([list containsObject:[ONEChatClient homeAccountId]] && ![owner isEqualToString:[ONEChatClient homeAccountId]]) {
                    
                    [[ONEGroupManager sharedInstance] setRoleType:GroupRoleType_Admin];
                    
                    [weakself.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"icon_at_all"] highlightedImage:[UIImage imageNamed:@"icon_at_all"] title:NSLocalizedString(@"group_at_all", @"")];
                }
            }
        });
    }];
}

- (CGFloat)segmentHeight
{
    if (self.conversation.type == ONEConversationTypeGroupChat) {
        
        if (_chatGroup.isPublicGroup) {
            
            return 64 + 40 + (IS_IPHONE_X ? 20 : 0);
        } else {
            return 0;
        }
    }
    return 0;
}

- (void)removeChatDelegate
{
//    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[ONEChatClient sharedClient] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.themeMap = @{
                                BGColorName:@"bg_normal_color"
                                };
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.estimatedRowHeight = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideImagePicker) name:@"hideImagePicker" object:nil];
    
    //Initialization
    CGFloat chatbarHeight = [EaseChatToolbar defaultHeight];
    EMChatToolbarType barType = self.conversation.type == ONEConversationTypeChat ? EMChatToolbarTypeChat : EMChatToolbarTypeGroup;
    CGFloat height = 0;
    if (_chatGroup.isPublicGroup) {
        if (IS_IPHONE_X) {
            height = 20;
        }
    }
    
    self.chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight - iPhoneX_BOTTOM_HEIGHT - [self segmentHeight] - height, self.view.frame.size.width, chatbarHeight) type:barType];
    self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
//    if (self.conversation.type == EMConversationTypeGroupChat) {
//
//        self.communityToolBar = [[ONECommunityToolBar alloc] initWithFrame:CGRectMake(0, KScreenH, self.view.frame.size.width, chatbarHeight)];
//        self.communityToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//        self.communityToolBar.delegate = self;
//        [self.view addSubview:self.communityToolBar];
//    }
    
    //Initializa the gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
    [self.view addGestureRecognizer:tap];
    
    _lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _lpgr.minimumPressDuration = 0.5;
    [self.tableView addGestureRecognizer:_lpgr];
    
    _messageQueue = dispatch_queue_create("hyphenate.com", NULL);
    
    [EMCDDeviceManager sharedInstance].delegate = self;
    [[ONEChatClient sharedClient] addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    UIImage *senderImage = THMImage(@"chat_send_bubble_bg");
    UIImage *recvImage = THMImage(@"chat_recv_bubble_bg");
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[senderImage stretchableImageWithLeftCapWidth:30 topCapHeight:17]];
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[recvImage stretchableImageWithLeftCapWidth:30 topCapHeight:17]];
    
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[[UIImage imageNamed:@"Voice_Self"], [UIImage imageNamed:@"Voice_Tag_Self_1"], [UIImage imageNamed:@"Voice_Tag_Self_2"], [UIImage imageNamed:@"Voice_Tag_Self_3"]]];
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[[UIImage imageNamed:@"Voice_Other"],[UIImage imageNamed:@"Voice_Tag_Other_1"], [UIImage imageNamed:@"Voice_Tag_Other_2"], [UIImage imageNamed:@"Voice_Tag_Other_3"]]];
    
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];
    
    [[EaseChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];

//    [self.chatBarMoreView removeItematIndex:3];
//    [self.chatBarMoreView removeItematIndex:3];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:THMImage(@"nav_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];


    if (self.conversation.type == ONEConversationTypeChat) {
        
        [self.chatBarMoreView removeItematIndex:3];
        [self.chatBarMoreView removeItematIndex:3];

    } else {
        [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"Group red"] highlightedImage:[UIImage imageNamed:@"Group red"] title:NSLocalizedString(@"red_packet", @"")];
        [self getAdminList];


    }
    [self tableViewDidTriggerHeaderRefresh];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageAttchmentDownloaded:) name:KNOTIFICATION_MESSAGEATTCHMENT_DOWNLOADED object:nil];
    [self moniterIncomingCall];
    
}

- (void)didMessageAttchmentDownloaded:(ONEMessage *)message
{
    if (message) {
        [self _reloadTableViewDataWithMessage:message];
    }
}



-(void)didEnterBackground
{
    if ([[EMCDDeviceManager sharedInstance] isRecording]) {
        [self didFinishRecoingVoiceAction:self.recordView];
    }
}

#pragma mark - 监测系统来电
// 录音时监测到系统来电，取消录音
- (void)moniterIncomingCall
{
    __weak typeof(self) weakself = self;
    _callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler = ^(CTCall * call) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[EMCDDeviceManager sharedInstance] isRecording]) {
                [weakself didFinishRecoingVoiceAction:weakself.recordView];
            }
        });
    };
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_MESSAGEATTCHMENT_DOWNLOADED object:nil];
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    [[ONEChatClient sharedClient] removeDelegate:self];
    
    if (_imagePicker){
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
        _imagePicker = nil;
    }
    if (self.conversation.type == ONEConversationTypeGroupChat) {
        [[ONEGroupManager sharedInstance] setGroupId:nil];
        [[ONEGroupManager sharedInstance] setRoleType:GroupRoleType_Member];
        [_roleTypeCache removeAllObjects];
        _roleTypeCache = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isViewDidAppear = YES;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
    
    if (self.scrollToBottomWhenAppear) {
        [self _scrollViewToBottom:NO];
    }
    self.scrollToBottomWhenAppear = YES;
    [(EaseChatToolbar *)self.chatToolbar endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.isViewDidAppear = NO;
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    
    if (self.conversation.type == ONEConversationTypeGroupChat && [ONEGroupManager isConversationHasAt:self.conversation.conversationId]) {
        [ONEGroupManager markConversationAsHasAt:self.conversation.conversationId hasAt:NO];
    }

}


#pragma mark - getter

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (NSMutableArray*)atTargets
{
    if (!_atTargets) {
        _atTargets = [NSMutableArray array];
    }
    return _atTargets;
}

#pragma mark - setter

- (void)setIsViewDidAppear:(BOOL)isViewDidAppear
{
    _isViewDidAppear =isViewDidAppear;
    if (_isViewDidAppear)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (ONEMessage *message in self.messsagesSource)
        {
            [unreadMessages addObject:message];
        }
        [_conversation markAllMessagesAsRead:nil];
    }
}

- (void)setChatToolbar:(EaseChatToolbar *)chatToolbar
{
    [_chatToolbar removeFromSuperview];
    
    _chatToolbar = chatToolbar;
    if (_chatToolbar) {
        [self.view addSubview:_chatToolbar];
    }
    
    CGRect tableFrame = self.tableView.frame;
    CGFloat height = 0;
    if (_chatGroup.isPublicGroup) {
        if (IS_IPHONE_X) {
            height = 20;
        }
    }

    tableFrame.size.height = self.view.frame.size.height - _chatToolbar.frame.size.height - iPhoneX_BOTTOM_HEIGHT - [self segmentHeight] - height;
    self.tableView.frame = tableFrame;
    if ([chatToolbar isKindOfClass:[EaseChatToolbar class]]) {
        [(EaseChatToolbar *)self.chatToolbar setDelegate:self];
        self.chatBarMoreView = (EaseChatBarMoreView*)[(EaseChatToolbar *)self.chatToolbar moreView];
        self.faceView = [(EaseChatToolbar *)self.chatToolbar faceView];
        self.recordView = (EaseRecordView*)[(EaseChatToolbar *)self.chatToolbar recordView];
    }
}

- (void)setDataSource:(id<EaseMessageViewControllerDataSource>)dataSource
{
    _dataSource = dataSource;
}

- (void)setDelegate:(id<EaseMessageViewControllerDelegate>)delegate
{
    _delegate = delegate;
}

#pragma mark - private helper

- (void)_scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (BOOL)_canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

- (void)showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(ONEMessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSEaseLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSEaseLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (messageType == ONEMessageBodyTypeText) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else {
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

- (void)_stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    [EMCDDeviceManager sharedInstance].delegate = nil;
}

- (NSURL *)_convert2Mp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [EMCDDeviceManager dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

- (ONEChatType)_messageTypeFromConversationType
{
    ONEChatType type = ONEChatTypeChat;
    switch (self.conversation.type) {
        case ONEConversationTypeChat:
            type = ONEChatTypeChat;
            break;
        case ONEConversationTypeGroupChat:
            type = ONEChatTypeGroupChat;
            break;
        case ONEConversationTypeChatRoom:
            type = ONEChatTypeGroupChat;
            break;
        default:
            break;
    }
    return type;
}

- (void)_downloadMessageAttachments:(ONEMessage *)message
{
    __weak typeof(self) weakSelf = self;

    ONEMessageBody *messageBody = message.body;
    if ([messageBody type] == ONEMessageBodyTypeImage) {
        ONEImageMessageBody *imageBody = (ONEImageMessageBody *)messageBody;
        
        if (imageBody.localPath.length > 0) {
            return;
        }
        if (imageBody.remotePath.length > 0) {
            
            NSString *localPath = [ONEChatClient localPathFromRemotePath:imageBody.remotePath];
            if (localPath == nil || localPath.length == 0) {
                
                [[ONEChatClient sharedClient] downloadMessageAttchment:message completion:^(ONEMessage *message, BOOL success) {
                   
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self _reloadTableViewDataWithMessage:message];
                    });

                }];
            }
        }

    } else if ([messageBody type] == ONEMessageBodyTypeVoice) {
        ONEVoiceMessageBody *voiceBody = (ONEVoiceMessageBody*)messageBody;
        
        
        if (voiceBody.localPath.length > 0) {
            return;
        }
        if (voiceBody.remotePath.length > 0) {
            
            NSString *localPath = [ONEChatClient localPathFromRemotePath:voiceBody.remotePath];
            if (localPath == nil || localPath.length == 0) {
                
                [[ONEChatClient sharedClient] downloadMessageAttchment:message completion:^(ONEMessage *message, BOOL success) {
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self _reloadTableViewDataWithMessage:message];
                    });
                    
                }];
                
            }
        }
    }
}


- (BOOL)_shouldMarkMessageAsRead
{
    BOOL isMark = YES;
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
    {
        isMark = NO;
    }
    return isMark;
}

- (void)_locationMessageCellSelected:(id<IMessageModel>)model
{
    _scrollToBottomWhenAppear = NO;
    
    EaseLocationViewController *locationController = [[EaseLocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)_videoMessageCellSelected:(id<IMessageModel>)model
{
    return;
}

- (NSUInteger)indexFromImageMessages
{
    return 0;
}

- (void)_imageMessageCellSelected:(id<IMessageModel>)model
{
    __weak EaseMessageViewController *weakSelf = self;
    ONEImageMessageBody *imageBody = (ONEImageMessageBody*)[model.message body];
    
    if ([imageBody type] == ONEMessageBodyTypeImage) {
        
        if (imageBody.localPath && imageBody.localPath.length > 0) {
            
            UIImage *image = [UIImage imageWithContentsOfFile:imageBody.localPath];
            if (image)
            {
                [self showImage:image model:model];
            }
            return;
        }
        if (imageBody.remotePath && imageBody.remotePath.length > 0)
        {
            
            NSString *localPath = [ONEChatClient localPathFromRemotePath:imageBody.remotePath];
            if (localPath && localPath.length > 0)
            {
                
                UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                if (image)
                {
                    [self showImage:image model:model];
                } else {
                    
                    [[ONEChatClient sharedClient] downloadMessageAttchment:model.message completion:^(ONEMessage *message, BOOL success) {
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (success) {
                                ONEImageMessageBody *body = (ONEImageMessageBody *)message.body;
                                NSString *localPath = [ONEChatClient localPathFromRemotePath:body.remotePath];
                                [weakSelf _reloadTableViewDataWithMessage:model.message];
                                UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                                if (image) {
                                    [self showImage:image model:model];
                                }
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self showHint:NSLocalizedString(@"img_overdue", @"")];
                                });
                            }
                        });
                    }];
                }
                return;
            }
            
            [[ONEChatClient sharedClient] downloadMessageAttchment:model.message completion:^(ONEMessage *message, BOOL success) {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (success) {
                        ONEImageMessageBody *body = (ONEImageMessageBody *)message.body;
                        NSString *localPath = [ONEChatClient localPathFromRemotePath:body.remotePath];
                        [weakSelf _reloadTableViewDataWithMessage:model.message];
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        if (image) {
                            [self showImage:image model:model];
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self showHint:NSLocalizedString(@"img_overdue", @"")];
                        });
                    }
                });
            }];
        }
    }
}

- (void)_audioMessageCellSelected:(id<IMessageModel>)model
{
    _scrollToBottomWhenAppear = NO;
    ONEVoiceMessageBody *body = (ONEVoiceMessageBody*)model.message.body;
    ONEMessageAttchmentStatus attStatus = body.attchmentStatus;
    if (attStatus == ONEMessageAttchmentStatusNotDownloaded) {
        
        [[ONEChatClient sharedClient] downloadMessageAttchment:model.message completion:^(ONEMessage *message, BOOL success) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (success == YES) {
                    
                    [self showHint:NSLocalizedString(@"file_overdue", @"")];
                }
            });
        }];
        return;
    } else if (attStatus == ONEMessageAttchmentStatusError) {

        [self showHint:NSLocalizedString(@"File_does_not_exist", @"File not found")];
        return;
    }
    // play the audio
    if (model.bodyType == ONEMessageBodyTypeVoice) {
        //send the acknowledgement
        __weak EaseMessageViewController *weakSelf = self;
        
        BOOL isPrepare = [[EaseMessageReadManager defaultManager] prepareMessageAudioModel:(EaseMessageModel *)model updateViewCompletion:^(EaseMessageModel *prevAudioModel, EaseMessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                self.playingVoiceModel = currentAudioModel;
                [weakSelf.tableView reloadData];
            }
        }];

        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak EaseMessageViewController *weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.voiceLocalPath completion:^(NSError *error) {
                [[EaseMessageReadManager defaultManager] stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}
// 红包被点击
- (void)_redpacketCellSelected:(id<IMessageModel>)model
{
    [self.view endEditing:YES];
    _redpacketView = [[RedpacketView alloc] initWithModel:model];
    if ([RedPacketMngr redpacketStatus:model.red_id]) {
        
        RedPacketDetailController *redPacket = [[RedPacketDetailController alloc] initWithRedBagId:model.red_id];
        [self.navigationController pushViewController:redPacket animated:YES];
    } else {
        __weak typeof(self) weakSelf = self;

        [self showRedPacketView];
        _redpacketView.clickRedbag = ^(id<IMessageModel> model) {
            [weakSelf showHudInView:weakSelf.redpacketView hint:nil];
            
            [[ONEChatClient sharedClient] clickRedpacket:model.red_id withCompletion:^(ONEError *error) {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    if (!error) {
                        [RedPacketMngr saveStatusAfterClick:model.red_id];
                        [weakSelf hideRedPacketView];
                        [weakSelf.tableView reloadData];
                        RedPacketDetailController *redPacket = [[RedPacketDetailController alloc] initWithRedBagId:model.red_id];
                        [weakSelf.navigationController pushViewController:redPacket animated:YES];
                    } else {
                        [weakSelf showHint:NSLocalizedString(@"redpacket_open_failed", @"")];
                    }
                });
            }];
        };
        _redpacketView.clickCancel = ^{
            
            [weakSelf hideRedPacketView];
        };
    }
}

- (void)gotoRelogin
{
    [self hideRedPacketView];
    [RedPacketMngr showPasswordVC];
}


- (void)showRedPacketView
{
    _coverView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.layer.opacity = 0.35;
    _coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRedPacketView)];
    [_coverView addGestureRecognizer:tap];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_coverView];
    [window addSubview:_redpacketView];
}

- (void)hideRedPacketView
{
    [_coverView removeFromSuperview];
    [_redpacketView removeFromSuperview];
    _coverView = nil;
    _redpacketView = nil;
}

#pragma mark - pivate data

- (void)_loadMessagesBefore:(NSString*)messageId
                      count:(NSInteger)count
                     append:(BOOL)isAppend
                     scroll:(BOOL)scrollTop
{
    __weak typeof(self) weakSelf = self;
    void (^refresh)(NSArray *messages) = ^(NSArray *messages) {
        dispatch_async(_messageQueue, ^{
            //Format the message
            NSArray *formattedMessages = [weakSelf formatMessages:messages];
            
            //Refresh the page
            dispatch_async(dispatch_get_main_queue(), ^{
                EaseMessageViewController *strongSelf = weakSelf;
                if (strongSelf) {
                    NSInteger scrollToIndex = 0;
                    if (isAppend) {
                        [strongSelf.messsagesSource insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                        
                        //Combine the message
                        id object = [strongSelf.dataArray firstObject];
                        if ([object isKindOfClass:[NSString class]]) {
                            NSString *timestamp = object;
                            [formattedMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                                if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model]) {
                                    [strongSelf.dataArray removeObjectAtIndex:0];
                                    *stop = YES;
                                }
                            }];
                        }
                        scrollToIndex = [strongSelf.dataArray count];
                        [strongSelf.dataArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formattedMessages count])]];
                    }
                    else {
                        [strongSelf.messsagesSource removeAllObjects];
                        [strongSelf.messsagesSource addObjectsFromArray:messages];
                        
                        [strongSelf.dataArray removeAllObjects];
                        [strongSelf.dataArray addObjectsFromArray:formattedMessages];
                    }
                    
                    ONEMessage *latest = [strongSelf.messsagesSource lastObject];
                    strongSelf.messageTimeIntervalTag = latest.timestamp;

                    [strongSelf.tableView reloadData];
                    if (scrollTop) {
                        [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        [self hideNew_MsgRemindBtn];
                    } else {
                        [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - scrollToIndex - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
                }
            });
            for (ONEMessage *message in messages)
            {
                [weakSelf _downloadMessageAttachments:message];
            }
        });
    };
    
    
    
    [self.conversation loadMessagesStartFromId:messageId count:(int)count searchDirection:ONEMessageSearchDirectionUp completion:^(NSArray *aMessages, ONEError *aError) {
        if (!aError && [aMessages count]) {
            [self.msgSet addObjectsFromArray:aMessages];
            refresh(aMessages);
        }
    }];
}

- (void)_loadMessagesBefore:(NSString*)messageId
                      count:(NSInteger)count
                     append:(BOOL)isAppend
{
    
    [self _loadMessagesBefore:messageId count:count append:isAppend scroll:NO];

}

#pragma mark - GestureRecognizer

-(void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.chatToolbar endEditing:YES];
    }
}

- (BOOL)isAvatarLocation:(CGPoint)location
{
    if (location.x < 50) {
        return YES;
    }
    return NO;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataArray count] > 0)
    {
        
        CGPoint location = [recognizer locationInView:self.tableView];
        if ([self isAvatarLocation:location]) {
            return;
        }
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        BOOL canLongPress = NO;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:canLongPressRowAtIndexPath:)]) {
            canLongPress = [_dataSource messageViewController:self
                                   canLongPressRowAtIndexPath:indexPath];
        }
        
        if (!canLongPress) {
            return;
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:didLongPressRowAtIndexPath:)]) {
            [_dataSource messageViewController:self
                    didLongPressRowAtIndexPath:indexPath];
        }
        else{
            id object = [self.dataArray objectAtIndex:indexPath.row];
            if (![object isKindOfClass:[NSString class]]) {
                EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell becomeFirstResponder];
                _menuIndexPath = indexPath;
                [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    
    //time cell
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *timeCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        timeCell.title = object;
        return timeCell;
    }
    else{
        id<IMessageModel> model = object;
        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:cellForMessageModel:)]) {
            UITableViewCell *cell = [_delegate messageViewController:tableView cellForMessageModel:model];
            if (cell) {
                if ([cell isKindOfClass:[EaseMessageCell class]]) {
                    EaseMessageCell *emcell= (EaseMessageCell*)cell;
                    if (emcell.delegate == nil) {
                        emcell.delegate = self;
                    }
                }
                return cell;
            }
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
            BOOL flag = [_dataSource isEmotionMessageFormessageViewController:self messageModel:model];
            if (flag) {
                NSString *CellIdentifier = [EaseCustomMessageCell cellIdentifierWithModel:model];
                //send cell
                EaseCustomMessageCell *sendCell = (EaseCustomMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                // Configure the cell...
                if (sendCell == nil) {
                    sendCell = [[EaseCustomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
                    sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                if (_dataSource && [_dataSource respondsToSelector:@selector(emotionURLFormessageViewController:messageModel:)]) {
                    EaseEmotion *emotion = [_dataSource emotionURLFormessageViewController:self messageModel:model];
                    if (emotion) {
                        model.image = [UIImage sd_animatedGIFNamed:emotion.emotionOriginal];
                        model.fileURLPath = emotion.emotionOriginalURL;
                    }
                }
                sendCell.model = model;
                sendCell.delegate = self;
                return sendCell;
            }
        }
        NSString *CellIdentifier = [EaseMessageCell cellIdentifierWithModel:model];
        
        EaseBaseMessageCell *sendCell = (EaseBaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[EaseBaseMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sendCell.delegate = self;
        }

        sendCell.model = model;
        sendCell.roleType = [self userRoleWithMessageModel:model];
        return sendCell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        return self.timeCellHeight;
    }
    else{
        id<IMessageModel> model = object;
        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:heightForMessageModel:withCellWidth:)]) {
            CGFloat height = [_delegate messageViewController:self heightForMessageModel:model withCellWidth:tableView.frame.size.width];
            if (height) {
                return height;
            }
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
            BOOL flag = [_dataSource isEmotionMessageFormessageViewController:self messageModel:model];
            if (flag) {
                return [EaseCustomMessageCell cellHeightWithModel:model];
            }
        }

        return [EaseBaseMessageCell cellHeightWithModel:model];
    }
}





#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self _convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
    }else{
        
        NSURL *url = info[UIImagePickerControllerReferenceURL];
        if (url == nil) {
            UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
            [self sendImageMessage:orgImage];
        } else {
            if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0f) {
                PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset *asset , NSUInteger idx, BOOL *stop){
                    if (asset) {
                        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *data, NSString *uti, UIImageOrientation orientation, NSDictionary *dic){
                            if (data.length > 10 * 1000 * 1000) {
                                [self showHint:NSEaseLocalizedString(@"message.smallerImage", @"The image size is too large, please choose another one")];
                                return;
                            }
                            if (data != nil) {
                                [self sendImageMessageWithData:data];
//                                UIImage *image = [UIImage imageWithData:data];
//                                [OCUtil saveImage:image];
                            } else {
                                [self showHint:NSEaseLocalizedString(@"message.smallerImage", @"The image size is too large, please choose another one")];
                            }
                        }];
                    }
                }];
            } else {
                ALAssetsLibrary *alasset = [[ALAssetsLibrary alloc] init];
                [alasset assetForURL:url resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
                        Byte* buffer = (Byte*)malloc((size_t)[assetRepresentation size]);
                        NSUInteger bufferSize = [assetRepresentation getBytes:buffer fromOffset:0.0 length:(NSUInteger)[assetRepresentation size] error:nil];
                        NSData* fileData = [NSData dataWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
                        if (fileData.length > 10 * 1000 * 1000) {
                            [self showHint:NSEaseLocalizedString(@"message.smallerImage", @"The image size is too large, please choose another one")];
                            return;
                        }
                        [self sendImageMessageWithData:fileData];
//                        UIImage *image = [UIImage imageWithData:fileData];
//                        [OCUtil saveImage:image];
                    }
                } failureBlock:NULL];
            }
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.isViewDidAppear = YES;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:^{
        [self _scrollViewToBottom:YES];
    }];

    self.isViewDidAppear = YES;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
}

#pragma mark - EaseMessageCellDelegate

- (void)messageCellSelected:(id<IMessageModel>)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didSelectMessageModel:)]) {
        BOOL flag = [_delegate messageViewController:self didSelectMessageModel:model];
        if (flag) {
            return;
        }
    }
    
    switch (model.bodyType) {
        case ONEMessageBodyTypeImage:
        {
            _scrollToBottomWhenAppear = NO;
            [self _imageMessageCellSelected:model];
        }
            break;
        case ONEMessageBodyTypeLocation:
        {
             [self _locationMessageCellSelected:model];
        }
            break;
        case ONEMessageBodyTypeVoice:
        {
            [self _audioMessageCellSelected:model];
        }
            break;
        case ONEMessageBodyTypeVideo:
        {
            [self _videoMessageCellSelected:model];

        }
            break;
        case ONEMessageBodyTypeFile:
        {
            _scrollToBottomWhenAppear = NO;
            [self showHint:@"Custom implementation!"];
        }
            break;
        case ONEMessageBodyTypeTransfer:
        {
        }
            break;
        case ONEMessageBodyTypeRedpacket:
        {
            _scrollToBottomWhenAppear = NO;
            [self _redpacketCellSelected:model];
        }
            break;
        default:
            break;
    }
}

- (void)statusButtonSelcted:(id<IMessageModel>)model withMessageCell:(EaseMessageCell*)messageCell
{
    if ((model.messageStatus != ONEMessageStatusFailed) && (model.messageStatus != ONEMessageStatusPending))
    {
        return;
    }
    
    __weak typeof(self) weakself = self;
    [[ONEChatClient sharedClient] resendMessage:model.message progress:nil completion:^(ONEMessage *message, ONEError *error) {
        
        if (!error) {
            [weakself _refreshAfterSentMessage:model.message];
        } else {
            if (error.errorCode == ONEErrorBalanceNotEnough) {
                [weakself showHint:NSLocalizedString(@"msg_not_enough_balance", @"") yOffset:-220];
            } else if (error.errorCode == ONEErrorYouAreInBanList) {
                [weakself showHint:NSLocalizedString(@"you_in_ban", @"") yOffset:-220];
            } else if (error.errorCode == ONEErrorAllInBanList) {
                [weakself showHint:NSLocalizedString(@"all_in_ban", @"") yOffset:-220];
            }
            [weakself.tableView reloadData];
        }
    }];

    
    [self.tableView reloadData];
}

- (void)avatarViewSelcted:(id<IMessageModel>)model
{
    if (self.conversation.type == ONEConversationTypeChat) {
        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didSelectAvatarMessageModel:)]) {
            [_delegate messageViewController:self didSelectAvatarMessageModel:model];
        }
    } else {
        
        if (!model.isSender) {
            _selectedModel = model;
            [self showPersonMenu];
        }
    }

    
    _scrollToBottomWhenAppear = NO;
}

#pragma mark - EMChatToolbarDelegate

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        CGFloat height = 0;
        if (_chatGroup.isPublicGroup) {
            if (IS_IPHONE_X) {
                height = 20;
            }
        }

        rect.size.height = self.view.frame.size.height - toHeight - iPhoneX_BOTTOM_HEIGHT - [self segmentHeight] - height;
        self.tableView.frame = rect;
    }];
    
    [self _scrollViewToBottom:NO];
}

- (void)inputTextViewWillBeginEditing:(EaseTextView *)inputTextView
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    [_menuController setMenuItems:nil];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
        [self.atTargets removeAllObjects];
    }
}


- (BOOL)didDeleteCharacterFromLocation:(NSUInteger)location
{
    EaseChatToolbar *toolbar = (EaseChatToolbar*)self.chatToolbar;
    if ([toolbar.inputTextView.text length] == location + 1) {
        //delete last character
        NSString *inputText = toolbar.inputTextView.text;
        NSRange range = [inputText rangeOfString:@"@" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            if (location - range.location > 1) {
                NSString *sub = [inputText substringWithRange:NSMakeRange(range.location + 1, location - range.location - 1)];
                for (EaseAtTarget *target in self.atTargets) {
                    if ([sub isEqualToString:target.userId] || [sub isEqualToString:target.nickname]) {
                        inputText = range.location > 0 ? [inputText substringToIndex:range.location] : @"";
                        toolbar.inputTextView.text = inputText;
                        toolbar.inputTextView.selectedRange = NSMakeRange(inputText.length, 0);
                        [self.atTargets removeObject:target];
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext
{
    if ([ext objectForKey:EASEUI_EMOTION_DEFAULT_EXT]) {
        EaseEmotion *emotion = [ext objectForKey:EASEUI_EMOTION_DEFAULT_EXT];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(emotionExtFormessageViewController:easeEmotion:)]) {
            NSDictionary *ext = [self.dataSource emotionExtFormessageViewController:self easeEmotion:emotion];
            [self sendTextMessage:emotion.emotionTitle withExt:ext];
        } else {
            [self sendTextMessage:emotion.emotionTitle withExt:@{MESSAGE_ATTR_EXPRESSION_ID:emotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)}];
        }
        return;
    }
    if (text && text.length > 0) {
        [self sendTextMessage:text withExt:ext];
    }
}



- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        NSLog(@"LF_LOG:没有录音权限");
        [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"setting_microphone_authority", @"") controller:self];
        return;
    }
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                
            } else {
            }
        }];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeTouchDown];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonTouchDown];
        }
    }
    
    if ([self _canRecord]) {
        EaseRecordView *tmpView = (EaseRecordView *)recordView;
        tmpView.center = self.view.center;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        if (self.playingVoiceModel) {
            
            self.playingVoiceModel.isMediaPlaying = NO;
            self.playingVoiceModel = nil;
            [[EMCDDeviceManager sharedInstance] stopPlaying];
            [self.tableView reloadData];
        }
        
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error)
         {
             if (error) {
                 NSLog(@"%@",NSEaseLocalizedString(@"message_start_record_fail", @""));
                 [self showHint:error.domain];
             } else {
                 [self _clearRecordTimer];
                 _recordTimer = [NSTimer scheduledTimerWithTimeInterval:kMAXRECORDLENGTH target:self selector:@selector(timeToStopRecord) userInfo:nil repeats:NO];
             }
         }];
    }
}

- (void)timeToStopRecord
{
    if ([[EMCDDeviceManager sharedInstance] isRecording]) {
        [self didFinishRecoingVoiceAction:self.recordView];
        [self _clearRecordTimer];
    }
}

- (void)_clearRecordTimer
{
    if (_recordTimer) {
        [_recordTimer invalidate];
        _recordTimer = nil;
        KLog(@"LF_LOG:录音timer释放");
    }
}
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeTouchUpOutside];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonTouchUpOutside];
        }
        [self.recordView removeFromSuperview];
        [self _clearRecordTimer];
    }
}

- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeTouchUpInside];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonTouchUpInside];
        }
        [self.recordView removeFromSuperview];
    }
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            [weakSelf _clearRecordTimer];
            [weakSelf sendVoiceMessageWithLocalPath:recordPath duration:aDuration];
        }
        else {
            [weakSelf showHudInView:self.view hint:error.domain];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
            });
        }
    }];
}

- (void)didDragInsideAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeDragInside];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonDragInside];
        }
    }
}

- (void)didDragOutsideAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeDragOutside];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonDragOutside];
        }
    }
}


- (NSString *)paramsFromAmount:(NSString *)amount symbol:(NSString *)symbol
{
    if (amount.length > 0 && symbol.length > 0) {
        
        NSDictionary *dict = @{
                               @"symbol":symbol,
                               @"value":amount
                               };
        NSString *jsonString = [dict yy_modelToJSONString];
        return jsonString;
    }
    return @"";
}

- (void)sendRedpacketAction
{
    LFSendRedController *send = [[LFSendRedController alloc] init];
    send.groupId = self.conversation.conversationId;
    __weak typeof(self) weakSelf = self;
    send.sendRedMsg = ^(NSString *redID, NSString *redMsg) {
        
        if (redID.length > 0 && redMsg.length > 0) {
            
            NSDictionary *dic = @{
                                  @"red_packet_id":redID,
                                  @"red_packet_msg":redMsg
                                  };
            NSString *params = [dic yy_modelToJSONString];
            [weakSelf sendRedPacketMsg:params];
        }
        
    };
    [self.navigationController pushViewController:send animated:YES];
}

- (void)didShowCommunityStyle:(EaseChatToolbar *)toolBar
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.05 animations:^{
        [toolBar setY:KScreenH];
        [self.communityToolBar setY:(self.view.frame.size.height - [EaseChatToolbar defaultHeight] - iPhoneX_BOTTOM_HEIGHT)];

    } completion:^(BOOL finished) {
    }];
}



#pragma mark - EaseChatBarMoreViewDelegate

// 闪电转账、发红包
- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index
{
    if (self.conversation.type == ONEConversationTypeGroupChat) {
        
        // 处理发红包
        if (index == 3) {
            [self sendRedpacketAction];
        } else if (index == 4) {
            [self handleWithAtAllAction];
        }
        
    } else {
        
        if (index == 3) {
            //        NSLog(@"红包");
          
        }
        
    }
    
    
}

-(void) showHintMsg {
    
    [self showHint:NSLocalizedString(@"feature_come_soon", nil)];
}

- (void)moreViewPhotoAction:(EaseChatBarMoreView *)moreView
{
//    // Hide the keyboard
    
    [self.chatToolbar endEditing:YES];

    // 获取权限

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
        {
            NSLog(@"LF_LOG_NF:去打开权限");
            return;
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                    
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    imagePicker.delegate = self;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
                    [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
                    self.isViewDidAppear = NO;
                }

            }];
            return;
        }
            break;
            case PHAuthorizationStatusAuthorized:
        {
        }
            break;
        default:
            break;
    }

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
    self.isViewDidAppear = NO;
//    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];

}
//拍照
- (void)moreViewTakePicAction:(EaseChatBarMoreView *)moreView
{

    [self.chatToolbar endEditing:YES];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:NULL];

    self.isViewDidAppear = NO;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];

}

- (void)moreViewLocationAction:(EaseChatBarMoreView *)moreView
{
    EaseLocationViewController *locationVC = [[EaseLocationViewController alloc] initWithNibName:nil bundle:nil];
    locationVC.delegate = self;
    [self.navigationController pushViewController:locationVC animated:YES];

}


#pragma mark - EMLocationViewDelegate

-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address
{
    [self sendLocationMessageLatitude:latitude longitude:longitude andAddress:address];
}


#pragma mark - EMChatManagerDelegate

- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (ONEMessage *message in aMessages) {

        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            
            if (message.messageId && [self.msgSet containsObject:message.messageId]) {
                
                return;
            }
            [self.msgSet addObject:message.messageId];
            [self.messsagesSource addObject:message];

            [self addMessageToDataSource:message progress:nil];
            
            if ([self _shouldMarkMessageAsRead])
            {
                [self.conversation markMessageAsReadWithId:message.messageId error:nil];
            }

        }
    }
}

#pragma mark - EMCDDeviceManagerProximitySensorDelegate

- (void)proximitySensorChanged:(BOOL)isCloseToUser
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (self.playingVoiceModel == nil) {
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }
    }
    [audioSession setActive:YES error:nil];
}

#pragma mark - action

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
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - public 

- (NSArray *)formatMessages:(NSArray *)messages
{

    NSMutableArray *formattedArray = [[NSMutableArray alloc] init];
    if ([messages count] == 0) {
        return formattedArray;
    }
    
    for (ONEMessage *message in messages) {
        //Calculate time interval
        CGFloat interval = (self.messageTimeIntervalTag - message.timestamp) / 1000;
        if (self.messageTimeIntervalTag < 0 || interval > 60 || interval < -60) {

            NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSString *timeStr = @"";
            
            if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:stringForDate:)]) {
                timeStr = [_dataSource messageViewController:self stringForDate:messageDate];
            }
            else{
                timeStr = [messageDate formattedTime];
            }
            [formattedArray addObject:timeStr];
            self.messageTimeIntervalTag = message.timestamp;
        }
        
        //Construct message model
        id<IMessageModel> model = nil;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
            model = [_dataSource messageViewController:self modelForMessage:message];
        }
        else{
            model = [[EaseMessageModel alloc] initWithMessage:message];
            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.nickname];
            if (profileEntity) {
                model.avatarURLPath = profileEntity.imageUrl;
                model.nickname = profileEntity.nickname;
            }
            model.failImageName = @"imageDownloadFail";
        }

        if (model) {
            [formattedArray addObject:model];
        }
    }
    
    return formattedArray;
}

- (NSInteger)userRoleWithMessageModel:(id<IMessageModel>)model
{
    if (!model || self.conversation.type == ONEConversationTypeChat) {
        return 0;
    }
    NSString *from = model.message.from;
    if (![from isAccountId]) {
        from = [ONEChatClient accountIdWithName:from];
    }
    if ([from length] == 0) {
        return 0;
    }
    if ([_roleTypeCache objectForKey:from]) {
        return [[_roleTypeCache objectForKey:from] integerValue];
    } else {
        if ([from isEqualToString:self.chatGroup.owner]) {
            [_roleTypeCache setObject:@"2" forKey:from];
            return 2;
        }
        if ([self.adminSet containsObject:from]) {
            [_roleTypeCache setObject:@"1" forKey:from];
            return 1;
        }
    }
    
    return 0;
    
}

-(void)addMessageToDataSource:(ONEMessage *)message
                     progress:(id)progress
{
    [self.messsagesSource addObject:message];
     __weak EaseMessageViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessages:@[message]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataArray addObjectsFromArray:messages];
            [self.tableView reloadData];
            if ([message.from isEqualToString:[ONEChatClient homeAccountName]]) {
                [weakSelf scrollToTheLatestMsg];
            } else {
                
                if (self.currentIsInBottom) {
                    
                    [weakSelf scrollToTheLatestMsg];
                } else {
                    ++_unReadMsgCount;
                    [self showMsgRemindBtn];
                }
            }
        });
    });
}


- (void)scrollToTheLatestMsg
{
    if (self.dataArray.count - 1 > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
        
             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
       
    }
}



#pragma mark - public

- (void)tableViewDidTriggerHeaderRefresh
{
    self.messageTimeIntervalTag = -1;
    NSString *messageId = nil;
    if ([self.messsagesSource count] > 0) {
        messageId = [(ONEMessage *)self.messsagesSource.firstObject messageId];
    }
    else {
        messageId = nil;
    }
    [self _loadMessagesBefore:messageId count:self.messageCountOfPage append:YES];
    
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

#pragma mark - send message

- (void)_refreshAfterSentMessage:(ONEMessage*)aMessage
{
    if ([self.messsagesSource count]) {
        NSString *msgId = aMessage.messageId;
        ONEMessage *last = self.messsagesSource.lastObject;
        if ([last isKindOfClass:[ONEMessage class]]) {
            
            __block NSUInteger index = NSNotFound;
            index = NSNotFound;
            [self.messsagesSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(ONEMessage *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[ONEMessage class]] && [obj.messageId isEqualToString:msgId]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            if (index != NSNotFound) {
                [self.messsagesSource removeObjectAtIndex:index];
                [self.messsagesSource addObject:aMessage];
                
                //格式化消息
                self.messageTimeIntervalTag = -1;
                NSArray *formattedMessages = [self formatMessages:self.messsagesSource];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:formattedMessages];
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                return;
            }
        }
    }
    [self.tableView reloadData];
    [self scrollToTheLatestMsg];
}

- (void)_sendMessage:(ONEMessage *)message
{
    if (self.conversation.type == ONEConversationTypeGroupChat){
        message.chatType = ONEChatTypeGroupChat;
    }
    else if (self.conversation.type == ONEConversationTypeChatRoom){
        message.chatType = ONEChatTypeGroupChat;
    }
    
    [self addMessageToDataSource:message
                        progress:nil];
    
    __weak typeof(self) weakself = self;
    
    [[ONEChatClient sharedClient] sendMessage:message progress:nil completion:^(ONEMessage *message, ONEError *error) {
        
        if (!error) {
            [weakself _refreshAfterSentMessage:message];

            [[NSNotificationCenter defaultCenter] postNotificationName:RELOADWALLETTABLEVIEW object:nil];
        } else {
            if (error.errorCode == ONEErrorBalanceNotEnough) {
                [weakself showHint:NSLocalizedString(@"msg_not_enough_balance", @"") yOffset:-220];
            } else if (error.errorCode == ONEErrorYouAreInBanList) {
                [weakself showHint:NSLocalizedString(@"you_in_ban", @"") yOffset:-220];
            } else if (error.errorCode == ONEErrorAllInBanList) {
                [weakself showHint:NSLocalizedString(@"all_in_ban", @"") yOffset:-220];
            }
            [weakself.tableView reloadData];

        }
    }];

}

- (void)sendTextMessage:(NSString *)text
{
    NSDictionary *ext = nil;
    if (self.conversation.type == ONEConversationTypeGroupChat) {
        NSArray *targets = [self _searchAtTargets:text];
        if ([targets count]) {
            __block BOOL atAll = NO;
            [targets enumerateObjectsUsingBlock:^(NSString *target, NSUInteger idx, BOOL *stop) {
                if ([target compare:kGroupMessageAtAll options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    atAll = YES;
                    *stop = YES;
                }
            }];
            ext = @{@"one_at_list": targets};
        }
    }
    if ([self needShowLinkAlert:text]) {
        [self showLinkAlert:text];
    } else {
        [self sendTextMessage:text withExt:ext];
    }
}

- (BOOL)needShowLinkAlert:(NSString *)text
{
    if (text == nil || text.length == 0) {
        return NO;
    }
    if (self.conversation.type == ONEConversationTypeChat || [ONEGroupManager hadShownLinkAlert] || ![text containsLink]) {
        return NO;
    }
    
    ONEChatGroup *groupInfo = [[ONEChatClient sharedClient] groupChatWithGroupId:self.conversation.conversationId];
    if (groupInfo == nil) {
        return NO;
    }
    if (groupInfo.isPublicGroup) {
        return NO;
    }
    return YES;
}

- (void)showLinkAlert:(NSString *)text
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"group_chat_send_url_tip", @"Sending links in group chat gonna cost your Red Packet, are you sure?") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.chatToolbar.inputView becomeFirstResponder];
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [ONEGroupManager markHadShownLinkAlert];
        [self sendTextMessage:text withExt:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)sendTransferMessage:(NSString *)params
{
    ONEMessage *message = [EaseSDKHelper sendTransferMessage:params to:self.conversation.conversationId messageType:[self _messageTypeFromConversationType] messageExt:nil];
    [self _sendMessage:message];
}
- (void)sendRedPacketMsg:(NSString *)params
{
    ONEMessage *message = [EaseSDKHelper sendRedPacketMessage:params to:self.conversation.conversationId messageType:[self _messageTypeFromConversationType] messageExt:nil];
    [self _sendMessage:message];
}

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext
{
    ONEMessage *message = [EaseSDKHelper sendTextMessage:text
                                                   to:self.conversation.conversationId
                                          messageType:[self _messageTypeFromConversationType]
                                           messageExt:ext];
    [self _sendMessage:message];
}

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address
{
    ONEMessage *message = [EaseSDKHelper sendLocationMessageWithLatitude:latitude
                                                            longitude:longitude
                                                              address:address
                                                                   to:self.conversation.conversationId
                                                          messageType:[self _messageTypeFromConversationType]
                                                           messageExt:nil];
    [self _sendMessage:message];
}

- (void)sendImageMessageWithData:(NSData *)imageData
{
    ONEMessage *message = [EaseSDKHelper sendImageMessageWithImageData:imageData
                                                                   to:self.conversation.conversationId
                                                          messageType:[self _messageTypeFromConversationType]
                                                           messageExt:nil];
    [self _sendMessage:message];
}

- (void)sendImageMessage:(UIImage *)image
{
    
    ONEMessage *message = [EaseSDKHelper sendImageMessageWithImage:image
                                                             to:self.conversation.conversationId
                                                    messageType:[self _messageTypeFromConversationType]
                                                     messageExt:nil];
    [self _sendMessage:message];
}

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration
{
    
    ONEMessage *message = [EaseSDKHelper sendVoiceMessageWithLocalPath:localPath
                                                           duration:duration
                                                                 to:self.conversation.conversationId
                                                        messageType:[self _messageTypeFromConversationType]
                                                         messageExt:nil];
    [self _sendMessage:message];
}



#pragma mark - notifycation
- (void)didBecomeActive
{

}

- (void)hideImagePicker
{
    if (_imagePicker && [EaseSDKHelper shareHelper].isShowingimagePicker) {
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - private
- (void)_reloadTableViewDataWithMessage:(ONEMessage *)message
{
    if ([self.conversation.conversationId isEqualToString:message.conversationId])
    {
        for (int i = 0; i < self.dataArray.count; i ++) {
            id object = [self.dataArray objectAtIndex:i];
            if ([object isKindOfClass:[EaseMessageModel class]]) {
                id<IMessageModel> model = object;
                if ([message.messageId isEqualToString:model.messageId]) {
                    id<IMessageModel> model = nil;
                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
                        model = [self.dataSource messageViewController:self modelForMessage:message];

                    }
                    else{
                        model = [[EaseMessageModel alloc] initWithMessage:message];
                        model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
                        model.failImageName = @"imageDownloadFail";
                    }
                    model.exceedImage = [[UIImage imageNamed:@"img_download_fail"] addContextToImage:NSLocalizedString(@"img_overdue", @"")];
                    [self.tableView beginUpdates];
                    [self.dataArray replaceObjectAtIndex:i withObject:model];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView endUpdates];
                    break;
                }
            }
        }
    }
}

- (NSArray*)_searchAtTargets:(NSString*)text
{
    NSMutableArray *targets = nil;
    if (text.length > 1) {
        targets = [NSMutableArray array];
        NSArray *splits = [text componentsSeparatedByString:@"@"];
        if ([splits count]) {
            for (NSString *split in splits) {
                if (split.length) {

                    for (EaseAtTarget *target in self.atTargets) {
                        if ([target.userId length]) {
                            if ([split hasPrefix:target.userId] || (target.nickname && [split hasPrefix:target.nickname])) {
                                [targets addObject:target.userId];
                                [self.atTargets removeObject:target];
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    return targets;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    if (bottomOffset - KSCROLL_BOTTOM <= height)
    {
        //在最底部
        self.currentIsInBottom = YES;
        
        if (_msgRemind) {
            _unReadMsgCount = 0;
            [self hideMsgRemindBtn];
        }
    } else
    {
        self.currentIsInBottom = NO;
    }
}

#pragma mark - 新消息提示

- (UIButton *)msgRemind
{
    if (!_msgRemind) {
        
        _msgRemind = [UIButton buttonWithType:UIButtonTypeCustom];
        [_msgRemind setBackgroundImage:[UIImage imageNamed:@"Msg_scroll"] forState:UIControlStateNormal];
        _msgRemind.titleLabel.font = KMSG_REMIND_FONT;
        _msgRemind.titleEdgeInsets = UIEdgeInsetsMake(0, WidthScale(25), 0, 0);
        [_msgRemind setTitleColor:[UIColor colorWithHex:THEME_COLOR] forState:UIControlStateNormal];
        [_msgRemind setTitle:[NSString stringWithFormat:@"%lu%@",_unReadMsgCount,NSLocalizedString(@"new_chat_message_num", @"New Messages")] forState:UIControlStateNormal];
        _msgRemind.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_msgRemind addTarget:self action:@selector(scrollToBottom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _msgRemind;
}


- (void)showMsgRemindBtn
{
    if (_msgRemind == nil) {
        CGFloat height = HeightScale(480);
        if (self.conversation.type == ONEConversationTypeGroupChat && self.chatGroup.isPublicGroup) {
            height -= 60;
        }
        [self.msgRemind setFrame:CGRectMake(KScreenW, height, KMSG_REMIND_WIDTH, KMSG_REMIND_HEIGHT)];
        [self.view addSubview:self.msgRemind];
        [UIView animateWithDuration:KMSG_REMIND_DURATION animations:^{
            
            self.msgRemind.x = KScreenW - KMSG_REMIND_WIDTH;
        }];
    } else {
        
        [self.msgRemind setTitle:[NSString stringWithFormat:@"%lu%@",_unReadMsgCount,NSLocalizedString(@"new_chat_message_num", @"New Messages")] forState:UIControlStateNormal];
    }

}

- (void)hideMsgRemindBtn
{
    KLog(@"LF_LOG:隐藏滚动到底部的按钮");
    [UIView animateWithDuration:KMSG_REMIND_DURATION animations:^{
        
        self.msgRemind.x = KScreenW;
    } completion:^(BOOL finished) {
        
        [self.msgRemind removeFromSuperview];
        _msgRemind = nil;
    }];

}

- (void)scrollToBottom {
    
    _unReadMsgCount = 0;
    [self scrollToTheLatestMsg];
}


#pragma mark - Test Code
- (UIButton *)new_msgRemind
{
    if (!_new_msgRemind) {
        
        _new_msgRemind = [UIButton buttonWithType:UIButtonTypeCustom];
        [_new_msgRemind setBackgroundImage:[UIImage imageNamed:@"Msg_scroll_up"] forState:UIControlStateNormal];
        _new_msgRemind.titleLabel.font = KMSG_REMIND_FONT;
        _new_msgRemind.titleEdgeInsets = UIEdgeInsetsMake(0, WidthScale(25), 0, 0);
//        [_new_msgRemind setTitleColor:[UIColor colorWithHex:THEME_COLOR] forState:UIControlStateNormal];
        _new_msgRemind.themeMap = @{
                                    TextColorName:@"theme_color"
                                    };
        [_new_msgRemind setTitle:[NSString stringWithFormat:@"%lu%@",_new_unreadMsgCount,NSLocalizedString(@"new_chat_message_num", @"New Messages")] forState:UIControlStateNormal];
        [_new_msgRemind addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _new_msgRemind;
}

- (void)scrollToTop
{
    [self _loadMessagesBefore:nil count:_new_unreadMsgCount append:NO scroll:YES];
}

- (void)hideNew_MsgRemindBtn
{
    _new_unreadMsgCount = 0;
    [UIView animateWithDuration:KMSG_REMIND_DURATION animations:^{
        
        self.new_msgRemind.x = KScreenW;
    } completion:^(BOOL finished) {
        
        [self.new_msgRemind removeFromSuperview];
        _new_msgRemind = nil;
    }];
    
}

#pragma mark - 附件下载

- (void)messageAttchmentDownloaded:(NSNotification *)notification
{
    @synchronized(self) {
        
        id object = notification.object;
        if ([object isKindOfClass:[ONEMessage class]]) {
            
            ONEMessage *msg = (ONEMessage *)object;
            
            [self _reloadTableViewDataWithMessage:msg];
        }
    }
    
}

- (NSArray *)photosFromMessageSource
{
    __block NSMutableArray *mPhotos = [NSMutableArray array];
    if (!_imageSources) {
        _imageSources = [NSMutableArray array];
    }
    [_imageSources removeAllObjects];
    [self.messsagesSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ONEMessage class]]) {
            ONEMessage *msg = (ONEMessage *)obj;
            ONEMessageBody *body = msg.body;
            if (body.type == ONEMessageBodyTypeImage) {
                
                [_imageSources addObject:msg];
                NSString *remotePath = ((ONEImageMessageBody *)body).remotePath;
                NSString *localPath = ((ONEImageMessageBody *)body).localPath;
                if ([remotePath length] > 0 || [localPath length] > 0) {
                    
                    NSString *p_localPath = [ONEChatClient localPathFromRemotePath:remotePath];
                    if ([p_localPath length] == 0) {
                        p_localPath = localPath;
                    }
                    UIImage *image = [UIImage imageWithContentsOfFile:p_localPath];
                    if (!image) {
                        [mPhotos addObject:@"error"];
                    } else {
                        [mPhotos addObject:image];
                    }
                } else {
                    [mPhotos addObject:@"error"];
                }
            }
        }
        
    }];
    NSArray *photos = [NSArray arrayWithArray:mPhotos];
    return photos;
}

- (void)showImage:(UIImage *)image model:(id<IMessageModel>)model
{
    if (image == nil) {
        return;
    }
    NSArray *photos = [self photosFromMessageSource];
    if (photos != nil && [photos count] > 0) {
        
        NSInteger index = [_imageSources indexOfObject:model.message];
        if (index >= 0 && index < [photos count]) {
            [[EaseMessageReadManager defaultManager] showBrowserWithImages:photos atIndex:index];
        } else {
            [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[image]];
        }
    } else {
        [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[image]];
    }
}


#pragma mark - ONECommunityToolBarDelegate

- (void)didChangeToChatStyle:(ONECommunityToolBar *)toolBar
{
    [UIView animateWithDuration:0.05 animations:^{
        [toolBar setY:KScreenH];
        [(EaseChatToolbar *)self.chatToolbar setY:(self.view.frame.size.height - [EaseChatToolbar defaultHeight] - iPhoneX_BOTTOM_HEIGHT)];
    }];
}

- (void)didCommunityButtonClicked:(ONECommunityToolBar *)toolBar
{
    ONECommunityController *communityVC = [[ONECommunityController alloc] initWithGroup_uid:self.conversation.conversationId];
    [self.navigationController pushViewController:communityVC animated:YES];
}

#pragma mark - 点击头像处理

- (PersonMenuType)personMenuTypeFromRoleType:(GroupRoleType)roleType
{
    if (roleType == GroupRoleType_Member) {
        return PersonMenuType_Member;
    } else if (roleType == GroupRoleType_Admin) {
        return PersonMenuType_Admin;
    } else if (roleType == GroupRoleType_Owner) {
        return PersonMenuType_Owner;
    } else {
        return PersonMenuType_Member;
    }
}

- (void)showPersonMenu
{
    [self.view endEditing:YES];
    
    if (!_personMenu) {
        
        _personMenuCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        _personMenuCover.backgroundColor = [UIColor clearColor];
        _personMenuCover.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePersonMenu)];
        [_personMenuCover addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:_personMenuCover];

        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _personMenu = [[ONEPersonMenuView alloc] initWithEffect:effect type:[self personMenuTypeFromRoleType:[ONEGroupManager sharedInstance].roleType]];
        _personMenu.delegate = self;
        [_personMenu setFrame:CGRectMake(10, KScreenH, _personMenu.width, _personMenu.height)];
        [[UIApplication sharedApplication].keyWindow addSubview:_personMenu];
        CGFloat originY = [_personMenu heightFromPersonMenuType:[self personMenuTypeFromRoleType:[ONEGroupManager sharedInstance].roleType]] + 10;
        [UIView animateWithDuration:0.5 animations:^{
            
            [_personMenu setY:(KScreenH - originY)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)hidePersonMenu
{
    if (_personMenu) {
        
        [UIView animateWithDuration:0.5 animations:^{
            [_personMenuCover setHidden:YES];
            [_personMenu setY:KScreenH];
        } completion:^(BOOL finished) {
            
            [_personMenuCover removeFromSuperview];
            [_personMenu removeFromSuperview];
            _personMenuCover = nil;
            _personMenu = nil;
        }];
    }
}

- (void)personalCenterAction
{
    [self hidePersonMenu];
    LZContactsDetailTableViewController *detailVC = [[LZContactsDetailTableViewController alloc] initWithBuddy:_selectedModel.message.from];
    detailVC.canSendMsg = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    _selectedModel = nil;
}

- (void)userBeingAted
{
    [self hidePersonMenu];
    [self handleWithAtAction];
    _selectedModel = nil;
}

- (void)userBeingSetAdmin
{
    [self hidePersonMenu];
    
    __weak typeof(self) weakself = self;
    NSString *memberId = _selectedModel.message.from;
    if (![memberId isAccountId]) {
        memberId = [ONEChatClient accountIdWithName:memberId];
    }
    
    [[ONEChatClient sharedClient] addMemberToAdminList:memberId groupId:self.conversation.conversationId completion:^(ONEError *error) {
        
        if (!error) {
            
            [weakself showHint:NSLocalizedString(@"set_admin_success", @"")];
            [weakself.roleTypeCache setObject:@"1" forKey:memberId];
            [weakself.tableView reloadData];
        } else {

            if (error.errorCode == ONEErrorInsufficientPrivilege) {
                [weakself showHint:NSLocalizedString(@"limits_of_authority", @"")];
            } else if (error.errorCode == ONEErrorUserNotInGroup) {
                [weakself showHint:NSLocalizedString(@"user_not_in_group", @"")];
            } else if (error.errorCode == ONEErrorAdminsCountExceed) {
                [weakself showHint:NSLocalizedString(@"admin_counts_limit", @"")];
            } else {
                [weakself showHint:NSLocalizedString(@"error", @"")];
            }
        }
    }];
}

- (void)userBeingMuted
{
    [self hidePersonMenu];
    NSString *memberId = _selectedModel.message.from;
    if (![memberId isAccountId]) {
        memberId = [ONEChatClient accountIdWithName:memberId];
    }
    __weak typeof(self) weakself = self;
    
    [[ONEChatClient sharedClient] muteMember:memberId groupId:self.conversation.conversationId completion:^(ONEError *error) {
       
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

}

- (void)userBeingRemoved
{
    [self hidePersonMenu];
    [self deleteGroupMember:_selectedModel];
}

- (void)userBeingAddToBlackList
{
    [self hidePersonMenu];
    NSString *memberId = _selectedModel.message.from;
    if (![memberId isAccountId]) {
        memberId = [ONEChatClient accountIdWithName:memberId];
    }
    __weak typeof(self) weakself = self;
    [[ONEChatClient sharedClient] addMemberToBlackList:memberId groupId:self.conversation.conversationId completion:^(ONEError *error) {
        if (!error) {
            [weakself showHint:NSLocalizedString(@"add_member_to_blacklist_success", @"")];
        } else {
            [weakself showHint:NSLocalizedString(@"error", @"")];
        }

    }];
}

- (void)cancelAction
{
    [self hidePersonMenu];
    _selectedModel = nil;
}

- (void)handleWithAtAction
{
    if (_selectedModel == nil) {
        return;
    }
    WSAccountInfo *accountInfo = nil;
    NSString *account_id = _selectedModel.message.from;
    if ([account_id isAccountId]) {
        accountInfo = [ONEChatClient accountInfoWithId:account_id];
    } else {
        accountInfo = [ONEChatClient accountInfoWithName:account_id];
    }
    if (accountInfo == nil) {
        return;
    }
    EaseAtTarget *target = [[EaseAtTarget alloc] initWithUserId:accountInfo.ID andNickname:accountInfo.accountNickName];
    [self.atTargets addObject:target];
    NSString *accountNick = accountInfo.accountNickName;
    NSString *insertStr = [NSString stringWithFormat:@"@%@ ",accountNick];
    EaseChatToolbar *toolbar = (EaseChatToolbar *)self.chatToolbar;
    NSMutableString *originStr = [toolbar.inputTextView.text mutableCopy];
    NSUInteger insertLocation = originStr.length;
    [originStr insertString:insertStr atIndex:insertLocation];
    if ([toolbar.inputTextView.text length] > KMAX_INPUT_COUNT) {
        [toolbar inputViewTextExceed:YES];
        return;
    }
    [toolbar inputViewTextExceed:NO];
    toolbar.inputTextView.text = originStr;
    toolbar.inputTextView.selectedRange = NSMakeRange(insertLocation + insertStr.length, 0);
    [toolbar.inputTextView becomeFirstResponder];
}

- (void)deleteGroupMember:(id<IMessageModel>)model
{
    NSString *accountId = EMPTY_STR;
    NSString *member = model.message.from;
    if ([[member componentsSeparatedByString:@"."] count] != 3) {
        
        accountId = [ONEChatClient accountIdWithName:member];
    } else {
        
        accountId = member;
    }
    __weak typeof(self) weakself = self;
    
    [[ONEChatClient sharedClient] removeOccupants:@[accountId] fromGroup:self.conversation.conversationId completion:^(ONEError *error, NSArray *removedOccupants) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                [weakself showHint:NSLocalizedString(@"delete_success", @"")];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GROUPSUBJECT_UPDATED object:nil];
            } else {
                [weakself showHint:NSLocalizedString(@"group_deletecontact_failed", @"")];
            }
        });
    }];

}

#pragma mark - AT All

- (void)handleWithAtAllAction
{
    EaseAtTarget *target = [[EaseAtTarget alloc] initWithUserId:@"-1" andNickname:NSLocalizedString(@"all_member", @"")];
    [self.atTargets addObject:target];
    NSString *insertStr = [NSString stringWithFormat:@"@%@ ",target.nickname];
    EaseChatToolbar *toolbar = (EaseChatToolbar *)self.chatToolbar;
    NSMutableString *originStr = [toolbar.inputTextView.text mutableCopy];
    NSUInteger insertLocation = originStr.length;
    [originStr insertString:insertStr atIndex:insertLocation];
    toolbar.inputTextView.text = originStr;
    toolbar.inputTextView.selectedRange = NSMakeRange(insertLocation + insertStr.length, 0);
    [toolbar.inputTextView becomeFirstResponder];
}


@end
