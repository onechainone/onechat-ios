//
//  ONEAddMemberViewController.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/17.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEAddMemberViewController.h"

@interface ONEAddMemberViewController ()<EMChooseViewDelegate>

@end

@implementation ONEAddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableHeaderView = nil;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    // 处理添加群成员。
    if (selectedSources.count > 0) {
        
        NSMutableArray *sources = [NSMutableArray array];
        NSMutableArray *ids = [NSMutableArray array];
        for (ONEFriendModel *model in selectedSources) {
            if ([model.account_id length] == 0) {
                continue;
            }
            [sources addObject:model.account_id];
            WSAccountInfo *info = [ONEChatClient accountInfoWithId:model.account_id];
            if (!info) {
                [ids addObject:model.account_id];
            }
        }
        if ([ids count] > 0) {
            
            [[ONEChatClient sharedClient] pullAccountInfosWithAccountIdList:ids completion:^(ONEError *error) {
               
                !_addContact ?: _addContact(sources);
            }];
        } else {
            !_addContact ?: _addContact(sources);
        }
    }
    return YES;
}

@end
