//
//  ONEErrorDefs.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/25.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#ifndef ONEErrorDefs_h
#define ONEErrorDefs_h


typedef NS_ENUM(NSInteger, ONEErrorType) {
 
    // Common
    ONEErrorInvalidParam = -1001,
    ONEErrorHttpFailed = -1002,
    ONEErrorUnknown = -1003,
    ONEErrorOperationFailed = -1004,
    ONEErrorFetchTokenFailed = -1005,       // 获取token失败
    ONEErrorTokenExpired = -1006,           // token过期，此时需要重新获取token
    // Group
    ONEErrorInsufficientPrivilege = 1005,   // 所执行的操作权限不足
    ONEErrorUserNotInGroup = 1006,          // 用户不在群里
    ONEErrorAdminsCountExceed = 1007,       // 群管理员人数达到上限
    ONEErrorGroupNumCreatedExceed = 1008,   // 创建群个数达到上限
    ONEErrorJoinGroupNeedAudit = 1009,      // 进群需要审核
    ONEErrorGroupPasswordWrong = 1010,      // 群组密码错误
    ONEErrorUserInGroupBlackList = 1011,    // 申请加群的用户在群组黑名单中
    ONEErrorUserAlreadyInGroup = 1012,      // 申请加群的用户已经在群组中
    ONEErrorGroupNotExist = 1013,           // 群组不存在
    ONEErrorOwnerCantLeaveGroup = 1014,     // 群主不允许退群
    
    // Message
    ONEErrorBalanceNotEnough = 1101,        // 消息需要发红包，红包余额不足
    ONEErrorYouAreInBanList = 1102,         // 被禁言中
    ONEErrorAllInBanList = 1103,            // 全员禁言中
    ONEErrorSendMsgFailed = 1104,           // 发消息失败
    
    // Friend
    ONEErrorFriendRequestHasSend = 1201,    // 已发送过好友申请
    ONEErrorFriendRemarkLengthExceed = 1202,// 好友备注名长度超过限制
    ONEErrorFriendApplyRecordNotFound = 1203,// 记录不存在
    ONEErrorOperationHasDone = 1204,        // 已经操作
    
    // Redpacket
    ONEErrorRedpacketBalanceNotEnough = 1301, // 红包余额不足
    ONEErrorRedpacketNotExist = 1302,         // 红包不存在
    
    // Community
    ONEErrorCommunityOpeNeedAssetButNotEnough = 1401,           // 操作需要资产，数量不足
    ONEErrorCommunityPayValue = 1402,                           // 支付类型(看涨/看跌时需要消耗资产)
    ONEErrorContentTooShort = 1403,                             // 发布帖子内容太短
    ONEErrorContentTooLong = 1404,                              // 发布帖子内容太长
    ONEErrorHasReported = 1405,                                 // 已经举报过帖子
    
    // Account
    ONEErrorAccountNameExist = 1501,            // 用户名已存在
    ONEErrorAccountUnknownRegister = 1502,      // 注册商错误
    ONEErrorAccountInvalidInviteCode = 1503,    // 邀请码错误
    ONEErrorAccountServerError = 1504,          // 服务错误
    ONEErrorAccountNameInvalid = 1505,          // 用户名错误
    ONEErrorRegistCountExceed = 1506,           // 注册超过最大次数
    ONEErrorSeedUsed = 1507,                    // Seed已经被使用
    ONEErrorNetworkInvalid = 1508,              // 网络不可用
    ONEErrorAccountNotExist = 1509,             // 用户不存在
    ONEErrorConnectionFailed = 1510,            // 服务器连接失败
    ONEErrorConnectionTimeout = 1511,           // 服务器连接超时
    ONEErrorRecoverFailed = 1512,               // 恢复账号失败
    ONEErrorRecoverUnknownError = 1513,         // 恢复未知错误
    
    // Seed
    ONEErrorSeedIsNull = 1601,                  // Seed为空
    ONEErrorSeedCountError = 1602,              // Seed个数错误
    ONEErrorSeedWordError = 1603,               // Seed单词错误
    
    
};

#endif /* ONEErrorDefs_h */
