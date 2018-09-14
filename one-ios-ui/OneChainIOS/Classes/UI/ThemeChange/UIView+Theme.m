//
//  UIView+Theme.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/29.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "UIView+Theme.h"
#import <objc/runtime.h>
#import "DeallocBlockExecutor.h"
#import "NSObject+DeallocBlock.h"
#import "ONEThemeManager.h"

NSString *const ColorName = @"ColorName";
NSString *const BGColorName = @"BGColorName";
NSString *const TableSepColorName = @"TableSepColorName";
NSString *const TextColorName = @"TableTextColorName";
NSString *const PlaceHolderColorName = @"TablePlaceHolderColorName";
NSString *const ActivityViewStyle = @"ActivityViewStyle";
NSString *const BorderColorName = @"BorderColorName";
NSString *const MainThemeColor = @"MainThemeColor";

NSString *const ButtonSelectedTextColor = @"ButtonSelectedTextColor";
// image
NSString *const BackgroudImageName = @"BackgroudImageName";
NSString *const NormalImageName = @"NormalImageName";
NSString *const HighLightedImageName = @"HighLightedImageName";
NSString *const SelectedImageName = @"SelectedImageName";
NSString *const DisabledImageName = @"DisabledImageName";
NSString *const ImageName = @"ImageName";

static void *kThemeMap;
static void *kUIView_DeallocHelper;
@implementation UIView (Theme)

- (NSDictionary *)themeMap
{
    return objc_getAssociatedObject(self, &kThemeMap);
}

- (void)setThemeMap:(NSDictionary *)themeMap
{
    objc_setAssociatedObject(self, &kThemeMap, themeMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (themeMap) {
        @autoreleasepool {
            
            if (objc_getAssociatedObject(self, &kUIView_DeallocHelper) == nil) {
                __unsafe_unretained typeof(self) weakSelf = self;
                
                id deallocHelper = [self addDeallocBlock:^{
                    NSLog(@"deallocing %@", weakSelf);
                    [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                }];
                objc_setAssociatedObject(self, &kUIView_DeallocHelper, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
            }
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeDidChangeNotification object:nil];
            [self themeChanged];
        }
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    }
    
}

- (void)themeChanged
{
    if (self.hidden) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeTheme];
        });
    }
    else {
        [self changeTheme];
    }
}

- (void)changeTheme
{
    NSDictionary *map = self.themeMap;
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *lbl = (UILabel *)self;
        if (map[BGColorName]) {
            [lbl setBackgroundColor:THMColor(map[BGColorName])];
        }
        if (map[TextColorName]) {
            [lbl setTextColor:THMColor(map[TextColorName])];
        }
        
        if (map[BorderColorName]) {
            [lbl.layer setBorderColor:THMColor(map[BorderColorName]).CGColor];
        }

        return;
    } else if ([self isKindOfClass:[UITableView class]]) {
        UITableView *table = (UITableView *)self;
        if (map[BGColorName]) {
            [table setBackgroundColor:THMColor(map[BGColorName])];
        }
        if (map[TableSepColorName]) {
            [table setSeparatorColor:THMColor(map[TableSepColorName])];
        }
        return;
    } else if ([self isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)self;
        if (map[BGColorName]) {
            [cell setBackgroundColor:THMColor(map[BGColorName])];
        }
        return;
    } else if ([self isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton *)self;
        if (map[TextColorName]) {
            [button setTitleColor:THMColor(map[TextColorName]) forState:UIControlStateNormal];
        }
        if (map[ButtonSelectedTextColor]) {
            [button setTitleColor:THMColor(map[ButtonSelectedTextColor]) forState:UIControlStateSelected];
        }
        if (map[BGColorName]) {
            [button setBackgroundColor:THMColor(map[BGColorName])];
        }
        if (map[NormalImageName]) {
            [button setImage:THMImage(map[NormalImageName]) forState:UIControlStateNormal];
        }
        if (map[SelectedImageName]) {
            [button setImage:THMImage(map[SelectedImageName]) forState:UIControlStateSelected];
        }
        if (map[HighLightedImageName]) {
            [button setImage:THMImage(map[HighLightedImageName]) forState:UIControlStateHighlighted];
        }
        if (map[BackgroudImageName]) {
            [button setBackgroundImage:THMImage(map[BackgroudImageName]) forState:UIControlStateNormal];
        }
        return;
    } else if ([self isKindOfClass:[UIImageView class]]) {
        
        UIImageView *imageV = (UIImageView *)self;
        if (map[BGColorName]) {
            [imageV setBackgroundColor:THMColor(map[BGColorName])];
        }
        if (map[ImageName]) {
            imageV.image = THMImage(map[ImageName]);
        }
        return;
    } else if ([self isKindOfClass:[UITextField class]]) {
        
        UITextField *tf = (UITextField *)self;
        if (map[TextColorName]) {
            [tf setTextColor:THMColor(map[TextColorName])];
        }
        if (map[PlaceHolderColorName]) {
            [tf setValue:THMColor(map[PlaceHolderColorName]) forKeyPath:@"_placeholderLabel.textColor"];
        }
        if (map[BGColorName]) {
            [tf setBackgroundColor:THMColor(map[BGColorName])];
        }
        return;
    } else if ([self isKindOfClass:[UITextView class]]) {
        
        UITextView *tv = (UITextView *)self;
        if (map[TextColorName]) {
            [tv setTextColor:THMColor(map[TextColorName])];
        }
        if (map[BGColorName]) {
            [tv setBackgroundColor:THMColor(map[BGColorName])];
        }
        return;
    } else if ([self isKindOfClass:[UIActivityIndicatorView class]]) {
      
        UIActivityIndicatorView *av = (UIActivityIndicatorView *)self;
        if (map[ActivityViewStyle]) {

            [av setActivityIndicatorViewStyle:THMACStyle(map[ActivityViewStyle])];
        }
        return;
    } else if ([self isKindOfClass:[UISearchBar class]]) {
        UISearchBar *searchBar = (UISearchBar *)self;
        if (map[BGColorName]) {
            [searchBar setBackgroundColor:THMColor(map[BGColorName])];
        }
        return;
    } else if ([self isKindOfClass:[UIView class]]) {
        
        if (map[BGColorName]) {
            [self setBackgroundColor:THMColor(map[BGColorName])];
        }
    }
}
@end
