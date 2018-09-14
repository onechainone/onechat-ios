//
//  ONEThemeManager.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/28.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEThemeManager.h"
#import "ONETheme.h"
#define kTHEMESAVETAG @"THEME_SAVE_TAG"
@interface ONEThemeManager()

@property (nonatomic, strong) NSMutableArray *themes;

@end

static ONEThemeManager *instance = nil;

@implementation ONEThemeManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ONEThemeManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _themes = [self _configFile];
    }
    return self;
}



- (NSArray *)_configFile
{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"json"];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
//    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil
//                 ];
//    if (result && [result isKindOfClass:[NSArray class]]) {
//        return (NSArray *)result;
//    }
//    return nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"OneTheme" ofType:@"plist"];

    return [NSArray arrayWithContentsOfFile:filePath];
}


- (NSString *)_themeConfigPath
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ONETheme" ofType:@"bundle"];
    NSBundle *themeBundle = [NSBundle bundleWithPath:path];
    NSString *plistPath = [themeBundle pathForResource:@"ONETheme" ofType:@"plist"];
    return plistPath;
}

+ (void)start
{
    [self startWithSavedTheme];
}

- (void)switchTheme:(NSString *)themeId
{
    if ([themeId length] == 0) {
        themeId = @"1";
    }
    if (self.theme && [self.theme.theme_id isEqualToString:themeId]) {
        return;
    }
    NSDictionary *config = nil;
    for (NSDictionary *dic in _themes) {
        
        if ([dic[@"id"] isEqualToString:themeId]) {
            config = [dic copy];
            break;
        }
    }
    ONETheme *theme = [[ONETheme alloc] initWithThemeConfig:config];
    self.theme = theme;
    if ([theme.theme_id isEqualToString:@"2"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
    [self saveTheme:theme];
}

- (void)saveTheme:(ONETheme *)theme
{
    NSString *theme_id = theme.theme_id;
    if ([theme_id length] == 0) {
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:theme_id forKey:kTHEMESAVETAG];
    [ud synchronize];
}

+ (void)startWithSavedTheme
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *tID = @"1";
    
    if ([ud objectForKey:kTHEMESAVETAG] && [[ud objectForKey:kTHEMESAVETAG] integerValue] > 0 && [[ud objectForKey:kTHEMESAVETAG] integerValue] <= 3) {
        tID = [ud objectForKey:kTHEMESAVETAG];
    }
    [[self sharedInstance] switchTheme:tID];
}

+ (void)resetTheme
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTHEMESAVETAG];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self start];
}

+ (void)resetStatusBarStyle
{
    NSString *theme_id = [[self sharedInstance] theme].theme_id;
    if ([theme_id length] > 0 && [theme_id isEqualToString:@"2"]) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        return;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

@end
