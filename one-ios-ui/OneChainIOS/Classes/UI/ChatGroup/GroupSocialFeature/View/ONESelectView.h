//
//  ONESelectView.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol ONESelectViewDelegate<NSObject>
//
//- (void)selectViewDidChooseItem:(NSDictionary *)dict;
//
//@end

typedef void(^ChooseItemBlock)(NSDictionary *dict);

@interface ONESelectView : UIView

@property (nonatomic, copy) ChooseItemBlock chooseItemBlock;
+ (CGFloat)defaultHeight;

- (void)reloadItems:(NSArray *)items;


@end
