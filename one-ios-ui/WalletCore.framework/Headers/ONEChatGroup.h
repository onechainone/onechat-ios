//
//  ONEChatGroup.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/25.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 群搜索ID,群描述等信息
 */
@interface GroupIndexInfomation: NSObject<NSCoding>

/**
 群搜索ID
 */
@property (nonatomic, readonly, assign) NSInteger groupIndexId;

/**
 群描述
 */
@property (nonatomic, readonly, copy) NSString *groupDesc;

- (instancetype)initWithIndexId:(NSInteger)indexId desc:(NSString *)desc;
@end



@class GroupInformation;
@interface ONEChatGroup : NSObject

/**
 群名称
 */
@property (nonatomic, readonly, copy) NSString *name;

/**
 群ID
 */
@property (nonatomic, readonly, copy) NSString *groupId;

/**
 是否是公开群
 */
@property (nonatomic, readonly) BOOL isPublicGroup;

/**
 群主accountID
 */
@property (nonatomic, readonly, copy) NSString *owner;

/**
 群人数
 */
@property (nonatomic, readonly, assign) NSUInteger memberSize;

/**
 群头像Url
 */
@property (nonatomic, readonly, copy) NSString *groupAvatarUrl;


/**
 是否是官方群
 */
@property (nonatomic, readonly) BOOL isOfficialGroup;


/**
 扩展信息
 */
@property (nonatomic, strong) GroupIndexInfomation *indexInformation;


- (instancetype)initWithGroupInformation:(GroupInformation *)information;
@end
