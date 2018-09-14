//
//  ONENetworkTool.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/9/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^successBlock)(id data);
typedef void (^failedBlock)(NSError *error);
typedef void (^errorBlock)(NSString *message);

@interface ONENetworkTool : AFHTTPSessionManager
{
    AFHTTPSessionManager *sessionManager;
}

+ (instancetype)sharedNetworkTool;

+ (instancetype) jsonModeInstance;

// GET请求方法
+ (void)getUrlString:(NSString *)url
           withParam:(id)param
    withSuccessBlock:(successBlock)success
     withFailedBlock:(failedBlock)failed
      withErrorBlock:(errorBlock)error;

// POST请求方法
+ (void)postUrlString:(NSString *)url
            withParam:(id)param
     withSuccessBlock:(successBlock)success
      withFailedBlock:(failedBlock)failed
       withErrorBlock:(errorBlock)error;


@end
