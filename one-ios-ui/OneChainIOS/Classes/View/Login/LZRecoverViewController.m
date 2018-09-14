//
//  LZRecoverViewController.m
//  LZEasemob3
//
//  Created by hanshaoqing on 2017/11/9.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZRecoverViewController.h"
#import <Masonry.h>
#import "FSTextView.h"
#import "UIColor+Addition.h"
#import "UILabel+Addition.h"
#import "LZRegistViewController.h"
#import "UIAlertController+Addition.h"
#import "ZYKeyboardUtil.h"
#import "ChooseSeedController.h"
#import "PreRegisterController.h"
#import "NetworkStatusController.h"
#import "ExtendedButton.h"
#define ConfirmBtnWith 18
#define ConfirmBtnHeight 18
#define AGREE_COLOR 0x0197FF
#define TextViewHeight 80
#define MARGIN_KEYBOARD 50
#define LOCAL_UNDERLINESPECE 5
#define LOCAL_UNDERLINEHEIGHT 1
#define LOCAL_TIPSSTRSPECE 1
//scrollview 的高
#define ScrollViewHeight 664

@interface LZRecoverViewController ()<UITextViewDelegate>

@property(nonatomic, strong)UITextField *miMatextFiled;
@property(nonatomic, strong) UITextField *confirmmiMatextFiled;
@property(nonatomic, strong)FSTextView *textView;
//键盘
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
//miMatipLabel
@property(nonatomic, strong)UILabel *miMatipLabel;
//confirmMiMatipLabel
@property(nonatomic, strong)UILabel *confirmMiMatipLabel;
//confirmBtn
@property(nonatomic, strong)ExtendedButton *confirmBtn;
//滚动界面
@property(nonatomic, strong)UIScrollView *scrollView;
//confirmconfirmBtn 创建账号按钮
@property(nonatomic, strong)UIButton *confirmconfirmBtn;

@property (nonatomic, strong) UILabel *errorLbl;

@end
#define LOCAL_TIPSLABELTOP 15
#define LOCAL_TIPSLABELWIDTH 50
#define LOCAL_TIPLABELWIDTH 100
#define LOCAL_TIPLABELHEIGHT 17
#define LOCAL_ACCOUNTFILEDHEIGHT 25
#define LOCAL_ACCOUNTTIPLABELHEIGHT 14
#define LOCAL_NAMEFILEDHEIGHT 20
#define LOCAL_NAMELABELHEIGHT 20
#define LOCAL_LABELHEIGHT 20
#define LOCAL_CONFIRMSEXBTNWIDTH 18

@implementation LZRecoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //恢复账号 accountname_restore_title
    self.title = NSLocalizedString(@"accountname_restore_title", nil);
    
    [self setupUI];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.rightBarButtonItem =nil;
    
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    UISwipeGestureRecognizer *swipeGest = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:swipeGest];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    ///解决键盘遮挡
    self.miMatextFiled.delegate = self;
    self.confirmmiMatextFiled.delegate = self;
    self.textView.delegate = self;
    
    [self.miMatextFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    [self.confirmmiMatextFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
//        [self.textView addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self configKeyBoardRespond];
//    self.confirmBtn.selected = YES;
    //
    if (self.type) {
        ////重写返回键
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_old"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    }
    [self initNodeCheck];
}
-(void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)hideKeyBoard
{
    [self.miMatextFiled endEditing:YES];
    [self.confirmmiMatextFiled endEditing:YES];
    [self.textView endEditing:YES];
    [self.scrollView endEditing:YES];
    [self.view endEditing:YES];

}
- (void)dealloc {
    self.miMatextFiled.delegate = nil;
    self.confirmmiMatextFiled.delegate = nil;
    self.textView.delegate = nil;
}
//解决键盘遮挡
- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak LZRecoverViewController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.scrollView,weakSelf.miMatextFiled, weakSelf.confirmmiMatextFiled, weakSelf.textView, nil];
    }];
    
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        // NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}
#pragma mark delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.miMatextFiled resignFirstResponder];
    [self.confirmmiMatextFiled resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.miMatextFiled resignFirstResponder];
    [self.confirmmiMatextFiled resignFirstResponder];
    [self.textView resignFirstResponder];
    return YES;
}


- (void)setupUI {
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, self.view.bounds.size.height)];
//
//    self.scrollView = scrollView;
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    //    scrollView.center = self.view.center;
    //    scrollView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    scrollView.contentSize = CGSizeMake(KScreenW, ScrollViewHeight);
    [self.view addSubview: self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    
    [container addGestureRecognizer:tapGestureRecognizer];
    UISwipeGestureRecognizer *swipeGest = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [container addGestureRecognizer:swipeGest];
    
    
    UILabel *tipsLabel = [UILabel new];
    //secure_key_important 数字货币的安全,核心在于私钥安全,请在不能被拍照、摄像、偷看的情况下进行创建!
    tipsLabel.text = NSLocalizedString(@"secure_key_important", nil);
    [container addSubview:tipsLabel];
    //    [tipsLabel sizeToFit];
    tipsLabel.numberOfLines = 0;
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(MID_SPACE);
        make.left.offset(LEFT_SPACE);
        make.width.offset(KScreenW-LEFT_SPACE);
        make.height.offset(LOCAL_TIPSLABELWIDTH+LOCAL_LABELHEIGHT);
    }];
    [tipsLabel sizeToFit];
    //
    UILabel *tipLabel = [UILabel new];
    //脑钱包 accountname_restore_key
    tipLabel.text = NSLocalizedString(@"accountname_restore_key", nil);
    [container addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(MID_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.width.offset(KScreenW);
        make.height.offset(LOCAL_LABELHEIGHT);
    }];
    [tipLabel sizeToFit];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    
    FSTextView *textView = [[FSTextView alloc] init];
    //accountname_restore_key_tips 请输入助记单词
    textView.placeholder = NSLocalizedString(@"accountname_restore_key_tips", nil);
    self.textView = textView;
    [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    //    textView.layer.borderColor = [UIColor redColor].CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 5;
    
    [container addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.top.equalTo(tipLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.height.offset(TextViewHeight);
    }];
    UILabel *miMaLabel = [UILabel new];
    //密码 password
    miMaLabel.text = NSLocalizedString(@"password", nil);
    [container addSubview:miMaLabel];
    [miMaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.height.offset(LOCAL_LABELHEIGHT);
        make.width.offset(KScreenW);
    }];
    miMaLabel.textAlignment = NSTextAlignmentLeft;
    
    UITextField *miMatextFiled = [UITextField new];
    //accountname_create_password_tips 请输入8位以上密码
    miMatextFiled.placeholder = NSLocalizedString(@"accountname_create_password_tips", nil);
    miMatextFiled.secureTextEntry = YES;
    self.miMatextFiled = miMatextFiled;
    [miMatextFiled setValue:[UIFont boldSystemFontOfSize:LITTLE_LABEL_FRONT] forKeyPath:@"_placeholderLabel.font"];
    
    [container addSubview:miMatextFiled];
    [miMatextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(miMaLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.height.offset(LOCAL_ACCOUNTFILEDHEIGHT);
    }];
    
    [self.miMatextFiled addTarget:self action:@selector(miMatextFiledChange:) forControlEvents:UIControlEventEditingChanged];
    ///下划线
    UIImageView *miMaUnderlineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline"]];
    [container addSubview:miMaUnderlineImg];
    [miMaUnderlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        
        make.top.equalTo(miMatextFiled.mas_bottom).offset(LOCAL_UNDERLINESPECE);
        make.height.offset(LOCAL_UNDERLINEHEIGHT);
        
    }];
    //    //提示框
    UILabel *miMatipLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:RECOVERTIPS_COLOR] andTextFont:LITTLE_LABEL_FRONT andContentText:@""];
    self.miMatipLabel = miMatipLabel;
    
    [container addSubview:miMatipLabel];
    [miMatipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);        make.top.equalTo(miMaUnderlineImg.mas_bottom).offset(LOCAL_TIPSSTRSPECE);
        make.width.offset(KScreenW);
        make.height.offset(15);
    }];
    miMatipLabel.textAlignment = NSTextAlignmentLeft;
    [miMatipLabel sizeToFit];
    
    
    UILabel *confirmmiMaLabel = [UILabel new];
    //确认密码 password_confirm
    confirmmiMaLabel.text = NSLocalizedString(@"password_confirm", nil);
    [container addSubview:confirmmiMaLabel];
    [confirmmiMaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(miMatipLabel.mas_bottom).offset(LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.width.offset(KScreenW);
        make.height.offset(15);
    }];
    confirmmiMaLabel.textAlignment = NSTextAlignmentLeft;
    [confirmmiMaLabel sizeToFit];
    
    //
    UITextField *confirmmiMatextFiled = [UITextField new];
    //accountname_create_password_tips2 再次输入密码,最少8位
    confirmmiMatextFiled.placeholder = NSLocalizedString(@"accountname_create_password_tips2", nil);
    if (KScreenW == IPHONEFIVESCREENH) {
        [confirmmiMatextFiled setValue:[UIFont boldSystemFontOfSize:SMALL_FRONT] forKeyPath:@"_placeholderLabel.font"];
    } else {
        [confirmmiMatextFiled setValue:[UIFont boldSystemFontOfSize:LITTLE_LABEL_FRONT] forKeyPath:@"_placeholderLabel.font"];
    }
    
    confirmmiMatextFiled.secureTextEntry = YES;
    self.confirmmiMatextFiled = confirmmiMatextFiled;
    [container addSubview:confirmmiMatextFiled];
    [confirmmiMatextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmmiMaLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.height.offset(LOCAL_ACCOUNTFILEDHEIGHT);
    }];
    [self.confirmmiMatextFiled addTarget:self action:@selector(confirmmiMatextFiled:) forControlEvents:UIControlEventEditingChanged];
    //下划线
    UIImageView *confirmmiMaUnderline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline"]];
    [container addSubview:confirmmiMaUnderline];
    [confirmmiMaUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.top.equalTo(confirmmiMatextFiled.mas_bottom).offset(LOCAL_UNDERLINESPECE);
        make.height.offset(LOCAL_UNDERLINEHEIGHT);
    }];
    //    //提示框
    UILabel *confirmMiMatipLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:RECOVERTIPS_COLOR] andTextFont:LITTLE_LABEL_FRONT andContentText:@""];
    [container addSubview:confirmMiMatipLabel];
    self.confirmMiMatipLabel = confirmMiMatipLabel;
    [confirmMiMatipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.top.equalTo(confirmmiMaUnderline.mas_bottom).offset(LOCAL_TIPSSTRSPECE);
        //    make.right.equalTo(tipsLabel.mas_left).offset(-RIGHT_SPACE);
        make.width.offset(KScreenW);
        make.height.offset(15);
    }];
    confirmMiMatipLabel.textAlignment = NSTextAlignmentLeft;
    //    [confirmMiMatipLabel sizeToFit];


    ExtendedButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn setImage:[UIImage imageNamed:@"circlecnofrim"] forState:UIControlStateNormal];
    [confirmBtn setImage:[UIImage imageNamed:@"confrim"] forState:UIControlStateSelected];
    [container addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.height.offset(ConfirmBtnWith);
        make.width.offset(ConfirmBtnHeight);
        make.top.equalTo(confirmMiMatipLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        
    }];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn = confirmBtn;
    //
    UILabel *agereeLabel = [UILabel new];
    //同意 button_agree
    agereeLabel.text = NSLocalizedString(@"button_agree", nil);
    [container addSubview:agereeLabel];
    [agereeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_right).offset(LITTLE_LITTLE_SPACE);
        make.top.equalTo(confirmMiMatipLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
//        make.width.offset(50);
        make.height.offset(LOCAL_LABELHEIGHT);
    }];
    [agereeLabel sizeToFit];
    //
    UIButton *agereeBtn = [UIButton new];
    //用户协议  terms_of_service
    [agereeBtn setTitle:NSLocalizedString(@"terms_of_service", nil) forState:UIControlStateNormal];
    
    [agereeBtn setTitleColor:[UIColor colorWithHex:AGREE_COLOR] forState:UIControlStateNormal];
    [container addSubview:agereeBtn];
    //    [agereeBtn sizeToFit];
    [agereeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agereeLabel.mas_right).offset(SPEACE_ZERO);
        make.top.equalTo(confirmMiMatipLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
//        make.width.offset(150);
        make.height.offset(20);
        
    }];
    [agereeBtn sizeToFit];
    //    agereeBtn.textAlignment = NSTextAlignmentLeft;
    agereeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //UIControlContentHorizontalAlignmentRight
    //    //user_contract_txt 请遵守各个国家和地区的法律法规,国际公约,以及风俗习惯,请在合法合规的范围内使用本软件,否则请终止
    UILabel *desLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:AGREE_COLOR] andTextFont:SMALL_FRONT+2 andContentText:NSLocalizedString(@"user_contract_txt", nil)];
    desLabel.numberOfLines = 0;
    [container addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agereeLabel.mas_left).offset(SPEACE_ZERO);
        make.top.equalTo(agereeBtn.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
    }];
    [desLabel sizeToFit];
    
    UIButton *confirmconfirmBtn = [UIButton new];
    [confirmconfirmBtn setBackgroundImage:[UIImage imageNamed:@"Button_BG_small"] forState:UIControlStateNormal];

    //button_ok 确定
    [confirmconfirmBtn setTitle:NSLocalizedString(@"button_ok", nil) forState:UIControlStateNormal];
    [confirmconfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [container addSubview:confirmconfirmBtn];
    [confirmconfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.height.offset(BTN_HEIGHT);
        make.top.equalTo(desLabel.mas_bottom).offset(LITTLE_SPACE);
        make.bottom.equalTo(container.mas_bottom).offset(-LITTLE_SPACE);
    }];

    [confirmconfirmBtn addTarget:self action:@selector(confirmconfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.confirmconfirmBtn = confirmconfirmBtn;
    //先判断完 长度 然后再判断一下 是不是一样
    self.confirmconfirmBtn.userInteractionEnabled=NO;//交互关闭
    self.confirmconfirmBtn.alpha=BTN_ALPHA;//透明度
    
    NSString *isDebugOpen = nil;
    if (isDebugOpen) {
        
        [confirmconfirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipsLabel.mas_left).offset(SPEACE_ZERO);
            make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
            make.height.offset(BTN_HEIGHT);
            make.top.equalTo(desLabel.mas_bottom).offset(LITTLE_SPACE);
        }];
        
        _errorLbl = [[UILabel alloc] init];
        _errorLbl.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:16.f];
        _errorLbl.textColor = [UIColor blackColor];
        _errorLbl.numberOfLines = 0;
        _errorLbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *copy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyText:)];
        [_errorLbl addGestureRecognizer:copy];
        [container addSubview:_errorLbl];
        
        [_errorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(confirmconfirmBtn.mas_bottom).offset(10);
            
            make.left.right.equalTo(confirmconfirmBtn);
            make.bottom.equalTo(container.mas_bottom).offset(-LITTLE_SPACE);
        }];
        
    }
    
    UIButton *creatBtn = [UIButton new];
    //创建账号按钮
    if (self.type) {
        //accountname_create_title 创建账号
        [creatBtn setTitle:NSLocalizedString(@"accountname_create_title", nil) forState:UIControlStateNormal];
        [creatBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [creatBtn setTitleColor:[UIColor colorWithHex:AGREE_COLOR] forState:UIControlStateNormal];
        
        [container addSubview:creatBtn];
        [creatBtn sizeToFit];
        [creatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(confirmconfirmBtn.mas_right).offset(-2);
            make.top.equalTo(confirmconfirmBtn.mas_bottom).offset(MID_SPACE);
            make.width.offset(150);
            make.height.offset(LABEL_FRONT);
            
        }];
        [creatBtn sizeToFit];
        [creatBtn addTarget:self action:@selector(creatAccout) forControlEvents:UIControlEventTouchUpInside];
        creatBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
    }
}



- (void)confirmconfirmBtnClick {
    
    BOOL ret = [self checkSeed:self.textView.text];

    if( ret == FALSE ) {

        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *netWork = [[CoinTools sharedCoinTools] judgeNetWork];
    if([netWork isEqualToString:@"NO"]) {
        
        [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"one_no_network_tips", nil) controller:self];
        
        [hud hide:YES];
        
        return;
    }
    
    //    for(int i=0; i< self.miMatextFiled.text.length;i++)
    //    {
    //        int a =[self.miMatextFiled.text characterAtIndex:i];
    //        if( a >0x4e00&& a <0x9fff){
    //            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"密码设置有误" message:@"请重新设置" preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    //            [alertVC addAction:confirmAction];
    //            [self presentViewController:alertVC animated:YES completion:nil];
    //            return;
    //        }
    //    }
    //
    //    if (self.miMatextFiled.text.length < 8 || self.miMatextFiled.text.length > 40 ) {
    //        [[UIAlertController shareAlertController] showAlertcWithString:@"密码长度有误,请重新输入" controller:self];
    //        return;
    //    }    //判断新密码与旧密码是否不同
    //    if (![self.confirmmiMatextFiled.text isEqualToString:self.miMatextFiled.text]) {
    //        //password_second_erro
    //        [[UIAlertController shareAlertController] showAlertcWithString:@"两次密码不相同!请重新输入!" controller:self];
    //        return;
    //
    //    }
    //
    // NSString* seed = @"cream finish become sand parrot blanket turtle stadium poverty inch planet adult couple actual belt joy invite essence age real word soda breeze ranch";
    
    // NSString* seed = @"fold satoshi weird piano shine dinner fence error scan evidence season silk around mule make damp oblige into pupil original space game random valid";
    
    // NSString* seed = @"track industry load blue shield often clog quality harbor mouse inquiry abandon fiscal minute wide shove adult unable today risk neglect light either spend";
    
    NSString* seed = nil;
    
    
#if as_is_dev_mode
    
    seed = self.textView.text;
    
    if( seed == nil || seed.length < 1) {
        
        seed =  @"garlic salt fossil broom vapor path then excuse catalog weather retreat floor hand gospel dice off remind champion lab detail elder minor card hero";
        
    }
    
#else
    
    seed = self.textView.text;
    
#endif
    
    
   
    NSString *errorString = [[ONEChatClient sharedClient] recoverAccount:seed password:self.miMatextFiled.text completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self hideHud];
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SWITCH_ROOT_VIEWCONTROLLER object:nil];
            } else {
                NSString *showErr = [CSUtil showRecoverErrMsg:error];
                [[UIAlertController shareAlertController] showAlertcWithString:showErr controller:self];
            }
        });
    }];

    
    if (errorString.length > 0 && _errorLbl) {
        
        _errorLbl.text = [errorString copy];
    }
    

    
}



-(BOOL) checkSeed:(NSString*) seed {
    
    NSMutableArray* wList = [NSMutableArray new];
    
    ONEError *error = [ONEChatClient seedIsValid:seed invalidWords:&wList];    
    if( error == nil ) {
        
        return TRUE;
        
    }
    
    NSMutableString* buff = [NSMutableString new];
    
    [buff appendFormat:@"seed check fail code:%lu:%@\n",error.errorCode,error.errorDescription];
    
    for(NSString* t in wList) {
        
        [buff appendFormat:@"\"%@\"\n",t];
        
    }
    
    [self showHint:buff];
    
    return FALSE;
    
}

- (void)creatAccout {
    
    PreRegisterController *preRegist = [[PreRegisterController alloc] init];
    preRegist.type = @"1";
    [self.navigationController pushViewController:preRegist animated:YES];
    
}
- (void)confirmBtnClick:(UIButton *)button {
    //    button.isSelected = YES;
//    button.selected = YES;
    button.selected = !button.isSelected;
    [self textFiledChange:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)miMatextFiledChange:(UITextField *)textField {
    if (textField.text.length < 8 && textField.text.length>0) {
        self.miMatipLabel.text =NSLocalizedString(@"password_length_erro", nil);
    } else if (textField.text.length == 0) {
        self.miMatipLabel.text =@"";
    }else {
        self.miMatipLabel.text = @"";
    }
    
}
//confirmmiMatextFiled
-(void)confirmmiMatextFiled:(UITextField *)textField {
    if ([textField.text isEqualToString:self.miMatextFiled.text] ||textField.text.length == 0) {
        //密码不一致
        //        self.confirmMiMatipLabel.text = NSLocalizedString(@"password_second_erro", nil);
        self.confirmMiMatipLabel.text = @"";
        
    } else {
        self.confirmMiMatipLabel.text = NSLocalizedString(@"password_second_erro", nil);
        
    }
}
/*
 [self.miMatextFiled endEditing:YES];
 [self.confirmmiMatextFiled endEditing:YES];
 [self.textView endEditing:YES];
 */
-(void)textFiledChange:(UITextField *)textField{
    if (self.miMatextFiled.text.length<8 ||self.confirmmiMatextFiled.text.length<8||![self.miMatextFiled.text isEqualToString:self.confirmmiMatextFiled.text]||self.textView.text.length<=0 || !self.confirmBtn.isSelected) {
        //先判断完 长度 然后再判断一下 是不是一样
        self.confirmconfirmBtn.userInteractionEnabled=NO;//交互关闭
        self.confirmconfirmBtn.alpha=BTN_ALPHA;//透明度
    } else {
        //先判断完 长度 然后再判断一下 是不是一样
        self.confirmconfirmBtn.userInteractionEnabled=YES;//交互关闭
        self.confirmconfirmBtn.alpha=BTN_NOALPHA;//透明度
    }
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textViewDidChange:(UITextView *)textView  {
    if (textView.text.length <=0||self.miMatextFiled.text.length<8 ||self.confirmmiMatextFiled.text.length<8||![self.miMatextFiled.text isEqualToString:self.confirmmiMatextFiled.text]) {
        self.confirmconfirmBtn.userInteractionEnabled=NO;//交互关闭
        self.confirmconfirmBtn.alpha=BTN_ALPHA;//透明度
    } else {
        //先判断完 长度 然后再判断一下 是不是一样
        self.confirmconfirmBtn.userInteractionEnabled=YES;//交互关闭
        self.confirmconfirmBtn.alpha=BTN_NOALPHA;//透明度
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    ChooseSeedController *chooseSeed = [[ChooseSeedController alloc] init];
    chooseSeed.type = self.type;
    if (textView.text.length > 0) {
        
        chooseSeed.existSeedString = textView.text;
    }
    chooseSeed.selectedSeed = ^(NSString *seedString) {
        self.textView.text = seedString;
    };
    [self.navigationController pushViewController:chooseSeed animated:NO];
    
    return NO;
}

- (void)copyText:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        
        if (_errorLbl.text.length == 0) {
            
            return;
        }
        BOOL succeess = [[CoinTools sharedCoinTools] copyToPasteboardWithString:_errorLbl.text];
        if (succeess) {
            
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"copied_to_clipboard", @"")];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
    }
}

#define KCHECK_BTN_TITLE_SIZE 14.f
- (void)initNodeCheck
{
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:KCHECK_BTN_TITLE_SIZE];

    UIColor *btn_title_color = [UIColor blackColor];

    [checkBtn setFrame:CGRectMake(0, 0, 80,40)];
    [checkBtn setTitleColor:btn_title_color forState:UIControlStateNormal];
    [checkBtn setTitle:NSLocalizedString(@"switch_service_node", @"") forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkNode:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)checkNode:(UIButton *)sender {
    
    NetworkStatusController *networkStatus = [[NetworkStatusController alloc] init];
    [self.navigationController pushViewController:networkStatus animated:YES];
}

@end
