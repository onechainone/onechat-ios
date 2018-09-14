//
//  LZContactsDetailTableViewController.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/30.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RemarkChanged)();
typedef void(^MessagesCleared)();
typedef void(^AlisChanged)(NSString *accountId, NSString *alis);

typedef void(^FriendDeletedAction)(NSString *account_name);

@interface LZContactsDetailTableViewController : UITableViewController
@property(nonatomic,copy)NSString *buddy;
@property (nonatomic) BOOL canSendMsg;
///从联系人进来的时候的邀请码
@property(nonatomic,copy)NSString *invitationCode;

@property (nonatomic, copy) RemarkChanged remarkChanged;
@property (nonatomic, copy) MessagesCleared msgCleared;

@property (nonatomic, copy) FriendDeletedAction deleteAction;

@property (nonatomic, copy) AlisChanged alisChanged;

//@property (nonatomic, )

- (instancetype)initWithBuddy:(NSString *)buddy;
@end
