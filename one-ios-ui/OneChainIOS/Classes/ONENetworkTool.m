//
//  ONENetworkTool.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/9/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONENetworkTool.h"

@implementation ONENetworkTool



+ (instancetype)sharedNetworkTool{
    
    static ONENetworkTool *client;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //http://47.95.239.122
        //http://101.201.235.27:8084
        
        NSURL *url = [NSURL URLWithString:@""];
        
        client = [[self alloc]initWithBaseURL:url];
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",@"image/jpeg",@"image/png", nil];
        
        [client.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        client.requestSerializer = [AFHTTPRequestSerializer  new];
        
    });
    
    return client;
    
}

+ (instancetype) jsonModeInstance {
    
    __block ONENetworkTool *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //http://47.95.239.122
        //http://101.201.235.27:8084
        
        NSURL *url = [NSURL URLWithString:@""];
        
        instance = [[self alloc]initWithBaseURL:url];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",@"image/jpeg",@"image/png", nil];
        
        [instance.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        
        instance.requestSerializer = [AFJSONRequestSerializer new];
        
        
        
        
        
    });
    
    return instance;
    
}

+ (void)getUrlString:(NSString *)url
           withParam:(NSDictionary *)param
    withSuccessBlock:(successBlock)success
     withFailedBlock:(failedBlock)failed
      withErrorBlock:(errorBlock)error{
    
    
    [[ONENetworkTool sharedNetworkTool] getUrlString:url
                                        withParam:param
                                 withSuccessBlock:success
                                  withFailedBlock:failed
                                   withErrorBlock:error];
    
}

- (void)getUrlString:(NSString *)url
           withParam:(NSDictionary *)param
    withSuccessBlock:(successBlock)success
     withFailedBlock:(failedBlock)failed
      withErrorBlock:(errorBlock)error {
    
    
    url = [ONENetworkTool reBuildUrl:url];
    
    self.requestSerializer = [AFHTTPRequestSerializer  new];
    
#ifdef  Def_TestCode
    
    //    NSLog(@"GET");
    //
    //    NSLog(@"url:%@",url);
    //    NSLog(@"param:%@",[ASUtil serialize:param]);
    
#endif
    
    [self GET:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id  responseObject) {
        
        
        [ONENetworkTool onSuccessWithResponse:responseObject url:url successBlock:success];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [ONENetworkTool onFailureWithError:error failedBlock:failed];
        
    }];
    
}


- (void)postUrlString:(NSString *)url
            codecMode:(NSString*) mode
            withParam:(NSDictionary *)param
     withSuccessBlock:(successBlock)success
      withFailedBlock:(failedBlock)failed
       withErrorBlock:(errorBlock)error{
    
    /*
     
     if( mode != nil && [mode isEqualToString:@"json"] ) {
     
     self.requestSerializer = [AFJSONRequestSerializer new];
     
     
     } else {
     
     self.requestSerializer = [AFHTTPRequestSerializer  new];
     
     }
     
     */
    
    
    url = [ONENetworkTool reBuildUrl:url];
    
    
#ifdef  Def_TestCode
    
    //    NSLog(@"POST");
    //
    //    NSLog(@"url:%@",url);
    //    NSLog(@"param:%@",[ASUtil serialize:param]);
    
#endif
    
    [self POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id   responseObject) {
        
        [ONENetworkTool onSuccessWithResponse:responseObject url:url successBlock:success];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [ONENetworkTool onFailureWithError:error failedBlock:failed];
        
    }];
    
    
    
}

+ (void)postUrlString:(NSString *)url
            withParam:(NSDictionary *)param
     withSuccessBlock:(successBlock)success
      withFailedBlock:(failedBlock)failed
       withErrorBlock:(errorBlock)error {
    
    [[ONENetworkTool sharedNetworkTool] postUrlString:url
                                         codecMode:@"http"
                                         withParam:param
                                  withSuccessBlock:success
                                   withFailedBlock:failed
                                    withErrorBlock:error];
}


+(void) onSuccessWithResponse:(id) responseObject url:(NSString*) url successBlock:(successBlock)success {
    
#ifdef  Def_TestCode
    
    
    //    NSLog(@"response");
    //
    //    NSLog(@"url:%@",url);
    //    NSLog(@"response:%@",responseObject);
    
#endif
    
    
    success(responseObject);
    
    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
    
    if ([code isEqualToString:@"100900"]) {
        
        NSLog(@"url:%@ req token invalid",url);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DefTokenInvalidNotifTag object:nil];
    }
    
    
    
    
    
    
}

+(void) onFailureWithError:(NSError*) error failedBlock:(failedBlock) failed {
    
    
    failed(error);
    
    [ONENetworkTool checkNodeStatus];
    
}


+(NSString*) reBuildUrl:(NSString*) url {
    
    NSString* p = [ONEUrlHelper commonParam];
    
    if([p rangeOfString:@"?"].location !=NSNotFound)
    {
        // NSLog(@"包含");
        url = [NSString stringWithFormat:@"%@&%@",url,p];
    }
    else
    {
        // NSLog(@"不包含");
        url = [NSString stringWithFormat:@"%@?%@",url,p];
    }
    
    return url;
}
+ (void)checkNodeStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetReqExceptionNotifTag" object:nil];
    });
}

@end
