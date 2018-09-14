//
//  ONEChatClient+RedPacketManager.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/28.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEChatClient.h"
@class RedbagModel;
@interface ONEChatClient (RedPacketManager)

/**
 获取红包资产列表
 @param completion 回调
 */
- (void)getRedPacketAssetListWithCompletion:(void(^)(ONEError *error, NSArray *list))completion;


/**
 发送红包

 @param redbag 红包实例对象
 @param completion 错误、红包ID、红包留言
 */
- (void)sendRedpacket:(RedbagModel *)redbag
       withCompletion:(void(^)(ONEError *error, NSString *redpacketID, NSString *redpacketMsg))completion;


/**
 领取红包

 @param redpacketID 红包ID
 @param completion 错误信息
 */
- (void)clickRedpacket:(NSString *)redpacketID
        withCompletion:(void(^)(ONEError *error))completion;
@end
