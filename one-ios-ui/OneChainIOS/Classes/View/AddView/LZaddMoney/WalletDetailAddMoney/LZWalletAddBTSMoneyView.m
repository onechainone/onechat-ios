//
//  LZWalletAddBTSMoneyView.m
//  OneChainIOS
//
//  Created by chunzheng wang on 2018/4/19.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZWalletAddBTSMoneyView.h"

@implementation LZWalletAddBTSMoneyView

-(void)setupUIWith:(NSString *)name {
    self.backgroundColor = [UIColor blackColor];
    
    NSString *str = [NSString stringWithFormat:@"%@ %@?",NSLocalizedString(@"button_add", nil),name];
    //添加label
    UILabel *tianjiaLabel = [UILabel makeLabelWithTextColor:[UIColor blackColor] andTextFont:LITTLE_LABEL_FRONT andContentText:str];
    [self addSubview:tianjiaLabel];
    [tianjiaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFT_SPACE);
        make.top.offset(LEFT_SPACE);
    }];
    [tianjiaLabel sizeToFit];
    ///添加用户名label
    UILabel *addAccountLabel = [UILabel makeLabelWithTextColor:[UIColor blackColor] andTextFont:LITTLE_LABEL_FRONT andContentText:@"用户名"];
    [self addSubview:addAccountLabel];
    [addAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tianjiaLabel.mas_bottom).offset(10);
        make.left.offset(LEFT_SPACE);
    }];
    //输入账户label
    UITextField *accountTextfield = [UITextField new];
    accountTextfield.placeholder = @"请输入用户名";
    [self addSubview:accountTextfield];
    [accountTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addAccountLabel.mas_bottom).offset(10);
        make.left.offset(LEFT_SPACE);
        make.right.offset(-RIGHT_SPACE);
    }];
    UIImageView *underLineImg =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline"]];
    [self addSubview:underLineImg];
    [underLineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountTextfield.mas_bottom).offset(1);
        make.left.offset(LEFT_SPACE);
        make.right.offset(-RIGHT_SPACE);
    }];
    UIButton *confirmBtn = [UIButton new];
    confirmBtn.titleLabel.text = @"确定";
    [self addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-RIGHT_SPACE);
        make.top.equalTo(underLineImg.mas_bottom).offset(20);
    }];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [UIButton new];
    cancelBtn.titleLabel.text = @"取消";
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(confirmBtn.mas_centerY).offset(0);
        make.right.equalTo(confirmBtn.mas_left).offset(-5);
        
    }];
    
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}
-(void)cancelBtnClick{
    
}
-(void)confirmBtnClick{
    
}
@end
