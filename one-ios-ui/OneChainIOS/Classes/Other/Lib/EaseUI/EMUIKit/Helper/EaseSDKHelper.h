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


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define KNOTIFICATION_CALL @"callOutWithChatter"
#define KNOTIFICATION_CALL_CLOSE @"callControllerClose"

#define kGroupMessageAtList      @"em_at_list"
#define kGroupMessageAtAll       @"all"

#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"
#define kEaseUISDKConfigIsUseLite @"isUselibHyphenateClientSDKLite"

@interface EaseSDKHelper : NSObject

@property (nonatomic) BOOL isShowingimagePicker;

@property (nonatomic) BOOL isLite;

+ (instancetype)shareHelper;

#pragma mark - send message

+ (ONEMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)to
                   messageType:(ONEChatType)messageType
                    messageExt:(NSDictionary *)messageExt;

+ (ONEMessage *)sendTransferMessage:(NSString *)params
                                to:(NSString *)toUser
                       messageType:(ONEChatType)messageType
                        messageExt:(NSDictionary *)messageExt;




+ (ONEMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(ONEChatType)messageType
                                    messageExt:(NSDictionary *)messageExt;

+ (ONEMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(ONEChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

+ (ONEMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(ONEChatType)messageType
                              messageExt:(NSDictionary *)messageExt;

+ (ONEMessage *)transpondImageMessageWithLocalPath:(NSString *)localPath
                                               to:(NSString *)to
                                      messageType:(ONEChatType)messageType
                                       messageExt:(NSDictionary *)messageExt;

+ (ONEMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                messageType:(ONEChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;


+ (ONEMessage *)sendRedPacketMessage:(NSString *)params
                               to:(NSString *)toUser
                      messageType:(ONEChatType)messageType
                       messageExt:(NSDictionary *)messageExt;

@end
