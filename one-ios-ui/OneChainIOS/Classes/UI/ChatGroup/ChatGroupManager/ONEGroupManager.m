//
//  ONEGroupManager.m
//  OneChainIOS
//
//  Created by lifei on 2018/4/26.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEGroupManager.h"
@interface ONEGroupManager()

@end

static ONEGroupManager *manager = nil;
static NSObject *g_lock = nil;

@implementation ONEGroupManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ONEGroupManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _atLock = [[NSObject alloc] init];
        g_lock = [[NSObject alloc] init];
        _willFireNoti = [NSMutableArray array];
        _isShowing = NO;
        _adminsCache = [NSMutableDictionary dictionary];
    }
    return self;
}



+ (void)cacheGroupAdmis:(NSArray *)adminList groupId:(NSString *)groupId
{
    [[self sharedInstance] cacheGroupAdmis:adminList groupId:groupId];
}

- (void)cacheGroupAdmis:(NSArray *)adminList groupId:(NSString *)groupId
{
    if ([adminList count] == 0 || [groupId length] == 0) {
        return;
    }
    @synchronized(_adminsCache) {
        [_adminsCache setObject:adminList forKey:groupId];
    }
}

+ (NSArray *)groupAdminsWithGroupId:(NSString *)groupId
{
    return [[self sharedInstance] groupAdminsWithGroupId:groupId];
}

- (NSArray *)groupAdminsWithGroupId:(NSString *)groupId
{
    if ([groupId length] == 0) {
        return nil;
    }
    NSArray *list = nil;
    @synchronized(_adminsCache) {
        list = [_adminsCache objectForKey:groupId];
    }
    return list;
}


- (NSString *)errorCodeFromData:(id)data
{
    NSString *errorCode = [NSString stringWithFormat:@"%@",data[@"code"]];
    return errorCode;
}
+ (BOOL)isConversationHasAt:(NSString *)conversationId
{
    return [[self sharedInstance] isConversationHasAt:conversationId];
}

+ (BOOL)isAtMessage:(ONEMessage *)message
{
    return [[self sharedInstance] isAtMessage:message];
}

+ (void)markConversationAsHasAt:(NSString *)conversationId hasAt:(BOOL)hasAt
{
    [[self sharedInstance] markConversationAsHasAt:conversationId hasAt:hasAt];
}


- (BOOL)isAtMessage:(ONEMessage *)message
{
    BOOL ret = NO;
    if (message && message.ext) {
        
        NSDictionary *ext = message.ext;
        id atList = [ext objectForKey:@"one_at_list"];
        if ([atList isKindOfClass:[NSArray class]] && [(NSArray *)atList count] > 0) {
            NSArray *atListArr = (NSArray *)atList;
            if ([atListArr containsObject:@"-1"]) {
                return YES;
            }
            NSString *account_id = [ONEChatClient homeAccountId];
            if ([account_id length] > 0 && [atListArr containsObject:account_id]) {
                ret = YES;
            }
        } else {
            // todo - at all
        }
    }
    return ret;
}

- (void)markConversationAsHasAt:(NSString *)conversationId hasAt:(BOOL)hasAt
{
    if (conversationId == nil) {
        return;
    }
    @synchronized(self.atLock){
        
        NSString *key = [self constructGroupAtUDKey:conversationId];
        if (key == nil) {
            return;
        }
        if (hasAt) {
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:key];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (NSString *)constructGroupAtUDKey:(NSString *)conversationId
{
    if (conversationId == nil) {
        return nil;
    }
    if ([self.saveAccId length] == 0) {
        self.saveAccId = [ONEChatClient homeAccountId];
    }
    NSString *accountId = self.saveAccId;
    if (accountId == nil) {
        return nil;
    }
    NSString *key = [NSString stringWithFormat:@"%@-%@",conversationId, accountId];
    return key;
}

- (BOOL)isConversationHasAt:(NSString *)conversationId
{
    if (conversationId == nil) {
        return NO;
    }
    BOOL ret = NO;
    @synchronized(self.atLock) {
        NSString *key = [self constructGroupAtUDKey:conversationId];
        if (key != nil && [key length] > 0) {
            id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            if (value) {
                ret = [value boolValue];
            }
        }
    }
    return ret;
}

+ (NSString *)atTagMessage
{
    return NSLocalizedString(@"someone_at_me", @"");
}

+ (UIColor *)atTagMessageColor
{
    return THMColor(@"theme_color");
}


+ (BOOL)hadShownLinkAlert
{
    NSString *key = [self constructKey];
    if (key == nil) {
        return NO;
    }
    NSNumber *hadShown = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return [hadShown boolValue];
}

+ (void)markHadShownLinkAlert
{
    NSString *key = [self constructKey];
    if (key == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)constructKey
{
    NSString *account_id = [ONEChatClient homeAccountId];
    if (account_id == nil) {
        return nil;
    }
    NSString *key = [NSString stringWithFormat:@"SHOWLINK_%@",account_id];
    return key;
}



@end
