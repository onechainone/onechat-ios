//
//  ONEChatClient.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/25.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ONEMessage;
@class OneContext;
@class GCDMulticastDelegate;
@class ONEError;


typedef NS_ENUM(NSInteger, JoinGroupCondition) {
    JoinGroupCondition_Unkown = 1,          // 获取条件失败
    JoinGroupCondition_WithPassword,        // 申请入群需要输入密码
    JoinGroupCondition_WithoutPassword,     // 不需要输入群组密码
};


typedef NS_ENUM(NSInteger, FetchTokenStatus) {
    FetchTokenStatusSuccess = 0,      /** 请求保存token成功 */
    FetchTokenStatusLoading,          /** 正在请求token */
    FetchTokenStatusFail,             /** 请求token失败 */
};

/**
 账号验证结束类型
 */
typedef NS_ENUM(NSInteger, AccountVerifyType) {
    
    AccountVerifyTypeRecover = 1,   // 恢复
    AccountVerifyTypeCreate,        // 注册
    AccountVerifyTypeVerify,        // 验证密码
};


@protocol ONEChatClientDelegate<NSObject>

/**
 会话列表更新
 */
- (void)conversationListDidUpdate;


/**
 收到新消息

 @param aMessages 消息数组List<ONEMessage>
 */
- (void)didReceiveMessages:(NSArray *)aMessages;


/**
 token 过期，需要重新获取一次
 */
- (void)didLocalTokenExpired;


/**
 收到包含@自己/@all的消息

 @param message 消息实例
 */
- (void)didReceiveAtMessage:(ONEMessage *)message;


/**
 账号验证完成

 @param type AccountVerifyType
 */
- (void)accountVerificationFinish:(AccountVerifyType)type;


/**
 消息附件下载完成

 @param message 消息对象
 */
- (void)didMessageAttchmentDownloaded:(ONEMessage *)message;

@end

@interface ONEChatClient : NSObject
{
    GCDMulticastDelegate<ONEChatClientDelegate> *_delegates;
    
    NSMutableSet *_downloadingMsgSet;
    
    NSMutableArray *_willDownloadMsgArray;
    
    NSString *_cachedAccountID;
    NSString *_cachedAccountName;
    NSMutableSet *_uploadTasks;
    NSMutableDictionary *_groupIndexInfoDic;
}


+ (instancetype)sharedClient;

/**
 添加代理
 
 @param delegate 代理对象
 @param queue 队列
 */
- (void)addDelegate:(id<ONEChatClientDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;

/**
 移除代理
 
 @param delegate 代理对象
 */
- (void)removeDelegate:(id<ONEChatClientDelegate>)delegate;


/**
 获取本地缓存的token

 @return token
 */
+ (NSString *)myToken;

+ (void)clearToken;

/**
 从服务器获取token,获取成功内部会做缓存，成功之后可以通过[ONEChatClient myToken]获取

 @param completion token
 */
- (void)fetchTokenFromServerWithCompletion:(void(^)(ONEError *error, NSString *token))completion;

/**
 清除上传任务
 */
- (void)clearUploadTasks;

/**
 初始化SDK
 */
- (void)registerSDK;


/**
 初始化信息,获取token之后调用
 */
- (void)initContext;


/**
 清除信息，需要退出账号时调用
 */
- (void)clearContext;



@end
