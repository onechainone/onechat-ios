//
//  ONEUnreadModel.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/12.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEUnreadModel : NSObject

@property (nonatomic, copy) NSString *weibo_type;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *weibo_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *is_like;
@property (nonatomic, copy) NSString *comment_content;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger type;   // 1是打赏.2是微博看多/看空.3评论点赞.4是微博评论,5是必须支付类型
@property (nonatomic, copy) NSString *video_jietu_url;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic ,copy) NSString *pic_url;
@property (nonatomic, copy) NSString *weibo_content;

@end
