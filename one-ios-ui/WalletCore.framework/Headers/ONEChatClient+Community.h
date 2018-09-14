//
//  ONEChatClient+Community.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/29.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEChatClient.h"

@class ONEArticlesRequest;
@class ONEArticle;
@class ONEComment;
@class ONECreateArticleModel;
@interface ONEChatClient (Community)


/**
 获取帖子列表

 @param articleRequest 帖子列表请求实例对象
 @param completion 帖子列表List<ONEArticle>
 */
- (void)getArticleList:(ONEArticlesRequest *)articleRequest
            completion:(void(^)(ONEError *error, NSArray *list))completion;


/**
 看涨帖子/取消看涨

 @param article 帖子实例对象
 @param groupId 群组ID
 @param completion 错误对象,帖子实例对象
 */
- (void)likeArticle:(ONEArticle *)article
            groupId:(NSString *)groupId
         completion:(void(^)(ONEError *error, ONEArticle *newArticle))completion;


/**
 看跌帖子/取消看跌
 
 @param article 帖子实例对象
 @param groupId 群组ID
 @param completion 错误对象,帖子实例对象
 */
- (void)dislikeArticle:(ONEArticle *)article
               groupId:(NSString *)groupId
            completion:(void(^)(ONEError *error, ONEArticle *newArticle))completion;


/**
 评论帖子

 @param articleId 帖子ID
 @param accountName -ONEArticle.account_name
 @param comment 评论内容
 @param groupId 群组ID
 @param completion 错误回调
 */
- (void)commentArticle:(NSString *)articleId
                  from:(NSString *)accountName
               comment:(NSString *)comment
               groupId:(NSString *)groupId
            completion:(void(^)(ONEError *error))completion;


/**
 回复帖子评论

 @param articleId 帖子ID
 @param accountName -ONEArticle.account_name
 @param comment_id 评论ID
 @param comment 回复内容
 @param groupId 群组ID
 @param completion 错误回调
 */
- (void)commentToArticleComment:(NSString *)articleId
                      toAccount:(NSString *)accountName
                      commentId:(NSString *)comment_id
                        comment:(NSString *)comment
                        groupId:(NSString *)groupId
                     completion:(void(^)(ONEError *error))completion;

/**
 获取帖子详情

 @param articleId 帖子ID
 @param completion 回调，帖子实例对象
 */
- (void)getArticleDetail:(NSString *)articleId
              completion:(void(^)(ONEError *error, ONEArticle *article))completion;


/**
 获取未读消息列表(打赏、评论、看涨、看跌等)

 @param groupId 群组ID
 @param completion 回调
 */
- (void)getUnreadMsgList:(NSString *)groupId
              completion:(void(^)(ONEError *error, NSArray *list))completion;

/**
 获取未读消息数(打赏、评论、看涨、看跌等)

 @param groupId 群组ID
 @param completion 回调
 */
- (void)getUnreadMsgCount:(NSString *)groupId
               completion:(void(^)(ONEError *error, NSDictionary *map))completion;


/**
 获取帖子评论列表

 @param articleId 帖子ID
 @param groupId 群组ID
 @param completion 回调
 */
- (void)getCommentListFromArticle:(NSString *)articleId
                            group:(NSString *)groupId
                       completion:(void(^)(ONEError *error, NSArray *list))completion;


/**
 评论点赞/取消点赞

 @param comment 评论实例对象
 @param groupId 群组ID
 @param completion 回调
 */
- (void)likeComment:(ONEComment *)comment
            groupId:(NSString *)groupId
         completion:(void(^)(ONEError *error, NSDictionary *map))completion;


/**
 删除帖子

 @param articleId 帖子ID
 @param groupId 群组ID
 @param completion 回调
 */
- (void)deleteArticle:(NSString *)articleId
              groupId:(NSString *)groupId
           completion:(void(^)(ONEError *error))completion;


/**
 删除评论

 @param comment 评论实例对象
 @param groupId 群组ID
 @param completion 回调
 */
- (void)deleteComment:(ONEComment *)comment
              groupId:(NSString *)groupId
           completion:(void(^)(ONEError *error, NSString *commentId))completion;

/**
 获取帖子打赏列表

 @param articleId 帖子ID
 @param groupId 群组ID
 @param completion 回调List<ONEReward>
 */
- (void)getArticleRewardList:(NSString *)articleId
                     groupId:(NSString *)groupId
                  completion:(void(^)(ONEError *error, NSArray *list))completion;


/**
 支付帖子(帖子是收费时，需要先支付)

 @param articleId 帖子ID
 @param assetCode 类型
 @param amount 数量
 @param groupId 群组ID
 @param completion 回调
 */
- (void)payForArticle:(NSString *)articleId
            assetCode:(NSString *)assetCode
               amount:(NSString *)amount
              groupId:(NSString *)groupId
       withCompletion:(void (^)(ONEError *error))completion;



/**
 打赏帖子

 @param articleId 帖子ID
 @param assetCode 资产类型
 @param reward_amount 数量
 @param groupId 群组ID
 @param completion 回调
 */
- (void)rewardArticle:(NSString *)articleId
            assetCode:(NSString *)assetCode
               amount:(NSString *)reward_amount
              groupId:(NSString *)groupId
       withCompletion:(void (^)(ONEError *error))completion;


/**
 帖子加精

 @param article 帖子实例对象
 @param groupId 群组ID
 @param completion 回调
 */
- (void)essenceArticle:(ONEArticle *)article
                    groupId:(NSString *)groupId
                 completion:(void(^)(ONEError *error, ONEArticle *article))completion;

/**
 举报帖子

 @param articleId 帖子ID
 @param groupId 群组ID
 @param completion 回调
 */
- (void)reportArticle:(NSString *)articleId
              groupId:(NSString *)groupId
           completion:(void(^)(ONEError *error))completion;

/**
 发布帖子

 @param model 创建帖子的model对象
 @param progress 进度
 @param completion 错误回调
 */
- (void)createArticle:(ONECreateArticleModel *)model
        progressBlock:(void(^_Nullable)(NSProgress *_Nonnull progress))progress
           completion:(void(^_Nullable)(ONEError * _Nullable error))completion;

@end
