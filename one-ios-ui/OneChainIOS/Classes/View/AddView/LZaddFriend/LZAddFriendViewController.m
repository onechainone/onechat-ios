//
//  LZAddFriendViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/29.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZAddFriendViewController.h"


#import "lhScanQCodeViewController.h"
#import "QRDecoder.h"
#import "ChatViewController.h"
#import "LZContactsDetailTableViewController.h"

@interface LZAddFriendViewController ()
@property (weak, nonatomic) IBOutlet UILabel *changeAccontLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UILabel *changeNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
///弹出框
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation LZAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    self.changeAccontLabel.themeMap = @{
                                        TextColorName:@"conversation_title_color"
                                        };
    self.accountTextField.themeMap = @{
                                       TextColorName:@"conversation_title_color",
                                       PlaceHolderColorName:@"conversation_detail_color"
                                       };
    self.confirmBtn.themeMap = @{
                                 BGColorName:@"theme_color",
                                 TextColorName:@"theme_title_color"
                                 };
    //添加朋友
    self.title = NSLocalizedString(@"menu_addfriend", nil);
    [self setLanguage];
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}
-(void)setLanguage {
    ///账号accountname_create_username
    self.changeAccontLabel.text = NSLocalizedString(@"accountname_create_username", nil);
    ///朋友账号accountname_friend_username_tips
    self.accountTextField.placeholder = NSLocalizedString(@"accountname_friend_username_tips", nil);
    //昵称 accountname_friend_nickname
    self.changeNameLabel.text = NSLocalizedString(@"accountname_friend_nickname", nil);
    //本地好记的昵称 accountname_friend_nickname_tips
    self.nameTextField.placeholder = NSLocalizedString(@"accountname_friend_nickname_tips", nil);
    //确定 按钮 button_ok
    [self.confirmBtn setTitle:NSLocalizedString(@"button_ok", nil) forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmBtnClick:(id)sender {
    [self.view endEditing:YES];
    [self addFriendWithName:self.accountTextField.text];
    
}
- (IBAction)erWeiMaBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    lhScanQCodeViewController * sqVC = [[lhScanQCodeViewController alloc]init];
    UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
    [self.navigationController presentViewController:nVC animated:YES completion:^{
        
    }];
    sqVC.succ = ^(NSString *str) {
        
        QRDecoder *qrDecoder = [QRDecoder new];
        BOOL state = [qrDecoder decodeString:str];
        //成功的时候
        if (state) {
            NSString *type = qrDecoder.tag;
            NSMutableDictionary *infoDic = qrDecoder.config;
            if (!type||!infoDic) {
                [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"add_friend_error", nil) controller:self];
                return ;
            }
            
            if ([[infoDic objectForKey:@"a"] isEqualToString:@"addfriend"]&&([[infoDic objectForKey:@"_tag_"] isEqualToString:@"onechatapp"] || [[infoDic objectForKey:@"_tag_"] isEqualToString:@"oneapp"])) {
                [self addFriendWithName:[infoDic objectForKey:@"n"]];
            } else {
                [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"add_friend_error", nil) controller:self];
           }
            
        }else {
            //好友添加失败 add_friend_error
            [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"add_friend_error", nil) controller:self];
            
        }
        
    };
}

- (void)addFriendWithName:(NSString *)name {
    
    if ([name length] == 0) {
        return;
    }
    LZContactsDetailTableViewController *contactDetail = [[LZContactsDetailTableViewController alloc] initWithBuddy:name];
    [self.navigationController pushViewController:contactDetail animated:YES];
}

- (void)jumpToChatWithAccountInfo:(WSAccountInfo *)accountInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (accountInfo == nil) {
            return;
        }
        ChatViewController *chat = [[ChatViewController alloc] initWithConversationChatter:accountInfo.name conversationType:ONEConversationTypeChat];
        NSString *title = nil;
        if ([accountInfo.nickname isEqual:[NSNull null]] || accountInfo.nickname == nil || [accountInfo.nickname length] == 0) {
            title = accountInfo.name;
        } else {
            title = accountInfo.nickname;
        }
        chat.title = title;
        [self.navigationController pushViewController:chat animated:YES];
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:[self.navigationController.viewControllers copy]];
        [mArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[LZAddFriendViewController class]]) {
                [mArray removeObject:obj];
                *stop = YES;
            }
        }];
        self.navigationController.viewControllers = mArray;
    });
}

-(void)hidehideHud {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHud];
    });
}

-(void)hideKeyBoard
{
    [self.view endEditing:YES];
}


@end
