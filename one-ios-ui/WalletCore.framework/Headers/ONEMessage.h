//
//  ONEMessage.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/27.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ONEMessageBody.h"
/*!
 *  \~chinese
 *  聊天类型
 *
 *  \~english
 *  Chat type
 */
typedef enum{
    ONEChatTypeChat   = 0,   /*! \~chinese 单聊消息 \~english one to one chat type */
    ONEChatTypeGroupChat,    /*! \~chinese 群聊消息 \~english Group chat type */
}ONEChatType;

/*!
 *  \~chinese
 *  消息发送状态
 *
 *  \~english
 *   Message Status
 */
typedef enum{
    ONEMessageStatusPending  = 0,    /*! \~chinese 发送未开始 \~english Pending */
    ONEMessageStatusDelivering,      /*! \~chinese 正在发送 \~english Delivering */
    ONEMessageStatusSuccessed,       /*! \~chinese 发送成功 \~english Successed */
    ONEMessageStatusFailed,          /*! \~chinese 发送失败 \~english Failed */
}ONEMessageStatus;

/*!
 *  \~chinese
 *  消息方向
 *
 *  \~english
 *  Message direction
 */
typedef enum{
    ONEMessageDirectionSend = 0,    /*! \~chinese 发送的消息 \~english Send */
    ONEMessageDirectionReceive,     /*! \~chinese 接收的消息 \~english Receive */
}ONEMessageDirection;


@interface ONEMessage : NSObject

/*!
 *  \~chinese
 *  消息的唯一标识符
 *
 *  \~english
 *  Unique identifier of message
 */
@property (nonatomic, copy) NSString *messageId;

/*!
 *  \~chinese
 *  所属会话的唯一标识符
 *
 *  \~english
 *  Unique identifier of message's conversation
 */
@property (nonatomic, copy) NSString *conversationId;

/*!
 *  \~chinese
 *  消息的方向
 *
 *  \~english
 *  Message direction
 */
@property (nonatomic) ONEMessageDirection direction;

/*!
 *  \~chinese
 *  发送方
 *
 *  \~english
 *  Message sender
 */
@property (nonatomic, copy) NSString *from;

/*!
 *  \~chinese
 *  接收方
 *
 *  \~english
 *  Message receiver
 */
@property (nonatomic, copy) NSString *to;

/*!
 *  \~chinese
 *  时间戳，服务器收到此消息的时间
 *
 *  \~english
 *  Timestamp, the time of server received this message
 */
@property (nonatomic) long long timestamp;

/*!
 *  \~chinese
 *  客户端发送/收到此消息的时间
 *
 *  \~english
 *  The time of client send/receive the message
 */
@property (nonatomic) long long localTime;

/*!
 *  \~chinese
 *  消息类型
 *
 *  \~english
 *  Chat type
 */
@property (nonatomic) ONEChatType chatType;

/*!
 *  \~chinese
 *  消息状态
 *
 *  \~english
 *  Message status
 */
@property (nonatomic) ONEMessageStatus status;

/*!
 *  \~chinese
 *  是否已读
 *
 *  \~english
 *  Whether the message has been read
 */
@property (nonatomic) BOOL isRead;

/*!
 *  \~chinese
 *  消息体
 *
 *  \~english
 *  Message body
 */
@property (nonatomic, strong) ONEMessageBody *body;

/*!
 *  \~chinese
 *  消息扩展
 *
 *  Key值类型必须是NSString, Value值类型必须是NSString或者 NSNumber类型的 BOOL, int, unsigned in, long long, double.
 *
 *  \~english
 *  Message extention
 *
 *  Key type must be NSString, Value type must be NSString, int, unsigned in, long long, or double. Please use NSNumber (@YES or @NO) instead of BOOL.
 */
@property (nonatomic, copy) NSDictionary *ext;


- (id)initWithConversationID:(NSString *)aConversationId
                        from:(NSString *)aFrom
                          to:(NSString *)aTo
                        body:(ONEMessageBody *)aBody
                         ext:(NSDictionary *)aExt;

@end
