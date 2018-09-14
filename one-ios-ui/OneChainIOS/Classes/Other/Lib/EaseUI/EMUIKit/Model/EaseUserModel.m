/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseUserModel.h"

@implementation EaseUserModel

- (instancetype)initWithBuddy:(NSString *)buddy
{
    self = [super init];
    if (self) {
        _buddy = buddy;
        _nickname = @"";
        _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    }
    
    return self;
}

- (instancetype)initWithFriendDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _buddy = [dict objectForKey:@"account_name"];
        _nickname = [dict objectForKey:@"nickname"];
        _avatarURLPath = [dict objectForKey:@"avatar_url"];
        _to_alias = [dict objectForKey:@"to_alias"];
        _friendShipId = [[dict objectForKey:@"id"] integerValue];
    }
    return self;
}

- (NSString *)nickname
{
    if ([_to_alias length] > 0) {
        return _to_alias;
    }
    if ([_nickname length] > 0) {
        return _nickname;
    }
    return _buddy;
}

@end
