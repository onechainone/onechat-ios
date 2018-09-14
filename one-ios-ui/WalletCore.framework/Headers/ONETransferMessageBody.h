//
//  ONETransferMessageBody.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/27.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEMessageBody.h"

@interface ONETransferMessageBody : ONEMessageBody

/*!
 *  \~chinese
 *  闪电转账的参数，jsonstring
 *
 *  \~english
 *  Transfer params
 */
@property (nonatomic, copy, readonly) NSString *params;
/*!
 *  \~chinese
 *  初始化闪电转账消息体
 *
 *  param params   参数内容
 *
 *  result 转账消息体实例
 */
- (instancetype)initWithParams:(NSString *)params;


@property (nonatomic, readonly, copy) NSString *symbol;

@property (nonatomic, readonly, copy) NSString *value;

- (instancetype)initWithSymbol:(NSString *)symbol value:(NSString *)value;
@end
