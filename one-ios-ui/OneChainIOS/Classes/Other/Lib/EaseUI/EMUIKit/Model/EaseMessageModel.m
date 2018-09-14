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

#import "EaseMessageModel.h"

#import "EaseEmotionEscape.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "RedPacketMngr.h"
@implementation EaseMessageModel

- (instancetype)initWithMessage:(ONEMessage *)message
{
    self = [super init];
    if (self) {
        _cellHeight = -1;
        _message = message;
        _firstMessageBody = message.body;
        _isMediaPlaying = NO;
        
        _nickname = message.from;
        _isSender = message.direction == ONEMessageDirectionSend ? YES : NO;
        
        switch (_firstMessageBody.type) {
            case ONEMessageBodyTypeText:
            {
                ONETextMessageBody *textBody = (ONETextMessageBody *)_firstMessageBody;
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:textBody.text];
                self.text = didReceiveText;
            }
                break;
            case ONEMessageBodyTypeTransfer:
            {
                ONETransferMessageBody *transferBody = (ONETransferMessageBody *)_firstMessageBody;
                NSString *params = transferBody.params;
                if (params.length > 0) {
                    
                    NSData *jsonData = [params dataUsingEncoding:NSUTF8StringEncoding];
                    if (jsonData) {

                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                        self.symbol = dic[@"symbol"];
                        self.amount = dic[@"value"];
                    }
                }
            }
                break;
            case ONEMessageBodyTypeImage:
            {
                ONEImageMessageBody *imgMessageBody = (ONEImageMessageBody *)_firstMessageBody;
                
                NSString *localPath = imgMessageBody.localPath;
                NSString *remotePath = imgMessageBody.remotePath;
                if (localPath == nil) {
                    
                    localPath = [ONEChatClient localPathFromRemotePath:remotePath];
                }
                NSData *imageData = [NSData dataWithContentsOfFile:localPath];
                if (imageData.length > 0) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    self.image = image;
                    CGSize size = self.image.size;
                    CGFloat newWidth;
                    CGFloat newHeight;
                    if (size.width > 300) {
                        
                        newWidth = 300;
                        newHeight = 300 *size.height / size.width;
                    } else {
                        
                        newWidth = size.width;
                        newHeight = size.height;
                    }
                    self.thumbnailImage =  [self scaleImage:self.image toScale:sqrt((newWidth * newHeight) / (size.width * size.height))];
                    self.thumbnailImage = [UIImage clipImage:self.thumbnailImage cornerRadius:10];
                }
                self.thumbnailImageSize = self.thumbnailImage.size;
                self.fileURLPath = imgMessageBody.remotePath;
            }
                break;
            case ONEMessageBodyTypeLocation:
            {
                ONELocationMessageBody *locationBody = (ONELocationMessageBody *)_firstMessageBody;
                self.address = locationBody.address;
                self.latitude = locationBody.latitude;
                self.longitude = locationBody.longitude;
            }
                break;
            case ONEMessageBodyTypeVoice:
            {
                ONEVoiceMessageBody *voiceBody = (ONEVoiceMessageBody *)_firstMessageBody;
                self.mediaDuration = voiceBody.duration;
                
                NSString *messageId = message.messageId;
                self.isMediaPlayed = [ONEChatClient voiceMessageHasPlayed:messageId];
                
                NSString *localPath = voiceBody.localPath;
                NSString *remotePath = voiceBody.remotePath;
                if (localPath == nil) {
                    
                    localPath = [ONEChatClient localPathFromRemotePath:remotePath];
                }
                self.voiceLocalPath = localPath;
                // audio file path
                self.mediaDuration = voiceBody.duration;
                self.fileURLPath = voiceBody.remotePath;
            }
                break;
            case ONEMessageBodyTypeRedpacket:
            {
                ONERedPacketMessageBody *msgBody = (ONERedPacketMessageBody *)_firstMessageBody;
                NSString *params = msgBody.redpacketParam;
                if (params.length > 0) {
                    
                    NSData *jsonData = [params dataUsingEncoding:NSUTF8StringEncoding];
                    if (jsonData) {
                        
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                        self.red_id = dic[@"red_packet_id"];
                        self.red_msg = dic[@"red_packet_msg"];
                        self.isChecked = [RedPacketMngr redpacketStatus:self.red_id];
                    }
                }

            }
            default:
                break;
        }
    }
    
    return self;
}

- (NSString *)messageId
{
    return _message.messageId;
}

- (ONEMessageStatus)messageStatus
{
    return _message.status;
}

- (ONEChatType)messageType
{
    return _message.chatType;
}

- (ONEMessageBodyType)bodyType
{
    return self.firstMessageBody.type;
}

- (BOOL)isMessageRead
{
    return NO;
}

- (NSString *)fileLocalPath
{
    if (_firstMessageBody) {
        switch (_firstMessageBody.type) {
            case ONEMessageBodyTypeVideo:
            case ONEMessageBodyTypeImage:
            {
                ONEImageMessageBody *imageBody = (ONEImageMessageBody *)_firstMessageBody;
                NSString *localPath = imageBody.localPath;
                if (localPath == nil || [localPath length] == 0) {
                    localPath = [ONEChatClient localPathFromRemotePath:imageBody.remotePath];
                }
                return localPath;
            }
                break;
            case ONEMessageBodyTypeVoice:
            {
                ONEVoiceMessageBody *voiceBody = (ONEVoiceMessageBody *)_firstMessageBody;
                NSString *localPath = voiceBody.localPath;
                if (localPath == nil || [localPath length] == 0) {
                    localPath = [ONEChatClient localPathFromRemotePath:voiceBody.remotePath];
                }
                return localPath;
            }
                break;
            default:
                break;
        }
    }
    return nil;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}



@end
