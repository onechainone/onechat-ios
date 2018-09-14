//
//  QRDecoder.h
//  LZEasemob3
//
//  Created by summer0610 on 2017/12/14.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRDecoder : NSObject

@property(nonatomic,strong) NSString* tag;
@property(nonatomic,strong) NSMutableDictionary* config;


-(BOOL) decodeString:(NSString*) string;

+(UIImage*)  txQRCodeImageWithCoinName:(NSString*) coinName
                               address:(NSString*) address
                                amount:(NSString*) amount
                                  size:(CGSize)size
                                 scale:(CGFloat)scale;

@end
