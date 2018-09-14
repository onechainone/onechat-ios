//
//  ASObject.h
//  WalletCore
//
//  Created by summer0610 on 2017/11/9.
//  Copyright © 2017年 FanYuanYouQing. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import <WalletCore/ASEntity.h>
#import "ASEntity.h"

/** SQLite五种数据类型 */
#define SQLTEXT     @"TEXT"
#define SQLINTEGER  @"INTEGER"
#define SQLREAL     @"REAL"
#define SQLBLOB     @"BLOB"
#define SQLNULL     @"NULL"
#define PrimaryKey  @"primary key"

@interface ASObject : ASEntity


+(NSString*) indexColumnName;
+(NSString*) defIndexColumnName;

+(void) colNameList:(NSMutableArray*) colList;
+(NSString*) buildHash;

+(NSMutableDictionary*) proInfoWithObject;

+(NSString*) formatObject:(id) raw;

+(NSString*) formatFilterWithKey:(NSString*) key value:(id) v;


@end
