//
//  ChoseCell.h
//  demoDan
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoseCell : UITableViewCell



@property(nonatomic,strong)UILabel * nameLabel;

@property(nonatomic,strong)UIImageView * stateV;
//是不是选中
@property(nonatomic,assign)BOOL isSele;
@end
