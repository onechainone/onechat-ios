//
//  LZSetChargeContentViewController.m
//  OneChainIOS
//
//  Created by chunzheng wang on 2018/5/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZSetChargeContentViewController.h"
#import "LZSearchSelectCoinViewController.h"

@interface LZSetChargeContentViewController ()

@end

@implementation LZSetChargeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set_charge_content
    self.title = NSLocalizedString(@"setting_charge_content", nil);
    ///////////// imgV4 red_countLbl imgV5 msgLbl
    
    self.imgV4.hidden = YES;
    self.imgV5.hidden = YES;
    self.red_countLbl.hidden = YES;
    self.msgLbl.hidden = YES;
    self.changeLabel1.hidden = YES;
    [self updateRedType:YES];
    self.redCountTF.hidden = YES;
    self.groupMCLbl.hidden = YES;
    self.redMsgTF.hidden = YES;
    self.sendButton.hidden = YES;
    [self setupSwichViewandOther];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button_confirm", @"ok") style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:DEFAULT_BLACK_COLOR];
    
    if (![CoinInfoMngr sharedCoinInfoMngr].isOpen||[CoinInfoMngr sharedCoinInfoMngr].isOpen == NO) {
        //这个地方什么都不敢
    } else {
        ///这个地方是开启的需要加载存的内容
        [self.openSwich setOn:[CoinInfoMngr sharedCoinInfoMngr].isOpen animated:NO];
        ///币种
        [self updateCoinWithCode:[CoinInfoMngr sharedCoinInfoMngr].chargeAsset_code button:self.selectCoinBtn];
        ///金额
        self.singleAmountTF.text = [CoinInfoMngr sharedCoinInfoMngr].chargeCount;
        
    }
    
}
-(void)backClick{
    
    NSString *amount = [CoinInfoMngr sharedCoinInfoMngr].chargeCount;
    NSDecimalNumber *decmNum = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *zeroNum = [NSDecimalNumber decimalNumberWithString:@"0"];
    BOOL smaller = ([decmNum compare:zeroNum] == NSOrderedAscending || [decmNum compare:zeroNum] == NSOrderedSame) ? YES : NO;
    if (smaller && [CoinInfoMngr sharedCoinInfoMngr].isOpen) {
        return;
    }
    self.sendchargeMsg([CoinInfoMngr sharedCoinInfoMngr].chargeAsset_code, [CoinInfoMngr sharedCoinInfoMngr].chargeCount, [CoinInfoMngr sharedCoinInfoMngr].isOpen);
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)setupSwichViewandOther {
    //
    UILabel *chargeLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:MONEY_COUNT_COLOR] andTextFont:LITTLE_LABEL_FRONT andContentText:NSLocalizedString(@"setting_charge_content", nil)];
    [chargeLabel sizeToFit];
    [self.view addSubview:chargeLabel];
    [chargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(WidthScale(18));
        make.top.offset(HeightScale(15));
        //        make.width.offset(98);
        make.height.offset(20);
    }];
    [chargeLabel sizeToFit];
    UISwitch *openSwich = [UISwitch new];
    [self.view addSubview:openSwich];
    self.openSwich = openSwich;
    [openSwich mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-WidthScale(18));
        make.centerY.equalTo(chargeLabel.mas_centerY).offset(0);
    }];
    [openSwich addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chargeLabel.mas_bottom).offset(38);
        
    }];
    //charge_amount
    self.singleALbl.text = NSLocalizedString(@"charge_amount", nil);
    
    [self.singleAmountTF addTarget:self action:@selector(amountTextFieldChange:) forControlEvents:(UIControlEventEditingChanged)];

    
}
- (void)amountTextFieldChange:(UITextField *)textfiled {
    self.chargeCount = textfiled.text;
    [CoinInfoMngr sharedCoinInfoMngr].chargeCount = textfiled.text;
    
}
- (void)valueChanged:(UISwitch *)sender
{
    BOOL isOn = sender.isOn;
    if (isOn) {
        ///开的时候
//        [self showHint:@"开"];
        self.isOpen = YES;
        [CoinInfoMngr sharedCoinInfoMngr].isOpen = self.isOpen;
        
    } else {
//        [self showHint:@"关"];
        self.isOpen = NO;
        [CoinInfoMngr sharedCoinInfoMngr].isOpen = self.isOpen;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadAssetsList
{
    __weak typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    
    [[ONEChatClient sharedClient] getAtomicAssetList:^(ONEError *error, NSArray *list) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                if ([list count] > 0) {
                    [weakSelf gotoCoinSelectionVC:list];
                } else {
                    [weakSelf showHint:NSLocalizedString(@"assets_nodata", @"No assets")];
                }
            } else {
                [weakSelf showHint:NSLocalizedString(@"get_asset_list_error", @"Failed to get asset list")];
            }
        });
    }];
}

-(void)gotoCoinSelectionVC:(NSArray *)datasource {
    LZSearchSelectCoinViewController *vc = [[LZSearchSelectCoinViewController alloc] initWithDatasources:datasource];
    vc.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.selectCoin = ^(RpAssetModel *model) {

        self.selectedModel = model;
        [self updateCoinWithCode:model.asset_code button:self.selectCoinBtn];
        self.chargeAsset_code = model.asset_code;

        [CoinInfoMngr sharedCoinInfoMngr].chargeAsset_code = self.chargeAsset_code;

        //        self.singleAmountTF.text = @"";
        //        _sedCountTF.text = @"";
    };
    [self presentViewController:vc animated:YES completion:nil];

}

@end
