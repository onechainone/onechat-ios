//
//  ONEQuoteComment.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEQuoteComment : NSObject


@property (nonatomic, copy) NSString *yuan_comment_id;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *account_name;

@property (nonatomic, copy) NSAttributedString *real_content;

@end
