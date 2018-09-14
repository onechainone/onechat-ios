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

#import "ChatGroupDetailViewController.h"

#import "ContactSelectionViewController.h"
#import "ContactView.h"

#import "ONEAddMemberViewController.h"
#import <ShareSDKUI/ShareSDKUI.h>
#import "UserProfileManager.h"
#import "LZContactsDetailTableViewController.h"
#import "ChatGroupQRcodeViewController.h"
#import "DKSHTMLController.h"
#import "ONEGroupManager.h"
#import "ONEGroupAllMembersController.h"

#import "GroupSubjectChangingViewController.h"
#pragma mark - ChatGroupDetailViewController

#define kColOfRow 4
#define kContactSize ((self.view.frame.size.width - 20) / 4)
#define KMEMBER_SHOW_COUNT 16

@interface ChatGroupDetailViewController ()<EMChooseViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)unregisterNotifications;
- (void)registerNotifications;


@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *addButton;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *exitButton;
@property (strong, nonatomic) UIButton *configureButton;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) UITapGestureRecognizer *tapPress;

@property (strong, nonatomic) ContactView *selectedContact;

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, strong) ONEChatGroup *grInfomation;
@property (nonatomic, strong) UIImageView *groupAvatarView;
@property (nonatomic, copy) NSString *groupSubject;
@property (nonatomic, copy) NSString *groupShareUrl;

@property (nonatomic, strong) NSMutableArray *memberList;

@property (nonatomic, strong) UIButton *showAllBtn;
@property (nonatomic,strong)UISwitch *recevieswitch;
///disturbingSwitch
@property (nonatomic,strong)UISwitch *disturbingSwitch;
//IDLabel 群IDLAbel
@property (nonatomic,strong)UILabel *IDLAbel;
///获取到的群iD
@property (nonatomic,copy)NSString *qunIDStr;
//群简介
@property (nonatomic,copy)NSString *qunDesStr;

@property (nonatomic, strong) UIImageView *imgBtn;

@property (nonatomic, strong) NSMutableSet *adminsSet;

@property (nonatomic, assign) GroupRoleType myRole;

- (void)dissolveAction;
- (void)clearAction;
- (void)exitAction;

@end

@implementation ChatGroupDetailViewController

- (void)registerNotifications {
    [self unregisterNotifications];
}

- (void)unregisterNotifications {
}


- (void)dealloc {
    [self unregisterNotifications];
}

- (NSMutableArray *)memberList
{
    if (!_memberList) {
        
        _memberList = [NSMutableArray array];
    }
    return _memberList;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableSet *)adminsSet
{
    if (!_adminsSet) {
        
        _adminsSet = [NSMutableSet set];
    }
    return _adminsSet;
}

- (UIImageView *)groupAvatarView
{
    if (!_groupAvatarView) {
        
        UIImage *image = [UIImage imageNamed:@"groupPublicHeader"];
        _groupAvatarView = [[UIImageView alloc] init];
        _groupAvatarView.image = image;
        [_groupAvatarView sizeToFit];
        _groupAvatarView.layer.cornerRadius = CGRectGetWidth(_groupAvatarView.frame) / 2;
        _groupAvatarView.layer.masksToBounds = YES;
    }
    return _groupAvatarView;
}

- (UIButton *)showAllBtn
{
    if (!_showAllBtn) {
        
        _showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showAllBtn setTitle:NSLocalizedString(@"look_all_group_members", @"") forState:UIControlStateNormal];
        _showAllBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _showAllBtn.themeMap = @{
                                 TextColorName:@"conversation_title_color"
                                 };
        [_showAllBtn addTarget:self action:@selector(showAllMembers:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showAllBtn;
}




- (instancetype)initWithGroupId:(NSString *)chatGroupId
{
    self = [super init];
    if (self) {
        
        _groupId = chatGroupId;
        
        _myRole = GroupRoleType_Member;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH) style:UITableViewStyleGrouped];
    self.tableView.themeMap = @{
                                BGColorName:@"bg_white_color",
                                TableSepColorName:@"conversation_line_color"
                                };
    self.tableView.tableFooterView = self.footerView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupBansChanged) name:@"GroupBansChanged" object:nil];
    
    [self fetchMyGroupInfo];

    ///加载群信息
    [self loadGroupInfo];
    
    [self getAdmins];
    
}
-(void)loadGroupInfo {
    
    kWeakSelf
    [[ONEChatClient sharedClient] getGroupIndexInformation:_groupId completion:^(ONEError *error, ONEChatGroup *group) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                weakself.grInfomation = group;
                weakself.qunIDStr = [NSString stringWithFormat:@"%lu",weakself.grInfomation.indexInformation.groupIndexId];
                weakself.qunDesStr = weakself.grInfomation.indexInformation.groupDesc;
                [weakself.tableView reloadData];
            }
        });
    }];
}

- (void)getAdmins {
    
    [self.adminsSet removeAllObjects];
    kWeakSelf
    [[ONEChatClient sharedClient] getGroupAdminList:_groupId completion:^(ONEError *error, NSArray *list) {
       
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([list count] > 0) {
                    [ONEGroupManager cacheGroupAdmis:list groupId:_groupId];
                    [weakself.adminsSet addObjectsFromArray:list];
                    if ([weakself.adminsSet containsObject:[ONEChatClient homeAccountId]]) {
                        if (weakself.myRole == GroupRoleType_Member) {
                            weakself.myRole = GroupRoleType_Admin;
                        }
                    } else {
                        if ([weakself.grInfomation.owner isEqualToString:[ONEChatClient homeAccountId]]) {
                            weakself.myRole = GroupRoleType_Owner;
                        }
                    }
                    [weakself refreshScrollView];
                } else {
                    
                    if ([weakself.grInfomation.owner isEqualToString:[ONEChatClient homeAccountId]]) {
                        weakself.myRole = GroupRoleType_Owner;
                    }
                }
            });
        } else {
            NSArray *cachedList = [ONEGroupManager groupAdminsWithGroupId:weakself.grInfomation.groupId];
            if ([cachedList count] > 0) {
                [weakself.adminsSet addObjectsFromArray:cachedList];
                if ([weakself.adminsSet containsObject:[ONEChatClient homeAccountId]]) {
                    if (weakself.myRole == GroupRoleType_Member) {
                        weakself.myRole = GroupRoleType_Admin;
                    }
                } else {
                    if ([weakself.grInfomation.owner isEqualToString:[ONEChatClient homeAccountId]]) {
                        weakself.myRole = GroupRoleType_Owner;
                    }
                }
                [weakself refreshScrollView];
            } else {
                
                if ([weakself.grInfomation.owner isEqualToString:[ONEChatClient homeAccountId]]) {
                    weakself.myRole = GroupRoleType_Owner;
                }
            }

        }
    }];


}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (NSString *)localLaungage
{
    NSString *language = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] && ![[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:@""])
    {
        language = [[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE];
    } else {
        
        language = [[CoinTools sharedCoinTools] getPreferredLanguage];
    }
    return language;
}

- (void)fetchMyGroupInfo
{
    if (_groupId.length <= 0) {
        
        return;
    }
    // 获取群组信息
    NSString *language = [self localLaungage];
    
    _groupShareUrl = [ONEUrlHelper groupShareUrlWithGroupId:_groupId];
    _grInfomation = [[ONEChatClient sharedClient] groupChatWithGroupId:_groupId];
    
    NSString *owner = _grInfomation.owner;
    NSString *homeId = [ONEChatClient homeAccountId];
    if ([owner isEqualToString:homeId]) {
        _myRole = GroupRoleType_Owner;
    }
    _groupSubject = _grInfomation.name;
    self.title = [NSString stringWithFormat:NSLocalizedString(@"chat_info", @"Chat info(%d)"),_grInfomation.memberSize];
    [self showHudInView:self.view hint:nil];
    [self.memberList removeAllObjects];
    __weak typeof(self)weakself = self;
    
    
    [[ONEChatClient sharedClient] getMemberListFromGroup:_groupId completion:^(ONEError *error, NSArray *list) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakself hideHud];
            if (!error) {
                NSArray *sortedList = [weakself sortedGroupMembers:list];
                [weakself reloadMembers:sortedList];
                [weakself.memberList addObjectsFromArray:sortedList];
            } else {
                [weakself showHint:NSLocalizedString(@"group_member_list_fail", @"获取群成员失败")];
            }
        });
    }];
}

- (NSArray *)sortedGroupMembers:(NSArray *)memberList {
    
    if (memberList.count == 0) return nil;
    
    NSMutableArray *mMemberList = [NSMutableArray arrayWithArray:memberList];
    
    [mMemberList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:self.grInfomation.owner]) {
            [mMemberList removeObject:obj];
            [mMemberList insertObject:obj atIndex:0];
            *stop = YES;
        }
    }];
    NSArray *sortedList = [NSArray arrayWithArray:mMemberList];
    
    return sortedList;
}

- (void)reloadMembers:(NSArray *)members
{
    NSArray *subArray = [NSArray array];
    
    if (members.count > KMEMBER_SHOW_COUNT) {
        
        subArray = [members subarrayWithRange: NSMakeRange(0, KMEMBER_SHOW_COUNT - 1)];
    } else {
        
        subArray = members;
    }
    NSArray *needFetchList = [self serverGroupMemberList:subArray];
    
    [self reloadDataSource:subArray];
    __weak typeof(self) weakself = self;
    
    [[ONEChatClient sharedClient] pullAccountInfosWithAccountIdList:needFetchList completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            [weakself reloadDataSource:subArray];
        });
    }];
    
}

- (void)updateTitle:(int)count
{
    self.title = [NSString stringWithFormat:NSLocalizedString(@"chat_info", @"chat_info(%d)"),count];
}

- (void)updateTitle
{
    _grInfomation = [[ONEChatClient sharedClient] groupChatWithGroupId:_groupId];
    self.title = [NSString stringWithFormat:NSLocalizedString(@"chat_info", @"Chat info(%d)"),_grInfomation.memberSize];
}

- (void)reloadUI:(NSNotification *)noti
{
    [self fetchMyGroupInfo];
}
#pragma mark - getter

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, kContactSize)];
        _scrollView.tag = 0;
        _scrollView.themeMap = @{
                                 BGColorName:@"bg_white_color"
                                 };
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kContactSize - 10, kContactSize - 10)];
        _addButton.accessibilityIdentifier = @"add_member";
        [_addButton setImage:[UIImage imageNamed:@"group_participant_add"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"group_participant_addHL"] forState:UIControlStateHighlighted];
        [_addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
        
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteContactBegin:)];
        _longPress.minimumPressDuration = 0.5;
        
        _tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];

    }
    
    return _scrollView;
}


- (UIButton *)exitButton
{
    if (_exitButton == nil) {
        _exitButton = [[UIButton alloc] init];
        _exitButton.accessibilityIdentifier = @"leave";
        [_exitButton setTitle:NSLocalizedString(@"out_chat_group", @"") forState:UIControlStateNormal];
        _exitButton.themeMap = @{
                                 BGColorName:@"theme_color",
                                 TextColorName:@"theme_title_color"
                                 };
        [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exitButton;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 160)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        self.exitButton.frame = CGRectMake(20, 40, _footerView.frame.size.width - 40, 35);
        [_footerView addSubview:self.exitButton];

    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.grInfomation.isPublicGroup ? 6 : 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 90;
    } else{
        return 1;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [self setupHeader];
    }
    else{
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 1)];
        view.backgroundColor = [UIColor clearColor];
        return view ;
    }
}
-(UIView *)setupHeader{
    UIView *headerView =[UIView new];
    headerView.themeMap = @{
                            BGColorName:@"bg_white_color"
                            };
    
    _imgBtn = [UIImageView new];
    [headerView addSubview:_imgBtn];
    [_imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFT_SPACE);
        make.centerY.offset(0);
        make.width.offset(60);
        make.height.offset(60);
        
    }];
    _imgBtn.layer.cornerRadius = 30;
    _imgBtn.layer.masksToBounds = YES;
    NSString *groupUrl = _grInfomation.groupAvatarUrl;
    [_imgBtn sd_setImageWithURL:[NSURL URLWithString:groupUrl] placeholderImage:[UIImage imageNamed:@"group_default_avatar"]];
    _imgBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseGroupAvatar:)];
    [_imgBtn addGestureRecognizer:tap];
    
    UILabel *nameLabel = [UILabel makeLabelWithTextColor:[UIColor blackColor] andTextFont:LABEL_MID_FRONT andContentText:_groupSubject];
    nameLabel.themeMap = @{
                           TextColorName:@"common_text_color"
                           };
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgBtn.mas_right).offset(15);
        make.top.offset(24);
        make.width.offset(KScreenW-LEFT_SPACE-60-15-RIGHT_SPACE);
    }];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [nameLabel sizeToFit];
    NSString *str = @"";

    if (!self.qunIDStr||self.qunIDStr.length<=0) {
        
    } else{
    str = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"group_id", @"群ID"),self.qunIDStr];
    }

    UILabel *IDLabel = [UILabel makeLabelWithTextColor:[UIColor blackColor] andTextFont:LITTLE_LABEL_FRONT andContentText:str];
    IDLabel.themeMap = @{
                         TextColorName:@"common_text_color"
                         };
    self.IDLAbel = IDLabel;
    [headerView addSubview:IDLabel];
    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left).offset(0);
        make.top.equalTo(nameLabel.mas_bottom).offset(3);
    }];
    
    return headerView;
    
}

- (void)chooseGroupAvatar:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        
        // todo
        if ([ONEGroupManager sharedInstance].roleType != GroupRoleType_Owner) {
            return;
        }
        [self showImagePicker];
    }
}

- (void)showImagePicker
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(5,KScreenH-100,KScreenW-10,100);
    
    //按钮：拍照，类型：UIAlertActionStyleDefault //attach_take_pic
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"attach_take_pic", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        PickerImage.allowsEditing = YES;
        
        PickerImage.delegate = self;
        
        [self presentViewController:PickerImage animated:YES completion:nil];
        
    }]];
    
    
    //按钮：从相册选择，类型：UIAlertActionStyleDefault gallery
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"gallery", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        
        //自代理
        PickerImage.delegate = self;
        
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    //按钮：取消，类型：UIAlertActionStyleCancel cancel
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
    UIImage *scaleImage = [image imageByScalingAndCroppingForSize:CGSizeMake(100, 100)];
    
    UIImage *newImage = [UIImage scaleImage:image toKb:20];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
    
    [self showHudInView:self.view hint:nil];
    __weak typeof(self)weakself = self;
    
    [[ONEChatClient sharedClient] uploadGroupAvatar:self.grInfomation.groupId imageData:imageData completion:^(ONEError *error, NSString *groupId) {
        [weakself hideHud];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error && [groupId isEqualToString:weakself.grInfomation.groupId]) {
                [weakself showHint:NSLocalizedString(@"setting.uploadSuccess", @"uploaded successfully")];
                __strong ChatGroupDetailViewController *strongself = weakself;
                [[ONEChatClient sharedClient] syncGroupChatInfo:^(ONEError *error) {
                   
                    strongself.grInfomation = [[ONEChatClient sharedClient] groupChatWithGroupId:strongself.grInfomation.groupId];
                    [_imgBtn sd_setImageWithURL:[NSURL URLWithString:strongself.grInfomation.groupAvatarUrl] placeholderImage:[UIImage imageNamed:@"group_default_avatar"]];
                }];
            } else {
                [weakself showHint:NSLocalizedString(@"setting.uploadFail", @"uploaded failed")];
            }
        });
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    // Configure the cell...
//    if (cell == nil) {
      UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    }
    cell.themeMap = @{
                      BGColorName:@"bg_white_color"
                      };
    cell.textLabel.themeMap = @{
                                TextColorName:@"conversation_title_color"
                                };
    cell.detailTextLabel.themeMap = @{
                                      TextColorName:@"conversation_detail_color"
                                      };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.scrollView];
    }
    else if(indexPath.row == 1) {
        ///群管理
        cell.textLabel.text = NSLocalizedString(@"group_manage", @"");
    }
    else if(indexPath.row == 2) {
        ///群名称
        cell.textLabel.text = NSLocalizedString(@"group_detail_name", @"Group name");
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = _groupSubject;
    }

    else if(indexPath.row == 3) {
        ///群二维码
        if (_grInfomation.isPublicGroup) {
            cell.textLabel.text = NSLocalizedString(@"group_qr_code", @"");
        } else {
            cell.textLabel.text = NSLocalizedString(@"group_notice", @"");
        }
    }
    else if(indexPath.row == 4) {
        ///群公告

        cell.textLabel.text = NSLocalizedString(@"group_notice", @"");
    }
    else if(indexPath.row == 5) {
        //群分享
        cell.textLabel.text = NSLocalizedString(@"group_detail_share", @"");
        
    }
    
    return cell;
}
- (void)disturbingSwitchvalueChanged:(UISwitch *)sender{
    BOOL isOn = sender.isOn;
    if (isOn) {
        ///开的时候
        [self showHint:@"开"];
    } else {
        [self showHint:@"关"];
    }
}
- (void)valueChanged:(UISwitch *)sender
{
    BOOL isOn = sender.isOn;
    if (isOn) {
        ///开的时候
        [self showHint:@"开"];
    } else {
        [self showHint:@"关"];
    }
    
}
#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    if (row == 0) {
        return self.scrollView.frame.size.height + 40;
    }
    else {
        return 48;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {

        if (self.myRole == GroupRoleType_Member) {
            [self showHint: NSLocalizedString(@"no_auth", @"Only owners can edit")];
            
        }  else {
            
            NSString *str = [ONEUrlHelper groupManagementH5WithGroupId:self.grInfomation.groupId];
            
            DKSHTMLController *htmlVC = [DKSHTMLController new];
            htmlVC.htmlUrl = str;
            [self.navigationController pushViewController:htmlVC animated:YES];
        }
        return;
    } else if(indexPath.row == 2){
        ///群名称
        if (![self.grInfomation.owner isEqualToString:[ONEChatClient homeAccountId]]) {

            [self showHint: NSLocalizedString(@"no_auth", @"Only owners can edit")];
        } else {

            GroupSubjectChangingViewController *changingController = [[GroupSubjectChangingViewController alloc] initWithGroup:self.grInfomation];
            __weak typeof(self) weakself = self;
            changingController.subjectChanged = ^(ONEChatGroup *info) {

                weakself.groupSubject = info.name;
                weakself.grInfomation = info;
                [weakself.tableView reloadData];
            };
            [self.navigationController pushViewController:changingController animated:YES];
        }
    } else if(indexPath.row == 3) {
        ///群二维码
        if (_grInfomation.isPublicGroup) {
            ChatGroupQRcodeViewController *qrVC = [ChatGroupQRcodeViewController new];
            qrVC.group_id = _groupId;
            qrVC.group_name = _groupSubject;
            qrVC.show_group_id = self.qunIDStr;
            qrVC.group_avatar_url = _grInfomation.groupAvatarUrl;
            [self.navigationController pushViewController:qrVC animated:YES];
        } else {
            NSString *str = [ONEUrlHelper groupAnnouncementH5WithGroupId:self.grInfomation.groupId];
            DKSHTMLController *htmlVC = [DKSHTMLController new];
            htmlVC.htmlUrl = str;
            [self.navigationController pushViewController:htmlVC animated:YES];

        }

    } else if (indexPath.row == 4) {
        ///群公告
        NSString *str = [ONEUrlHelper groupAnnouncementH5WithGroupId:self.grInfomation.groupId];
        DKSHTMLController *htmlVC = [DKSHTMLController new];
        htmlVC.htmlUrl = str;
        [self.navigationController pushViewController:htmlVC animated:YES];
        
        return;
    } else if(indexPath.row == 5) {
        ///群分享
        [self shareAction];
        
    }
    
    
    
}
- (void)nameChange:(UITextField *)textfiled {

    
}
- (void)shareAction {
    
    if (_groupShareUrl.length == 0) {
        
        return;
    }
    NSString *shareString = [NSString stringWithFormat:NSLocalizedString(@"group_share_joingroup", @"Click the url to join ONE group:%@"),_groupShareUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:shareString images:[UIImage imageNamed:@"share_icon"] url:[NSURL URLWithString:_groupShareUrl] title:nil type:SSDKContentTypeAuto];
    __weak typeof(self) weakself = self;
    [ShareSDK showShareActionSheet:nil items:nil shareParams:params onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        if (state == SSDKResponseStateFail) {
            
            if (error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakself showHint:NSLocalizedString(@"group_share_failed", @"Share failed")];
                });
            }
        }
    }];
}

- (void)groupBansChanged
{
    [self.dataSource removeAllObjects];
//    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
}

- (NSArray *)serverGroupMemberList:(NSArray *)datasource
{
    if (datasource.count == 0) return @[];
    
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:datasource];
    
    [mArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSString class]]) {
            
            NSString *account_uid = (NSString *)obj;
            
            WSAccountInfo *info = [ONEChatClient accountInfoWithId:account_uid];
            if (info) {
                
                [mArray removeObject:account_uid];
            }
        }
    }];
    
    return [NSArray arrayWithArray:mArray];
}

- (void)reloadDataSource:(NSArray *)datasource
{
    if (datasource.count == 0) {
        
        return;
    }
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:datasource];
    [self refreshScrollView];
    [self refreshFooterView];
    [self hideHud];
}

- (void)refreshScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView removeGestureRecognizer:_longPress];
    [self.scrollView removeGestureRecognizer:_tapPress];
    [self.addButton removeFromSuperview];
    
    BOOL showAddButton = NO;
    if (self.myRole == GroupRoleType_Owner) {
        [self.scrollView addGestureRecognizer:_longPress];
    }
    [self.scrollView addGestureRecognizer:_tapPress];

    [self.scrollView addSubview:self.addButton];
    showAddButton = YES;
    
    int tmp = ([self.dataSource count] + 1) % kColOfRow;
    int row = (int)([self.dataSource count] + 1) / kColOfRow;
    row += tmp == 0 ? 0 : 1;
    self.scrollView.tag = row;
    self.scrollView.frame = CGRectMake(10, 20, self.tableView.frame.size.width - 20, row * kContactSize + 60);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, row * kContactSize + 60);
    
    NSString *loginUsername = [ONEChatClient homeAccountName];
    
    int i = 0;
    int j = 0;
    BOOL isEditing = self.addButton.hidden ? YES : NO;
    BOOL isEnd = NO;
    for (i = 0; i < row; i++) {
        for (j = 0; j < kColOfRow; j++) {
            NSInteger index = i * kColOfRow + j;
            if (index < [self.dataSource count]) {
                NSString *username = [self.dataSource objectAtIndex:index];
                ContactView *contactView = [[ContactView alloc] initWithFrame:CGRectMake(j * kContactSize, i * kContactSize, kContactSize, kContactSize)];
                contactView.index = i * kColOfRow + j;
                contactView.image = [UIImage imageNamed:@"chatListCellHead.png"];
                WSAccountInfo *info = [ONEChatClient accountInfoWithId:username];
                contactView.remark = info.name;
                if ([self isGroupOwner:username]) {
                    contactView.roleTyle = GroupRoleType_Owner;
                } else if ([self isGroupAdmin:username]) {
                    contactView.roleTyle = GroupRoleType_Admin;
                } else {
                    contactView.roleTyle = GroupRoleType_Member;
                }
                if (![info.name isEqualToString:loginUsername]) {
                    contactView.editing = isEditing;
                }
                
                __weak typeof(self) weakSelf = self;
                [contactView setDeleteContact:^(NSInteger index) {
                    
                    NSString *memberUid = [weakSelf.dataSource objectAtIndex:index];
                    if (memberUid == nil) {
                        
                        return;
                    }
                    [weakSelf showHudInView:weakSelf.view hint:nil];
                    
                    [[ONEChatClient sharedClient] removeOccupants:@[memberUid] fromGroup:weakSelf.grInfomation.groupId completion:^(ONEError *error, NSArray *removedOccupants) {
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf hideHud];
                            if (!error) {
                                [weakSelf.dataSource removeObjectAtIndex:index];
                                [weakSelf.memberList removeObject:memberUid];
                                [weakSelf refreshScrollView];
                                [weakSelf updateTitle:(int)weakSelf.dataSource.count];
                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GROUPSUBJECT_UPDATED object:nil];
                            } else {
                                [weakSelf showHint:NSLocalizedString(@"group_deletecontact_failed", @"Delete members failed")];
                            }
                        });
                    }];

                }];
                
                [self.scrollView addSubview:contactView];
            }
            else{
                if(showAddButton && index == self.dataSource.count)
                {
                    self.addButton.frame = CGRectMake(j * kContactSize + 5, i * kContactSize + 10, kContactSize - 10, kContactSize - 10);
                }
                
                isEnd = YES;
                break;
            }
        }
        
        if (isEnd) {
            break;
        }
    }
    [self.showAllBtn setFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) - 60, CGRectGetWidth(self.scrollView.frame), 60)];

    [self.scrollView addSubview:self.showAllBtn];
    
    [self.tableView reloadData];
}

- (BOOL)isGroupOwner:(NSString *)accountId
{
    if ([accountId length] == 0) {
        return NO;
    }
    if ([accountId isEqualToString:_grInfomation.owner]) {
        return YES;
    }
    return NO;
}

- (BOOL)isGroupAdmin:(NSString *)accountId
{
    if ([accountId length] == 0 || [self.adminsSet count] == 0) {
        return NO;
    }
    if ([self.adminsSet containsObject:accountId]) {
        return YES;
    }
    return NO;
}

- (void)refreshFooterView
{
    [_footerView addSubview:self.exitButton];
}

#pragma mark - action

- (void)tapView:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (self.addButton.hidden) {
            [self setScrollViewEditing:NO];
        }
    }
}

- (void)deleteContactBegin:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        NSString *loginUsername = [ONEChatClient homeAccountName];
        for (ContactView *contactView in self.scrollView.subviews)
        {
            CGPoint locaton = [longPress locationInView:contactView];
            if (CGRectContainsPoint(contactView.bounds, locaton))
            {
                if ([contactView isKindOfClass:[ContactView class]]) {
                    if ([contactView.remark isEqualToString:loginUsername]) {
                        return;
                    }
                    _selectedContact = contactView;
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"delete", @"deleting member..."), nil];
                    [sheet showInView:self.view];
                }
            }
        }
    }

//    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSString *loginUsername = [ONEChatClient homeAccountName];
    for (ContactView *contactView in self.scrollView.subviews)
    {
        CGPoint locaton = [tap locationInView:contactView];
        if (CGRectContainsPoint(contactView.bounds, locaton))
        {
            if ([contactView isKindOfClass:[ContactView class]]) {
                if ([contactView.remark isEqualToString:loginUsername]) {
                    return;
                }
                LZContactsDetailTableViewController *contact = [[LZContactsDetailTableViewController alloc] initWithBuddy:contactView.remark];
                contact.canSendMsg = YES;
                [self.navigationController pushViewController:contact animated:YES];
            }
        }
    }
}

- (void)setScrollViewEditing:(BOOL)isEditing
{
    NSString *loginUsername = [ONEChatClient homeAccountName];
    
    for (ContactView *contactView in self.scrollView.subviews)
    {
        if ([contactView isKindOfClass:[ContactView class]]) {
            if ([contactView.remark isEqualToString:loginUsername]) {
                continue;
            }
            
            [contactView setEditing:isEditing];
        }
    }
    
    self.addButton.hidden = isEditing;
}


- (void)addContact:(id)sender
{
    NSSet *set = [NSSet setWithArray:self.memberList];
    ONEAddMemberViewController *oneC = [[ONEAddMemberViewController alloc] initWithBlockSelectedUsernames:set];
    __weak typeof(self)weakSelf = self;
    oneC.addContact = ^(NSArray *sources) {
        
        

        [weakSelf showHudInView:weakSelf.view hint:nil];
        
        [[ONEChatClient sharedClient] addOccupants:sources intoGroup:weakSelf.grInfomation.groupId completion:^(ONEError *error, NSArray *newOccupants) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (!error) {
                    if ([newOccupants count] == 0) {
                        [weakSelf showHint:NSLocalizedString(@"pls_wait_apply", @"")];
                    } else {
                        NSArray *members = [newOccupants copy];
                        NSMutableArray *newMemberIdLis = [NSMutableArray array];
                        for (NSString *info in members) {
    
                            if (info && info.length > 0) {
                                [newMemberIdLis addObject:info];
                                [weakSelf.dataSource addObject:info];
                                [weakSelf.memberList addObject:info];
                            }
                        }
                        [weakSelf refreshScrollView];
                        [weakSelf sendGroupMsg:newMemberIdLis];

                        [weakSelf updateTitle:(int)weakSelf.dataSource.count];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GROUPSUBJECT_UPDATED object:nil];
                    }
                } else {
                    if (error.errorCode == ONEErrorJoinGroupNeedAudit) {
                        [weakSelf showHint:NSLocalizedString(@"pls_wait_examine", @"")];
                    } else {
                        [weakSelf showHint:NSLocalizedString(@"group_addcontact_failed", @"Add members failed")];
                    }
                }
            });
        }];
    };
    [self.navigationController pushViewController:oneC animated:YES];
}

- (void)sendGroupMsg:(NSArray *)source
{
    if (!source || source.count == 0) return;
    
    NSString *inviter = [[UserProfileManager sharedInstance] getNickNameWithUsername:[ONEChatClient homeAccountName]];
    
    NSString *invitees = [self inviteesFromSource:source];
    
    NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"default_groupchat_sentence", @"%@ invite %@ to join group chat!"),inviter, invitees];
    
    !_sendGroupMsg ?: _sendGroupMsg(msg, self.groupId);
    
}

- (NSString *)inviteesFromSource:(NSArray *)source
{
    NSString *string = @"";
    for (NSString *invitee in source) {
        
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",[[UserProfileManager sharedInstance] getNickNameWithUsername:invitee]]];
    }
    if ([string hasSuffix:@"、"]) {
        
        string = [string substringToIndex:string.length - 1];
    }
    return string;
}

//退出群组
- (void)exitAction
{
    [self showHudInView:self.view hint:nil];
    kWeakSelf
    [[ONEChatClient sharedClient] leaveGroup:self.grInfomation.groupId completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [weakself showHint:NSLocalizedString(@"group.leaveFail", @"exit the group failure")];
            }
        });
    }];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger index = _selectedContact.index;
    if (buttonIndex == 0)
    {
        //delete
        _selectedContact.deleteContact(index);
    }
    else if (buttonIndex == 1)
    {
    }
    _selectedContact = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    _selectedContact = nil;
}


#pragma mark - 显示全部群成员
- (void)showAllMembers:(UIButton *)sender
{
    
    ONEGroupAllMembersController *all = [[ONEGroupAllMembersController alloc] initWithGroupId:self.groupId];
    
    __weak typeof(self) weakself = self;
    all.addMember = ^(NSArray *members) {
        
        [weakself.dataSource addObjectsFromArray:members];
        [weakself.memberList addObjectsFromArray:members];
        [weakself sendGroupMsg:members];
        
        [weakself updateTitle:(int)weakself.dataSource.count];

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GROUPSUBJECT_UPDATED object:nil];
        
        [weakself refreshScrollView];
    };
    all.deleteMember = ^(NSString *memberName) {
        
        [weakself.dataSource removeObject:memberName];
        [weakself.memberList removeObject:memberName];
        [weakself updateTitle:(int)weakself.dataSource.count];

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GROUPSUBJECT_UPDATED object:nil];
        
        [weakself refreshScrollView];
    };
    [self.navigationController pushViewController:all animated:YES];
}
@end
