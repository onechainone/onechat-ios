//
//  ONEError.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/25.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONEErrorDefs.h"
@interface ONEError : NSObject

@property (nonatomic) ONEErrorType errorCode;

@property (nonatomic, copy) NSString *errorDescription;

+ (instancetype)errorWithCode:(ONEErrorType)code description:(NSString *)description;

+ (ONEError *)errorWithNSError:(NSError *)error;

+ (ONEError *)paramError;

@end
