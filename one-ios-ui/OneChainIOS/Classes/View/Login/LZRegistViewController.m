//
//  LZRegistViewController.m
//  LZEasemob3
//
//  Created by hanshaoqing on 2017/11/9.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZRegistViewController.h"
#import "UIColor+Addition.h"
#import "UILabel+Addition.h"
#import "UIAlertController+Addition.h"
#import "ZYKeyboardUtil.h"
#import "LZRecoverViewController.h"
#import "LXDScrollView.h"
#import <SVProgressHUD.h>
//#import <WalletCore/WSWallet.h>

#import "LZDecryptWalletViewController.h"


#import "LZBackupWalletViewController.h"
#import "LZLoginWritePassWordViewController.h"
#import "LZNavigationController.h"
#import "NetworkStatusController.h"
#import "ExtendedButton.h"

#define MARGIN_KEYBOARD 10
#define LOCAL_UNDERLINESPECE 5
#define LOCAL_UNDERLINEWITH 1
#define LOCAL_TIPSSTRSPECE 1
#define LOCALLITTLETIP_COLOR 0x0197FF
//scrollview 的高
#define ScrollViewHeight 750
#define MAX_WIRTE_NUM 50
#define KCHECK_BTN_TITLE_SIZE 14.f



@interface LZRegistViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
//账号textfiled
@property(nonatomic, strong)UITextField *accountFiled;
//昵称textfiled
@property(nonatomic, strong)UITextField *nameFiled;
//密码textfiled
@property(nonatomic, strong)UITextField *miMatextFiled;
//confirmmiMatextFiled 确认密码textfiled
@property(nonatomic, strong)UITextField *confirmmiMatextFiled;
///推荐人
@property(nonatomic, strong)UITextField *tuiJianRenTextField;

//键盘
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
///确认男女按钮
@property (strong, nonatomic) UIButton *confirmnvBtn;
@property (strong, nonatomic) UIButton *confirmnanBtn;
//账户提示框
@property(nonatomic, strong)UILabel *accountTipLabel;
//miMatipLabel 密码提示框
@property(nonatomic, strong)UILabel *miMatipLabel;
//confirmMiMatipLabel 确认密码提示框
@property(nonatomic, strong)UILabel *confirmMiMatipLabel;

//confirmBtn
@property(nonatomic, strong)UIButton *confirmBtn;
//滚动界面
@property(nonatomic, strong)UIScrollView *scrollView;
//confirmconfirmBtn 创建账号按钮
@property(nonatomic, strong)UIButton *confirmconfirmBtn;
///弹出框
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (nonatomic) BOOL isPullUserInfo;
//repullCount
@property ( nonatomic) NSInteger *repullCount;

@end
#define LOCAL_TIPSLABELTOP 10
#define LOCAL_TIPSLABELWIDTH 50
#define LOCAL_TIPLABELWIDTH 100
#define LOCAL_TIPLABELHEIGHT 17
#define LOCAL_ACCOUNTFILEDHEIGHT 35
#define LOCAL_ACCOUNTTIPLABELHEIGHT 14
#define LOCAL_NAMEFILEDHEIGHT 35
#define LOCAL_NAMELABELHEIGHT 20
#define LOCAL_LABELHEIGHT 20
#define LOCAL_CONFIRMSEXBTNWIDTH 18
#define LOCAL_ACCOUNTLENGTH 6
#define LCAL_MIMALENGTH 8
#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ALPHANUM @"abcdefghijklmnopqrstuvwxyz0123456789-"

//#define kAlphaNum @"abcdefghijklmnopqrstuvwxyz0123456789"

@implementation LZRegistViewController {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.repullCount = 0;
    //判断是从恢复账号过来的
    if (self.type) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    }
    NSString *netWork = [[CoinTools sharedCoinTools] judgeNetWork];
    if([netWork isEqualToString:@"NO"]) {
        
        //        [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"one_no_network_tips", nil) controller:self];
    }
    //accountname_create_title
    self.title = NSLocalizedString(@"accountname_create_title", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    UITapGestureRecognizer *uprecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    //    [uprecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    ////////
    //   UITapGestureRecognizer *downrecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    //    [downrecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    //    [self.scrollView addGestureRecognizer:downrecognizer];
    //    [self.scrollView addGestureRecognizer:uprecognizer];
    //    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
    self.navigationItem.rightBarButtonItem =nil;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.view addGestureRecognizer:uprecognizer];
    
    ///解决键盘遮挡
    self.accountFiled.delegate = self;
    //    self.nameFiled.delegate = self;
    //    self.miMatextFiled.delegate = self;
    //    self.confirmmiMatextFiled.delegate = self;
    //添加监听
    
    [self.accountFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    [self.nameFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    self.nameFiled.keyboardType = UIKeyboardTypeDefault;
    
    [self.miMatextFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    self.miMatextFiled.keyboardType = UIKeyboardTypeDefault;
    [self.confirmmiMatextFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    self.confirmmiMatextFiled.keyboardType = UIKeyboardTypeDefault;
    
    [self.accountFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [self.accountFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [self configKeyBoardRespond];
//    self.confirmBtn.selected = YES;
    if (self.type) {
        ////重写返回键
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_old"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    }
    
    [self initNodeCheck];
}
-(void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideKeyBoard
{
    [self.accountFiled endEditing:YES];
    [self.nameFiled endEditing:YES];
    [self.miMatextFiled endEditing:YES];
    [self.confirmmiMatextFiled endEditing:YES];
    //tuiJianRenTextField
    [self.tuiJianRenTextField endEditing:YES];
    
    
}

- (void)dealloc {
    self.accountFiled.delegate = nil;
    self.nameFiled.delegate = nil;
    self.miMatextFiled.delegate = nil;
    self.confirmmiMatextFiled.delegate = nil;
    self.tuiJianRenTextField.delegate = nil;
    
}
//解决键盘遮挡
- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak LZRegistViewController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.scrollView,weakSelf.accountFiled, weakSelf.nameFiled, weakSelf.miMatextFiled,weakSelf.confirmmiMatextFiled,weakSelf.tuiJianRenTextField, nil];
    }];
    
    
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        // NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}
#pragma mark delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.accountFiled resignFirstResponder];
    [self.nameFiled resignFirstResponder];
    [self.miMatextFiled resignFirstResponder];
    [self.confirmmiMatextFiled resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.accountFiled resignFirstResponder];
    [self.nameFiled resignFirstResponder];
    [self.miMatextFiled resignFirstResponder];
    [self.confirmmiMatextFiled resignFirstResponder];
    
    return YES;
}
//- (void)setupUI {
//
//    LXDScrollView * scrollView = [[LXDScrollView alloc] initWithFrame: CGRectMake(0, 0, 200, 667)];
//    scrollView.backgroundColor = [UIColor orangeColor];
//    scrollView.center = self.view.center;
//    scrollView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    scrollView.contentSize = CGSizeMake(200, 800);
//    [self.view addSubview: scrollView];
//
//    UILabel *seemeLabel = [UILabel makeLabelWithTextColor:[UIColor blueColor] andTextFont:16 andContentText:@"12312"];
//
//    [scrollView addSubview:seemeLabel];
//    [seemeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(10);
//        make.left.offset(18);
//        make.width.offset(100);
//        make.height.offset(100);
//    }];
//
//
//}

- (void)setupUI {
    
    //    LXDScrollView * scrollView = [[LXDScrollView alloc] initWithFrame: CGRectMake(0, 0, KScreenW, self.view.bounds.size.height)];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, self.view.bounds.size.height)];
    
    self.scrollView = scrollView;
    self.scrollView.bounces = NO;
    
    scrollView.backgroundColor = [UIColor whiteColor];
    //    scrollView.center = self.view.center;
    //    scrollView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.contentSize = CGSizeMake(KScreenW, ScrollViewHeight);
    [self.view addSubview:scrollView];
//    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    scrollView.userInteractionEnabled = YES;
    self.scrollView.delegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    UITapGestureRecognizer *uprecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
    [self.scrollView addGestureRecognizer:uprecognizer];
    //    self.scrollView addt
    
    //    self.scrollView.bounces = NO;
    //
    UILabel *tipsLabel = [UILabel new];
    //secure_key_important 数字货币的安全,核心在于私钥安全,请在不能被拍照、摄像、偷看的情况下进行创建!
//    tipsLabel.text = NSLocalizedString(@"secure_key_important", nil);
    tipsLabel.text = @"";
    
    [self.scrollView addSubview:tipsLabel];
    //    self.scrollView.bounces = NO;
    tipsLabel.numberOfLines = 0;
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(LOCAL_TIPSLABELTOP);
        make.left.offset(LEFT_SPACE);
        make.width.offset(self.view.bounds.size.width-LEFT_SPACE);
//        make.height.offset(LOCAL_TIPSLABELWIDTH+LOCAL_LABELHEIGHT);
        make.height.offset(1);

        
    }];
    [tipsLabel sizeToFit];
    
    UILabel *tipLabel = [UILabel new];
    //账号 accountname_create_username
    tipLabel.text = NSLocalizedString(@"accountname_create_username", nil);
    [self.scrollView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(LOCAL_UNDERLINESPECE);
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.width.offset(LOCAL_TIPLABELWIDTH);
        make.height.offset(LOCAL_TIPLABELHEIGHT);
        
    }];
    UITextField *accountFiled = [UITextField new];
    //accountname_create_username_tips 暂时只支持小写字母和数字,至少5位
    accountFiled.placeholder = NSLocalizedString(@"accountname_create_username_tips", nil);
    if (KScreenW == IPHONEFIVESCREENH) {
        [accountFiled setValue:[UIFont boldSystemFontOfSize:SMALL_FRONT] forKeyPath:@"_placeholderLabel.font"];
    } else {
        [accountFiled setValue:[UIFont boldSystemFontOfSize:LITTLE_LABEL_FRONT] forKeyPath:@"_placeholderLabel.font"];
    }
    
    self.accountFiled = accountFiled;
    [self.scrollView addSubview:accountFiled];
    [accountFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        //        make.right.equalTo(tipsLabel.mas_right).offset(0);
        make.width.offset(KScreenW-LEFT_SPACE);
        make.height.offset(LOCAL_ACCOUNTFILEDHEIGHT+3);
    }];
    ///添加账户的text
    [self.accountFiled addTarget:self action:@selector(accountFiledChange:) forControlEvents:UIControlEventEditingChanged];
    ///设置成只能输入数字和英文的
    accountFiled.keyboardType = UIKeyboardTypeASCIICapable;
    //取消首字母大写
    [accountFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [accountFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    UIImageView *accountUnderLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline"]];
    [self.scrollView addSubview:accountUnderLine];
    [accountUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.height.offset(LOCAL_UNDERLINEWITH);
        //        make.width.offset(KScreenW-LEFT_SPACE);
        make.top.equalTo(accountFiled.mas_bottom).offset(LOCAL_UNDERLINESPECE);
        
    }];
    ///account_name_length_erro "用户名长度不足，至少5位";
    //NSLocalizedString(@"accountname_create_username_tips", nil)
    UILabel *accountTipLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:RECOVERTIPS_COLOR] andTextFont:LITTLE_LABEL_FRONT andContentText:@""];
    [self.scrollView addSubview:accountTipLabel];
    [accountTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.top.equalTo(accountUnderLine.mas_bottom).offset(LOCAL_TIPSSTRSPECE);
        make.height.offset(LOCAL_ACCOUNTTIPLABELHEIGHT);
        make.width.offset(KScreenW-LEFT_SPACE);
    }];
    [self.accountTipLabel sizeToFit];
    self.accountTipLabel = accountTipLabel;
    accountTipLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *nameLabel = [UILabel new];
    // 昵称 accountname_create_nickname
    nameLabel.text = NSLocalizedString(@"accountname_create_nickname", nil);
    [self.scrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountTipLabel.mas_bottom).offset(LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.width.offset(KScreenW);
        make.height.offset(LOCAL_NAMELABELHEIGHT);
    }];
    
    UITextField *nameFiled = [UITextField new];
    //accountname_create_nickname_tips 请输入昵称
    nameFiled.placeholder = NSLocalizedString(@"accountname_create_nickname_tips", nil);
    [nameFiled setValue:[UIFont boldSystemFontOfSize:LITTLE_LABEL_FRONT] forKeyPath:@"_placeholderLabel.font"];
    [nameFiled setAutocorrectionType:UITextAutocorrectionTypeNo];
    [nameFiled setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    //    self.miMatextFiled.secureTextEntry = YES;
    self.nameFiled = nameFiled;
    [self.scrollView addSubview:nameFiled];
    [nameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.right.equalTo(tipsLabel.mas_right).offset(0);
        make.height.offset(LOCAL_NAMEFILEDHEIGHT);
    }];
    //    [self.nameFiled addTarget:self action:@selector(nameFiledChange:) forControlEvents:UIControlEventEditingChanged];
    //下划线
    UIImageView *nameUnderLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline"]];
    [self.scrollView addSubview:nameUnderLine];
    [nameUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.top.equalTo(nameFiled.mas_bottom).offset(LOCAL_UNDERLINESPECE);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
    }];
    
    UILabel *sexLabel = [UILabel new];
    //性别 sex
    sexLabel.text = NSLocalizedString(@"sex", nil);
    [self.scrollView addSubview:sexLabel];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameUnderLine.mas_bottom).offset(LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.height.offset(LOCAL_LABELHEIGHT);
//        make.width.offset(60);
    }];
    [sexLabel sizeToFit];
    
    ///确认男的按钮
    UIButton *confirmnanBtn = [[UIButton alloc] init];
    [confirmnanBtn setTag:1];
    self.confirmnanBtn = confirmnanBtn;
    
    [confirmnanBtn setImage:[UIImage imageNamed:@"rb_set_sex_selected"] forState:UIControlStateSelected];
    [confirmnanBtn setImage:[UIImage imageNamed:@"rb_set_sex_normal"] forState:UIControlStateNormal];
    [self.scrollView addSubview:confirmnanBtn];
    [confirmnanBtn addTarget:self action:@selector(falmeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmnanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLabel.mas_right).offset(30);
        make.height.offset(LOCAL_CONFIRMSEXBTNWIDTH);
        make.width.offset(30); make.top.equalTo(nameUnderLine.mas_bottom).offset(MID_MID_SPACE-2);
    }];
    
//    UILabel *nanLabel = [UILabel new];
//    //man男
//    nanLabel.text = NSLocalizedString(@"man", nil);
//    [self.scrollView addSubview:nanLabel];
//    [nanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(nameUnderLine.mas_bottom).offset(LITTLE_SPACE+2);
//        make.left.equalTo(confirmnanBtn.mas_right).offset(LITTLE_LITTLE_SPACE);
//        //        make.width.offset(40);
//        make.height.offset(14);
//    }];
//    [nanLabel sizeToFit];
    UIButton *nanLabelBtn = [UIButton new];
    [nanLabelBtn setTitle:NSLocalizedString(@"man", nil) forState:UIControlStateNormal];
//    [nanLabelBtn setTintColor:[UIColor blackColor]];
    [nanLabelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.scrollView addSubview:nanLabelBtn];
    [nanLabelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameUnderLine.mas_bottom).offset(LITTLE_SPACE+2);
make.left.equalTo(confirmnanBtn.mas_right).offset(LITTLE_LITTLE_SPACE);
        //        make.width.offset(40);
        make.height.offset(14);
    }];
    [nanLabelBtn setTag:1];
    [nanLabelBtn addTarget:self action:@selector(falmeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [nanLabelBtn sizeToFit];
    
    
    
    
    
    //确认女按钮
    UIButton *confirmnvBtn = [[UIButton alloc] init];
    [confirmnvBtn setTag:2];
    self.confirmnvBtn = confirmnvBtn;
    [confirmnvBtn setImage:[UIImage imageNamed:@"rb_set_sex_selected"] forState:UIControlStateSelected];
    [confirmnvBtn setImage:[UIImage imageNamed:@"rb_set_sex_normal"] forState:UIControlStateNormal];
    
    [self.scrollView addSubview:confirmnvBtn];
    [confirmnvBtn addTarget:self action:@selector(falmeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmnvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nanLabelBtn.mas_right).offset(30);
        make.width.offset(30);
        make.height.offset(LOCAL_CONFIRMSEXBTNWIDTH); make.top.equalTo(nameUnderLine.mas_bottom).offset(MID_MID_SPACE-2);
        
        
    }];
//    UILabel *nvLabel = [UILabel new];
//    //女
//    nvLabel.text = NSLocalizedString(@"women", nil);
//    [self.scrollView addSubview:nvLabel];
//    [nvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(nameUnderLine.mas_bottom).offset(10);
//        make.left.equalTo(confirmnvBtn.mas_right).offset(LITTLE_LITTLE_SPACE);
//        //        make.width.offset(KScreenW);
//        make.height.offset(18);
//    }];
//    [nvLabel sizeToFit];
    UIButton *nvLabelBtn = [UIButton new];
    [nvLabelBtn setTitle:NSLocalizedString(@"women", nil) forState:UIControlStateNormal];
//    [nvLabelBtn setTintColor:[UIColor blackColor]];
    [nvLabelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.scrollView addSubview:nvLabelBtn];
    [nvLabelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameUnderLine.mas_bottom).offset(10);
        make.left.equalTo(confirmnvBtn.mas_right).offset(LITTLE_LITTLE_SPACE);
        //        make.width.offset(KScreenW);
        make.height.offset(18);
    }];
    [nvLabelBtn setTag:2];
    [nvLabelBtn addTarget:self action:@selector(falmeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [nvLabelBtn sizeToFit];
    
    
    
    
    
    
    
    UILabel *miMaLabel = [UILabel new];
    //密码 password
    miMaLabel.text = NSLocalizedString(@"password", nil);
    [self.scrollView addSubview:miMaLabel];
    [miMaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sexLabel.mas_bottom).offset(15);
        make.left.equalTo(tipsLabel.mas_left).offset(0);
    }];
    
    UITextField *miMatextFiled = [UITextField new];
    self.miMatextFiled = miMatextFiled;
    //accountname_create_password_tips @"请输入8位以上密码";
    miMatextFiled.placeholder = NSLocalizedString(@"accountname_create_password_tips", nil);
    [miMatextFiled setValue:[UIFont boldSystemFontOfSize:LABEL_FRONT] forKeyPath:@"_placeholderLabel.font"];
    
    miMatextFiled.secureTextEntry = YES;
    
    //    miMatextFiled.secureTextEntry = UIKeyboardTypeEmailAddress;
    
    self.miMatextFiled = miMatextFiled;
    [self.scrollView addSubview:miMatextFiled];
    [miMatextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(miMaLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.height.offset(LOCAL_ACCOUNTFILEDHEIGHT);
        
    }];
    ///添加动作
    [self.miMatextFiled addTarget:self action:@selector(miMatextFiledChange:) forControlEvents:UIControlEventEditingChanged];
    //
    //
    UIImageView *miMaUnderlineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline"]];
    [self.scrollView addSubview:miMaUnderlineImg];
    [miMaUnderlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.height.offset(LOCAL_UNDERLINEWITH); make.top.equalTo(miMatextFiled.mas_bottom).offset(LOCAL_UNDERLINESPECE);
        
    }];
    
    UILabel *miMatipLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:RECOVERTIPS_COLOR] andTextFont:LITTLE_LABEL_FRONT andContentText:@""];
    self.miMatipLabel = miMatipLabel;
    
    [self.scrollView addSubview:miMatipLabel];
    [miMatipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.top.equalTo(miMaUnderlineImg.mas_bottom).offset(LOCAL_TIPSSTRSPECE);
        make.width.offset(KScreenW);
        make.height.offset(LOCAL_ACCOUNTTIPLABELHEIGHT);
    }];
    miMatipLabel.textAlignment = NSTextAlignmentLeft;
    [miMatipLabel sizeToFit];
    
    //
    UILabel *confirmmiMaLabel = [UILabel new];
    ///确认密码 password_confirm
    confirmmiMaLabel.text = NSLocalizedString(@"password_confirm", nil);
    [self.scrollView addSubview:confirmmiMaLabel];
    [confirmmiMaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(miMatipLabel.mas_bottom).offset(LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.width.offset(KScreenW);
        make.height.offset(LOCAL_LABELHEIGHT);
    }];
    //
    UITextField *confirmmiMatextFiled = [UITextField new];
    //accountname_create_password_tips2 @"再次输入密码,最少8位"
    confirmmiMatextFiled.placeholder = NSLocalizedString(@"accountname_create_password_tips2", nil);
    if (KScreenW == IPHONEFIVESCREENH) {
        [confirmmiMatextFiled setValue:[UIFont boldSystemFontOfSize:SMALL_FRONT] forKeyPath:@"_placeholderLabel.font"];
    } else{
        [confirmmiMatextFiled setValue:[UIFont boldSystemFontOfSize:LITTLE_LABEL_FRONT] forKeyPath:@"_placeholderLabel.font"];
    }
    confirmmiMatextFiled.font =  [UIFont systemFontOfSize:LABEL_FRONT];
    confirmmiMatextFiled.secureTextEntry = YES;
    self.confirmmiMatextFiled = confirmmiMatextFiled;
    [self.scrollView addSubview:confirmmiMatextFiled];
    [confirmmiMatextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmmiMaLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.width.offset(KScreenW);
        make.height.offset(LOCAL_NAMEFILEDHEIGHT);
        
    }];
    [self.confirmmiMatextFiled addTarget:self action:@selector(confirmmiMatextFiled:) forControlEvents:UIControlEventEditingChanged];
    
    //
    UIImageView *confirmmiMaUnderline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline"]];
    [self.scrollView addSubview:confirmmiMaUnderline];
    [confirmmiMaUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.height.offset(LOCAL_UNDERLINEWITH); make.top.equalTo(confirmmiMatextFiled.mas_bottom).offset(LOCAL_UNDERLINESPECE);
        
    }];
    //提示框
    UILabel *confirmMiMatipLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:RECOVERTIPS_COLOR] andTextFont:LITTLE_LABEL_FRONT andContentText:@""];
    [self.scrollView addSubview:confirmMiMatipLabel];
    self.confirmMiMatipLabel = confirmMiMatipLabel;
    [confirmMiMatipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.top.equalTo(confirmmiMaUnderline.mas_bottom).offset(LOCAL_TIPSSTRSPECE);
        make.width.offset(KScreenW);
        make.height.offset(LOCAL_LABELHEIGHT);
        
    }];
    [confirmMiMatipLabel sizeToFit];
    UILabel *tuiJianRenLabel = [UILabel makeLabelWithTextColor:[UIColor blackColor] andTextFont:LABEL_FRONT andContentText:NSLocalizedString(@"invitation_code_must", nil)];
    [self.scrollView addSubview:tuiJianRenLabel];
    [tuiJianRenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.top.equalTo(confirmMiMatipLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.width.offset(KScreenW-LEFT_SPACE);
        
    }];
    tuiJianRenLabel.textAlignment = NSTextAlignmentLeft;
    
    UITextField *tuiJianRenTextField = [UITextField new];
    self.tuiJianRenTextField = tuiJianRenTextField;
    
    tuiJianRenTextField.placeholder = NSLocalizedString(@"write_referrer_account", nil);
    [tuiJianRenTextField addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:tuiJianRenTextField];
    [tuiJianRenTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [tuiJianRenTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    tuiJianRenTextField.keyboardType = UIKeyboardTypeNumberPad;
    [tuiJianRenTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.top.equalTo(tuiJianRenLabel.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.width.offset(KScreenW-LEFT_SPACE);
    }];
    
    UIImageView *tuiJianRenUnderline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline"]];
    [self.scrollView addSubview:tuiJianRenUnderline];
    [tuiJianRenUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.height.offset(LOCAL_UNDERLINEWITH); make.top.equalTo(tuiJianRenTextField.mas_bottom).offset(LOCAL_UNDERLINESPECE);
    }];
    
    
    
    
    
    
    
    //
    //
//    UIButton *confirmBtn = [[UIButton alloc] init];
    self.confirmBtn = [ExtendedButton buttonWithType:UIButtonTypeCustom];
    //    [confirmBtn setImage:[UIImage imageNamed:@"Action_Sheet_Warning_New"] forState:UIControlStateHighlighted];
    //
    //    [confirmBtn setImage:[UIImage imageNamed:@"Fav_Green_DeleteTab"] forState:UIControlStateNormal];
    
    [self.confirmBtn setImage:[UIImage imageNamed:@"circlecnofrim"] forState:UIControlStateNormal];
    [self.confirmBtn setImage:[UIImage imageNamed:@"confrim"] forState:UIControlStateSelected];
    //    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"circlecnofrim"] forState:UIControlStateNormal];
    //    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"confrim"] forState:UIControlStateSelected];
    //
    [self.scrollView addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.width.offset(18);
        make.height.offset(18);
        make.top.equalTo(tuiJianRenUnderline.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        
    }];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *agereeLabel = [UILabel new];
    //button_agree @"同意";
    agereeLabel.text = NSLocalizedString(@"button_agree", nil);
    [self.scrollView addSubview:agereeLabel];
    [agereeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmBtn.mas_right).offset(5);
        make.top.equalTo(tuiJianRenUnderline.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        //        make.width.offset(50);
        make.height.offset(LOCAL_LABELHEIGHT);
        
    }];
    [agereeLabel sizeToFit];
    
    UIButton *agereeBtn = [UIButton new];
    //terms_of_service @"用户协议"
    [agereeBtn setTitle:NSLocalizedString(@"terms_of_service", nil) forState:UIControlStateNormal];
    
    [agereeBtn setTitleColor:[UIColor colorWithHex:LOCALLITTLETIP_COLOR] forState:UIControlStateNormal];
    [self.scrollView addSubview:agereeBtn];
    //    [agereeBtn sizeToFit];
    [agereeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agereeLabel.mas_right).offset(0);
        make.top.equalTo(tuiJianRenUnderline.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.width.offset(KScreenW);
        make.height.offset(LOCAL_LABELHEIGHT);
    }];
    agereeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //user_contract_txt @"请遵守各个国家和地区的法律法规,国际公约,以及风俗习惯,请在合法合规的范围内使用本软件,否则请终止"
    UILabel *desLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:LOCALLITTLETIP_COLOR] andTextFont:TWELFTH_FRONT andContentText:NSLocalizedString(@"user_contract_txt", nil)];
    desLabel.numberOfLines = 0;
    [self.scrollView addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agereeLabel.mas_left).offset(0);
        make.top.equalTo(agereeBtn.mas_bottom).offset(LITTLE_LITTLE_SPACE);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        //        make.height.offset(100);
        
    }];
    [desLabel sizeToFit];
    //
    UIButton *confirmconfirmBtn = [UIButton new];
    [confirmconfirmBtn setBackgroundImage:[UIImage imageNamed:@"Button_BG_small"] forState:UIControlStateNormal];
    //accountname_create_title @"创建账号"
    [confirmconfirmBtn setTitle:NSLocalizedString(@"accountname_create_title", nil) forState:UIControlStateNormal];
    [confirmconfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:confirmconfirmBtn];
    [confirmconfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.right.equalTo(tipsLabel.mas_right).offset(-RIGHT_SPACE);
        make.height.offset(44);
        make.top.equalTo(desLabel.mas_bottom).offset(LITTLE_SPACE);
        
    }];
    [confirmconfirmBtn addTarget:self action:@selector(confirmconfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.confirmconfirmBtn = confirmconfirmBtn;
    //刚进入不能点击
    self.confirmconfirmBtn.userInteractionEnabled=NO;//交互关闭
    self.confirmconfirmBtn.alpha=BTN_ALPHA;//透明度
    
    
    
    UIButton *creatBtn = [UIButton new];
    //恢复账号 accountname_restore_title
    [creatBtn setTitle:NSLocalizedString(@"accountname_restore_title", nil) forState:UIControlStateNormal];
    [creatBtn setTitleColor:[UIColor colorWithHex:RECOVERACCOUNT_COLOR] forState:UIControlStateNormal];
    [self.scrollView addSubview:creatBtn];
    [creatBtn sizeToFit];
    [creatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(confirmconfirmBtn.mas_right).offset(-2);
        make.top.equalTo(confirmconfirmBtn.mas_bottom).offset(MID_MID_SPACE);
        //        make.width.offset(150);
        make.height.offset(LABEL_FRONT);
    }];
    [creatBtn addTarget:self action:@selector(recoverAccout) forControlEvents:UIControlEventTouchUpInside];
    creatBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [creatBtn sizeToFit];
    [creatBtn setHidden:YES];
}
- (void)recoverAccout {
    if (self.type) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        LZRecoverViewController *recoverVC = [LZRecoverViewController new];
        
        [self.navigationController pushViewController:recoverVC animated:YES];
        //        [self presentViewController:recoverVC animated:YES completion:nil];
    }
}

- (void)confirmconfirmBtnClick {
    
    if (self.miMatextFiled.text.length<LCAL_MIMALENGTH||self.confirmmiMatextFiled.text.length<LCAL_MIMALENGTH) {
        [[UIAlertController shareAlertController] showAlertcWithString:@"长度不能小于8位" controller:self];
        return ;
    }
    ///判断账号是不是有空格
    NSString *_string = [NSString stringWithFormat:@"%@",self.accountFiled.text];
    NSRange _range = [_string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [[UIAlertController shareAlertController] showAlertcWithString:@"账号不能用空格!" controller:self];
        return;
    }
    for(int i=0; i< self.accountFiled.text.length;i++)
    {
        int a =[self.accountFiled.text characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"账号设置不能有汉字" message:@"请重新设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertVC addAction:confirmAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
    }
    //
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    //    [SVProgressHUD show];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self showHudInView:self.navigationController.view hint:@""];
    
    
    //    hud.dimBackground = YES;
    WSAccountInfo* info = [[WSAccountInfo alloc] init];
    
    info.name = self.accountFiled.text;
    info.nickname = self.nameFiled.text;
    NSString *inviteCode = self.tuiJianRenTextField.text;
    if ([inviteCode length] == 0) {
        inviteCode = @"";
    }
    info.referrer = inviteCode;
    
    if( self.confirmnanBtn.selected ) {
        
        info.sex = AccountMan;
        
    } else if (self.confirmnvBtn.selected) {
        
        info.sex = AccountWoman;
        
    } else {
        info.sex = AccountWoman;
        [self falmeBtnClick:self.confirmnvBtn];
    }
    NSString *netWork = [[CoinTools sharedCoinTools] judgeNetWork];
    if([netWork isEqualToString:@"NO"]) {
        
        [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"one_no_network_tips", nil) controller:self];
        [self hideHud];
        return;
    }
    
    NSString *password = self.miMatextFiled.text;
    
    [[ONEChatClient sharedClient] createAccount:info seed:self.seed password:password completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            if (!error) {
                
                [self showHint:NSLocalizedString(@"register_request_ok", nil)];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SWITCH_ROOT_VIEWCONTROLLER object:nil];

            } else {

                NSString *str = [self registerShowErrorMsgFromONEError:error];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""message:str preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"button_ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];

                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    }];

    
    self.miMatextFiled.text = @"";
    self.confirmmiMatextFiled.text = @"";
    self.confirmconfirmBtn.userInteractionEnabled=NO;//交互关闭
    self.confirmconfirmBtn.alpha=BTN_ALPHA;//透明度
    
}

- (NSString *)registerShowErrorMsgFromONEError:(ONEError *)error
{
    NSString *msg = nil;
    if (error.errorCode == ONEErrorNetworkInvalid) {
        
        msg = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"one_network_error", nil),error.errorDescription];
    } else if (error.errorCode == ONEErrorAccountNameExist) {
        
        msg = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"register_request_user_exist", nil),error.errorDescription];
    } else if (error.errorCode == ONEErrorAccountUnknownRegister) {
        
        msg = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"register_request_unknown_registrar", nil),error.errorDescription];
    } else if (error.errorCode == ONEErrorAccountInvalidInviteCode) {
        
        msg = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"register_request_unknown_referrer", nil),error.errorDescription];
    } else if (error.errorCode == ONEErrorInvalidParam) {
        
        msg = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"register_request_param_error", nil),error.errorDescription];
    } else if (error.errorCode == ONEErrorAccountServerError) {
        msg = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"register_request_server_error", nil),error.errorDescription];
    } else if (error.errorCode == ONEErrorAccountNameInvalid) {
        msg = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"register_request_name_error", nil),error.errorDescription];
    } else if (error.errorCode == ONEErrorRegistCountExceed) {
        msg = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"register_request_exceeded_max_number", nil),error.errorDescription];
    } else if (error.errorCode == ONEErrorSeedUsed) {
        msg = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"register_request_seed_has_register", nil),error.errorDescription];
    } else {
        msg = error.errorDescription;
    }
    return msg;
}

- (NSString *)errorMsgFromData:(id)data
{
    NSString *msg = nil;
    if ([data isKindOfClass:[NSError class]]) {
        NSError *pError = (NSError *)data;
        msg = [NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"register.fail", @"Registration failed"),pError.code];
    }
    return msg;
}





- (void)delayMethod{
    NSLog(@"delayMethodEnd");
}


-(void)falmeBtnClick:(UIButton *)button {
    
    if (button.tag == 1) {
        self.confirmnanBtn.selected = YES;
        self.confirmnvBtn.selected = NO;
    } if (button.tag == 2) {
        self.confirmnanBtn.selected = NO;
        self.confirmnvBtn.selected = YES;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)confirmBtnClick:(UIButton *)button {
    //    button.isSelected = YES;
//    button.selected = YES;
    button.selected = !button.isSelected;
    [self textFiledChange:nil];
}
//accountFiledChange 账户更改
-(void)accountFiledChange:(UITextField *)textField {
    if (textField.text.length < LOCAL_ACCOUNTLENGTH &&textField.text.length >0) {
        self.accountTipLabel.text =NSLocalizedString(@"accountname_create_username_tips", nil);
    }else if (textField.text.length == 0) {
        self.accountTipLabel.text =@"";
    }else {
        self.accountTipLabel.text = @"";
    }
    
}
//miMatextFiledChange password_length_erro
-(void)miMatextFiledChange:(UITextField *)textField {
    if (textField.text.length < LCAL_MIMALENGTH && textField.text.length>0) {
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([filtered isEqualToString:@""]) {
        self.accountTipLabel.text =NSLocalizedString(@"accountname_create_username_tips", nil);
    } else {
        
    }
    return [string isEqualToString:filtered];
    
}
-(BOOL)MatchLetter:(NSString *)str
{
    
    if (str.length == 1) {
        NSString *regex =@"[a-zA-Z]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [pred evaluateWithObject:str];
    } else {
        //不能是-
        if (str.length == 1 && ![str isEqualToString:@"-"]) {
            return YES;
        } else {
            return NO;
        }
    }
    ////    if (str.length == 0) return NO;
    //    NSString *regex =@"[a-zA-Z]*";
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //    return [pred evaluateWithObject:str];
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSCharacterSet *cs;
//    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
//    BOOL canChange = [string isEqualToString:filtered];
//    return self.accountFiled.text.length>=0?NO: canChange;
//}

/*
 
 ///解决键盘遮挡
 self.accountFiled.delegate = self;
 //    self.nameFiled.delegate = self;
 self.miMatextFiled.delegate = self;
 self.confirmmiMatextFiled.delegate = self;
 */
-(void)textFiledChange:(UITextField *)textField{
    if (textField.text.length>MAX_WIRTE_NUM) {
        textField.text = [textField.text substringToIndex:MAX_WIRTE_NUM];
//        [string substringToIndex:5]
    }
    
    if (self.accountFiled.text.length<LOCAL_ACCOUNTLENGTH || self.nameFiled.text.length== 0 || self.miMatextFiled.text.length<LCAL_MIMALENGTH || self.confirmmiMatextFiled.text.length<LCAL_MIMALENGTH ||![self.miMatextFiled.text isEqualToString:self.confirmmiMatextFiled.text] || !self.confirmBtn.isSelected) {
        //先判断完 长度 然后再判断一下 是不是一样
        self.confirmconfirmBtn.userInteractionEnabled=NO;//交互关闭
        self.confirmconfirmBtn.alpha=BTN_ALPHA;//透明度
        if (self.accountFiled.text.length == 1) {
            
            //判断状态 是字母
            BOOL state = [self MatchLetter:self.accountFiled.text];
            if (state) {
                // 是字母
            } else {
                //不是字母
                self.accountFiled.text = @"";
            }
            
            
        }
    } else {
        self.confirmconfirmBtn.userInteractionEnabled=YES;//交互关闭
        self.confirmconfirmBtn.alpha=BTN_NOALPHA;//透明度
        
    }
}
- (BOOL)inputShouldLetterOrNum:(NSString *)inputString {
    
    if (inputString.length == 0) return NO;
    NSString *regex =@"[A-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.accountFiled endEditing:YES];
    [self.nameFiled endEditing:YES];
    [self.miMatextFiled endEditing:YES];
    [self.confirmmiMatextFiled resignFirstResponder];
}

- (void)backBtnClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

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
