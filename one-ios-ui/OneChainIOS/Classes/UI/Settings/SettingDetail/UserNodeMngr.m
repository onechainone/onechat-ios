//
//  UserNodeMngr.m
//  OneChainIOS
//
//  Created by summer0610 on 2018/2/5.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "UserNodeMngr.h"


#define Def_UserOneNodeTag @"UserOneNodeTag"

@implementation UserNodeMngr

+ (void)applyConfigWithIp:(NSString *)ip port:(NSString *)port cb:(void (^)(BOOL, id))cb
{
        if( cb == nil ) {
    
            return;
        }
    
        if( ip == nil || port == nil ) {
    
            cb(FALSE,nil);
    
            return;
        }
    [[ONEChatClient sharedClient] applyConfigWithIp:ip port:port completion:^(ONEError *error) {
       
        if (!error) {
            cb(YES, nil);
        } else {
            cb(NO, nil);
        }
    }];
}


+(void) clearConfig {

    [[ONEChatClient sharedClient] clearIPConfig];

}

@end
