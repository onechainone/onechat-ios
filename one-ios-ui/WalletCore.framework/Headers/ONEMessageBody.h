//
//  ONEMessageBody.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/27.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  \~chinese
 *  消息体类型
 *
 *  \~english
 *  Message body type
 */
typedef enum{
    ONEMessageBodyTypeText   = 1,    /*! \~chinese 文本类型 \~english Text */
    ONEMessageBodyTypeImage,         /*! \~chinese 图片类型 \~english Image */
    ONEMessageBodyTypeVideo,         /*! \~chinese 视频类型 \~english Video */
    ONEMessageBodyTypeLocation,      /*! \~chinese 位置类型 \~english Location */
    ONEMessageBodyTypeVoice,         /*! \~chinese 语音类型 \~english Voice */
    ONEMessageBodyTypeFile,          /*! \~chinese 文件类型 \~english File */
    ONEMessageBodyTypeCmd,           /*! \~chinese 命令类型 \~english Command */
    ONEMessageBodyTypeTransfer,      /*! \~chinese 转账类型 \~english Transfer */
    ONEMessageBodyTypeRedpacket      /*! \~chinese 红包类型 \~english Transfer */
}ONEMessageBodyType;


typedef NS_ENUM(NSUInteger, ONEMessageAttchmentStatus) {
    
    ONEMessageAttchmentStatusNotDownloaded = 1, // 未下载
    ONEMessageAttchmentStatusDownloaded,        // 已下载
    ONEMessageAttchmentStatusError,             // 未知错误
};

@interface ONEMessageBody : NSObject

/*!
 *  \~chinese
 *  消息体类型
 *
 *  \~english
 *  Message body type
 */
@property (nonatomic, readonly) ONEMessageBodyType type;
// 附件消息下载状态
@property (nonatomic, readonly) ONEMessageAttchmentStatus attchmentStatus;

- (instancetype)initWithType:(ONEMessageBodyType)type;

@end
