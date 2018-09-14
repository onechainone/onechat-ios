//
//  ONEArticle.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserProfileEntity;
@interface ONEArticle : NSObject

@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *uni_uuid;
@property (nonatomic, copy) NSString *group_uid;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *comment_count;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *volume;
@property (nonatomic, copy) NSString *likes_count;          // 利多
@property (nonatomic, copy) NSString *dislikes_count;       // 利空
@property (nonatomic, copy) NSString *is_top;               // 是否置顶 0不,1置顶
@property (nonatomic, copy) NSString *type;                 // 微博类型 image/feed/video
@property (nonatomic, copy) NSString *weibo_jinghua;        // 是否为精华帖子 1是,0不是
@property (nonatomic, copy) NSString *best_type;            // 是否为专题,1是,0不是
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *repost_count;
@property (nonatomic, copy) NSString *content_desc;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *reward_price;         // 收费金额
@property (nonatomic, copy) NSString *asset_code;           // 收费币种
@property (nonatomic, copy) NSString *is_pay;               // 是否收费 0不是,1是
@property (nonatomic, copy) NSString *reward_count;         // 打赏次数
@property (nonatomic, copy) NSString *key_word;             // 关键字
@property (nonatomic, strong) NSArray *img_list;            // 小图
@property (nonatomic, strong) NSArray *img_list_max;        // 大图
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *user_is_pay;
@property (nonatomic, copy) NSString *is_like;              // 0是未操作,1是利多2是利空

@property (nonatomic, copy) NSString *video_jietu_url;
@property (nonatomic, copy) NSString *video_bofang_url;


@end
