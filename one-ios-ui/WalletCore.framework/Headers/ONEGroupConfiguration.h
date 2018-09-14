//
//  ONEGroupConfiguration.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/25.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 创建群需要传入的model
 */

@interface ONEGroupConfiguration : NSObject

/**
 群名称
 */
@property (nonatomic, copy) NSString *groupName;

/**
 群成员数量
 */
@property (nonatomic, readonly, assign) NSInteger memberSize;

/**
 群成员列表
 */
@property (nonatomic, readonly, strong) NSArray *allMembers;

/**
 是否是公开群
 */
@property (nonatomic) BOOL is_public;

/**
 初始化群组配置

 @param occupants 用户account_id集合
 warning: - 此处传入的occupants要确保是account_id集合，否则会收不到消息。
 @return 群组配置
 */
- (instancetype)initWithOccupants:(NSArray *)occupants;
@end
