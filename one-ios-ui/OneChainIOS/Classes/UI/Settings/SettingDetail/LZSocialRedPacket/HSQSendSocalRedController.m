//
//  HSQSendSocalRedController.m
//  OneChainIOS
//
//  Created by chunzheng wang on 2017/12/30.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "HSQSendSocalRedController.h"
#import "LZSocialRedPacketDetailViewController.h"

@interface HSQSendSocalRedController ()

@end

@implementation HSQSendSocalRedController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:REDPACKET_TITLE_COLOR];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupMCLbl.hidden = YES;
    self.title = NSLocalizedString(@"social_redpacket", nil);
    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithHex:REDPACKET_TIP_COLOR]};
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:REDPACKET_TITLE_COLOR];

}
-(void)sendRedpacket {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:THEME_COLOR];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor blackColor]};

}

@end
