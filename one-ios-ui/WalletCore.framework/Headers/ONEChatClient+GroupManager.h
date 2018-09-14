//
//  ONEChatClient+GroupManager.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/25.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEChatClient.h"

@class ONEGroupConfiguration;
@class ONEChatGroup;
@interface ONEChatClient (GroupManager)



/**
 同步群组消息

 @param completion 错误
 */
- (void)syncGroupChatInfo:(void(^)(ONEError *error))completion;

/**
 群组列表

 @return 群组信息list
 */
- (NSArray *)groupChatList;

/**
 根据群组ID获取群组信息

 @param group_uid 群组ID
 @return 群组信息
 */
- (ONEChatGroup *)groupChatWithGroupId:(NSString *)group_uid;

/**
 保存群组信息
 */
- (void)saveGroupInfo;




/**
 创建群组

 @param configuration 群组配置项
 @param completion 错误码，群组实例
 */
- (void)createGroupWithConfiguration:(ONEGroupConfiguration *)configuration
                          completion:(void(^)(ONEError *error, ONEChatGroup *group))completion;


/**
 获取群成员列表

 @param group_uid 群组ID
 @param completion 群组成员ID列表
 */
- (void)getMemberListFromGroup:(NSString *)group_uid
                    completion:(void(^)(ONEError *error, NSArray *list))completion;


/**
 添加/邀请用户加入群聊

 @param occupants 用户ID列表
 @param group_uid 群组ID
 @param completion 新加入的成员ID列表
 */
- (void)addOccupants:(NSArray *)occupants
           intoGroup:(NSString *)group_uid
          completion:(void(^)(ONEError *error, NSArray *newOccupants))completion;


/**
 删除群成员

 @param occupants 要删除的群成员ID列表
 @param group_uid 群组ID
 @param completion 错误
 */
- (void)removeOccupants:(NSArray *)occupants
              fromGroup:(NSString *)group_uid
             completion:(void(^)(ONEError *error, NSArray *removedOccupants))completion;

/**
 修改群组名称

 @param newName 新的群组名称
 @param group_uid 群组ID
 @param completion 错误
 */
- (void)changeGroupName:(NSString *)newName
                  group:(NSString *)group_uid
             completion:(void(^)(ONEError *error))completion;

/**
 获取群组管理员列表

 @param group_uid 群组ID
 @param completion 管理员ID列表
 */
- (void)getGroupAdminList:(NSString *)group_uid
               completion:(void(^)(ONEError *error, NSArray *list))completion;



/**
 添加群成员进入群管理员列表

 @param member_id 群组成员ID
 @param group_uid 群组ID
 @param completion 错误
 */
- (void)addMemberToAdminList:(NSString *)member_id
                     groupId:(NSString *)group_uid
              completion:(void(^)(ONEError *error))completion;


/**
 删除群成员并添加进黑名单

 @param member_id 群成员ID
 @param group_uid 群组ID
 @param completion 错误
 */
- (void)addMemberToBlackList:(NSString *)member_id
                     groupId:(NSString *)group_uid
                  completion:(void(^)(ONEError *error))completion;

/**
 禁言群成员

 @param member_id 群成员ID
 @param group_uid 群组ID
 @param completion 错误
 */
- (void)muteMember:(NSString *)member_id
           groupId:(NSString *)group_uid
        completion:(void(^)(ONEError *error))completion;


/**
 查询申请入群条件

 @param group_uid 群组ID
 @param completion 条件
 */
- (void)fetchJoinGroupCondition:(NSString *)group_uid
                     completion:(void(^)(ONEError *error,JoinGroupCondition condition))completion;

/**
 申请加入公开群

 @param group_uid 群组ID
 @param password 群组密码(不需要输入密码时,password传nil)
 @param completion 错误
 */
- (void)applyToJoinGroup:(NSString *)group_uid
                password:(NSString *)password
              completion:(void(^)(ONEError *error))completion;



/**
 通过某人的入群申请

 @param userID 用户ID
 @param group_uid 群组ID
 @param completion 错误
 */
- (void)approveJoinGroupApplyFrom:(NSString *)userID
                          groupID:(NSString *)group_uid
                       completion:(void(^)(ONEError *error))completion;

/**
 拒绝某人的入群申请

 @param userID 用户ID
 @param group_uid 群组ID
 @param completion 错误
 */
- (void)rejectJoinGroupApplyFrom:(NSString *)userID
                         groupID:(NSString *)group_uid
                      completion:(void(^)(ONEError *error))completion;


/**
 同意进群邀请

 @param group_uid 群组ID
 @param completion 错误
 */
- (void)agreeToJoinGroup:(NSString *)group_uid
              completion:(void(^)(ONEError *error))completion;

/**
 拒绝进群邀请

 @param group_uid 群组ID
 @param completion 错误
 */
- (void)disAgreeToJoinGroup:(NSString *)group_uid
              completion:(void(^)(ONEError *error))completion;

/**
 获取进群邀请列表

 @param completion list
 */
- (void)getGroupInvitationListWithCompletion:(void(^)(ONEError *error, NSArray *list))completion;


/**
 上传群头像

 @param group_uid 群组ID
 @param imageData 图片Data
 @param completion 错误
 */
- (void)uploadGroupAvatar:(NSString *)group_uid
                imageData:(NSData *)imageData
               completion:(void(^)(ONEError *error, NSString *groupId))completion;


/**
 获取未处理入群申请数

 @param completion 入群申请数
 */
- (void)fetchGroupApplyCount:(void(^)(ONEError *error, NSInteger count))completion;


/**
 退出群组

 @param groupId 群组ID
 @param completion 错误,群主不能退出群组。
 */
- (void)leaveGroup:(NSString *)groupId completion:(void(^)(ONEError *error))completion;

/**
 打赏群组消息
 
 @param messageId 消息ID
 @param userId 被打赏的用户ID
 @param asset_code 打赏资产类型
 @param amount 打赏资产数量
 @param completion 打赏回调
 */
- (void)rewardGroupMessage:(NSString *)messageId
                    likedUserId:(NSString *)userId
                      assetCode:(NSString *)asset_code
                         amount:(NSString *)amount
                     completion:(void(^)(ONEError *error))completion;

/**
 获取群组的搜索ID，群介绍

 @param groupId 群组ID
 @param completion 群组实例对象
 */
- (void)getGroupIndexInformation:(NSString *)groupId
                      completion:(void(^)(ONEError *error, ONEChatGroup *group))completion;
@end
