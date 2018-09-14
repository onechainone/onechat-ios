//
//  MessageTableViewCell.h
//  LZEasemob3
//
//  Created by hanshaoqing on 2017/11/8.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property(nonatomic,strong)NSMutableDictionary *goodDic;
@property(nonatomic,strong)NSMutableDictionary *badDic;

@property(nonatomic,strong)NSString *messageCount;

@end
