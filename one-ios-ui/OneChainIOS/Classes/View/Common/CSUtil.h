//
//  CSUtil.h
//  LZEasemob3
//
//  Created by summer0610 on 2017/11/28.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Def_CreateAccount 1
#define Def_GetTxHistoryList 2
#define Def_GetConversationInfoFail 3
#define Def_SendMsgContextException 4

#define Def_BuildTranscationException 5
#define Def_YanZhengMa 6
typedef void (^sucBlock)(NSString *msg);
@interface CSUtil : NSObject

+(void) showError:(NSError*) error;

+(void) showErrorMsgWithOp:(int) op error:(NSError*) error successBlock:(sucBlock)success;
+(void) showErrorMsgWithOp:(int) op error:(NSError*) error;
+(NSString*) msgWithError:(id) error;
+ (NSString *)errorMsgFromData:(id)data;

+ (NSString *)showRecoverErrMsg:(ONEError *)error;
@end
