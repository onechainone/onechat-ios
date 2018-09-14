//
//  SYSContactManager.h
//  XMLDecoder
//
//  Created by lifei on 2018/2/5.
//  Copyright © 2018年 lifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYSContactManager : NSObject

+ (instancetype)manager;

+ (void)clearManager;

- (void)uploadSystemAddressBookListWithCompletion:(void(^)(NSError *error))completion;

- (void)getSystemAddressBookListWithCompletetion:(void(^)(NSError *error, NSArray *list))completion;
@end
