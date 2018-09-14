//
//  LZChageUserInfoViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/15.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZChageUserInfoViewController.h"
#import <UIImageView+WebCache.h>
#import "NSString+Addition.h"
#import <UIButton+WebCache.h>
#import "ZYKeyboardUtil.h"
#import <SVProgressHUD.h>
#import "LZGainIconModel.h"
#import "LZuserInfoModel.h"
#import "UIImage+Extension.h"
#define MARGIN_KEYBOARD 10
#define XIANZHIZIDHU 356

@interface LZChageUserInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *avatarBgView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *famleView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;



//图片按钮
@property (weak, nonatomic) IBOutlet UIButton *IconBtn;

//昵称
@property (weak, nonatomic) IBOutlet UITextField *nameText;
//个性签名
@property (weak, nonatomic) IBOutlet UITextView *signatureText;
//男按钮
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
//女按钮
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
//邮箱
@property (weak, nonatomic) IBOutlet UILabel *mailBoxLabel;
//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
//邮箱验证码
@property (weak, nonatomic) IBOutlet UITextField *emailYanZhengMatext;
//手机验证码
@property (weak, nonatomic) IBOutlet UITextField *phoneYanZhengMaText;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;


//中英文替换的名字
@property (weak, nonatomic) IBOutlet UILabel *chageNameLabel;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *chageAccountName;
//性别
@property (weak, nonatomic) IBOutlet UILabel *chageSex;
//男
@property (weak, nonatomic) IBOutlet UILabel *chageMan;
//女
@property (weak, nonatomic) IBOutlet UILabel *chageWoman;
//邮箱
@property (weak, nonatomic) IBOutlet UILabel *chageEmail;
//发送按钮
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
//邮箱验证码
@property (weak, nonatomic) IBOutlet UILabel *chageEmailYanZheng;
//邮箱验证码text
@property (weak, nonatomic) IBOutlet UITextField *chageEmailYanZhengText;
////确定按钮
//@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
//手机号
@property (weak, nonatomic) IBOutlet UILabel *chagePhoneNum;
//获取验证码btn
@property (weak, nonatomic) IBOutlet UIButton *chageGetYanZhengBtn;
//手机验证码
@property (weak, nonatomic) IBOutlet UILabel *chagePhoneYanZheng;
//个性签名
@property (weak, nonatomic) IBOutlet UILabel *chageSignature;
@property (weak, nonatomic) IBOutlet UILabel *clickTOChageIcon;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;


//存储用户性别
@property(nonatomic,assign) NSInteger *sex;

//储存的用户头像
@property(nonatomic, strong)UIImage *iconImage;
//键盘
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
//WSAccountInfo 用户信息
@property (nonatomic,strong)WSAccountInfo *accountInfo;
@property (weak, nonatomic) IBOutlet UIButton *nanLabelBtn;
@property (weak, nonatomic) IBOutlet UIButton *nvLabelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *firstLine;
@property (weak, nonatomic) IBOutlet UIImageView *secondLine;
@property (weak, nonatomic) IBOutlet UIImageView *thirdLine;

@end

@implementation LZChageUserInfoViewController

- (void)refreshUI
{
    self.view.themeMap = @{
                           BGColorName:@"bg_normal_color"
                           };
    self.scroll.themeMap = @{
                             BGColorName:@"bg_normal_color"
                             };
    self.avatarBgView.themeMap = @{
                                   BGColorName:@"bg_white_color"
                                   };
    self.nameView.themeMap = @{
                               BGColorName:@"bg_white_color"
                               };
    self.famleView.themeMap = @{
                                BGColorName:@"bg_white_color"
                                };
    self.clickTOChageIcon.themeMap = @{
                                       TextColorName:@"common_text_color"
                                       };
    self.chageNameLabel.themeMap = @{
                                     TextColorName:@"common_text_color"
                                     };
    self.chageAccountName.themeMap = @{
                                       TextColorName:@"common_text_color"
                                       };
    self.chagePhoneYanZheng.themeMap = @{
                                    TextColorName:@"common_text_color"
                                    };
    self.chageSex.themeMap = @{
                               TextColorName:@"common_text_color"
                               };
    self.nanLabelBtn.themeMap = @{
                               TextColorName:@"common_text_color"
                               };
    self.nvLabelBtn.themeMap = @{
                               TextColorName:@"common_text_color"
                               };
    self.chageSignature.themeMap = @{
                                     TextColorName:@"common_text_color"
                                     };
    self.nameText.themeMap = @{
                               TextColorName:@"common_text_color"
                               };
    self.accountNameLabel.themeMap = @{
                                       TextColorName:@"common_text_color"
                                       };
    self.phoneNumLabel.themeMap = @{
                                    TextColorName:@"conversation_detail_color"
                                          };
    self.signatureText.themeMap = @{
                                    TextColorName:@"conversation_detail_color",
                                    BGColorName:@"bg_white_color"
                                    };
    self.firstLine.image = nil;
    self.secondLine.image = nil;
    self.thirdLine.image = nil;
    self.firstLine.themeMap = @{
                                BGColorName:@"conversation_line_color"
                                };
    self.secondLine.themeMap = @{
                                BGColorName:@"conversation_line_color"
                                };
    self.thirdLine.themeMap = @{
                                BGColorName:@"conversation_line_color"
                                };
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshUI];
    ///配置标题 以及其他UI
    [self Configuration];
    ///展示用户信息
    [self showUserInfo];

    //设置tag值
    [self.manBtn setTag:MAN];
    [self.womanBtn setTag:WOMAN];
    [self.nanLabelBtn setTag:MAN];
    [self.nvLabelBtn setTag:WOMAN];

    self.signatureText.delegate = self;
    
    //设置键盘弹起
    [self ConfigurationKeyBoard];
    [self setLanguage];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.scroll addGestureRecognizer:tapGestureRecognizer];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:THMImage(@"nav_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.scroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
    self.backBlock();
    
}
- (void)showUserInfo {
    //    WSHomeAccount.accountId
    WSAccountInfo *accountInfo = [ONEChatClient homeAccountInfo];
    self.accountInfo = accountInfo;
    
    NSString *placeholderStr = [[NSString alloc] init];
    if (accountInfo.sex == AccountMan) {
        self.manBtn.selected = YES;
        self.womanBtn.selected = NO;
        placeholderStr = @"maniconplaceholder";
        self.sex = AccountMan;
    } else if (accountInfo.sex == AccountWoman) {
        self.manBtn.selected = NO;
        self.womanBtn.selected = YES;
        self.sex = AccountWoman;
        placeholderStr = @"womaniconpalceholder";
    } else {
        ///什么都不干
        placeholderStr = @"peopleicon";
        
    }
    
    ///头像
    [self.IconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString addURLStr:accountInfo.avatar_url]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:placeholderStr] options:nil];
    self.IconBtn.layer.cornerRadius = self.IconBtn.width/2;
    self.IconBtn.layer.masksToBounds = YES;
    //其他
    //名字赋值
    self.nameText.text = accountInfo.nickname;
    
    //个性签名赋值
    self.signatureText.text = accountInfo.intro;
    
    //用户名赋值
    self.accountNameLabel.text = accountInfo.name;
    //性别赋值
    
    //    NSString *currentsex = [NSString stringWithFormat:@"%@",infoModel.sex];
    //男
    
    //邮箱赋值
    
    self.mailBoxLabel.text = accountInfo.email;

    
}


- (void)setLanguage {
    //昵称
    self.chageNameLabel.text = NSLocalizedString(@"accountname_create_nickname", nil);
    //用户名
    self.chageAccountName.text =NSLocalizedString(@"user_name", nil);
    [self.chageAccountName sizeToFit];
    
    //性别
    self.chageSex.text = NSLocalizedString(@"sex", nil);
    [self.chageSex adjustsFontSizeToFitWidth];
    //男 man
//    self.chageMan.text = NSLocalizedString(@"man", nil);
    [self.nanLabelBtn setTitle:NSLocalizedString(@"man", nil) forState:UIControlStateNormal];
    
    //女
//    self.chageWoman.text = NSLocalizedString(@"women", nil);
    [self.nvLabelBtn setTitle:NSLocalizedString(@"women", nil) forState:UIControlStateNormal];
    
    //邮箱 user_email
    self.chageEmail.text = NSLocalizedString(@"user_email", nil);
    //邮箱验证码
    self.chageEmailYanZheng.text = NSLocalizedString(@"user_email_code", nil);
    //获取验证码
    [self.sendBtn setTitle:NSLocalizedString(@"get_code", nil) forState:UIControlStateNormal];
    //邮箱验证码站位 input_code
    self.chageEmailYanZhengText.placeholder = NSLocalizedString(@"input_code", nil);
    //手机号
    self.chagePhoneNum.text = NSLocalizedString(@"user_tel", nil);
    //获取验证码
    
    [self.chageGetYanZhengBtn setTitle:NSLocalizedString(@"get_code", nil) forState:UIControlStateNormal];
    
    //手机验证码label user_tel_code
    self.chagePhoneYanZheng.text = NSLocalizedString(@"user_tel_code", nil);
    //简介
    self.chageSignature.text = NSLocalizedString(@"user_intro", nil);
    //点此修改头像click_change_avatar
    self.clickTOChageIcon.text =NSLocalizedString(@"click_change_avatar", nil);
    
}
- (void)Configuration {
    //user_info 个人信息
    self.title = NSLocalizedString(@"user_info", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button_save", nil)style:UIBarButtonItemStylePlain target:self action:@selector(savaBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:THMColor(@"common_text_color")];
}
-(void)ConfigurationKeyBoard {
    ///解决键盘遮挡
    self.nameText.delegate = self;
    self.signatureText.delegate = self;
    self.emailYanZhengMatext.delegate = self;
    self.phoneYanZhengMaText.delegate = self;
    
    [self configKeyBoardRespond];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//用户头像选取
- (IBAction)iconBtnClick:(id)sender {
    
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(5,KScreenH-100,KScreenW-10,100);
    
    //按钮：拍照，类型：UIAlertActionStyleDefault //attach_take_pic
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"attach_take_pic", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        PickerImage.allowsEditing = YES;
        
        PickerImage.delegate = self;
        
        [self presentViewController:PickerImage animated:YES completion:nil];
        
    }]];
    
    
    //按钮：从相册选择，类型：UIAlertActionStyleDefault gallery
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"gallery", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        
        //自代理
        PickerImage.delegate = self;
        
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    //按钮：取消，类型：UIAlertActionStyleCancel cancel
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
    UIImage *scaleImage = [image imageByScalingAndCroppingForSize:CGSizeMake(100, 100)];
    
    UIImage *newImage = [UIImage scaleImage:scaleImage toKb:20];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self showHudInView:self.view hint:nil];
    
    [[ONEChatClient sharedClient] uploadAvatar:newImage completion:^(ONEError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            if (!error) {
                [self.IconBtn setBackgroundImage:newImage forState:UIControlStateNormal];
                self.iconImage = newImage;
            } else {
                [self showHint:NSLocalizedString(@"setting.uploadFail", @"uploaded failed")];
            }
        });
    }];
}

- (IBAction)seletFamle:(UIButton*) sender {
    
    if ([sender tag] == MAN) {
        self.manBtn.selected = YES;
        self.womanBtn.selected = NO;
        self.sex = AccountMan;
    } if ([sender tag]== WOMAN) {
        
        self.manBtn.selected = NO;
        self.womanBtn.selected = YES;
        self.sex = AccountWoman;
    }
}

//上传用户信息
- (void)savaBtnClick {

    [self.view endEditing:YES];
    WSAccountInfo *accInfo = [ONEChatClient homeAccountInfo];
    
    accInfo.sex = (AccountSex)self.sex;
    accInfo.nickname = self.nameText.text;
    accInfo.intro = self.signatureText.text;
    kWeakSelf
    [self showHudInView:self.view hint:nil];
    [[ONEChatClient sharedClient] pushAccountInfo:accInfo completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself backBtnClick];
                });
            } else {
                [weakself showHint:NSLocalizedString(@"error", @"Failed")];
            }
        });
    }];
}


- (void)textViewDidChange:(UITextView *)textView {
    if (self.signatureText.text.length>XIANZHIZIDHU) {
        textView.text = [textView.text substringToIndex:XIANZHIZIDHU];
    }
}

//解决键盘遮挡
- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak LZChageUserInfoViewController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        //        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.nameText, weakSelf.signatureText, weakSelf.emailYanZhengMatext,weakSelf.phoneYanZhengMaText, nil];
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.nameView, weakSelf.famleView, nil];
        
        
    }];
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        // NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}
#pragma mark delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.nameText resignFirstResponder];
    [self.signatureText resignFirstResponder];
    [self.emailYanZhengMatext resignFirstResponder];
    [self.phoneYanZhengMaText resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameText resignFirstResponder];
    [self.signatureText resignFirstResponder];
    [self.emailYanZhengMatext resignFirstResponder];
    [self.phoneYanZhengMaText resignFirstResponder];
    return YES;
}
-(void)hideKeyBoard
{
    
    [self.scroll endEditing:YES];
    
}
- (IBAction)BtnClick:(id)sender {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.scroll addSubview:hud];
    //即将加入敬请期待 feature_come_soon
    hud.labelText = NSLocalizedString(@"feature_come_soon", nil);
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    }
       completionBlock:^{
           [hud removeFromSuperview];
           //           _HUD = nil;
       }];
    
}
- (void)topAlignment{
    CGSize size = [self.phoneNumLabel.text sizeWithAttributes:@{NSFontAttributeName:self.phoneNumLabel.font}];
    CGRect rect = [self.phoneNumLabel.text boundingRectWithSize:CGSizeMake(self.phoneNumLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.phoneNumLabel.font} context:nil];
    self.phoneNumLabel.numberOfLines = 0;//为了添加\n必须为0
    NSInteger newLinesToPad = (self.phoneNumLabel.frame.size.height - rect.size.height)/size.height;
    
    for (NSInteger i = 0; i < newLinesToPad; i ++) {
        self.phoneNumLabel.text = [self.phoneNumLabel.text stringByAppendingString:@"\n "];
    }
}

@end
