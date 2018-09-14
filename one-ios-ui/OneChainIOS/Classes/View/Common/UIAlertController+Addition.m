//
//  UIAlertController+Addition.m
//  pet
//
//  Created by 韩绍卿 on 2017/7/28.
//  Copyright © 2017年 hanshaoqing. All rights reserved.
//

#import "UIAlertController+Addition.h"

void showMsgAlert(id target,NSString* stringId) {
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
    

            [[UIAlertController shareAlertController] showAlertcWithStringId:stringId controller:target];

    
        });
    
    
    return;
}

@implementation UIAlertController (Addition)

+ (instancetype)shareAlertController{
    
    static UIAlertController *client;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        client = [[self alloc]init];
    });
    
    return client;
}

- (void)showAlertcWithStringId:(NSString *) strId controller:(UIViewController *)target{
    
    if( target == nil ) return;
    
    if( strId == nil ) {
        
        strId = @"defualt_string_id";
    }
    
    NSString* title =  NSDefLocalizedString(@"message_title");
    
    NSString* msg = NSDefLocalizedString(strId);
    
    [self showTitleAlertcWithString:msg andTitle:title controller:target];

}


- (void)showAlertcWithString:(NSString *)str controller:(UIViewController *)target{
    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
//    //button_ok 确定按钮
//    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"button_ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }]];
//
//    [target presentViewController:alert animated:YES completion:nil];
    
    NSString* title =  NSDefLocalizedString(@"message_title");

    [self showTitleAlertcWithString:str andTitle:title controller:target];
    
    
}


//- (void)showTitleAlertcWithString:(NSString *)str andTitle:(NSString *)title controller:(UIViewController *)target {
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [self _showTitleAlertcWithString:str andTitle:title controller:target];
//
//
//    });
//}


- (void) showTitleAlertcWithString:(NSString *)str andTitle:(NSString *)title controller:(UIViewController *)target {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    //button_ok 确定按钮
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"button_ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [target presentViewController:alert animated:YES completion:nil];
}
-(void)showTwoChoiceAlertcWithTipString:(NSString *)tipStr andLeftBtnStr:(NSString *)leftStr andRightBtnStr:(NSString *)rightStr andRightBlock:(rightBlock)rightblock controller:(UIViewController *)target{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:tipStr message:@"" preferredStyle:UIAlertControllerStyleAlert];
    ///取消 button_cancel
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:leftStr style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
    //确认 button_confirm
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:rightStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        rightblock();
        
    }];
    
    [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
    
    [alertVC addAction:confirmAction];
    
    [alertVC addAction:cancelAction];
    
    [target presentViewController:alertVC animated:YES completion:nil];
    
}
-(void)writePassWordWith:(writeDown)writeDown andController:(UIViewController *)target{
    [CoinInfoMngr sharedCoinInfoMngr].mima = @"";
    //change_user_local_name 修改好友备注
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"enter_password", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
    ///取消 button_cancel
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
    
    //确认 button_confirm
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ///////
        NSLog(@"点击了确定");
        // self.tableCell.subtitles = self.nicknameStr;
        
        //            cb(TRUE,contentData);
        BOOL check = [ONEChatClient checkPassword:[CoinInfoMngr sharedCoinInfoMngr].mima];
        //成功了
        if (check) {
//            cb(TRUE,contentData);
            writeDown(check,[CoinInfoMngr sharedCoinInfoMngr].mima);
            
        } else {
//            cb(FALSE,contentData);
            writeDown(check,[CoinInfoMngr sharedCoinInfoMngr].mima);
            [[UIAlertController shareAlertController] showTitleAlertcWithString:NSLocalizedString(@"unlocking_wallet_error_detail", nil) andTitle:NSLocalizedString(@"unlocking_wallet_error_title", nil) controller:target];
            
        }
        
        
    }];
    
    [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.secureTextEntry = YES;
        
        [textField addTarget:self action:@selector(buyTextFieldChange:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    
    [alertVC addAction:confirmAction];
    [alertVC addAction:cancelAction];
    
    [target presentViewController:alertVC animated:YES completion:nil];
    
}
-(void)showTwoChoiceAlertcWithTitleString:(NSString *)tipStr andMsg:(NSString *)msg andLeftBtnStr:(NSString *)leftStr andRightBtnStr:(NSString *)rightStr andRightBlock:(rightBlock)rightblock controller:(UIViewController *)target{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:tipStr message:msg preferredStyle:UIAlertControllerStyleAlert];
    ///取消 button_cancel
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:leftStr style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
    //确认 button_confirm
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:rightStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        rightblock();
        
    }];
    
    [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
    
    [alertVC addAction:confirmAction];
    
    [alertVC addAction:cancelAction];
    
    [target presentViewController:alertVC animated:YES completion:nil];
    
    
}
-(void)showTextFeildWithTitle:(NSString *)title andMsg:(NSString *)msg andLeftBtnStr:(NSString *)leftStr andRightBtnStr:(NSString *)rightStr andRightBlock:(rightClick)rightblock controller:(UIViewController *)target {
//    self.shuRuStr = [NSString new];
    [CoinInfoMngr sharedCoinInfoMngr].shuRuStr = @"";
    
    //change_user_local_name 修改好友备注
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    ///取消 button_cancel
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
    
    //确认 button_confirm
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ///////
        NSLog(@"点击了确定");
        rightblock([CoinInfoMngr sharedCoinInfoMngr].shuRuStr);
        
    }];
    
    [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        [textField addTarget:self action:@selector(TextFieldChange:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    
    [alertVC addAction:confirmAction];
    [alertVC addAction:cancelAction];
    
    [target presentViewController:alertVC animated:YES completion:nil];
}

-(void)showTextFeildWithTitle:(NSString *)title andMsg:(NSString *)msg andLeftBtnStr:(NSString *)leftStr andRightBtnStr:(NSString *)rightStr andRightBlock:(rightClick)rightblock defaultStr:(NSString *)defaultStr controller:(UIViewController *)target
{
    [CoinInfoMngr sharedCoinInfoMngr].shuRuStr = @"";
    
    //change_user_local_name 修改好友备注
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    ///取消 button_cancel
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
    
    //确认 button_confirm
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ///////
        NSLog(@"点击了确定");
        rightblock([CoinInfoMngr sharedCoinInfoMngr].shuRuStr);
        
    }];
    
    [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        if ([defaultStr length] > 0) {
            textField.text = defaultStr;
        }
        [textField addTarget:self action:@selector(TextFieldChange:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    
    [alertVC addAction:confirmAction];
    [alertVC addAction:cancelAction];
    
    [target presentViewController:alertVC animated:YES completion:nil];
}
-(void)showThreeChoiceAlertWithTitleString:(NSString *)titleStr andMsg:(NSString *)msgStr andFristBtnTitle:(NSString *)fistStr andSecondBtnTitle:(NSString *)secondStr andThirdBtnTitle:(NSString *)thirdStr andfistBlock:(fistBlock)fistBlock andSecondBlck:(secondBlock)secondBlock andThirdBlock:(thirdBlock)thirdBlock controller:(UIViewController *)target {
    
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr
                                                                             message:msgStr
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.创建并添加按钮
    UIAlertAction *fistAction = [UIAlertAction actionWithTitle:fistStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"OK Action");
        fistBlock();
        
    }];

    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"Reset Action");
        secondBlock();
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:thirdStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cancelAction];       // B
    [alertController addAction:fistAction];           // A
    [alertController addAction:secondAction];        // C
    
    // 3.呈现UIAlertContorller
    [target presentViewController:alertController animated:YES completion:nil];
    
    
    
    
    
    
    
    
}

- (void)buyTextFieldChange:(UITextField *)textfiled {
    
    [CoinInfoMngr sharedCoinInfoMngr].mima = textfiled.text;
    

}
- (void)TextFieldChange:(UITextField *)textfiled {
    [CoinInfoMngr sharedCoinInfoMngr].shuRuStr = textfiled.text;
    
    
    
}
//- (NSString *)shuRuStr
//{
//    if (!_shuRuStr) {
//
//        _shuRuStr = [NSString new];
//    }
//    return _shuRuStr;
//}
@end
