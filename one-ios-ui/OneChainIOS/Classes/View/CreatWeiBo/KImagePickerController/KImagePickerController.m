//
//  KImagePickerController.m
//  CancerDo
//
//  Created by hugaowei on 16/6/13.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "KImagePickerController.h"

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define kThumbnailLength ((ScreenWidth-25)/4.0)//78.0f
#define kThumbnailSize CGSizeMake(kThumbnailLength,kThumbnailLength)
#define kPopovercontentSize CGSizeMake(320,480)

@interface KImagePickerController ()

@end

#pragma mark ************************************************* KAssetsGroupViewController
@interface KAssetsGroupViewController : UITableViewController

@end

@interface KAssetsGroupViewController()

@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic,strong) NSMutableArray *groups;

@end

#pragma mark ************************************************* KAssetsViewController
@interface KAssetsViewController : UICollectionViewController

@property (nonatomic,strong) ALAssetsGroup *assetsGroup;

@property (nonatomic,strong) NSMutableArray *assets;
@property (nonatomic,assign) NSInteger numberOfPhotos;
@property (nonatomic,assign) NSInteger numberOfVideos;

@property (nonatomic,retain) NSMutableArray *selectedAssets;

@end

#pragma mark ************************************************* KAssetsGroupViewCell
@interface KAssetsGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end

@interface KAssetsGroupViewCell()

@property (nonatomic,strong) ALAssetsGroup *assetsGroup;

@end

#pragma mark  ************************************************* KAssetsViewCell
@interface KAssetsViewCell : UICollectionViewCell

- (void)bind:(ALAsset*)asset;

@end

@interface KAssetsViewCell ()

@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy  ) NSString *type;
@property (nonatomic,copy  ) NSString *title;
@property (nonatomic,strong) UIImage *videoImage;

@end


#pragma mark ************************************************* KAssetsSupplementaryView
@interface KAssetsSupplementaryView : UICollectionReusableView

@property (nonatomic,strong) UILabel *sectionLabel;

- (void)setNumberOfPhotos:(NSInteger)numberOfPhotos numberOfVideos:(NSInteger)numberOfVideo;

@end

@interface KAssetsSupplementaryView()

@end

#pragma mark ********************** KimagePickerController @implementation
@implementation KImagePickerController

- (id)init{
    KAssetsGroupViewController *groupViewController = [[KAssetsGroupViewController alloc] init];
    if (self = [super initWithRootViewController:groupViewController]) {
        _maximumNumberOfSelection = NSIntegerMax;
        _assetsFilter             = [ALAssetsFilter allAssets];
        _showsCancleButton        = YES;
        
        self.preferredContentSize = kPopovercontentSize;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    UIImage *image = [[UIImage imageNamed:@"imagePickNav"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = YES;
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, /*[MTool navigationBarTitleFont], NSFontAttributeName, */nil];
    [self.navigationBar setTitleTextAttributes:textAttributes];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end


#pragma mark ********************** KAssetsGroupViewController
@implementation KAssetsGroupViewController

- (id)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.preferredContentSize = kPopovercontentSize;
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"相簿";
    self.tableView.rowHeight = kThumbnailLength;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupNaviBarButton];
    
    [self prepareDataSource];
}

- (void)setupNaviBarButton{
    KImagePickerController *pickerController = (KImagePickerController*)[self navigationController];
    if (pickerController && pickerController.showsCancleButton) {
        
        UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        
        [cancleButton setTitleColor:ColorWithRGB(255.0f, 255.0f, 255.0f, 1) forState:UIControlStateNormal];
        [cancleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        cancleButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [cancleButton setExclusiveTouch:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancleButton];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark
- (void)prepareDataSource{
    if (![self assetsLibrary]) {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    if (!self.groups) {
        self.groups = [[NSMutableArray alloc] init];
    }else{
        [self.groups removeAllObjects];
    }
    
    KImagePickerController *pickerController = (KImagePickerController*)[self navigationController];
    ALAssetsFilter *assetsFilter = pickerController.assetsFilter;
    
    [ALAssetsLibrary disableSharedPhotoStreamsSupport];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group,BOOL *stop){
        if (group) {
            [group setAssetsFilter:assetsFilter];
            if ([group numberOfAssets] > 0) {
                [self.groups addObject:group];
            }
        }else{
            [self reloadData];
        }
        
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
        [self showNotAllowed];
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultBlock
                                    failureBlock:failureBlock];
    NSUInteger type = ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces;
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultBlock
                                    failureBlock:failureBlock];
}

- (void)reloadData{
    if (self.groups.count < 1) {
        [self showNoAssets];
    }
    
    [self.tableView reloadData];
}

- (void)showNotAllowed{
    self.title = NULL_STRING;
    
    UIView *lockedView    = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *locked   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CTAssetsPickerLocked"]];
    
    CGRect rect           = CGRectInset(self.view.bounds, 8, 8);
    UILabel *title        = [[UILabel alloc] initWithFrame:rect];
    title.text            = NSLocalizedString(@"此应用程序没有权限来访问您的相册", @"This app does not have access to your photots or videos.");
    title.font            = [UIFont systemFontOfSize:17.0f];
    title.textColor       = [UIColor colorWithRed:129.0f/255.0f green:136.0f/255.0f blue:148.0f/255.0f alpha:1];
    title.textAlignment   = NSTextAlignmentCenter;
    title.numberOfLines   = 5;
    
    UILabel *message      = [[UILabel alloc] initWithFrame:rect];
    message.text          = NSLocalizedString(@"您可以在\"隐私设置\"中启用访问", @"You can enable access in Privacy Settings.");
    message.font          = [UIFont systemFontOfSize:14.0f];
    message.textColor     = [UIColor colorWithRed:129.0f/255.0f green:136.0f/255.0f blue:148.0f/255.0f alpha:1];
    message.textAlignment = NSTextAlignmentCenter;
    message.numberOfLines = 5;
    
    [title   sizeToFit];
    [message sizeToFit];
    
    locked.center  = CGPointMake(locked.center.x, locked.center.y - 40);
    title.center   = lockedView.center;
    message.center = lockedView.center;
    
    rect = title.frame;
    rect.origin.y = locked.frame.origin.y + locked.frame.size.height + 20;
    title.frame = rect;
    
    rect = message.frame;
    rect.origin.y = title.frame.origin.y+title.frame.size.height + 10;
    message.frame = rect;
    
    [lockedView addSubview:locked];
    [lockedView addSubview:title];
    [lockedView addSubview:message];
    
    self.tableView.tableHeaderView = lockedView;
    self.tableView.scrollEnabled = NO;
}

- (void)showNoAssets{
    UIView *noAssetsView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    CGRect rect = CGRectInset(self.view.bounds, 10, 10);
    
    UILabel *title = [[UILabel alloc] initWithFrame:rect];
    title.text          = NSLocalizedString(@"No Photos or Videos", nil);
    title.font          = [UIFont systemFontOfSize:26.0];
    title.textColor     = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 5;
    
    UILabel *message        = [[UILabel alloc] initWithFrame:rect];
    message.text            = NSLocalizedString(@"You can sync photos and videos onto your iPhone using iTunes.", nil);
    message.font            = [UIFont systemFontOfSize:18.0];
    message.textColor       = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title   sizeToFit];
    [message sizeToFit];
    
    title.center    = CGPointMake(noAssetsView.center.x, noAssetsView.center.y - 10 - title.frame.size.height / 2);
    message.center  = CGPointMake(noAssetsView.center.x, noAssetsView.center.y + 10 + message.frame.size.height / 2);
    
    [noAssetsView addSubview:title];
    [noAssetsView addSubview:message];
    
    self.tableView.tableHeaderView  = noAssetsView;
    self.tableView.scrollEnabled    = NO;
}

+ (ALAssetsLibrary*)defaultAssetsLibrary{
    
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    _dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
    return library;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    KAssetsGroupViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[KAssetsGroupViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [cell bind:[self.groups objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kThumbnailLength + 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KAssetsViewController *assetsViewController = [[KAssetsViewController alloc] init];
    assetsViewController.assetsGroup = [self.groups objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:assetsViewController animated:YES];
}

- (void)dismiss:(id)sender{
    KImagePickerController *pickerController = (KImagePickerController*)[self navigationController];
    if (pickerController) {
        if (pickerController.kDelegate && [pickerController respondsToSelector:@selector(kImagePickerControllerDidCancel:)]) {
            [pickerController.kDelegate kImagePickerControllerDidCancel:pickerController];
        }
    }
    
    [pickerController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end


#pragma mark KAssetsGroupViewCell
@implementation KAssetsGroupViewCell


- (void)bind:(ALAssetsGroup *)assetsGroup{
    self.assetsGroup = assetsGroup;
    
    CGImageRef posterImage = assetsGroup.posterImage;
    size_t height = CGImageGetHeight(posterImage);
    float scale = height / kThumbnailLength;
    
    self.imageView.image = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.textLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)[assetsGroup numberOfAssets]];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString*)accessibilityLabel{
    NSString *label = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    return [label stringByAppendingFormat:NSLocalizedString(@"%d 张图片", nil),[self.assetsGroup numberOfAssets]];
}

@end

#pragma mark KAssetsViewController

#define KAssetsViewCellIdentifier @"AssetsViewCell"
#define KAssetsSupplementaryViewIdentifier @"KAssetsSupplementaryIdentifier"

@implementation KAssetsViewController

- (id)init{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = kThumbnailSize;
    layout.sectionInset = UIEdgeInsetsMake(9.0, 0, 0, 0);
    layout.minimumInteritemSpacing = 2.0f;
    layout.minimumLineSpacing = 2.0f;
    layout.footerReferenceSize = CGSizeMake(0, 44.0f);
    
    if (!self.selectedAssets) {
        self.selectedAssets = [[NSMutableArray alloc] init];
    }else{
        [self.selectedAssets removeAllObjects];
    }
    
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.collectionView.allowsMultipleSelection = YES;
        [self.collectionView registerClass:[KAssetsViewCell class] forCellWithReuseIdentifier:KAssetsViewCellIdentifier];
        
        [self.collectionView registerClass:[KAssetsSupplementaryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:KAssetsSupplementaryViewIdentifier];
        
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
        
        self.preferredContentSize = kPopovercontentSize;
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self addNaviBarItem];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupAssets];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)setupAssets{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!self.assets) {
        self.assets = [[NSMutableArray alloc] init];
    }else{
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock resultBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        
        if (result) {
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            
            if ([type isEqualToString:ALAssetTypePhoto]) {
                [self.assets addObject:result];
                self.numberOfPhotos ++;
            }
            
            if ([type isEqualToString:ALAssetTypeVideo]) {
                [self.assets addObject:result];
                self.numberOfVideos ++;
            }
        }else{
            if (self.assets.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.assets.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
                });
            }
        }
        
        
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultBlock];
}

#pragma mark UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = KAssetsViewCellIdentifier;
    KAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell bind:[self.assets objectAtIndex:indexPath.row]];
    
    return cell;
}


- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    static NSString *viewIdentifier = KAssetsSupplementaryViewIdentifier;
    KAssetsSupplementaryView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:viewIdentifier forIndexPath:indexPath];
    [view setNumberOfPhotos:self.numberOfPhotos numberOfVideos:self.numberOfVideos];
    return view;
}

#pragma mark UICollectionView delegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KImagePickerController *picker = (KImagePickerController*)[self navigationController];
    
    if (self.selectedAssets.count >= 9) {
        KImagePickerController *controller = (KImagePickerController*)[self navigationController];
        NSString *string = [NSString stringWithFormat:@"最多选择%ld张图片",(long)controller.maximumNumberOfSelection];
        [MTool showWrongAlertViewWithMessage:string viewController:self];
    }
    
    return ([collectionView indexPathsForSelectedItems].count < picker.maximumNumberOfSelection);
}

#pragma mark 选中某个图片
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self setTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
    
    ALAsset *asset = [self.assets objectAtIndex:indexPath.item];
    [self.selectedAssets addObject:asset];
}

#pragma mark 取消选中某个图片
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self setTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
    ALAsset *asset = [self.assets objectAtIndex:indexPath.item];
    [self.selectedAssets removeObject:asset];
}

- (void)setTitleWithSelectedIndexPaths:(NSArray*)indexPaths{
    if (indexPaths.count == 0) {
        self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        return;
    }
    
    BOOL photoSelected = NO;
    BOOL videoSelected = NO;
    
    for (NSIndexPath *indexPath in indexPaths) {
        ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
            photoSelected = YES;
        }
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
            videoSelected = YES;
        }
        
        if (photoSelected && videoSelected) {
            break;
        }
    }
    
    NSInteger count = 0;
    if (videoSelected) {
        for (NSIndexPath *indexPath in indexPaths) {
            ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
            if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                count ++;
            }
        }
    }
    
    if (photoSelected && videoSelected) {
        self.title = [NSString stringWithFormat:@"选中%ld张图片，选中%ld个视频",(long)(indexPaths.count - count),(long)count];
    }else if (photoSelected){
        
        self.title = [NSString stringWithFormat:@"选中%ld张图片",(long)indexPaths.count];
        
    }else if (videoSelected){
        self.title = [NSString stringWithFormat:@"选中%ld个视频",(long)indexPaths.count];
    }
}

- (void)setupButtons
{
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"选择", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(finishPickingAssets:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f],NSFontAttributeName,[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

#pragma mark 选择结束
- (void)finishPickingAssets:(id)sender{
    
    KImagePickerController *pickerController = (KImagePickerController*)[self navigationController];
    if (pickerController.kDelegate && [pickerController.kDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingAssets:)]) {
        [pickerController.kDelegate imagePickerController:pickerController didFinishPickingAssets:self.selectedAssets];
    }
    
//    [pickerController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


- (void)addNaviBarItem{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [backBtn setImage:[UIImage imageNamed:@"imagePickBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)gotoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

@implementation KAssetsSupplementaryView

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _sectionLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 8.0, 8.0)];
        _sectionLabel.font = [UIFont systemFontOfSize:18.0f];
        _sectionLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_sectionLabel];
    }
    
    return self;
}


- (void)setNumberOfPhotos:(NSInteger)numberOfPhotos numberOfVideos:(NSInteger)numberOfVideo{
    NSString *title;
    
    if (numberOfVideo == 0) {
        title = [NSString stringWithFormat:NSLocalizedString(@"%d 张图片", nil),numberOfPhotos];
    }else if (numberOfPhotos == 0){
        title = [NSString stringWithFormat:NSLocalizedString(@"%d 个视频", nil),numberOfVideo];
    }else{
        title = [NSString stringWithFormat:NSLocalizedString(@"%d 张图片，%d 个视频", nil),numberOfPhotos,numberOfVideo];
    }
    
    self.sectionLabel.text = title;
}

@end

@implementation KAssetsViewCell

static UIFont *titleFont = nil;
static CGFloat titleHeight;
static UIImage *videoIcon;
static UIColor *titleColor;
static UIImage *checkedIcon;
static UIColor *selectedColor;

static UIImage *checkedNormalIcon;
static UIColor *normalColor;

+(void)initialize{
    titleFont = [UIFont systemFontOfSize:12];
    titleHeight = 20.0f;
    videoIcon = [UIImage imageNamed:@"CTAssetsPickerVideo"];
    titleColor = [UIColor whiteColor];
    checkedIcon = [UIImage imageNamed:@"CTAssetsPickerChecked"];
    selectedColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    checkedNormalIcon = [UIImage imageNamed:@"checkedNormalIcon"];
    normalColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.opaque = YES;
        self.isAccessibilityElement = YES;
        self.accessibilityTraits = UIAccessibilityTraitImage;
    }
    
    return self;
}


- (void)bind:(ALAsset *)asset{
    self.asset = asset;
    self.image = [UIImage imageWithCGImage:asset.thumbnail];
    self.type = [asset valueForProperty:ALAssetPropertyType];
    self.title = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [self.image drawInRect:CGRectMake(0, 0, kThumbnailLength, kThumbnailLength)];
    if ([self.type isEqualToString:ALAssetTypeVideo]) {
        CGFloat colors[] = {
            0.0,0.0,0.0,0.0,
            0.0,0.0,0.0,0.8,
            0.0,0.0,0.0,1.0
        };
        
        CGFloat locations[] = {0.0,0.75,1.0};
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGFloat height = rect.size.height;
        CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), height - titleHeight);
        CGPoint endPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
        
        CGSize titleSize = [self.title sizeWithFont:titleFont];
        [titleColor set];
        
        [self.title drawAtPoint:CGPointMake(rect.size.width - titleSize.width - 2 , startPoint.y + (titleHeight - 12) / 2)
                       forWidth:kThumbnailLength
                       withFont:titleFont
                       fontSize:12
                  lineBreakMode:NSLineBreakByTruncatingTail
             baselineAdjustment:UIBaselineAdjustmentAlignCenters];
        
        [videoIcon drawAtPoint:CGPointMake(2, startPoint.y+(titleHeight - videoIcon.size.height)/2)];
        
        CGColorSpaceRelease(baseSpace);
        CGGradientRelease(gradient);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.selected) {
        CGContextSetFillColorWithColor(context, selectedColor.CGColor);
        CGContextFillRect(context, rect);
        [checkedIcon drawAtPoint:CGPointMake(CGRectGetMaxX(rect) - checkedIcon.size.width, CGRectGetMinY(rect))];
    }else{
        CGContextSetFillColorWithColor(context, normalColor.CGColor);
        CGContextFillRect(context, rect);
        [checkedNormalIcon drawAtPoint:CGPointMake(CGRectGetMaxX(rect) - checkedNormalIcon.size.width, CGRectGetMinY(rect))];
    }
}

- (NSString*)accessibilityLabel{
    ALAssetRepresentation *representation = self.asset.defaultRepresentation;
    
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    NSDate *date = [self.asset valueForProperty:ALAssetPropertyDate];
    CGSize dimension = representation.dimensions;
    
    if ([type isEqual:ALAssetTypeVideo]) {
        [labels addObject:NSLocalizedString(@"Video", nil)];
    }else{
        [labels addObject:NSLocalizedString(@"Photo", nil)];
    }
    
    if (dimension.height >= dimension.width) {
        [labels addObject:NSLocalizedString(@"Portrait", nil)];
    }else{
        [labels addObject:NSLocalizedString(@"Landscape", nil)];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale currentLocale];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    df.doesRelativeDateFormatting = YES;
    
    [labels addObject:[df stringFromDate:date]];
    
    return [labels componentsJoinedByString:@", "];
}

@end


