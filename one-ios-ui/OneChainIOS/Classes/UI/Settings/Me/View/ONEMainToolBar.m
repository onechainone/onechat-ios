//
//  ONEMainToolBar.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/23.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEMainToolBar.h"
#import "ONESettingItem.h"

@interface ONEMainToolBar()

@end

@implementation ONEMainToolBar

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        _items = items;
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    if ([_items count] == 0) {
        return;
    }
    CGFloat kItemWidth = self.width / _items.count;
    for (NSInteger i = 0; i < _items.count ; i++) {
        
        NSDictionary *dic = _items[i];
        CGFloat x = kItemWidth * i;
        ONESettingItem *item = [[ONESettingItem alloc] initWithFrame:CGRectMake(x, 0, kItemWidth, self.height) image:dic[@"image"] title:dic[@"title"]];
        kWeakSelf
        item.itemClicked = ^(NSString *title) {
            if ([weakself.delegate respondsToSelector:@selector(toolBar:didItemClick:)]) {
                [weakself.delegate toolBar:weakself didItemClick:title];
            }
        };
        [self addSubview:item];
    }
}




@end
