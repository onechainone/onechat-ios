//
//  MessageTableViewCell.m
//  LZEasemob3
//
//  Created by hanshaoqing on 2017/11/8.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "MessageTableViewCell.h"
#import <WalletCore/WSBigNumber.h>

#import "CoinTools.h"

@interface  MessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *badCountLabel;

@end
@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageLabel.text =
    [NSString stringWithFormat:@"%@ 10",NSLocalizedString(@"chat_asset_num", nil)];
    
}
-(void)setMessageCount:(NSString *)messageCount {
    self.messageLabel.text =
    [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"chat_asset_num", nil),messageCount];
}

-(NSString*) amountWithDict:(NSMutableDictionary*) dict {
    
    return [CoinTools creditAssetWithDict:dict];
    
//    //等于空的时候retrun
//    if(goodDic == nil ) {
//
//        return @"";
//    }
//
//
//    id amount = goodDic[BALANCE_AMOUNT];
//
//    NSString* ta = nil;
//
//    if( [amount isKindOfClass:[NSNumber class]] ) {
//
//        NSNumber* na = amount;
//
//        ta = [na stringValue];
//
//    } else {
//
//        ta = amount;
//    }
//
//
//    WSBigNumber* n = [[WSBigNumber alloc] initWithDecimalString:ta];
//    //这个方法传 精度和个数
//    int  min_prece = [goodDic[BALANCE_PRECISION] intValue];
//    NSString* strAmount =  [n stringWithRShiftDec:min_prece];
//
//    return strAmount;
}

-(void)setGoodDic:(NSMutableDictionary *)goodDic {
    if (!goodDic) {
        return;
    }
    
//    self.goodCountLabel.text = [self amountWithDict:goodDic];
    id amount = [goodDic objectForKey:BALANCE_AMOUNT];
    
    //    if( dict == nil ) {
    //
    //        return ret;
    //    }
    
    NSString* ta = nil;
    
    if( [amount isKindOfClass:[NSNumber class]] ) {
        
        NSNumber* na = amount;
        
        ta = [na stringValue];
        
    } else {
        
        ta = amount;
    }
    
    
    //这个方法传 精度和个数
    
    //    NSNumber* p = [dict objectForKey:BALANCE_PRECISION];
    NSNumber* p = [[NSNumber alloc] initWithInt:3];
    
    //    if( p == nil ) {
    //
    //        return ret;
    //    }
    //
    int  min_prece = [p intValue];
    
    WSBigNumber* n = [[WSBigNumber alloc] initWithDecimalString:ta];
    //    WSBigNumber *temp = [[WSBigNumber alloc] initWithDecimalString:@"100"];
    
    NSString* strAmount =  [n stringWithRShiftDec:min_prece];
    
    
    
    
    
    self.goodCountLabel.text = strAmount;
    
    
    
}
-(void)setBadDic:(NSMutableDictionary *)badDic {
    
        if(!badDic) {
            return;
        }
    //    WSBigNumber* n = [[WSBigNumber alloc] initWithDecimalString:badDic[BALANCE_AMOUNT]];
    //    //这个方法传 精度和个数
    //    NSString* strAmount =  [n stringWithRShiftDec:badDic[BALANCE_PRECISION]];
    
//    NSString *str = [self amountWithDict:badDic];

//    NSDecimalNumber *decimalNum = [[NSDecimalNumber alloc] initWithString:str];
//    NSDecimalNumber *hundNum = [[NSDecimalNumber alloc] initWithString:@"100"];
//    NSDecimalNumber *temp = [decimalNum decimalNumberByMultiplyingBy:hundNum];
//
//    NSString* ret = @"0";
    
    //等于空的时候retrun
//    if(dict == nil ) {
//
//        return ret;
//    }
    
    
    id amount = [badDic objectForKey:BALANCE_AMOUNT];
    
//    if( dict == nil ) {
//
//        return ret;
//    }
    
    NSString* ta = nil;
    
    if( [amount isKindOfClass:[NSNumber class]] ) {
        
        NSNumber* na = amount;
        
        ta = [na stringValue];
        
    } else {
        
        ta = amount;
    }
    
    
    //这个方法传 精度和个数
    
//    NSNumber* p = [dict objectForKey:BALANCE_PRECISION];
    NSNumber* p = [[NSNumber alloc] initWithInt:3];

//    if( p == nil ) {
//
//        return ret;
//    }
//
    int  min_prece = [p intValue];
    
    WSBigNumber* n = [[WSBigNumber alloc] initWithDecimalString:ta];
    //    WSBigNumber *temp = [[WSBigNumber alloc] initWithDecimalString:@"100"];
    
    NSString* strAmount =  [n stringWithRShiftDec:min_prece];
    
    
    
    
    
    self.badCountLabel.text = strAmount;

    
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
