//
//  ONETextMessageBody.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/27.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEMessageBody.h"

@interface ONETextMessageBody : ONEMessageBody

/*!
 *  \~chinese
 *  文本内容
 */
@property (nonatomic, copy, readonly) NSString *text;

/*!
 *  \~chinese
 *  初始化文本消息体
 *
 *  param aText   文本内容
 *
 *  result 文本消息体实例
 */
- (instancetype)initWithText:(NSString *)aText;
@end
