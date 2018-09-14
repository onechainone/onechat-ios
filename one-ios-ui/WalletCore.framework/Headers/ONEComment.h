//
//  ONEComment.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONEQuoteComment;
@interface ONEComment : NSObject

@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *uni_uuid;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *likes_count;
@property (nonatomic, copy) NSString *weibo_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *to_account_name;
@property (nonatomic, copy) NSString *comment_read;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *is_like;
@property (nonatomic, strong) NSDictionary *yuan_comment;

@property (nonatomic, strong) ONEQuoteComment *quoteComment;
@end
