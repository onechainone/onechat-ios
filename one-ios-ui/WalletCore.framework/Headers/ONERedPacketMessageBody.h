//
//  ONERedPacketMessageBody.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/27.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEMessageBody.h"

@interface ONERedPacketMessageBody : ONEMessageBody

@property (nonatomic, copy, readonly) NSString *redpacketParam;

@property (nonatomic, readonly, copy) NSString *red_uid;

@property (nonatomic, readonly, copy) NSString *red_content;

- (instancetype)initWithPacket:(NSString *)packetParam;

- (instancetype)initWithRedPacketId:(NSString *)redPacketId content:(NSString *)redPacketContent;
@end
