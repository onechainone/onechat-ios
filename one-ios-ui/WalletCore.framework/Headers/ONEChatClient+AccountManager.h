//
//  ONEChatClient+AccountManager.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/30.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEChatClient.h"
@class WSAccountInfo;
@interface ONEChatClient (AccountManager)


/**
 根据密码获取本地seed

 @param password 密码
 @return seed
 */
+ (NSString *)seedWithPassword:(NSString *)password;


/**
 我的account_id

 @return account_id
 */
+ (NSString *)homeAccountId;

/**
 我的account_name

 @return account_name
 */
+ (NSString *)homeAccountName;

/**
 我的账号信息

 @return 账号信息
 */
+ (WSAccountInfo *)homeAccountInfo;


/**
 创建账号

 @param accountInfo 账号信息
 @param seed 助记词
 @param password 密码
 @param completion 错误回调
 */
- (void)createAccount:(WSAccountInfo *)accountInfo
                 seed:(NSString *)seed
             password:(NSString *)password
           completion:(void(^)(ONEError *error))completion;

/**
 恢复账号

 @param seed 助记词
 @param password 密码
 @param completion 错误回调
 @return 错误回调
 */
- (NSString *)recoverAccount:(NSString *)seed
              password:(NSString *)password
            completion:(void(^)(ONEError *error))completion;


/**
 验证密码

 @param password 密码
 @return 是否验证通过
 */
+ (BOOL)verifyAccountWithPassword:(NSString *)password;



/**
 根据accountName获取用户信息，如果本地存在，直接取本地信息，本地没有从服务器拉取

 @param accountName accountName
 @param completion 回调
 */
- (void)pullAccountInfoWithAccountName:(NSString *)accountName
                            completion:(void(^)(ONEError *error, WSAccountInfo *accountInfo))completion;


/**
 批量获取用户信息,获取成功之后会自动存入本地

 @param idList 用户ID列表List<accountId>
 @param completion 错误回调
 */
- (void)pullAccountInfosWithAccountIdList:(NSArray *)idList
                               completion:(void(^)(ONEError *error))completion;

/**
 通过accountName获取账号信息，直接从服务器拉取

 @param completion 回调
 */
- (void)updateFriendAccountInfoWithCompletion:(void(^)(ONEError *error))completion;


/**
 保存accountInfo

 @param accountInfo info
 @return bool
 */
+ (BOOL)saveAccountInfo:(WSAccountInfo *)accountInfo;


/**
 获取用户信息

 @param name accountName
 @return info
 */
+ (WSAccountInfo *)accountInfoWithName:(NSString *)name;


/**
 获取用户信息

 @param accountId accountId
 @return info
 */
+ (WSAccountInfo *)accountInfoWithId:(NSString *)accountId;


/**
 根据accountName获取accountId

 @param name accountName
 @return accountId
 */
+ (NSString *)accountIdWithName:(NSString *)name;


/**
 本地是否有用户信息

 @return bool
 */
+ (BOOL)isHomeAccountExist;

/**
 本地账号是否激活

 @return BOOL
 */
+ (BOOL)isHomeAccountActive;

/**
 更新用户信息到服务器,只更新性别，昵称，简介

 @param accountInfo accountInfo对象
 @param completion 错误回调
 */
- (void)pushAccountInfo:(WSAccountInfo *)accountInfo
             completion:(void(^)(ONEError *error))completion;

/**
 上传用户头像

 @param avatarImage 用户头像Image
 @param completion 错误回调
 */
- (void)uploadAvatar:(UIImage *)avatarImage
              completion:(void(^)(ONEError *error))completion;


/**
 获取用户的头像URL

 @param accountId 用户ID
 @param completion 回调
 */
- (void)fetchUserAvatarUrl:(NSString *)accountId
                completion:(void(^)(ONEError *error, NSString *newAvatarUrl))completion;

@end
