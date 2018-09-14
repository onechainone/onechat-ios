//
//  LZChooseNetWorkViewController.m
//  OneChainIOS
//
//  Created by chunzheng wang on 2018/2/5.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZChooseNetWorkViewController.h"
#import "UserNodeMngr.h"
#import "ZYKeyboardUtil.h"
#define MARGIN_KEYBOARD 10
#define HUDMERGE 150
@interface LZChooseNetWorkViewController ()



@property (weak, nonatomic) IBOutlet UILabel *severLabel;
@property (weak, nonatomic) IBOutlet UITextField *severTextField;
@property (weak, nonatomic) IBOutlet UILabel *duanKouLabel;
@property (weak, nonatomic) IBOutlet UITextField *duanKouTextField;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@property (weak, nonatomic) IBOutlet UIView *ipView;
@property (weak, nonatomic) IBOutlet UIView *portView;

@end

@implementation LZChooseNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    self.view.themeMap = @{
                           BGColorName:@"bg_normal_color"
                           };
    //add_network_sataus
    self.title = NSLocalizedString(@"add_network_sataus", @"add netwrok node");
    [self setupUI];
    [self ConfigurationKeyBoard];

    
}
-(void)ConfigurationKeyBoard {
    ///解决键盘遮挡
    self.duanKouTextField.delegate = self;
    self.severTextField.delegate = self;
    
    [self configKeyBoardRespond];
    
}
- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak LZChooseNetWorkViewController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {

        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.duanKouTextField, weakSelf.severTextField, nil];
        
        
    }];
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        // NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}


#pragma mark delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.duanKouTextField resignFirstResponder];
    [self.severTextField resignFirstResponder];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.duanKouTextField resignFirstResponder];
    [self.severTextField resignFirstResponder];
    
    return YES;
}
-(void)setupUI {
    
    self.ipView.themeMap = @{
                             BGColorName:@"input_bg_color"
                             };
    self.portView.themeMap = @{
                               BGColorName:@"input_bg_color"
                               };
    self.severLabel.themeMap = @{
                                 TextColorName:@"golden_text_color"
                                 };
    self.duanKouLabel.themeMap = @{
                                   TextColorName:@"golden_text_color"
                                   };
    self.useBtn.themeMap = @{
                             TextColorName:@"theme_title_color",
                             BGColorName:@"theme_color"
                             };
    self.clearBtn.themeMap = @{
                               TextColorName:@"theme_title_color",
                               BGColorName:@"theme_color"
                               };
    self.severTextField.themeMap = @{
                                     TextColorName:@"conversation_title_color",
                                     PlaceHolderColorName:@"conversation_title_color"
                                     };
    self.duanKouTextField.themeMap = @{
                           TextColorName:@"conversation_title_color",
                           PlaceHolderColorName:@"conversation_title_color"
                           };
    
    self.severLabel.text = NSLocalizedString(@"server_ip", nil);
    [self.severLabel sizeToFit];
    //不存在
    if (![[NSUserDefaults standardUserDefaults] objectForKey:Def_UserOneNodeTag]) {
        
    } else {
        //存在
//        //@"ws://%@:%@/";
        NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:Def_UserOneNodeTag];
//
////        NSString *string = @"<a href=\"http\">这是要截取的内容</a>";
//        NSString *str1 = [url substringFromIndex:3];//截取掉下标5之前的字符串
//        NSString *string = str1;
//
//        NSRange startRange = [string rangeOfString:@"//"];
//        NSRange endRange = [string rangeOfString:@":"];
//        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
//        NSString *result = [string substringWithRange:range];
//        NSLog(@"%@",result);
//        self.severTextField.text = result;
//
//        NSRange startRange1 = [string rangeOfString:@":"];
//        NSRange endRange1 = [string rangeOfString:@"/"];
//        NSRange range1 = NSMakeRange(startRange1.location + startRange1.length, endRange1.location - startRange1.location - startRange1.length);
//        NSString *result1 = [string substringWithRange:range1];
//        self.duanKouTextField.text = result1;
        NSArray *array = [url componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
        NSLog(@"%@",array);
        NSString *strUrl = [array[1] stringByReplacingOccurrencesOfString:@"//" withString:@""];
        self.severTextField.text = strUrl;
        NSString *strUrl1 = [array[2] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        self.duanKouTextField.text = strUrl1;
        
        
    }
//    [[NSUserDefaults standardUserDefaults] objectForKey:Def_UserOneNodeTag]
    self.severTextField.placeholder = NSLocalizedString(@"please_write_server_ip", nil);
    self.duanKouLabel.text = NSLocalizedString(@"port_num", nil);
    [self.duanKouLabel sizeToFit];
    self.duanKouTextField.placeholder = NSLocalizedString(@"please_write_port_num", nil);
    [self.useBtn setTitle:NSLocalizedString(@"detection_and_use", nil) forState:UIControlStateNormal];
    [self.clearBtn setTitle:NSLocalizedString(@"clear_network_status", nil) forState:UIControlStateNormal];
    
}
- (IBAction)userBtnClick:(id)sender {
    [self.view endEditing:YES];
    [self showHudInView:self.view hint:@""];
    
    [UserNodeMngr applyConfigWithIp:self.severTextField.text port:self.duanKouTextField.text cb:^(BOOL state, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            if (state) {
                [self showHint:NSLocalizedString(@"add_success", nil) yOffset:-HUDMERGE];
            } else{
                [self showHint:NSLocalizedString(@"add_error", nil) yOffset:-HUDMERGE];
            }
        });

        
    }];
}
- (IBAction)clearBtnClick:(id)sender {
    [self.view endEditing:YES];
    [UserNodeMngr clearConfig];
    [self showHint:NSLocalizedString(@"clear_mesage_success", nil) yOffset:-HUDMERGE];
//    [self showHint:NSLocalizedString(@"clear_mesage_success", nil)];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
