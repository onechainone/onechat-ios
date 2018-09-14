//
//  ONEPaymentController.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/15.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LFSendRedController.h"
@class ONEArticle;

/**
 支付微博

 @param article 微博实例
 */
typedef void(^ArticleHasPayed)(ONEArticle *article);

/**
 打赏微博

 @param articleId 微博ID
 */
typedef void(^ArticleHasRewarded)(NSString *articleId);

/**
 打赏群消息
 */
typedef void(^GroupMessageRewarded)();

@interface ONEPaymentController : LFSendRedController

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) ArticleHasPayed articlePayed;
@property (nonatomic, copy) ArticleHasRewarded articleHasRewarded;
@property (nonatomic, copy) GroupMessageRewarded groupMsgRewarded;

- (instancetype)initWithAssetCode:(NSString *)assetCode amount:(NSString *)amount;

- (instancetype)initWithMessage:(id<IMessageModel>)msgModel;
@end
