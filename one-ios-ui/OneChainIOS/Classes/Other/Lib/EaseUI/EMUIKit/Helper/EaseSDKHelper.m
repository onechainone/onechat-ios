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

#import <UserNotifications/UserNotifications.h>
#import "EaseSDKHelper.h"

#import "EaseConvertToCommonEmoticonsHelper.h"



static EaseSDKHelper *helper = nil;

@implementation EaseSDKHelper

@synthesize isShowingimagePicker = _isShowingimagePicker;

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

+(instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[EaseSDKHelper alloc] init];
    });
    
    return helper;
}


#pragma mark - send message

+ (ONEMessage *)sendTransferMessage:(NSString *)params
                                to:(NSString *)toUser
                       messageType:(ONEChatType)messageType
                        messageExt:(NSDictionary *)messageExt
{
    ONETransferMessageBody *body = [[ONETransferMessageBody alloc] initWithParams:params];
    NSString *from = [ONEChatClient homeAccountName];
    ONEMessage *message = [[ONEMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:messageExt];
    message.chatType = messageType;
    message.timestamp = [[ONEChatClient date] timeIntervalSince1970]*1000;
    
    return message;
}

+ (ONEMessage *)sendRedPacketMessage:(NSString *)params
                              to:(NSString *)toUser
                     messageType:(ONEChatType)messageType
                      messageExt:(NSDictionary *)messageExt
{
    ONERedPacketMessageBody *body = [[ONERedPacketMessageBody alloc] initWithPacket:params];
    NSString *from = [ONEChatClient homeAccountName];
    ONEMessage *message = [[ONEMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:messageExt];
    message.chatType = messageType;
    message.timestamp = [[ONEChatClient date] timeIntervalSince1970]*1000;
    return message;
}

+ (ONEMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)toUser
                   messageType:(ONEChatType)messageType
                    messageExt:(NSDictionary *)messageExt

{
    NSString *willSendText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
    ONETextMessageBody *body = [[ONETextMessageBody alloc] initWithText:willSendText];
    NSString *from = [ONEChatClient homeAccountName];
    ONEMessage *message = [[ONEMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:messageExt];
    message.chatType = messageType;
    message.timestamp = [[ONEChatClient date] timeIntervalSince1970]*1000;
    KLog(@"LF_LOG:SendMsg_date:%@",[ONEChatClient date]);
    KLog(@"LF_LOG:SendMsg_timestamp:%lu",message.timestamp);
    return message;
}


+ (ONEMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(ONEChatType)messageType
                                    messageExt:(NSDictionary *)messageExt
{
    ONELocationMessageBody *body = [[ONELocationMessageBody alloc] initWithLatitude:latitude longitude:longitude address:address];
    NSString *from = [ONEChatClient homeAccountName];
    ONEMessage *message = [[ONEMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    message.timestamp = [[ONEChatClient date] timeIntervalSince1970]*1000;
    return message;
}

+ (ONEMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(ONEChatType)messageType
                                  messageExt:(NSDictionary *)messageExt
{
    
    ONEImageMessageBody *body = [[ONEImageMessageBody alloc] initWithData:imageData];
    NSString *from = [ONEChatClient homeAccountName];
    ONEMessage *message = [[ONEMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    message.timestamp = [[ONEChatClient date] timeIntervalSince1970]*1000;
    return message;

}

+ (ONEMessage *)transpondImageMessageWithLocalPath:(NSString *)localPath
                                               to:(NSString *)to
                                      messageType:(ONEChatType)messageType
                                       messageExt:(NSDictionary *)messageExt
{
    ONEImageMessageBody *body = [[ONEImageMessageBody alloc] initWithLocalPath:localPath];
    NSString *from = [ONEChatClient homeAccountName];
    ONEMessage *message = [[ONEMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    message.timestamp = [[ONEChatClient date] timeIntervalSince1970]*1000;
    return message;
}

+ (ONEMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(ONEChatType)messageType
                              messageExt:(NSDictionary *)messageExt
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    return [self sendImageMessageWithImageData:data to:to messageType:messageType messageExt:messageExt];
}

+ (ONEMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                 messageType:(ONEChatType)messageType
                                  messageExt:(NSDictionary *)messageExt
{
    ONEVoiceMessageBody *body = [[ONEVoiceMessageBody alloc] initWithLocalPath:localPath];
    body.duration = (int)duration;
    NSString *from = [ONEChatClient homeAccountName];
    ONEMessage *message = [[ONEMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    message.timestamp = [[ONEChatClient date] timeIntervalSince1970] * 1000;
    
    return message;
}



@end
