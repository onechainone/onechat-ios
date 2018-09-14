//
//  ONEGroupInvitation.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/2.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEGroupInvitation : NSObject

@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, assign) long create_time;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *group_uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *user_status;
@property (nonatomic, copy) NSString *group_name;
@end
