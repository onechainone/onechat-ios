//
//  ONEChatClient+ContactManager.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/27.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEChatClient.h"
@class WSAccountInfo;
@interface ONEChatClient (ContactManager)


/**
 获取好友列表

 @param completion List<ONEFriendModel>
 */
- (void)getFriendListWithCompletion:(void(^)(ONEError *error, NSArray *list))completion;


/**
 获取好友账号信息

 @param account_id 好友account_id
 @param completion WSAccountInfo
 */
- (void)getFriendInfo:(NSString *)account_id
           completion:(void(^)(ONEError *error, WSAccountInfo *accountInfo))completion;


/**
 获取好友申请列表

 @param completion List<ONEFriendApply>
 */
- (void)getFriendApplyListWithCompletion:(void(^)(ONEError *error, NSArray *list))completion;


/**
 请求添加某人为好友

 @param account_name 请求对方的account_name
 @param message 留言
 @param completion 错误
 */
- (void)addFriend:(NSString *)account_name
          message:(NSString *)message
       completion:(void(^)(ONEError *error))completion;

/**
 删除好友

 @param account_name 好友account_name
 @param completion 错误
 */
- (void)deleteFriend:(NSString *)account_name
          completion:(void(^)(ONEError *error))completion;

/**
 修改好友备注

 @param account_name 好友account_name
 @param remark 新备注
 @param completion 错误
 */
- (void)changeFriendRemark:(NSString *)account_name
                    remark:(NSString *)remark
                completion:(void(^)(ONEError *error))completion;

/**
 同意某人的好友请求

 @param account_name 申请人的account_name
 @param completion 错误
 */
- (void)approveAddFriendRequest:(NSString *)account_name
                     completion:(void(^)(ONEError *error))completion;

/**
 拒绝某人的好友请求

 @param account_name 申请人的account_name
 @param completion 错误
 */
- (void)rejectFriendRequest:(NSString *)account_name
                 completion:(void(^)(ONEError *error))completion;

/**
 获取未处理的好友申请数

 @param completion 好友申请数
 */
- (void)fetchFriendApplyCount:(void(^)(ONEError *error, NSInteger count))completion;
@end
