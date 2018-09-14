//
//  ONEFriendModel.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/5.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEFriendModel : NSObject

@property (nonatomic, assign) NSInteger friendShipId;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *to_alias;

@property (nonatomic, copy) NSString *showName;
@end
