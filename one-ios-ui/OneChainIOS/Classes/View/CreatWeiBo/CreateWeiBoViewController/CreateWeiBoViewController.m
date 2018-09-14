//
//  CreateWeiBoViewController.m
//  CancerDo
//
//  Created by hugaowei on 16/8/10.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "CreateWeiBoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImageManager.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LZSetChargeContentViewController.h"
#import "ONEGroupManager.h"

#define CREATE_WEIBO_TYPE_FEED      @"feed"// 文本
#define CREATE_WEIBO_TYPE_REPOST    @"repost"// 转发
#define CREATE_WEIBO_TYPE_IMAGE     @"image"// 图文混合
#define CREATE_WEIBO_TYPE_SHARE     @"share"// 分享
#define CREATE_WEIBO_TYPE_VIDEO     @"video"// 视频

#define MaxNumberOfImages 9



#define SEED_CONTENT_MIN_HEIGHT 119

//////
#define COL_OF_ROW 4
//#define SEED_WIDTH ((self.view.frame.size.width - 20 - 2 * 5) / 4)
#define SEED_WIDTH ((ScreenWidth-18 - 20 - 2 * 5) / 4)

#define SEED_CONTENT_MIN_HEIGHT 119
#define SEED_HEIGHT 25
#define KTIP_LBL_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:16.f]
#define KSEED_CONTENT_FRAME CGRectMake(WidthScale(10), 12, WidthScale(355), SEED_CONTENT_MIN_HEIGHT)
#define KSEARCHBAR_Y_PADDING 12
#define KSEARCHBAR_WIDTH WidthScale(339)
#define KSEARCHBAR_HEIGHT 35
#define KSEARCHBAR_CORNER 15.f
#define KLBL_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:12.f]
#define KLBL_COLOR RGBACOLOR(173, 173, 173, 1)
#define KTABLE_Y_PADDING 5
#define KRIGHTITEM_FRAME CGRectMake(0, 0, 60, 44)
#define KRIGHTITEM_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:14.f]
#define KSEED_NUM 24
#define SEARCH_RESULT_HEIGHT 60
#define KWIDTH_PADDING WidthScale(18)
#define KBOTTOM_BTN_LEFT_PADDING WidthScale(8)
#define KBOTTOM_BTN_TOP_PADDING 45
#define KBOTTOM_BTN_WIDTH WidthScale(138)
#define KBOTTOM_BTN_HEIGHT 37
#define KSEED_PADDING 2
#define KSEED_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:12.f]


@interface CreateWeiBoViewController()<UIActionSheetDelegate>
@property(nonatomic,strong)UILabel *guanjianciLabel;
@property(nonatomic,strong)UILabel *jiageLabel;

@property (nonatomic, strong) UIScrollView *seedContentView;
@property (nonatomic, strong) NSMutableArray *datasources;

@end


@implementation CreateWeiBoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = ColorWithRGB(239.0, 239.0, 244.0, 1);
    
    self.title = NSLocalizedString(@"release_invitation", @"发布帖子");
    ///屏蔽右边按钮
    
        [self.rightButton setFrame:CGRectMake(0, 0, 50, 24)];
        [self.rightButton setTitle:NSLocalizedString(@"publish", @"发布") forState:UIControlStateNormal];
        [self.rightButton setTitleColor:THMColor(@"common_text_color") forState:UIControlStateNormal];
        [self.rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    
        UIImage *image = [[UIImage imageNamed:@"selectedColor"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [self.rightButton setBackgroundImage:nil   forState:UIControlStateNormal];
        [self.rightButton setBackgroundImage:image forState:UIControlStateHighlighted];
    
    
    //    kScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-50)];
    
    
    
    kScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height+150)];
    
    
    [kScrollView setShowsVerticalScrollIndicator:NO];
    [kScrollView setShowsHorizontalScrollIndicator:NO];
    //    [kScrollView setContentSize:CGSizeMake(kScrollView.frame.size.width, kScrollView.frame.size.height+1)];
    [kScrollView setContentSize:CGSizeMake(kScrollView.frame.size.width, kScrollView.frame.size.height+150)];
    
    [kScrollView setBackgroundColor:[UIColor whiteColor]];
    [kScrollView setDelegate:self];
    [self.view addSubview:kScrollView];
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    tap.numberOfTapsRequired = 1;
    [kScrollView addGestureRecognizer:tap];
    
    mediaButtonView = [[MediaButtonView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, ScreenWidth, 50)];
    mediaButtonView.delegate = self;
    [self.view addSubview:mediaButtonView];
    /////////
    [self setupTopUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    isFristAppear = NO;
    
    NSString *filePathString = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/uploadVideo"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if ([fileManager fileExistsAtPath:filePathString isDirectory:&isDirectory]) {
        //        NSLog(@"%s === %d",__func__,[fileManager removeItemAtPath:filePathString error:nil]);
    }
    
    videoUploadAlertView = [[VideoUploadAlertView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    videoUploadAlertView.layer.cornerRadius = 20;
    videoUploadAlertView.layer.masksToBounds = YES;
    videoUploadAlertView.hidden = YES;
    //    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    //    [appDelegate.window addSubview:videoUploadAlertView];
    [self.view addSubview:videoUploadAlertView];
    videoUploadAlertView.center = self.view.center;
    
}
//点击
-(void)doTapChange:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
    [kScrollView endEditing:YES];
    
}
-(void)biaoTiTapChange:(UITapGestureRecognizer *)sender{
    
    LZSetChargeContentViewController *chargeVC = [LZSetChargeContentViewController new];
    chargeVC.isEquailRed = YES;
    chargeVC.sendchargeMsg = ^(NSString *chargeAsset_code, NSString *chargeCount, BOOL isOpen) {
        if (isOpen == NO || chargeAsset_code.length<= 0 ||chargeCount.length<=0) {
            self.jiageLabel.text = @"";
        } else {
            
            NSDictionary *infoDic = [[ONEChatClient sharedClient] assetShowInfoFromAssetCode:chargeAsset_code];
            NSString *short_name = [infoDic objectForKey:@"name"];
            
            NSString *pinjieStr = [NSString stringWithFormat:@"%@%@",chargeCount,short_name];
            
            CGSize size = [self sizeWithText: pinjieStr font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            [self.jiageLabel setFrame:CGRectMake(KScreenW-24-size.width, 12, size.width, size.height)];
            self.jiageLabel.text = pinjieStr;
            
        }
        
        
        
    };
    [self.navigationController pushViewController:chargeVC animated:YES];
    
}

- (NSMutableArray *)datasources
{
    if (!_datasources) {
        
        _datasources = [NSMutableArray array];
    }
    return _datasources;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(void)setupTopUI {
    UIView *biaotiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47)];
    //    [biaotiView setBackgroundColor:[UIColor greenColor]];
    [kScrollView addSubview:biaotiView];
    // 设置收费内容 set_charge_content
    UILabel *biaoTiLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:BIAOTICOLOR] andTextFont:16 andContentText:NSLocalizedString(@"setting_charge_content", nil)];
    [biaoTiLabel setFrame:CGRectMake(18, 12, 67, 20)];
    [biaoTiLabel sizeToFit];
    [biaotiView addSubview:biaoTiLabel];
    
    UILabel *jiageLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:BORDER_COLOR] andTextFont:TWELFTH_FRONT andContentText:@""];
    [jiageLabel setFrame:CGRectMake(WidthScale(280), 14, 20, 17)];
    self.jiageLabel = jiageLabel;
    
    [jiageLabel sizeToFit];
    [biaotiView addSubview:jiageLabel];
    //    CGSize size = [self sizeWithText: @"此处是测试字体" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightenter"]];
    [rightImg setFrame:CGRectMake(WidthScale(355), 12, 8, 15)];
    [biaotiView addSubview:rightImg];
    UIImageView *underLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underline"]];
    [underLine setFrame:CGRectMake(0, 47, KScreenW, 1)];
    [kScrollView addSubview:underLine];
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(biaoTiTapChange:)];
    tap.numberOfTapsRequired = 1;
    [biaotiView addGestureRecognizer:tap];
    
    
    //NSLocalizedString(@"write_content", nil)
    UILabel *tipLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:BIAOTICOLOR] andTextFont:16 andContentText:NSLocalizedString(@"input_content", nil)];
    [tipLabel setFrame:CGRectMake(18, CGRectGetMaxY(biaotiView.frame)+12, 10, 10)];
    [tipLabel sizeToFit];
    [kScrollView addSubview:tipLabel];
    
    
    kTextView = [[kUITextView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(tipLabel.frame), ScreenWidth-16, 40)];
    //    kTextView.backgroundColor = [UIColor redColor];
    kTextView.delegate = self;
    kTextView.placeHolderString = NSLocalizedString(@"no_sensitive_character", @"禁止出现敏感字符。");
    kTextView.backgroundImageView.image = nil;
    [kScrollView addSubview:kTextView];
    
    weiBoImagesView = [[WeiBoImagesView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(kTextView.frame)+2, ScreenWidth, 0)];
    weiBoImagesView.delegate = self;
    [weiBoImagesView setBackgroundColor:[UIColor whiteColor]];
    [kScrollView addSubview:weiBoImagesView];
    
    guanjianZiView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weiBoImagesView.frame)+2, ScreenWidth, 200)];
    //    [guanjianZiView setBackgroundColor:[UIColor greenColor]];
    [kScrollView addSubview:guanjianZiView];
    ///关键词
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, 15, 19, 19)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"article_add_key"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [guanjianZiView addSubview:addBtn];
    
    UILabel *guanjianciLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:BTN_BACKGROUNDCOLOR] andTextFont:16 andContentText:NSLocalizedString(@"key_word", nil)];
    self.guanjianciLabel = guanjianciLabel;
    
    [guanjianciLabel setFrame:CGRectMake(CGRectGetMaxX(addBtn.frame), 10+5, 50, 20)];
    guanjianciLabel.userInteractionEnabled = YES;
    [guanjianciLabel sizeToFit];
    [guanjianZiView addSubview:guanjianciLabel];
    
    UITapGestureRecognizer *tapgeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBtnClick)];
    tap.numberOfTapsRequired = 1;
    [guanjianciLabel addGestureRecognizer:tapgeture];
    
    
    
    ///
    _seedContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(self.guanjianciLabel.frame)+2, KScreenW-36, SEED_CONTENT_MIN_HEIGHT)];
    
    _seedContentView.layer.cornerRadius = 2;

    _seedContentView.layer.masksToBounds = YES;
    _seedContentView.backgroundColor = [UIColor whiteColor];
    [guanjianZiView addSubview:self.seedContentView];
    
}
- (void)refreshSeedContent
{
    
    [self.seedContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int tmp = ([self.datasources count] + 1) % COL_OF_ROW;
    int row = (int)([self.datasources count] + 1) / COL_OF_ROW;
    row += tmp == 0 ? 0 : 1;
    CGFloat contentHeight = row * (SEED_HEIGHT + KSEED_PADDING ) + 2*KSEED_PADDING + 45 > SEED_CONTENT_MIN_HEIGHT ? row * (SEED_HEIGHT + KSEED_PADDING ) + 2*KSEED_PADDING + 45 : SEED_CONTENT_MIN_HEIGHT;
    self.seedContentView.frame = CGRectMake(18, CGRectGetMaxY(self.guanjianciLabel.frame), KScreenW-36, contentHeight);
    self.seedContentView.contentSize = CGSizeMake(self.seedContentView.frame.size.width, contentHeight);
    
    //    [self refreshView];
    
    if (self.datasources.count == 0) {
        
        //        [self.seedContentView addSubview:self.lbl];
        //        [self.lbl setFrame:CGRectMake(WidthScale(8), 8, CGRectGetWidth(self.seedContentView.frame), 17)];
        //
        //        [self addBottomButton];
        return;
    }
    int i = 0;
    int j = 0;
    for (i = 0; i < row; i++) {
        
        for (j = 0; j < COL_OF_ROW; j++) {
            
            NSInteger index = i * COL_OF_ROW + j;
            
            if (index < self.datasources.count) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(j * (SEED_WIDTH + KSEED_PADDING) + 2, i * (SEED_HEIGHT + KSEED_PADDING) + 2, SEED_WIDTH, SEED_HEIGHT)];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor colorWithHex:THEME_COLOR]];
                button.layer.cornerRadius = 10.f;
                button.layer.masksToBounds = YES;
                button.tag = index;
                button.titleLabel.font = KSEED_FONT;
                [button setTitle:[self.datasources objectAtIndex:index] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(seedClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.seedContentView addSubview:button];
            }
        }
    }
}
- (void)seedClicked:(UIButton *)sender
{
    NSInteger index = sender.tag;
    [self.datasources removeObjectAtIndex:index];
    [self refreshSeedContent];
    
    //    if (self.datasources.count < KSEED_NUM) {
    //
    ////        [self showSearch];
    //    }
}
-(void)addBtnClick{
    //write_key_word
    [[UIAlertController shareAlertController] showTextFeildWithTitle:NSLocalizedString(@"write_key_word", nil) andMsg:@"" andLeftBtnStr:@"" andRightBtnStr:@"" andRightBlock:^(NSString *str) {
        if (!str||str.length<=0) {
            return;
        }
        if (self.datasources.count>=10) {
            //max_key_word
            [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"max_key_word", nil) controller:self];
            return;
        }
        [self.datasources addObject:str];
        [self refreshSeedContent];
    } controller:self];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (weiBoImagesView.imagesArray.count < 1 &&
        weiBoImagesView.videoPathString.length < 1 &&
        kTextView.kTextView.text.length < 1) {
    }
    
    [kTextView.kTextView becomeFirstResponder];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    

    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
#pragma mark 发布按钮点击
-(void)weiboFaBuClick {
    //    rightBarButtonAction
    
    if (kTextView.kTextView.text.length < 1 && weiBoImagesView.imagesArray.count < 1 && weiBoImagesView.videoPathString.length < 1) {
        [MTool showWrongAlertViewWithMessage:NSLocalizedString(@"there_is_no_content", @"你未填写内容") viewController:self];
        return;
    }
    
    if ([kTextView.kTextView isFirstResponder]) {
        [kTextView.kTextView resignFirstResponder];
    }
    
    NSString *videoPath = [NSString stringWithFormat:@"%@",weiBoImagesView.videoPathString];
    if (videoPath == nil || [videoPath isBlankString]) {
        videoPath = @"";
    }
    
    if (videoPath.length > 0) {// ------------  视频
        videoUploadAlertView.hidden = NO;
        [self uploadVideoToAiDuServer];
        
    }else{// ---------------------------------  文字   文字+图片
        videoUploadAlertView.hidden = YES;
        NSInteger count = 0;
        if (weiBoImagesView.imagesArray.count > 0) {
            count = weiBoImagesView.imagesArray.count;
        }
        
        if (count > 0 && kTextView.kTextView.text.length < 1) {
            [MTool showWrongAlertViewWithMessage:NSLocalizedString(@"there_is_no_content", @"你未填写内容") viewController:self];
            return;
        }
        
        NSString *weiBoType = @"";
        if (count > 0) {
            weiBoType = CREATE_WEIBO_TYPE_IMAGE;
        }else{
            weiBoType = CREATE_WEIBO_TYPE_FEED;
        }
        
        NSString *typeStr = @"upfile[]";
        NSString *videoPath = @"";
        NSMutableDictionary *extDict = [[NSMutableDictionary alloc] init];
        [extDict setObject:typeStr forKey:@"type"];
        [extDict setObject:videoPath forKey:@"path"];
        [self showHudInView:self.view hint:@""];
        [self createWeiBoWithType:weiBoType
                      withVideoID:@""
                          extDict:extDict
                  withImagesArray:weiBoImagesView.imagesArray];
    }
    
}
#pragma mark 相册选择图片
- (void)weiBoGetPictureFromPhotoList{
    
    if (weiBoImagesView.imagesArray.count < 1 && weiBoImagesView.videoPathString.length > 0) {
        [MTool showWrongAlertViewWithMessage:NSLocalizedString(@"can_not_choose_picture", @"无法选择图片") viewController:self];
        return;
    }
    
    [kTextView.kTextView resignFirstResponder];
    if (weiBoImagesView.imagesArray.count >= MaxNumberOfImages) {
        [MTool showWrongAlertViewWithMessage:NSLocalizedString(@"max_picture_nine", @"最多选择9张图片") viewController:self];
        return;
    }
    //button_cancel
//    NSLocalizedString(@"attach_take_pic", @"拍照");
//    NSLocalizedString(@"according_photo_album", @"从相册选取")
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"button_cancel", @"取消") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"attach_take_pic", @"拍照"),NSLocalizedString(@"according_photo_album", @"从相册选取"), nil];
    actionSheet.tag = 2000;
    [actionSheet showInView:self.view];
}

#pragma mark 选择视频
- (void)weiboGetVideoFromVideoList{
    
    if (weiBoImagesView.imagesArray.count > 0) {
        [MTool showWrongAlertViewWithMessage:NSLocalizedString(@"can_not_choose_video", @"无法选择视频") viewController:self];
        return;
    }
    
    mediaType = MEDIA_TYPE_VIDEO;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;  //是否可编辑
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie ,nil];
    imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark KImagePickerControllerDelegate
- (void)kImagePickerControllerDidCancel:(KImagePickerController*)pickerController{
    [pickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark KImagePickerControllerDelegate 从相册获取的相册
- (void)imagePickerController:(KImagePickerController*)pickerController didFinishPickingAssets:(NSArray*)assetsArray{
    
    //    [MTool showNetworkingWaitingViewWithTitle:@""];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i < assetsArray.count; i++) {
            ALAsset *asset = [assetsArray objectAtIndex:i];
            ALAssetRepresentation* representation = [asset defaultRepresentation];
            
            UIImage *image = [UIImage imageWithCGImage:representation.fullResolutionImage scale:1.0 orientation:(UIImageOrientation)representation.orientation];
            
            //            image = [[ImageManager sharedImageManager] rotationImage:image];
            image = [[ImageManager sharedImageManager] imageWithOriginImage:image withSize:CGSizeMake(ScreenWidth, ScreenHeight)];
            NoteImageModel *imageModel = [[NoteImageModel alloc] init];
            imageModel.image     = image;
            imageModel.imagePath = @"";
            imageModel.index     = weiBoImagesView.imagesArray.count + 1001 + i;
            
            [weiBoImagesView.imagesArray addObject:imageModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MTool networkingWaitingViewHidden];
            [weiBoImagesView reloadImages];
            [self checkVideoStringLength];
        });
    });
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [pickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 拍照
- (void)weiBoGetPictureFromCamera{
    [kTextView.kTextView resignFirstResponder];
    
    if (weiBoImagesView.imagesArray.count >= MaxNumberOfImages) {
        [MTool showWrongAlertViewWithMessage:NSLocalizedString(@"max_picture_nine", @"最多选择9张图片") viewController:self];
        return;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 2000) {
        if (buttonIndex == 0) {
            [self getImagesFromCamera];
        }else if (buttonIndex == 1){
            [self getImagesFromPhotoList];
        }
    }
}

- (void)getImagesFromPhotoList{
    KImagePickerController *pickerController = [[KImagePickerController alloc] init];
    pickerController.showsCancleButton = YES;
    pickerController.selectPhotoAndVideo = YES;
    pickerController.maximumNumberOfSelection = MaxNumberOfImages - weiBoImagesView.imagesArray.count;
    pickerController.kDelegate = self;
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
}

- (void)getImagesFromCamera{
    mediaType = MEDIA_TYPE_IMAGE;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;  //是否可编辑
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 拍照获取的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (mediaType == MEDIA_TYPE_VIDEO) {
        //        [MTool showNetworkingWaitingViewWithTitle:@""];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (mediaType == MEDIA_TYPE_IMAGE) {
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            //        image = [[ImageManager sharedImageManager] rotationImage:image];
            image = [[ImageManager sharedImageManager] imageWithOriginImage:image withSize:CGSizeMake(ScreenWidth, ScreenHeight)];
            NoteImageModel *imageModel = [[NoteImageModel alloc] init];
            imageModel.image     = image;
            imageModel.imagePath = @"";
            imageModel.index     = weiBoImagesView.imagesArray.count + 1001;
            [weiBoImagesView.imagesArray addObject:imageModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weiBoImagesView reloadImages];
                [self checkVideoStringLength];
            });
        }
        
        if (mediaType == MEDIA_TYPE_VIDEO) {
            NSString *mType = [info objectForKey:UIImagePickerControllerMediaType];
            if ([mType isEqualToString:(NSString*)kUTTypeMovie]) {
                NSURL *videoURL = [info objectForKey:UIImagePickerControllerReferenceURL];
                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                [self removeVideoCache];
                AVAsset *avasset = [AVAsset assetWithURL:videoURL];
                int64_t value = avasset.duration.value;
                CGFloat timeScale = (CGFloat)avasset.duration.timescale;
                
                weiBoImagesView.duration = value/timeScale;
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if (videoURL) {
                        [assetsLibrary assetForURL:videoURL
                                       resultBlock:^(ALAsset *asset) {
                                           ALAssetRepresentation *rep = [asset defaultRepresentation];
                                           NSLog(@"rep.filename === %@",rep.filename);
                                           NSString *filePathString = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/uploadVideo"];
                                           
                                           NSString *repFileName = [NSString stringWithFormat:@"%@",rep.filename];
                                           NSLog(@"repFileName.pathExtension === %@",repFileName.pathExtension);
                                           
                                           NSString *currentDateStr = [self currentDateStringWithSuffix:repFileName.pathExtension];
                                           NSString *filePath = [NSString stringWithFormat:@"%@/%@",filePathString,currentDateStr];
                                           NSLog(@"filePath ==== %@",filePath);
                                           
                                           NSFileManager *fileManager = [NSFileManager defaultManager];
                                           
                                           BOOL ieDirectory;
                                           if (![fileManager fileExistsAtPath:filePathString isDirectory:&ieDirectory]) {
                                               [fileManager createDirectoryAtPath:filePathString withIntermediateDirectories:YES attributes:nil error:nil];
                                           }
                                           
                                           const char * videoCharPath = [filePath UTF8String];
                                           FILE *file = fopen(videoCharPath, "a+");
                                           if (file) {
                                               const int bufferSize = 1024*1024;
                                               
                                               Byte *buffer = (Byte*)malloc(bufferSize);
                                               NSUInteger read = 0,offset = 0,written = 0;
                                               NSError *err = nil;
                                               if (rep.size != 0) {
                                                   do {
                                                       read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                                                       written = fwrite(buffer, sizeof(char), read, file);
                                                       offset += read;
                                                   } while (read != 0 && !err);
                                               }
                                               
                                               free(buffer);
                                               buffer = NULL;
                                               fclose(file);
                                               file = NULL;
                                           }
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [MTool networkingWaitingViewHidden];
                                               weiBoImagesView.videoPathString = filePath;
                                               [self checkVideoStringLength];
                                           });
                                       }
                                      failureBlock:^(NSError *error) {
                                          [MTool networkingWaitingViewHidden];
                                          weiBoImagesView.videoPathString = @"";
                                          [self checkVideoStringLength];
                                      }];
                    }
                });
            }
        }
    });
}


- (NSString*)currentDateStringWithSuffix:(NSString*)suffix{
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSInteger timeS = (NSInteger)(time*1000);
    return [NSString stringWithFormat:@"%ld.%@",(long)timeS,suffix];
}

#pragma mark 重新计算frame
- (void)superViewReload{
    CGFloat originY = weiBoImagesView.frame.size.height;
    CGFloat height  = ScreenHeight - originY - kTextView.frame.origin.y;
    [UIView animateWithDuration:0.25 animations:^{
        kTextView.frame = CGRectMake(kTextView.frame.origin.x, kTextView.frame.origin.y, kTextView.frame.size.width, height);
    }];
}

#pragma mark 弹出键盘
- (void)keyBoardWillShow:(NSNotification*)info{
    NSDictionary *dict  = [info userInfo];
    NSValue *frameValue = [dict objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect frame        = [frameValue CGRectValue];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat originY = 0;
        if (IS_IPHONE_X) {
        originY = frame.origin.y - mediaButtonView.frame.size.height-80;

        } else {
        originY = frame.origin.y - mediaButtonView.frame.size.height-64 ;
        }
//        CGFloat originY = frame.origin.y - mediaButtonView.frame.size.height-64 ;
        mediaButtonView.frame = CGRectMake(0, originY, ScreenWidth, mediaButtonView.frame.size.height);
        kScrollView.frame = CGRectMake(0, 0, ScreenWidth, mediaButtonView.frame.origin.y);
        [self setKscrollViewContentSize];
    }];
}

- (void)setKscrollViewContentSize{
    //    CGFloat height = CGRectGetMaxY(weiBoImagesView.frame);
    //    if (height < kScrollView.frame.size.height) {
    //        height = kScrollView.frame.size.height + 1;
    //    }
    //    [kScrollView setContentSize:CGSizeMake(kScrollView.frame.size.width, height)];
    
    //    CGFloat height = CGRectGetMaxY(weiBoImagesView.frame);
    //    if (height < kScrollView.frame.size.height) {
    //        height = kScrollView.frame.size.height + 1;
    //    }
    [kScrollView setContentSize:CGSizeMake(kScrollView.frame.size.width, ScreenHeight+150)];
}

#pragma mark 隐藏键盘
- (void)keyBoardWillHidden:(NSNotification*)infor{
    [weiBoImagesView reloadImages];
    
    [UIView animateWithDuration:0.25 animations:^{
        mediaButtonView.frame = CGRectMake(0, self.view.frame.size.height- mediaButtonView.frame.size.height, ScreenWidth, mediaButtonView.frame.size.height);
        kScrollView.frame = CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height- mediaButtonView.frame.size.height);
        [self setKscrollViewContentSize];
    }];
}


- (void)rightBarButtonAction:(UIButton *)btn{
    
    if (kTextView.kTextView.text.length < 1 && weiBoImagesView.imagesArray.count < 1 && weiBoImagesView.videoPathString.length < 1) {
        [MTool showWrongAlertViewWithMessage:NSLocalizedString(@"there_is_no_content", @"你未填写内容") viewController:self];
        return;
    }
    
    if ([kTextView.kTextView isFirstResponder]) {
        [kTextView.kTextView resignFirstResponder];
    }
    
    NSString *videoPath = [NSString stringWithFormat:@"%@",weiBoImagesView.videoPathString];
    if (videoPath == nil || [videoPath isBlankString]) {
        videoPath = @"";
    }
    
    if (videoPath.length > 0) {// ------------  视频
        videoUploadAlertView.hidden = NO;
        [self uploadVideoToAiDuServer];
        
    }else{// ---------------------------------  文字   文字+图片
        videoUploadAlertView.hidden = YES;
        NSInteger count = 0;
        if (weiBoImagesView.imagesArray.count > 0) {
            count = weiBoImagesView.imagesArray.count;
        }
        
        if (count > 0 && kTextView.kTextView.text.length < 1) {
            [MTool showWrongAlertViewWithMessage:NSLocalizedString(@"there_is_no_content", @"你未填写内容") viewController:self];
            return;
        }
        
        ArticleType weiBoType = -1;
        if (count > 0) {
            weiBoType = ArticleTypeImage;
        }else{
            weiBoType = ArticleTypeFeed;
        }
        
        NSString *typeStr = @"upfile[]";
        NSString *videoPath = @"";
        NSMutableDictionary *extDict = [[NSMutableDictionary alloc] init];
        [extDict setObject:typeStr forKey:@"type"];
        [extDict setObject:videoPath forKey:@"path"];
        
        [self createWeiBoWithType:weiBoType
                      withVideoID:@""
                          extDict:extDict
                  withImagesArray:weiBoImagesView.imagesArray];
    }
}

#pragma mark 上传视频
- (void)createWeiBoWithType:(ArticleType)weiBoType withVideoID:(NSString*)videoID extDict:(NSDictionary*)extDict withImagesArray:(NSArray*)imagesArray{
    
    
    ONECreateArticleModel *model = [[ONECreateArticleModel alloc] init];
    model.type = weiBoType;
    NSString *content = @"";
    if (kTextView.kTextView.text.length > 0) {
        content = [NSString stringWithFormat:@"%@",kTextView.kTextView.text];
    }

    model.content = content;
    model.groupId = [ONEGroupManager sharedInstance].groupId;
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic = [self addChargeInfoWith:mDic];
    model.isFree = [mDic[@"is_pay"] isEqualToString:@"1"] ? NO : YES;
    if (!model.isFree) {
        NSString *asscode = mDic[@"asset_code"];
        if ([asscode length] > 0) {
            model.asset_code = asscode;
        }
        
        NSString *amount = mDic[@"reward_price"];
        if ([amount length] > 0) {
            model.price = amount;
        }
    }
    NSMutableArray *images = [NSMutableArray array];
    for (NoteImageModel *imgModel in imagesArray) {
        if (imgModel.image) {
            [images addObject:imgModel.image];
        }
    }
    model.imageList = [images copy];
    if (self.datasources.count>0) {
        model.keywords = [self.datasources copy];
    }
    [self showHudInView:self.view hint:nil];
    [[ONEChatClient sharedClient] createArticle:model progressBlock:^(NSProgress * _Nonnull progress) {
       
    } completion:^(ONEError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self hideHud];
            if (!error) {
                [self showHint:NSLocalizedString(@"setting.uploadSuccess", @"Success")];
                [self performSelector:@selector(backForward:) withObject:nil afterDelay:1.8];
            } else {
                if (error.errorCode == ONEErrorContentTooShort) {
                    [self showHint:NSLocalizedString(@"content_too_short", @"内容太短")];
                } else if (error.errorCode == ONEErrorContentTooLong) {
                    [self showHint:NSLocalizedString(@"content_too_long", @"内容超过最大限度")];
                } else {
                    [self showHint:NSLocalizedString(@"setting.uploadFail", @"上传失败")];
                }
            }
        });
    }];
    
    
    
}

-(NSMutableDictionary *)addChargeInfoWith:(NSMutableDictionary *)dic {
    if (![CoinInfoMngr sharedCoinInfoMngr].isOpen || [CoinInfoMngr sharedCoinInfoMngr].isOpen == NO) {
        ////0是不收费
        [dic setObject:@"0" forKey:@"is_pay"];
    } else {
        ///收费
        [dic setObject:@"1" forKey:@"is_pay"];
    }
    if (![CoinInfoMngr sharedCoinInfoMngr].chargeAsset_code||[CoinInfoMngr sharedCoinInfoMngr].chargeAsset_code.length<=0) {
        ///这个时候说明不存在
    } else{
        ///存在
        [dic setObject:[CoinInfoMngr sharedCoinInfoMngr].chargeAsset_code forKey:@"asset_code"];
    }
    if (![CoinInfoMngr sharedCoinInfoMngr].chargeCount||[CoinInfoMngr sharedCoinInfoMngr].chargeAsset_code.length<=0) {
        ///不存在
    } else{
        [dic setObject:[CoinInfoMngr sharedCoinInfoMngr].chargeCount forKey:@"reward_price"];
    }
    return dic;
}

- (void)destroyRequest{
    [[ONEChatClient sharedClient] clearUploadTasks];
}

- (void)backForward:(id)sender{
    
    if ([kTextView.kTextView isFirstResponder]) {
        [kTextView.kTextView resignFirstResponder];
    }
    
    [self removeVideoCache];
    ///清除缓存
    [CoinInfoMngr sharedCoinInfoMngr].chargeAsset_code = nil;
    [CoinInfoMngr sharedCoinInfoMngr].chargeCount = nil;
    [CoinInfoMngr sharedCoinInfoMngr].isOpen = NO;
    !_needRefreshBlock ?: _needRefreshBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark 字数发生改变 调节各视图的frame
- (void)kTextViewDidChange:(NSString *)inputString{
    
    CGFloat originY = mediaButtonView.frame.origin.y;
    CGFloat y = kScrollView.frame.origin.y+kTextView.frame.origin.y+kTextView.kTextView.frame.origin.y;
    CGSize size = [kTextView.kTextView sizeThatFits:CGSizeMake(kTextView.kTextView.frame.size.width, (originY - y - 64))];// 64是个迷惑数字
    CGFloat height = size.height;
    if (height >= (originY - y - 64)) {
        height = originY - y - 64;
    }
    
    kTextView.kTextView.frame = CGRectMake(kTextView.kTextView.frame.origin.x, kTextView.kTextView.frame.origin.y, kTextView.kTextView.frame.size.height, height);
    kTextView.frame = CGRectMake(kTextView.frame.origin.x, kTextView.frame.origin.y, kTextView.frame.size.width, height);
    weiBoImagesView.frame = CGRectMake(weiBoImagesView.frame.origin.x, CGRectGetMaxY(kTextView.frame)+2, weiBoImagesView.frame.size.width, weiBoImagesView.frame.size.height);
    guanjianZiView.frame = CGRectMake(guanjianZiView.frame.origin.x, CGRectGetMaxY(weiBoImagesView.frame)+2, guanjianZiView.frame.size.width, guanjianZiView.frame.size.height);
    
    [self setKscrollViewContentSize];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == kScrollView) {
        if ([kTextView.kTextView isFirstResponder]) {
            [kTextView.kTextView resignFirstResponder];
        }
    }
}

#pragma mark
- (void)gotoBack:(UIButton *)btn{
    
    if (kTextView.kTextView.text.length > 0 ||
        weiBoImagesView.imagesArray.count > 0 ||
        weiBoImagesView.videoPathString.length > 0) {
//        NSLocalizedString(@"button_ok", @"确定");
//        NSLocalizedString(@"button_cancel", @"取消")
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"is_sure_to_forgive_this", @"确定放弃当前编辑吗？") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"button_ok", @"确定"),NSLocalizedString(@"button_cancel", @"取消"), nil];
        [UIView appearance].tintColor = SystemDefaultColor;
        alertView.tag = 2002;
        [alertView show];
        return;
    }

    
    [self backForward:nil];
}

#pragma mark
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2002) {
        if ([kTextView.kTextView isFirstResponder]) {
            [kTextView.kTextView resignFirstResponder];
        }
        if (buttonIndex == 0) {
            [self performSelector:@selector(backForward:) withObject:nil afterDelay:0.1];
        }
    }
}

- (void)removeVideoCache{
    if (weiBoImagesView.videoPathString.length > 0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:weiBoImagesView.videoPathString]) {
            [fileManager removeItemAtPath:weiBoImagesView.videoPathString error:nil];
        }
    }
    [self destroyRequest];
}

#pragma mark 
- (void)playVideoWithURL:(NSString *)urlStr{
    
    AiDuPlayerViewController *playerVC = [[AiDuPlayerViewController alloc] init];
    playerVC.videoURL = [NSString stringWithFormat:@"%@",urlStr];
    playerVC.nickName = @"123";
    YKPlayNaviController *nav = [[YKPlayNaviController alloc] initWithRootViewController:playerVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

- (void)checkVideoStringLength{
    if (weiBoImagesView.videoPathString.length > 0) {
        kTextView.placeHolderString = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"please_write_video_introduce", @"请填写视频介绍"),NSLocalizedString(@"weibo_video_max_tip", @"")];
        ;
    }else{
        kTextView.placeHolderString = @"";
    }
}

- (void)deleteVideo{
    [self checkVideoStringLength];
}


#pragma mark 上传视频到癌度服务器
- (void)uploadVideoToAiDuServer{
    
    
    ONECreateArticleModel *model = [[ONECreateArticleModel alloc] init];
    model.type = ArticleTypeVideo;
    model.videoPath = weiBoImagesView.videoPathString;
    model.videoThumbImage = weiBoImagesView.thumbImage;
    NSString *content = @"";
    if (kTextView.kTextView.text.length > 0) {
        content = [NSString stringWithFormat:@"%@",kTextView.kTextView.text];
    }

    model.content = content;
    
    model.groupId = [ONEGroupManager sharedInstance].groupId;
    
    if (self.datasources.count>0) {
        model.keywords = self.datasources;
    }
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    mDic = [self addChargeInfoWith:mDic];
//    model.isFree = [mDic[@"is_pay"] integerValue];
    model.isFree = [mDic[@"is_pay"] isEqualToString:@"1"] ? NO : YES;

    if (!model.isFree) {
        NSString *asscode = mDic[@"asset_code"];
        if ([asscode length] > 0) {
            model.asset_code = asscode;
        }
        
        NSString *amount = mDic[@"reward_price"];
        if ([amount length] > 0) {
            model.price = amount;
        }
    }
    kWeakSelf
    [[ONEChatClient sharedClient] createArticle:model progressBlock:^(NSProgress * _Nonnull progress) {
        
        [weakself uploadVideoWithProgress:progress withURLString:nil];
    } completion:^(ONEError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [videoUploadAlertView setHidden:YES];
            if (!error) {
                [weakself performSelector:@selector(backForward:) withObject:nil afterDelay:1];
            } else {
                [weakself hideHud];
                [weakself showHint:NSLocalizedString(@"setting.uploadFail", @"Fail")];
                
            }
        });
    }];
}

- (void)uploadVideoWithProgress:(NSProgress *)progress withURLString:(NSString *)urlStr
{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            double total    = (double)progress.totalUnitCount;
            double complete = (double)progress.completedUnitCount;

            CGFloat current = (CGFloat)(complete/total);

            NSLog(@"complete ===== %lf",complete);
            NSLog(@"total ======== %lf",total);
            NSLog(@"current ====== %lf",current);
            videoUploadAlertView.progressValue = current;

        });
}




- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self destroyRequest];
    
    if (videoUploadAlertView && videoUploadAlertView.superview) {
        [videoUploadAlertView removeFromSuperview];
    }
    
}
@end
