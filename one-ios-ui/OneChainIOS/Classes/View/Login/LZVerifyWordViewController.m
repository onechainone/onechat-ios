//
//  LZVerifyWordViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/25.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZVerifyWordViewController.h"
#import "LZTabBarController.h"
#import "LZRegistViewController.h"
#import "GuideView.h"


#define ScrollViewHeight 667
#define SCREERN_W [UIScreen mainScreen].bounds.size.width
#define SCREERN_H [UIScreen mainScreen].bounds.size.height

@interface LZVerifyWordViewController () {
        UIView *view;
}
@property(nonatomic,strong)UIScrollView *scrollView;
///装的分割之后的seed
@property (nonatomic,copy)NSMutableArray *seedArr;
//助记词数据字典 存的是字典
@property (nonatomic,copy)NSMutableArray *wordList;
//上面选择的字典 存的是字典
@property (nonatomic,copy)NSMutableArray *btnList;

///装的下面助记词的数组的按钮
@property (nonatomic,copy)NSMutableArray *wordBtnArray;
///装的上面显示的Btn
@property (nonatomic,copy)NSMutableArray *BtnArray;
//装拼接之后的seed 数组
@property (nonatomic,copy)NSMutableArray *pinJieSeedArr;
//真实的seedarr
@property (nonatomic,copy)NSMutableArray *realSeedArr;

@property (nonatomic, strong) GuideView *guideView;

@property (nonatomic, strong) UIButton *registerBtn;
///跳过按钮
@property (nonatomic, strong) UIButton *skipBtn;

@property (nonatomic, strong) UIView *btnContentView;

@end

@implementation LZVerifyWordViewController

- (GuideView *)guideView
{
    if (!_guideView) {
        
        _guideView = [[GuideView alloc] initWithGuideStyle:GuideStyleSecond];
    }
    return _guideView;
}
//skipBtn

- (UIButton *)registerBtn
{
    if (!_registerBtn) {
        
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:16.f];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
//        [_registerBtn setTitle:NSLocalizedString(@"accountname_create_title", @"") forState:UIControlStateNormal];
        [_registerBtn setTitle:NSLocalizedString(@"finish_verify", @"Verification Succeeded") forState:UIControlStateNormal];
        
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"Button_BG_big"] forState:UIControlStateNormal];
    }
    return _registerBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //验证助记词
    self.title = NSLocalizedString(@"make_sure_seed", nil);
    self.view.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
//    self.seedArr = [self.seed componentsSeparatedByString:@" "];
    self.seedArr = [self randomArray];
    
    if (self.type) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back_old"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    }
    
    [self setupUI];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupUI {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, self.view.bounds.size.height)];
    self.scrollView.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    self.scrollView = scrollView;
    self.scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    //    scrollView.center = self.view.center;
    //    scrollView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.contentSize = CGSizeMake(KScreenW, ScrollViewHeight);
    [self.view addSubview: scrollView];
    
    UILabel *tipLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:THEME_COLOR] andTextFont:TWELFTH_FRONT andContentText:NSLocalizedString(@"make_sure_seed_tip", @"Please make sure you write down the mnemonics right, and then tap the words in order to verify.")];
    tipLabel.numberOfLines = 0;
    [self.scrollView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(RIGHT_SPACE);
//        make.centerX.offset(0);
        make.left.offset(LEFT_SPACE);
        make.width.offset(KScreenW-LEFT_SPACE-RIGHT_SPACE);
    }];
    /////////
    //上面的按钮
    [self initShow];
    //下面的按钮
    [self initSelect];
    [self initBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initShow {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(40, 70, SCREERN_W-80,180)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i<self.seedArr.count; i++) {
        
        NSString *name = @" ";
        static UIButton *recordBtn =nil;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.layer.borderWidth = 1.0;
//        btn.layer.borderColor = [UIColor colorWithHex:BIANKUANG_COLOR].CGColor;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 15;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        CGRect rect = CGRectMake(0, 0, contentView.size.width/4, 30);
        if (i == 0)
        {
            btn.frame =CGRectMake(0, 0, rect.size.width, rect.size.height);
        }
        else{
            CGFloat yuWidth = contentView.size.width - 0 -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= rect.size.width) {
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 0, recordBtn.frame.origin.y, rect.size.width, rect.size.height);
            }else{
                btn.frame =CGRectMake(0, recordBtn.frame.origin.y+recordBtn.frame.size.height+0, rect.size.width, rect.size.height);
            }
        }
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [contentView addSubview:btn];
        recordBtn = btn;
        recordBtn.tag = i;
        [recordBtn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.BtnArray addObject:btn];
    }
    [self.scrollView addSubview:contentView];
}
-(void) initSelect {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(35, 270, SCREERN_W-70,30 * 4 + 8 * 5)];

    _btnContentView = contentView;
//    contentView.backgroundColor = [UIColor grayColor];
    
//    NSString *str = @"garlic salt fossil broom vapor path then excuse catalog weather retreat floor hand gospel dice";
//    NSMutableArray *array = [str componentsSeparatedByString:@" "];
    
    NSMutableArray* wordList  = [NSMutableArray new];
    for (int i = 0; i<self.seedArr.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:self.seedArr[i] forKey:@"word"];
        [dic setValue:@"0" forKey:@"flag"];
        [wordList addObject:dic];
    }
    self.wordList = wordList;
    //    NSMutableArray* btnList = [NSMutableArray new];
    
    int i = 0;
    for(NSDictionary* sub in wordList) {
        //
        //        UIButton* t = nil;
        //
        //        t.titleLabel.text = sub[@"word"];
        //        t.tag = i++;
        
        
        
        NSString *name = sub[@"word"];
        static UIButton *recordBtn =nil;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn.layer.cornerRadius=15;
        //        btn.clipsToBounds=YES;
        
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 15;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        CGRect rect =  CGRectMake(0, 0, contentView.size.width/4-16, 30);
        if (i == 0)
            
        {
            btn.frame =CGRectMake(0, 8, rect.size.width, rect.size.height);
        }   else{
            CGFloat yuWidth = contentView.size.width - 24 -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= rect.size.width) {
                btn.frame =CGRectMake(recordBtn.frame.origin.x+8 +recordBtn.frame.size.width + 8, recordBtn.frame.origin.y, rect.size.width, rect.size.height);
            }else{
                btn.frame =CGRectMake(0, recordBtn.frame.origin.y+8+recordBtn.frame.size.height+0, rect.size.width, rect.size.height);
            }
        }
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentView addSubview:btn];
        recordBtn = btn;
        recordBtn.tag = i;
        [recordBtn addTarget:self action:@selector(wordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.wordBtnArray addObject:btn];
        i++;
    }
    [self.scrollView addSubview:contentView];
    
}
- (void)wordBtnClick:(id)sender {
    UIButton *btn = sender;
    
    if ([btn.accessibilityHint isEqualToString:@"1"]) {
        [btn setBackgroundColor:[UIColor colorWithHex:THEME_COLOR]];
        btn.enabled = NO;
    }
    
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.enabled = NO;
    NSInteger idx = btn.tag;
    NSMutableDictionary* sub = [self.wordList objectAtIndex:idx];
    [sub setValue:@"1" forKey:@"flag"];
    btn.accessibilityHint = [sub objectForKey:@"flag"];
    
    [self.btnList addObject:sub];
    ///拼接的arr 加数组
    [self.pinJieSeedArr addObject:[sub objectForKey:@"word"]];
    
    for (int i = 0; i<self.btnList.count; i++) {
        UIButton *topBtn = self.BtnArray[i];
        [topBtn setBackgroundColor:[UIColor whiteColor]];
    }
    //数据
    for (int i = 0; i<self.btnList.count; i++) {
        UIButton *topBtn = self.BtnArray[i];
        [topBtn setTitle:[self.btnList[i] objectForKey:@"word"] forState:UIControlStateNormal];
        [topBtn setBackgroundColor:[UIColor colorWithHex:BACKGROUND_COLOR]];
    }
    //如果存储的数据达到和seed 相同位数的话 判断正确和错误
    if (self.btnList.count == self.seedArr.count) {
        
        
        self.registerBtn.alpha = 1.f;
        self.registerBtn.enabled = YES;

        
        
    } else {
        if (self.registerBtn.enabled) {
            
            [self.registerBtn setEnabled:NO];
            self.registerBtn.alpha = 0.9;
        }
    }
    
}

-(void)listBtnClick:(id)sender {
    UIButton *btn = sender;
    
    if (btn.tag>=self.btnList.count) {
        return;
    }
    if (self.btnList.count == 0) {
        return;
    }
    
    // 数组元素的删除
    //删除的那个元素
    NSMutableDictionary *deletDic = [self.btnList objectAtIndex:btn.tag];
    [self.btnList removeObjectAtIndex:btn.tag];
    [self.pinJieSeedArr removeObjectAtIndex:btn.tag];
    
    //先把所有的给清空
    for (int i = 0; i<self.BtnArray.count; i++) {
        UIButton *topBtn = self.BtnArray[i];
        [topBtn setTitle:@"" forState:UIControlStateNormal];
        [topBtn setBackgroundColor:[UIColor whiteColor]];
    }
    
    //然后再复制
    for (int i = 0; i<self.btnList.count; i++) {
        UIButton *topBtn = self.BtnArray[i];
        [topBtn setTitle:[self.btnList[i] objectForKey:@"word"] forState:UIControlStateNormal];
        [topBtn setBackgroundColor:[UIColor colorWithHex:BACKGROUND_COLOR]];
    }
    
    for (int i = 0; i<self.wordBtnArray.count; i++) {
        UIButton *wordBtn = self.wordBtnArray[i];
        if ([wordBtn.titleLabel.text isEqualToString:[deletDic objectForKey:@"word"]]) {
            wordBtn.accessibilityHint = @"0";
        }
        if ([wordBtn.accessibilityHint isEqualToString:@"1"]) {
            [wordBtn setBackgroundColor:[UIColor orangeColor]];
            wordBtn.enabled = NO;
        } else {
            [wordBtn setBackgroundColor:[UIColor colorWithHex:BACKGROUND_COLOR]];
            wordBtn.enabled = YES;
            if (self.registerBtn.enabled) {
                
                [self.registerBtn setEnabled:NO];
                self.registerBtn.alpha = 0.9;
            }
            
        }
    }
    

}
- (NSMutableArray *)wordList
{
    if (!_wordList) {
        _wordList = [[NSMutableArray alloc] init];
    }
    return _wordList;
}
//btnList
- (NSMutableArray *)btnList
{
    if (!_btnList) {
        _btnList = [[NSMutableArray alloc] init];
    }
    return _btnList;
}
//wordBtnArray
- (NSMutableArray *)wordBtnArray
{
    if (!_wordBtnArray) {
        _wordBtnArray = [[NSMutableArray alloc] init];
    }
    return _wordBtnArray;
}
//BtnArray
- (NSMutableArray *)BtnArray
{
    if (!_BtnArray) {
        _BtnArray = [[NSMutableArray alloc] init];
    }
    return _BtnArray;
}
//seedArr
- (NSMutableArray *)seedArr
{
    if (!_seedArr) {
        _seedArr = [[NSMutableArray alloc] init];
    }
    return _seedArr;
}
//pinJieSeedArr
- (NSMutableArray *)pinJieSeedArr
{
    if (!_pinJieSeedArr) {
        _pinJieSeedArr = [[NSMutableArray alloc] init];
    }
    return _pinJieSeedArr;
}
//realSeedArr
- (NSMutableArray *)realSeedArr
{
    if (!_realSeedArr) {
        _realSeedArr = [[NSMutableArray alloc] init];
    }
    return _realSeedArr;
}
 -(NSArray *)randomArray
 {
 //随机数从这里边产生
// NSMutableArray *startArray=[[NSMutableArray alloc] initWithObjects:@0,@1,@2,@3,@4,@5,@6,@7, nil nil];
    NSMutableArray *startArray = [self.seed componentsSeparatedByString:@" "];
     self.realSeedArr = startArray;
//NSMutableArray *startArray=[[NSMutableArray alloc] initWithObjects:@0,@1,@2,@3,@4,@5,@6,@7, nil nil];

 //随机数产生结果
 NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
 //随机数个数
 NSInteger m=startArray.count;
 for (int i=0; i<m; i++) {
 int t=arc4random()%startArray.count;
 resultArray[i]=startArray[t];
 startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
 [startArray removeLastObject];
 }
 return resultArray;
 }

- (void)initBottom
{
    [self.registerBtn setFrame:CGRectMake(0, 0, WidthScale(339), 44)];
    [self.scrollView addSubview:self.registerBtn];
    
    id sender = [self.wordBtnArray lastObject];
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        [self.registerBtn setCenter:CGPointMake(KScreenW / 2, CGRectGetMaxY(_btnContentView.frame) + 77)];
    } else {
        
        [self.registerBtn setCenter:CGPointMake(KScreenW / 2, CGRectGetHeight(_btnContentView.frame) - 210)];
    }

    self.registerBtn.alpha = 0.9f;
    self.registerBtn.enabled = NO;
    
    
    if (![self.VerifySeed isEqualToString:@"1"]) {
        
        UIButton *skipBtn = [UIButton new];
        self.skipBtn = skipBtn;
        [skipBtn setTitle:NSLocalizedString(@"skip_verify", @"Skip") forState:UIControlStateNormal];
        //0197FF
        [skipBtn setTitleColor:[UIColor colorWithHex:0x0197FF] forState:UIControlStateNormal];
        [skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //75
        [skipBtn setFrame:CGRectMake(18, CGRectGetMaxY(self.registerBtn.frame)+16, 0, 44)];
        
        //    skipBtn set
        [self.scrollView addSubview:skipBtn];
        
        [skipBtn sizeToFit];
    }
    


    
    
    
    
    
    
    
//    [self.guideView setFrame:CGRectMake(0, CGRectGetMaxY(self.registerBtn.frame) + 90, KScreenW, 49)];
    [self.scrollView addSubview:self.guideView];
    [self.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.left.right.equalTo(self.scrollView);
        make.centerX.equalTo(self.scrollView);
        make.width.mas_equalTo(@(KScreenW));
        make.top.equalTo(self.registerBtn.mas_bottom).offset(90);
    }];
    [self.scrollView setNeedsLayout];
    [self.scrollView layoutIfNeeded];
    [self.scrollView setContentSize:CGSizeMake(KScreenW, CGRectGetMaxY(self.guideView.frame) + 100)];
    ///存在就说明是从界面进去验证的
//    if (self.VerifySeed) {
//        skipBtn.hidden = YES;
//        self.guideView.hidden = YES;
//    }
//
}
///跳过验证
-(void)skipBtnClick {
//    NSLog(@"123");
    LZRegistViewController *regist = [LZRegistViewController new];
    regist.type = self.type;
    regist.seed = self.seed;
    [self.navigationController pushViewController:regist animated:YES];
    
}

- (void)registerAction
{
    if ([self.pinJieSeedArr isEqualToArray:self.realSeedArr]) {
        
        if (self.VerifySeed) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            LZRegistViewController *regist = [LZRegistViewController new];
            regist.type = self.type;
            regist.seed = self.seed;
            [self.navigationController pushViewController:regist animated:YES];
            
        }

        
    } else {
        //助记词错误，请检查后重试
        [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"make_sure_seed_error_tip", nil) controller:self];
    }
}


@end
