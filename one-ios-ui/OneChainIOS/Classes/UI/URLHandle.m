//
//  URLHandle.m
//  LZEasemob3
//
//  Created by summer0610 on 2017/12/18.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "URLHandle.h"

#import "QRDecoder.h"

#import "RedPacketMngr.h"

#import "ChatViewController.h"
#import "GroupChatSegmentController.h"
#import "LZContactsDetailTableViewController.h"

#define JOIN_GROUP_SETTING @"joinSetting"
#define JOIN_GROUP_NEED_PWD @"NEED_PASSWORD"

@implementation URLHandle

+(URLHandle*) instance {
    
    static URLHandle* g_uh = nil;
    
    if( g_uh == nil ) {
        
        g_uh = [[URLHandle alloc] init];
        
        
    }
    
    
    return g_uh;
    
}

+ (void)handleWithUrl:(NSURL *)url
{
    if (url == nil) return;
    
    NSMutableDictionary *config = [URLHandle configFromUrl:url];
    
    if (config == nil) return;
    
    NSString *action = [config objectForKey:@"a"];
    
    if (action == nil || action.length == 0) return;
    
    if ([action isEqualToString:SCHEME_ACTION_DIALOG]) {
        NSString *str = [config objectForKey:@"s"];
        [[UIAlertController shareAlertController] showAlertcWithString:str controller:[RedPacketMngr topViewController]];
    } else if ([action isEqualToString:SCHEME_ACTION_LOGIN]) {
        
        [RedPacketMngr showPasswordVC];
    }
}



+ (NSMutableDictionary *)configFromUrl:(NSURL *)url
{
    if( url == nil ) return nil;
    
    NSString* tmp = [url.absoluteString stringByRemovingPercentEncoding];
    
    if( tmp == nil ) return nil;
    
    QRDecoder* decoder = [[QRDecoder alloc] init];
    
    BOOL ret = [decoder decodeString:tmp];
    
    if( ret == FALSE ) return nil;
    
    if( decoder.config == nil ) return nil;
    
    return decoder.config;
}

+ (void)addGroupWithGroupId:(NSString *)groupId password:(NSString *)pwd
{
    if( groupId == nil || groupId.length == 0) return;
    
    [[RedPacketMngr topViewController] showHudInView:[UIApplication sharedApplication].keyWindow hint:nil];
    
    [[ONEChatClient sharedClient] applyToJoinGroup:groupId password:pwd completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [[RedPacketMngr topViewController] hideHud];
            if (!error) {
                [self sendMsg:groupId];
            } else {
                
                if (error.errorCode == ONEErrorGroupPasswordWrong) {
                    [[RedPacketMngr topViewController] showHint:NSLocalizedString(@"group_password_error", @"Join group error")];
                } else if (error.errorCode == ONEErrorUserInGroupBlackList) {
                    [[RedPacketMngr topViewController] showHint:NSLocalizedString(@"in_group_blacklist", @"Join group error")];
                } else if (error.errorCode == ONEErrorUserAlreadyInGroup) {
                    [[RedPacketMngr topViewController] showHint:NSLocalizedString(@"already_in_group", @"Join group error")];
                } else if (error.errorCode == ONEErrorGroupNotExist) {
                    [[RedPacketMngr topViewController] showHint:NSLocalizedString(@"group_not_exist", @"Join group error")];
                }  else if (error.errorCode == ONEErrorJoinGroupNeedAudit) {
                    [[RedPacketMngr topViewController] showHint:NSLocalizedString(@"pls_wait_examine", @"Join group error")];
                } else {
                    [[RedPacketMngr topViewController] showHint:NSLocalizedString(@"join_group_error", @"Join group error")];
                }
            }
        });
    }];
}

+ (void)addGroupWithGroupId:(NSString *)groupId
{
    if ([groupId length] == 0) {
        return;
    }
    
    ONEChatGroup *group = [[ONEChatClient sharedClient] groupChatWithGroupId:groupId];
    if (group) {
        dispatch_async(dispatch_get_main_queue(), ^{
            GroupChatSegmentController *seg = [[GroupChatSegmentController alloc] initWithConversationChatter:group.groupId conversationType:ONEConversationTypeGroupChat];
            
            UIViewController *vc = [RedPacketMngr topViewController];
            if ([vc isKindOfClass:[GroupChatSegmentController class]]) {
                [vc.navigationController popViewControllerAnimated:NO];
            }
            [[RedPacketMngr topViewController].navigationController pushViewController:seg animated:YES];
        });
        return;
    }
    
    [[ONEChatClient sharedClient] fetchJoinGroupCondition:groupId completion:^(ONEError *error, JoinGroupCondition condition) {
       
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (condition == JoinGroupCondition_WithPassword) {
                    [[UIAlertController shareAlertController] showTextFeildWithTitle:NSLocalizedString(@"input_join_group_psw", @"") andMsg:nil andLeftBtnStr:nil andRightBtnStr:nil andRightBlock:^(NSString *str) {
                        if ([str length] > 0) {
                            
                            [self addGroupWithGroupId:groupId password:str];
                        }
                        
                    } controller:[RedPacketMngr topViewController]];
                } else {
                    [self addGroupWithGroupId:groupId password:nil];

                }
            });
        }
    }];

   
}

+ (void)addFriendWithUsername:(NSString *)username
{
    if (username == nil || username.length == 0) return;
    
    LZContactsDetailTableViewController *contactDetail = [[LZContactsDetailTableViewController alloc] initWithBuddy:username];
    [[RedPacketMngr topViewController].navigationController pushViewController:contactDetail animated:YES];
}


+(void) sendMsg:(NSString*) groupId {
    
    WSAccountInfo *accountInfo = [ONEChatClient homeAccountInfo];
    NSString *selfName = accountInfo.accountNickName;
    
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"default_groupchat_sentence_plus", @"%@ was invited to group chat!"), selfName];
    
    ONEMessage *msg = [EaseSDKHelper sendTextMessage:text to:groupId messageType:ONEChatTypeGroupChat messageExt:nil];
    [[ONEChatClient sharedClient] sendMessage:msg progress:nil completion:^(ONEMessage *message, ONEError *error) {
       
        [[ONEChatClient sharedClient] updateConversationList];
        dispatch_async(dispatch_get_main_queue(), ^{
            GroupChatSegmentController *seg = [[GroupChatSegmentController alloc] initWithConversationChatter:groupId conversationType:ONEConversationTypeGroupChat];
            UIViewController *vc = [RedPacketMngr topViewController];
            if ([vc isKindOfClass:[GroupChatSegmentController class]]) {
                [vc.navigationController popViewControllerAnimated:NO];
            }
            [[RedPacketMngr topViewController].navigationController pushViewController:seg animated:YES];
        });
    }];
}

@end
