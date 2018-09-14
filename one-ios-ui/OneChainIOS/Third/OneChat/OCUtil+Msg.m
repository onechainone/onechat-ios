//
//  OCUtil+Msg.m
//  OneChainIOS
//
//  Created by lifei on 2018/2/3.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "OCUtil+Msg.h"


@implementation OCUtil (Msg)
+ (EMMessage *)em_messageFromUserChat:(UserChat *)uc
{
    if (uc == nil || uc.memo == nil) return nil;
    
    NSString *memoString = uc.memo;
    
    MemoMessage *memoMsg = [[MemoMessage alloc] initWithEncodeString:memoString];
    if (!memoMsg) {
        
        return nil;
    }
    EMMessageBody *msgBody = [self em_messageBodyFromMemoMsg:memoMsg];
    
    EMChatType chatType = EMChatTypeChat;
    NSString *conversationId = nil;
    if (uc.group_uid.length > 0) {
        
        chatType = EMChatTypeChat;
        conversationId = uc.group_uid;
    } else {
        
        chatType = EMChatTypeGroupChat;
        WSAccountInfo *accountInfo = [WSAccountMngr accountInfoWithId:uc.destination];
        if (accountInfo) {
            conversationId = accountInfo.name;
        } else {
            
            conversationId = uc.destination;
        }
    }

    NSString *from = uc.source;
    NSString *account_id = [WSHomeAccount accountId];
    EMMessageDirection direction = EMMessageDirectionSend;
    if ([from isEqualToString:account_id]) {
        
        direction = EMMessageDirectionSend;
    } else {
        
        direction = EMMessageDirectionReceive;
    }
    
    NSString *to = uc.destination;
    
    EMMessage *message = [[EMMessage alloc] initWithConversationID:conversationId from:from to:to body:msgBody ext:nil];
    message.messageId = uc.uuid;
    
    message.status = uc.status_send == 1 ? EMMessageStatusSuccessed : EMMessageStatusFailed;
    message.timestamp = uc.timestamp;
    message.localTime = uc.timestamp;
    
    return message;
}

+ (EMMessageBody *)em_messageBodyFromMemoMsg:(MemoMessage *)memoMsg
{
    if (!memoMsg) {
        
        return nil;
    }
    NSString *msgTxt = memoMsg.msg;
    NSString *msgParam = memoMsg.jsonParam;
//    NSDictionary *paramDic = [msgParam yy_modelToJSONObject];
    EMMessageBody *body = nil;
    switch (memoMsg.type) {
        case MSG_TYPE_TXT:
        {
            if (msgTxt == nil) {
                
                return nil;
            }
            body = [[EMTextMessageBody alloc] initWithText:msgTxt];
        }
            break;
        case MSG_TYPE_ASSET:
        {
            if (msgParam == nil) {
                
                return nil;
            }
            body = [[EMTransferMessageBody alloc] initWithParams:msgParam];
//            NSString *symbol = [paramDic objectForKey:@"symbol"];
//            NSString *value = [paramDic objectForKey:@"value"];
//            body = [[EMTransferMessageBody alloc] initWithSymbol:symbol value:value];
        }
            break;
        case MSG_TYPE_RED_PACKET:
        {
            if (msgParam == nil) {
                
                return nil;
            }
//            NSString *red_id = [paramDic objectForKey:@"red_packet_id"];
//            NSString *red_content = [paramDic objectForKey:@"red_packet_msg"];
//            body = [[EMRedpacketMessageBody alloc] initWithRedPacketId:red_id content:red_content];
            body = [[EMRedpacketMessageBody alloc] initWithPacket:msgParam];
        }
            break;
        default:
            break;
    }
    return body;
}
@end
