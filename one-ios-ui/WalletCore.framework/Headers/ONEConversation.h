//
//  ONEConversation.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/27.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  \~chinese
 *  会话类型
 *
 *  \~english
 *  Conversation type
 */
typedef enum{
    ONEConversationTypeChat  = 0,    /*! \~chinese 单聊会话 \~english one to one chat room type */
    ONEConversationTypeGroupChat,    /*! \~chinese 群聊会话 \~english Group chat room type */
    ONEConversationTypeChatRoom      /*! \~chinese 聊天室会话 \~english Chatroom chat room type */
} ONEConversationType;

/*
 *  \~chinese
 *  消息搜索方向
 *
 *  \~english
 *  Message search direction
 */
typedef enum{
    ONEMessageSearchDirectionUp  = 0,    /*! \~chinese 向上搜索 \~english Search older messages */
    ONEMessageSearchDirectionDown        /*! \~chinese 向下搜索 \~english Search newer messages */
} ONEMessageSearchDirection;

@class ONEMessage;
@class ONEError;

@class UserChat;
@interface ONEConversation : NSObject

/*!
 *  \~chinese
 *  会话唯一标识
 *
 *  \~english
 *  Unique identifier of conversation
 */
@property (nonatomic, copy, readonly) NSString *conversationId;


// TODO: 标题
@property (nonatomic, copy) NSString *conversationTitle;

@property (nonatomic, assign) long timestamp;
/*!
 *  \~chinese
 *  会话类型
 *
 *  \~english
 *  Conversation type
 */
@property (nonatomic, assign, readonly) ONEConversationType type;

/*!
 *  \~chinese
 *   会话未读消息数量
 *
 *  \~english
 *  Count of unread messages
 */
@property (nonatomic, assign/**, readonly*/) int unreadMessagesCount;

/*!
 *  \~chinese
 *  会话扩展属性
 *
 *  \~english
 *  Conversation extension property
 */
@property (nonatomic, copy) NSDictionary *ext;

/*!
 *  \~chinese
 *  会话最新一条消息
 *
 *  \~english
 *  Conversation latest message
 */
@property (nonatomic, strong/**, readonly*/) ONEMessage *latestMessage;


- (long)allMessagesCount;


-(ONEMessage*)oneMessageWithUserChat:(UserChat*) uc;
-(ONEMessage*)oneMessageWithGroupUserChat:(UserChat*) uc;

-(NSMutableArray*)oneMessageListWithUserChatModelList:(NSArray*) list;


- (NSMutableArray *)messageList;

- (void)markMessageListAsRead:(NSArray*) list;
- (void)markAllMessagesAsRead:(ONEError **)pError;
- (void)markMessageAsReadWithId:(NSString *)aMessageId
                          error:(ONEError **)pError;

- (void)deleteMessageWithId:(NSString *)aMessageId
                      error:(ONEError **)pError;
- (NSArray*)unreadMessagesList;

- (void)deleteExceedMessages:(NSInteger)count;

- (void)loadMessagesStartFromId:(NSString *)aMessageId
                          count:(int)aCount
                searchDirection:(ONEMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray *aMessages, ONEError *aError))aCompletionBlock;

- (instancetype)initWithId:(NSString*)conversationId andType:(ONEConversationType)conversationType;

@end
