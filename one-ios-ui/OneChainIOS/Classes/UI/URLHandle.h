//
//  URLHandle.h
//  LZEasemob3
//
//  Created by summer0610 on 2017/12/18.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLHandle : NSObject

+ (void)addGroupWithGroupId:(NSString *)groupId;

+ (void)addFriendWithUsername:(NSString *)username;

+ (NSMutableDictionary *)configFromUrl:(NSURL *)url;

+ (void)addGroupWithGroupId:(NSString *)groupId password:(NSString *)pwd;

+ (void)handleWithFaceRecognitionProtocol;

+ (void)handleWithUrl:(NSURL *)url;

@end
