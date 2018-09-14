//
//  ONEFriendApply.h
//  OneChainIOS
//
//  Created by lifei on 2018/6/1.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ApplyStatus) {
    ApplyStatus_undetermined = 0,
    ApplyStatus_agreed,
    ApplyStatus_rejected
};

@interface ONEFriendApply : NSObject

@property (nonatomic, assign) long create_time;
@property (nonatomic, copy) NSString *from_account_name;
@property (nonatomic, copy) NSString *from_alias;
@property (nonatomic, copy) NSString *to_account_name;
@property (nonatomic, assign) NSInteger applyId;
@property (nonatomic, copy) NSString *user_status;
@property (nonatomic, assign) long update_time;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) ApplyStatus status;
@end
