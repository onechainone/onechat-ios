//
//  CSUtil.m
//  LZEasemob3
//
//  Created by summer0610 on 2017/11/28.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "CSUtil.h"


@implementation CSUtil


+(void) showError:(NSError*) error {
    
    if( error == nil ) {
        
        return;
        
        
    }
    
    if([error isKindOfClass:[NSError class]] == FALSE) {
        
        return;
    }
    
    NSString *s = error.debugDescription;
    
//    showMsg(s);
    
}


+(void) showErrorMsgWithOp:(int) op error:(NSError*) error {



}



+(void)showErrorMsgWithOp:(int)op error:(NSError *)error successBlock:(sucBlock)success {
    
//    if( error != nil && error.code == Def_EC_ServerException ) {
//        
//        // hint user msg in here
//        
//        // NSLog(@"hell");
//        
//        NSString *msg = [NSString stringWithFormat:@"%@(%ld)", NSLocalizedString(@"one_network_error", nil), error.code];
//
//
//        success(msg);
//
//        return;
//    }
//    
//    NSString *msg = [CSUtil msgWithError:error];
//    if ([msg length] == 0) {
//        
//        success(msg);
//        return;
//    }
//    NSString *s = [NSString stringWithFormat:@"%@(%ld)",NSLocalizedString([CSUtil msgWithError:error], nil), error.code];
//    
//#if as_is_dev_mode
//    
//    if( error ) {
//
//        s = [error debugDescription];
//
//    }
//    
//#endif
//    
////    if( (s == nil || s.length < 1) && error != nil ) {
////
////        s = [NSString stringWithFormat:@"%@:%d",error.localizedDescription,op];
////    }
//    
//    success(s);
    
}

+(NSString*) msgWithError:(NSError*) error {
   /* 'OK': 100200,
    'USER_EXIST': 200101, 用户名已存在
    'UNKNOWN_REGISTRAR': 200102, 注册商错误
    'UNKNOWN_REFERRER': 200103, 邀请方错误
    'PARAM_ERROR': 200104, 参数错误
    'SERVER_ERROR': 200105,服务错误
    'NAME_ERROR': 200106, 用户名错误
    'CREATE_USER_EXIST': 200107, 用户名已存在
    ********* NEW_TAG *********
    Def_InvokeFunctionParamException:参数异常
    Def_EC_BuildAccountFail：生成账户信息失败
    Def_EC_RegAccountGetAddressException：生成账户地址失败
    Def_EC_RegAccountServerReturnDataException：服务器返回数据异常
    -1001 请求超时
    -1004：未能连接到服务器
    */
    NSDictionary* config = @{
                             @"200101":@"register_request_user_exist",
                             @"200102":@"register_request_unknown_registrar",
                             @"200103":@"register_request_unknown_referrer",
                             @"200104":@"register_request_param_error",
                             @"200105":@"register_request_server_error",
                             @"200106":@"register_request_name_error",
                             @"200107":@"register_request_create_user_exist",
                             @"200108":@"register_request_exceeded_max_number",
                             @"200109":@"register_request_seed_has_register",
                             
                             @"600116":@"phone_code_error",
                             @"600117":@"is_busy_later_go",
                             @"600118":@"phone_num_geshi_error",
                             @"600109":@"country_or_num_empty",

                             };
    
    NSString *eng = [NSString stringWithFormat:@"%d",error.code];
    
    NSString* s = [config objectForKey:eng];
    
    // if( s == nil ) return @"register_erro";

//    NSString* s = [NSString stringWithFormat:@"code:%d msg:%@",error.code,error.description];
    
    return s;

}

+ (NSString *)errorMsgFromData:(id)data
{
    NSString *errorMsg = nil;
    
    if ([data isKindOfClass:[NSError class]]) {
        
        NSError *pError = (NSError *)data;
        switch (pError.code) {
            case 60002:
            {
                // 该助记词账户信息不存在  未查询到账户信息
                errorMsg = NSLocalizedString(@"error_no_account", @"Account dosen't exist");
            }
                break;
            case 10001:
            {
                // server 连接失败
                errorMsg = [NSString stringWithFormat:@"%@,%@",NSLocalizedString(@"error.connectServerFail", @""),NSLocalizedString(@"refresh_node_then_retry", @"")];
            }
                break;
            case 10002:
            {
                // server 连接超时
                errorMsg = [NSString stringWithFormat:@"%@,%@",NSLocalizedString(@"error.connectServerTimeout", @""),NSLocalizedString(@"refresh_node_then_retry", @"")];
            }
                break;
            case 60003:
            case 60004:
            case 60005:
            case 50006:
            case 10000:
            {
                // 恢复账户失败(60003)
                errorMsg = [NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"recover_account_fail", @""),pError.code];
            }
                break;
            default:
            {
                // 未知错误(493893)
                errorMsg = [NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"unkown_error", @""),pError.code];
            }
                break;
        }
    }else {
        
        errorMsg = NSLocalizedString(@"unkown_error", @"");
    }
    
    return errorMsg;
}


+ (NSString *)showRecoverErrMsg:(ONEError *)error
{
    NSString *str = nil;
    if (error.errorCode == ONEErrorAccountNotExist) {
        str = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"error_no_account", @""),error.errorDescription];
    } else if (error.errorCode == ONEErrorConnectionFailed) {
        str = [NSString stringWithFormat:@"%@,%@(%@)",NSLocalizedString(@"error.connectServerFail", @""),NSLocalizedString(@"refresh_node_then_retry", @""),error.errorDescription];
    } else if (error.errorCode == ONEErrorConnectionTimeout) {
        str = [NSString stringWithFormat:@"%@,%@(%@)",NSLocalizedString(@"error.connectServerTimeout", @""),NSLocalizedString(@"refresh_node_then_retry", @""),error.errorDescription];
    } else if (error.errorCode == ONEErrorRecoverFailed) {
        str = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"recover_account_fail", @""),error.errorDescription];
    } else {
        str = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"unkown_error", @""),error.errorDescription];
    }
    return str;
}



@end
