//
//  ONEGroupManager.h
//  OneChainIOS
//
//  Created by lifei on 2018/4/26.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, GroupRoleType) {
    GroupRoleType_Owner = 1,
    GroupRoleType_Admin,
    GroupRoleType_Member,
};

@class GroupApplyModel;


@interface ONEGroupManager : NSObject
{
    NSMutableDictionary *_adminsCache;
}
// 群组at锁
@property (nonatomic, strong) NSObject *atLock;
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) NSMutableArray *willFireNoti;
@property (nonatomic) BOOL isShowing;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) GroupRoleType roleType;


@property (nonatomic, copy) NSString *saveAccId;

+ (instancetype)sharedInstance;

+ (NSArray *)groupAdminsWithGroupId:(NSString *)groupId;

+ (void)cacheGroupAdmis:(NSArray *)adminList groupId:(NSString *)groupId;

// 标记会话是否有at消息
+ (void)markConversationAsHasAt:(NSString *)conversationId hasAt:(BOOL)hasAt;
// 会话是否有at消息
+ (BOOL)isConversationHasAt:(NSString *)conversationId;
// at显示内容
+ (NSString *)atTagMessage;
// at显示颜色
+ (UIColor *)atTagMessageColor;

+ (BOOL)hadShownLinkAlert;

+ (void)markHadShownLinkAlert;
@end
