//
//  UserNodeMngr.h
//  OneChainIOS
//
//  Created by summer0610 on 2018/2/5.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserNodeMngr : NSObject

+(void) applyConfigWithIp:(NSString*) ip port:(NSString*) port cb:(void(^)(BOOL state,id data)) cb;
+(void) clearConfig;

@end
