//
//  QRDecoder.m
//  LZEasemob3
//
//  Created by summer0610 on 2017/12/14.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "QRDecoder.h"



@implementation QRDecoder

// oneapp://onechain.one?a=b&c=f


//oneapp://onechain.one?action=addfriend&account_name=heshuai123  加人
//我:
//oneapp://onechain.one?action=transfer&account_name=heshuai123

// bitcoin:sadfjaskldfjsdf?amount=3334

//

-(BOOL) decodeString:(NSString*) string {
    
    if( string == nil || string.length < 3 ) return FALSE;
    
    NSArray *list = [string componentsSeparatedByString:@":"];

    if( list == nil || list.count < 2 ) {
        
        return FALSE;
        
    }
    
    self.tag = list[0];
    
    if( self.tag== nil || self.tag.length < 1 ) {
        
        return FALSE;
    }
    
    int offset = self.tag.length +1;
    
    int len = string.length - offset;
    
    if( len <= 0 ) {
        
        return FALSE;
    }
    
    NSString* param = [string substringWithRange:NSMakeRange(offset, len)];
    
    
    NSMutableDictionary* dict = [self decodeParamWithTag:self.tag param:param];
    
    if( dict == nil ) return FALSE;
    
    self.config = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self.config setObject:self.tag forKey:@"_tag_"];

    return TRUE;

}

-(NSMutableDictionary*) decodeParamWithTag:(NSString*) tag param:(NSString*) param {
    
    NSString* funcName = [self decodeParamFunctionWithTag:tag];
    
    if( funcName == nil || funcName.length < 1 ) return nil;
    
    SEL function = NSSelectorFromString(funcName);
    
    if( function == nil ) {
        
        return nil;
        
    }
    
    if( [self respondsToSelector:function] == FALSE ) {
        
        return nil;
        
    }
    
    id ret = [self performSelector:function withObject:param];
    
    return ret;
    
}

-(NSString*) decodeParamFunctionWithTag:(NSString*) tag {
    
    if( tag == nil ) return nil;
    
    NSDictionary* map = @{
                           @"oneapp":@"decodeOneQRParam:",
                           @"coin":@"decodeCoinQRParam:"
                        };
    
    NSString* funcName = [map  objectForKey:tag];
    
    if( funcName == nil ) {
        
        funcName = [map objectForKey:@"coin"];
        
    }
    
    return funcName;
    
}


//oneapp:  //onechain.one?action=addfriend&account_name=heshuai123  加人

-(NSMutableDictionary*) decodeOneQRParam:(NSString*) param {
    
    if( param == nil || param.length < 1 ) return nil;
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *list = [param componentsSeparatedByString:@"?"];
    if (list.count>2) {
        for (int i = 2; i<list.count; i++) {
//            NSString *tempStr = [list[i-1] stringByAppendingString:list[i]];
            NSString *tempStr = [NSString stringWithFormat:@"%@?%@",list[i-1],list[i]];
            
            list[1] = tempStr;
            [list removeObjectAtIndex:i];
//            [list objectAtIndex:1] = tempStr;
        }
    }
    if( list == nil || list.count != 2 ) return dict;
    
    [self decodeOneSubQRParam: [list objectAtIndex:1] dict:dict];
    
    return dict;
    
    
}

// action=addfriend&account_name=heshuai123

-(void) decodeOneSubQRParam:(NSString*) param  dict:(NSMutableDictionary*) dict {
    
    if( param == nil || param.length < 1 ) return;
    
    NSArray *list = [param componentsSeparatedByString:@"&"];
    
   
    for(NSString* sub in list) {
        
        [self decodePeerSubQRParam:sub dict:dict];
    
    }
    
    
}


// bitcoin: address?amount=4

-(NSMutableDictionary*) decodeCoinQRParam:(NSString*) param {
    
    if( param == nil || param.length < 1 ) return nil;
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    NSArray *list = [param componentsSeparatedByString:@"?"];

    [dict setObject:list[0] forKey:@"address"];
    
    if( list.count < 2 ) return dict;
    
    [self decodeOneSubQRParam: [list objectAtIndex:1] dict:dict];
    
    return dict;
}

// like : amount=4

-(void) decodePeerSubQRParam:(NSString*) param  dict:(NSMutableDictionary*) dict {

    if( param == nil || param.length < 1 ) return;
    
    NSArray *list = [param componentsSeparatedByString:@"="];

    if( list == nil || list.count != 2 ) return;
    
    NSString* k = list[0];
    NSString* v = list[1];
    
    if(k.length< 1 ) return;
    
    if(v.length< 1 ) return;

    
    [dict setObject:list[1] forKey:list[0]];
    
}

+(UIImage*)  txQRCodeImageWithCoinName:(NSString*) coinName
                               address:(NSString*) address
                                amount:(NSString*) amount
                                  size:(CGSize)size
                                 scale:(CGFloat)scale {
    
    return nil;
    
}

+(NSString*)  oneQRCodeStringWithAddress:(NSString*) address
                                amount:(NSString*) amount {
    
    
    NSMutableString* tmp = [[NSMutableString alloc] init];
    
    [tmp appendFormat:@"oneapp://onechain.one?a=transfer&n=%@",address];
    
    if( amount != nil && amount.length > 0 ) {
        
        [tmp appendFormat:@"&amount=%@",amount];
        
    }
    
    return tmp;

}

+(NSString*)  erc20QRCodeStringWithEthAddress:(NSString*) address
                                 erc20Addrees:(NSString*) ERC20Address
                                  amount:(NSString*) amount {
    
    
    NSString* ethAddress = nil;
    
    
    NSMutableString* tmp = [[NSMutableString alloc] init];
    
    [tmp appendFormat:@"ethereum:%@?req-asset=%@",address,ERC20Address];
    
    if( amount != nil && amount.length > 0 ) {
        
        [tmp appendFormat:@"&amount=%@",amount];
    }
    
    return tmp;
    
}


+(NSString*)  commonQRCodeStringWithcoinName:(NSString*) coinName
                                 address:(NSString*) address
                                       amount:(NSString*) amount {
    
    
    
    coinName = [coinName lowercaseString];
    
    NSMutableString* tmp = [[NSMutableString alloc] init];

    [tmp appendFormat:@"%@:%@",coinName,address];
    
    if( amount != nil && amount.length > 0 ) {
        
        [tmp appendFormat:@"?amount=%@",amount];
    }
    
    return tmp;
    
}


@end
