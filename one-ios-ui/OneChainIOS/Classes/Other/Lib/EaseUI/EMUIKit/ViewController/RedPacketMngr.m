//
//  RedPacketMngr.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/22.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "RedPacketMngr.h"
#import "GetTokenController.h"
#define kLoginUserIdKey @"loginUser"
#import "NSString+Extension.h"
#import "ONEMiningShareView.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
NSString *const GotTokenSuccessNotification = @"GotTokenSuccessNotification";
@interface RedPacketMngr()

@end

static RedPacketMngr *mngr = nil;
@implementation RedPacketMngr

+ (instancetype)sharedMngr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mngr = [[RedPacketMngr alloc] init];
    });
    return mngr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isGettingToken = NO;
    }
    return self;
}

+ (BOOL)saveStatusAfterClick:(NSString *)redpacket_id
{
    if (redpacket_id.length == 0) return NO;
    
    NSString *userId = [ONEChatClient homeAccountId];
    
    if (userId.length == 0) return NO;
    
    NSDictionary *dic = @{
                          kLoginUserIdKey: userId,
                          };
    NSString *udKey = redpacket_id;
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:udKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+(BOOL)redpacketStatus:(NSString *)redpacket_id
{
    if (redpacket_id.length == 0) return NO;
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:redpacket_id];
    
    if (dic == nil) return NO;
    
    NSString *userId = [dic objectForKey:kLoginUserIdKey];
    
    if (userId.length == 0) return NO;
    
    NSString *accountId = [ONEChatClient homeAccountId];
    
    if (![userId isEqualToString:accountId]) return NO;
    
    return YES;
}

+ (void)loginWithCompletetion:(void (^)(GetTokenStatus status))completetion
{
    [[ONEChatClient sharedClient] fetchTokenFromServerWithCompletion:^(ONEError *error, NSString *token) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [[self sharedMngr] setIsGettingToken:NO];
            if (!error) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:GotTokenSuccessNotification object:nil];
                completetion(GetTokenStatusSuccess);
            } else {
                completetion(GetTokenStatusFail);
            }
        });
    }];
}


+ (void)reLoginWithCompletetion:(void (^)(GetTokenStatus status))completetion
{
    if ([[self sharedMngr] isGettingToken]) {
        
        completetion(GetTokenStatusLoading);
    } else {
        
        [[self sharedMngr] setIsGettingToken:YES];
        
        [self loginWithCompletetion:completetion];
    }
    
}


+ (NSString *)getToken
{
    return [ONEChatClient myToken];
}

+ (void)clearToken
{
    [ONEChatClient clearToken];
}

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+ (void)showPasswordVC
{
    UIViewController *topVC = [self topViewController];
    GetTokenController *getTokenVC = [[GetTokenController alloc] init];
    getTokenVC.view.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    [topVC.navigationController pushViewController:getTokenVC animated:YES];
    
}

+ (NSString *)localLaungage
{
    NSString *language = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] && ![[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:@""])
    {
        language = [[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE];
    } else {
        
        language = [[CoinTools sharedCoinTools] getPreferredLanguage];
    }
    return language;
}


+ (NSDictionary *)mapFromJsonString:(NSString *)jsonString
{
    if ([jsonString length] == 0) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = nil;
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    }
    return dic;
}



+ (void)shareMiningImage:(UIImage *)shareImage
{
    UIImage *image = nil;
    if (shareImage) {
        
        image = shareImage;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:nil images:image url:[NSURL URLWithString:@""] title:nil type:SSDKContentTypeImage];
    [ShareSDK showShareActionSheet:nil items:nil shareParams:params onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        if (state == SSDKResponseStateFail) {
            
            if (error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    KLog(@"%@",NSLocalizedString(@"group_share_failed", @"Share failed"));
                    
                });
            }
        }
    }];
}


@end
