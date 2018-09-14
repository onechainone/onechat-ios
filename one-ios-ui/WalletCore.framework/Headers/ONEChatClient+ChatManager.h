//
//  ONEChatClient+ChatManager.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/27.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEChatClient.h"
#import "ONEConversation.h"
@interface ONEChatClient (ChatManager)


- (void)regMsgListen;
- (void)stopListen;


/**
 删除会话

 @param aConversation 会话实例对象
 */
- (void)deleteConversation:(ONEConversation *)aConversation;


/**
 获取会话实例

 @param aConversationId 会话ID
 @param aType 会话类型
 @param aIfCreate 不存在时是否创建
 @return 会话实例
 */
- (ONEConversation *)getConversation:(NSString *)aConversationId
                               type:(ONEConversationType)aType
                   createIfNotExist:(BOOL)aIfCreate;


/**
 获取会话列表

 @return 会话列表List<ONEConversation>
 */
- (NSArray*)getAllConversations;


/**
 发送消息

 @param aMessage 消息实例
 @param aProgressBlock nil
 @param aCompletionBlock 错误回调
 */
- (void)sendMessage:(ONEMessage *)aMessage
           progress:(void (^)(int progress))aProgressBlock
         completion:(void (^)(ONEMessage *message, ONEError *error))aCompletionBlock;


/**
 重新发送消息

 @param aMessage 消息实例
 @param aProgressBlock nil
 @param aCompletionBlock 错误回调
 */
- (void)resendMessage:(ONEMessage *)aMessage
           progress:(void (^)(int progress))aProgressBlock
         completion:(void (^)(ONEMessage *message, ONEError *error))aCompletionBlock;


/**
 下载消息附件

 @param aMessage 消息对象
 @param completion 消息对象
 */
- (void)downloadMessageAttchment:(ONEMessage *)aMessage
                      completion:(void(^)(ONEMessage *message, BOOL success))completion;


/**
 根据account_name删除某人的会话

 @param account_name 用户的account_name
 */
- (void)deleteConversationFromUser:(NSString *)account_name;


/**
 主动更新会话列表
 */
- (void)updateConversationList;

/**
 同步聊天信息，账号验证成功之后调用

 @param completion 回调
 */
- (void)syncChatMessage:(void(^)(ONEError *error))completion;


/**
 开始监听群消息
 */
- (void)startSyncGroupChatMessage;

/**
 停止监听群消息
 */
- (void)stopSyncGroupChatMessage;


@end
