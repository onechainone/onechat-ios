//
//  ONEArticlesRequest.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SourceType) {
    
    SourceTypeAll = 1,      // 全部
    SourceTypeEssence,      // 精华
    SourceTypeFee,          // 免费
    SourceTypeCharge,       // 收费
};

typedef NS_ENUM(NSInteger, SortMethod) {
    
    SortMethod_time = 1,        // 按时间排序
    SortMethod_comment,         // 按评论数排序
    SortMethod_likes,           // 看多排序
    SortMethod_unlikes,         // 看空排序
    SortMethod_rewards,         // 赞赏数排序
    SortMethod_commenttime,     // 按评论时间排序
};

@interface ONEArticlesRequest : NSObject

@property (nonatomic, assign) NSInteger index;          // 第几页
@property (nonatomic, assign) NSInteger pageSize;       // 每页数量(default 20)
@property (nonatomic, assign) SourceType sourceType;    // 类型
@property (nonatomic, assign) SortMethod sortMethod;    // 排序
@property (nonatomic, copy) NSString *groupId;          // 群组ID
@property (nonatomic) BOOL isMore;                      // 是否是请求更多

- (instancetype)initWithGroupId:(NSString *)groupId;
@end
