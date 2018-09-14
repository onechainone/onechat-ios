//
//  WSAccountInfo.h
//  WalletCore
//
//  Created by summer0610 on 2017/11/9.
//  Copyright © 2017年 FanYuanYouQing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WalletCore/ASObject.h>
//#import "ASObject.h"


typedef NS_ENUM(NSUInteger, AccountSex) {
    
    AccountMan = 1,
    AccountWoman = 2,
    AccountUNKNOWN = 3,

    
};


typedef NS_ENUM(NSUInteger, AccountType) {
    
    AccountTypeFriend = 1,
    AccountTypeStranger = 2,
    AccountTypeOther = 100
    
};


@interface WSAccountInfo : ASObject

-(id) initWithDict:(NSDictionary*) dict;

- (instancetype)initWithNewDict:(NSDictionary *)map;

-(id) initWithDictPlus:(NSDictionary*) map type:(AccountType) type;

@property(nonatomic,strong) NSString* ID;

@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* nickname;
@property(nonatomic) AccountSex sex;


@property(nonatomic,strong) NSString* address;

@property(nonatomic,strong) NSString* avatar_url;

@property(nonatomic,strong) NSString* intro;
@property(nonatomic,strong) NSString* mobile;
@property(nonatomic,strong) NSString* email;

@property(nonatomic,strong) NSString* referrer;

@property(nonatomic) AccountType type;
@property(nonatomic,strong) NSString* mark;



-(NSString*) formatString;

-(NSString*) accountNickName;

@end
