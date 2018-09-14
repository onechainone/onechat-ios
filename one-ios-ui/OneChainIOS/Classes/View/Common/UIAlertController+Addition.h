//
//  UIAlertController+Addition.h
//  pet
//
//  Created by 韩绍卿 on 2017/7/28.
//  Copyright © 2017年 hanshaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Addition)
typedef void (^rightBlock)();
typedef void (^writeDown)(BOOL state,NSString *password);
typedef void (^rightClick)(NSString *str);
@property(nonatomic )NSString *shuRuStr;

typedef void (^fistBlock)();
typedef void (^secondBlock)();
typedef void (^thirdBlock)();

+ (instancetype)shareAlertController;
//弹窗提示
- (void)showAlertcWithString:(NSString *)str controller:(UIViewController *)target;

- (void)showTitleAlertcWithString:(NSString *)str andTitle:(NSString *)title controller:(UIViewController *)target;

- (void)showAlertcWithStringId:(NSString *) strId controller:(UIViewController *)target;
////双向的按钮
-(void)showTwoChoiceAlertcWithTipString:(NSString *)tipStr andLeftBtnStr:(NSString *)leftStr andRightBtnStr:(NSString *)rightStr andRightBlock:(rightBlock)rightblock controller:(UIViewController *)target;
-(void)writePassWordWith:(writeDown)writeDown andController:(UIViewController *)target;

-(void)showTwoChoiceAlertcWithTitleString:(NSString *)tipStr andMsg:(NSString *)msg andLeftBtnStr:(NSString *)leftStr andRightBtnStr:(NSString *)rightStr andRightBlock:(rightBlock)rightblock controller:(UIViewController *)target;
///输入框
-(void)showTextFeildWithTitle:(NSString *)title andMsg:(NSString *)msg andLeftBtnStr:(NSString *)leftStr andRightBtnStr:(NSString *)rightStr andRightBlock:(rightClick)rightblock controller:(UIViewController *)target;

-(void)showTextFeildWithTitle:(NSString *)title andMsg:(NSString *)msg andLeftBtnStr:(NSString *)leftStr andRightBtnStr:(NSString *)rightStr andRightBlock:(rightClick)rightblock defaultStr:(NSString *)defaultStr controller:(UIViewController *)target;
///////竖着排列3个选择的
-(void)showThreeChoiceAlertWithTitleString:(NSString *)titleStr andMsg:(NSString *)msgStr andFristBtnTitle:(NSString *)fistStr andSecondBtnTitle:(NSString *)secondStr andThirdBtnTitle:(NSString *)thirdStr andfistBlock:(fistBlock)fistBlock andSecondBlck:(secondBlock)secondBlock andThirdBlock:(thirdBlock)thirdBlock controller:(UIViewController *)target;

@end

void showMsgAlert(id target,NSString* stringId);
