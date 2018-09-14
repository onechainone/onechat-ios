//
//  GroupChatSegmentController.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/16.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "GroupChatSegmentController.h"
#import "LBSegmentControl.h"
#import "ONECommunityController.h"
#import "ChatViewController.h"
#import "ONEGroupManager.h"
#import "ChatGroupDetailViewController.h"

@interface GroupChatSegmentController ()

@property (nonatomic, copy) NSString *conversationChatter;

@property (nonatomic, assign) ONEConversationType type;

@property (nonatomic, strong) GroupInformation *oneGroup;
@property (nonatomic, strong) ChatViewController *chat;
@end

@implementation GroupChatSegmentController

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(ONEConversationType)conversationType
{
    self = [super init];
    if (self) {
        _conversationChatter = conversationChatter;
        _type = conversationType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _chat = [[ChatViewController alloc] initWithConversationChatter:_conversationChatter conversationType:_type];
    
    ONECommunityController *communityVC = [[ONECommunityController alloc] initWithGroup_uid:_conversationChatter];
    
    LBSegmentControl * segmentControl = [[LBSegmentControl alloc] initStaticTitlesWithFrame:CGRectMake(0, 0, KScreenW, 40)];

    segmentControl.titles = @[NSLocalizedString(@"group_chat", nil)
                              , NSLocalizedString(@"group_community", nil)];
    segmentControl.viewControllers = @[_chat, communityVC];
    
    segmentControl.titleNormalColor = [UIColor lightGrayColor];
    segmentControl.titleSelectColor = [UIColor blackColor];
    segmentControl.themeMap = @{
                                BGColorName:@"segment_bg_color"
                                };
    [segmentControl setBottomViewColor:[UIColor redColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVC:) name:NOTIFICATION_SEGMENT_CHANGE object:nil];
    [self.view addSubview:segmentControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupTitle) name:NOTIFICATION_GROUPSUBJECT_UPDATED object:nil];
    [self setupRightItem];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:THMImage(@"nav_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//    [self removeExistChatVC];
}

- (void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)changeVC:(NSNotification *)noti
{
    [_chat.view endEditing:YES];
}

- (void)removeExistChatVC
{
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    [vcs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[ChatViewController class]]) {
            [vcs removeObject:obj];
            *stop = YES;
        }
        
        if ([obj isKindOfClass:[GroupChatSegmentController class]] && (idx != [vcs count] - 1)) {
            [vcs removeObject:obj];
            *stop = YES;
        }
    }];
    self.navigationController.viewControllers = vcs;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_type == ONEConversationTypeGroupChat) {
        [self updateGroupTitle];
    }

}

- (void)updateGroupTitle
{
    ONEChatGroup *oneGroup = [[ONEChatClient sharedClient] groupChatWithGroupId:self.conversationChatter];
    
    self.title = [NSString stringWithFormat:@"%@(%lu)",oneGroup.name,oneGroup.memberSize];
}

- (void)setupRightItem
{
    [self updateGroupTitle];
    
    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    detailButton.accessibilityIdentifier = @"detail";
    [detailButton setImage:THMImage(@"group_detail_icon") forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
}

- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    
    if (_type == ONEConversationTypeGroupChat) {
        ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:_conversationChatter];
        detailController.sendGroupMsg = ^(NSString *msg, NSString *groupId) {
            
            if (![groupId isEqualToString:weakSelf.conversationChatter]) {
                
                return;
            }
            [weakSelf.chat sendTextMessage:msg];
        };
        [weakSelf.navigationController pushViewController:detailController animated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GROUPSUBJECT_UPDATED object:nil];
    [_chat removeChatDelegate];
}






@end
