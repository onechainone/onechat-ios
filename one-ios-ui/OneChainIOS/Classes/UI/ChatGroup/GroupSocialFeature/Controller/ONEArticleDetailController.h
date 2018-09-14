//
//  ONEArticleDetailController.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ONEArticle;

typedef void(^ArticleUpdated)(ONEArticle *oldArticle);
@interface ONEArticleDetailController : UIViewController

@property (nonatomic, copy) ArticleUpdated articleUpdated;

/**
 从微博列表跳转初始化

 @param article 微博对象
 @return 实例对象
 */
- (instancetype)initWithArticle:(ONEArticle *)article;

/**
 从通知中心、未读列表跳转初始化

 @param articleId 微博ID
 @param groupId 群组ID
 @return 实例对象
 */
- (instancetype)initWithArticleId:(NSString *)articleId groupId:(NSString *)groupId;
@end
