//
//  ServerInfo.h
//  WalletCore
//
//  Created by summer0610 on 2018/1/11.
//  Copyright © 2018年 FanYuanYouQing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerInfo:NSObject

-(id) initWithList:(NSArray*) list;

@property(nonatomic,strong) NSString* tag;
@property(nonatomic,strong) NSString* name;
@property(nonatomic) BOOL isPing;

@property(nonatomic,strong) NSString* activeUrl;
@property(nonatomic,strong) NSString* activeNodeId;
@property(nonatomic) float factor;

@property(nonatomic,strong) NSDictionary* activeNode;

@property(nonatomic,strong) NSArray* nodeList;

@property(nonatomic,strong) NSMutableDictionary * filterDict;


-(NSDictionary*) dict;

@end
