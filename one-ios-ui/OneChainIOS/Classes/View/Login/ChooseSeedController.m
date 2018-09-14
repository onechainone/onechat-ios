//
//  ChooseSeedController.m
//  OneChainIOS
//
//  Created by lifei on 2018/1/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ChooseSeedController.h"

#import "RealtimeSearchUtil.h"
#import "UIImage+Extension.h"
#import "LZVerifyWordViewController.h"
#import "LZRegistViewController.h"
#define SEED_CONTENT_MIN_HEIGHT 119


#define COL_OF_ROW 4
#define SEED_WIDTH ((self.view.frame.size.width - 20 - 2 * 5) / 4)
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

static const CGFloat KDEFAULT_CORNER = 3.f;
static const CGFloat KDEFAULT_BORDERWIDTH = 1.f;



@interface ChooseSeedController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datasources;

@property (nonatomic, strong) UIScrollView *seedContentView;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UILabel *lbl;

@property (nonatomic, strong) UITableView *resultTable;

@property (nonatomic, strong) NSMutableArray *searchResult;

@property (nonatomic, strong) NSArray *allSeeds;
@end

@implementation ChooseSeedController

- (UIScrollView *)seedContentView
{
    if (!_seedContentView) {
        
        _seedContentView = [[UIScrollView alloc] initWithFrame:KSEED_CONTENT_FRAME];
        _seedContentView.layer.cornerRadius = KDEFAULT_CORNER;
        _seedContentView.layer.borderColor = [[UIColor colorWithHex:THEME_COLOR] CGColor];
        _seedContentView.layer.borderWidth = KDEFAULT_BORDERWIDTH;
        _seedContentView.layer.masksToBounds = YES;
        _seedContentView.backgroundColor = [UIColor whiteColor];
        _seedContentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startSearch)];
        [_seedContentView addGestureRecognizer:tap];
    }
    return _seedContentView;
}


- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search_seed", @"Search");
        _searchBar.layer.cornerRadius = KSEARCHBAR_CORNER;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.keyboardType = UIKeyboardTypeASCIICapable;
        _searchBar.returnKeyType = UIReturnKeyDone;
        _searchBar.backgroundImage = [UIImage imageFromColor:RGBACOLOR(243, 243, 243, 1) withCGRect:_searchBar.bounds];
        
        UITextField *tf = [_searchBar valueForKey:@"_searchField"];
        tf.backgroundColor = [UIColor clearColor];
    }
    return _searchBar;
}

- (UILabel *)lbl
{
    if (!_lbl) {
        
        _lbl = [[UILabel alloc] init];
        _lbl.font = KLBL_FONT;
        _lbl.textColor = KLBL_COLOR;
        _lbl.text = NSLocalizedString(@"choose_seed", @"");
    }
    return _lbl;
}


- (UITableView *)resultTable
{
    if (!_resultTable) {
        
        _resultTable = [[UITableView alloc] init];
        _resultTable.tableFooterView = [UIView new];
        _resultTable.dataSource = self;
        _resultTable.delegate = self;
        _resultTable.backgroundColor = [UIColor whiteColor];
    }
    return _resultTable;
}

- (NSMutableArray *)datasources
{
    if (!_datasources) {
        
        _datasources = [NSMutableArray array];
    }
    return _datasources;
}

- (NSMutableArray *)searchResult
{
    if (!_searchResult) {
        
        _searchResult = [NSMutableArray array];
    }
    return _searchResult;
}

- (NSArray *)allSeeds
{
    if (!_allSeeds) {
        
                _allSeeds = [ONEChatClient englishWordList];
//        _allSeeds = @[@"Reading",@"from",@"DefMnemonic",@"unrecognized",@"threw",@"exception",@"will",@"appear",@"once",@"active",@"Err",@"Could",@"successfully",@"Conn",@"Failed"];
    }
    return _allSeeds;
}

- (void)refreshView
{
    [self.searchBar setFrame:CGRectMake(KWIDTH_PADDING, CGRectGetMaxY(self.seedContentView.frame) + KSEARCHBAR_Y_PADDING, KSEARCHBAR_WIDTH, KSEARCHBAR_HEIGHT)];
    [self.resultTable setFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame) + KTABLE_Y_PADDING, self.view.frame.size.width, KScreenH - CGRectGetMaxY(self.searchBar.frame) - NAVHEIGHT - 3 * KTABLE_Y_PADDING)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"input_seed", @"");
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    //    [self setupForDismissKeyboard];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.seedContentView];
    [self refreshSeedContent];
    [self setupRightItem];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.resultTable];
    if (self.existSeedString.length > 0) {
        
        NSArray *seedArray = [self seedArrayFromSeedString:self.existSeedString];
        [self.datasources removeAllObjects];
        [self.datasources addObjectsFromArray:seedArray];
        [self refreshSeedContent];
    }
    
}

- (void)setupRightItem
{
    if (!self.type) {
        UIButton *rBtn = [[UIButton alloc] initWithFrame:KRIGHTITEM_FRAME];
        rBtn.titleLabel.font = KRIGHTITEM_FONT;
        [rBtn setTitle:NSLocalizedString(@"action_ok", @"") forState:UIControlStateNormal];
        [rBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rBtn addTarget:self action:@selector(ensureAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = rItem;
    } else {
        UIButton *rBtn = [[UIButton alloc] initWithFrame:KRIGHTITEM_FRAME];
        rBtn.titleLabel.font = KRIGHTITEM_FONT;
        [rBtn setTitle:NSLocalizedString(@"action_ok", @"") forState:UIControlStateNormal];
        [rBtn setTitleColor:[UIColor colorWithHex:THEME_COLOR] forState:UIControlStateNormal];
        [rBtn addTarget:self action:@selector(ensureAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = rItem;
        ////重写返回键
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_old"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
        
    }

}
-(void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshSeedContent
{
    
    [self.seedContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int tmp = ([self.datasources count] + 1) % COL_OF_ROW;
    int row = (int)([self.datasources count] + 1) / COL_OF_ROW;
    row += tmp == 0 ? 0 : 1;
    CGFloat contentHeight = row * (SEED_HEIGHT + KSEED_PADDING ) + 2*KSEED_PADDING + 45 > SEED_CONTENT_MIN_HEIGHT ? row * (SEED_HEIGHT + KSEED_PADDING ) + 2*KSEED_PADDING + 45 : SEED_CONTENT_MIN_HEIGHT;
    self.seedContentView.frame = CGRectMake(WidthScale(10), 12, WidthScale(355), contentHeight);
    self.seedContentView.contentSize = CGSizeMake(self.seedContentView.frame.size.width, contentHeight);
    
    [self refreshView];
    
    if (self.datasources.count == 0) {
        
        [self.seedContentView addSubview:self.lbl];
        [self.lbl setFrame:CGRectMake(WidthScale(8), 8, CGRectGetWidth(self.seedContentView.frame), 17)];
        
        [self addBottomButton];
        
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
    [self addBottomButton];

}

- (void)addBottomButton
{
#if as_is_dev_mode
    UIButton *enSureBtn = [self createButton:NSLocalizedString(@"action_paste", @"")];
    [enSureBtn setFrame:CGRectMake(KBOTTOM_BTN_LEFT_PADDING, CGRectGetHeight(self.seedContentView.frame) - KBOTTOM_BTN_TOP_PADDING, KBOTTOM_BTN_WIDTH, KBOTTOM_BTN_HEIGHT)];
    [enSureBtn addTarget:self action:@selector(pasteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.seedContentView addSubview:enSureBtn];
    
    UIButton *clearBtn = [self createButton:NSLocalizedString(@"action_clear", @"")];
    [clearBtn setFrame:CGRectMake(CGRectGetWidth(self.seedContentView.frame) - KBOTTOM_BTN_LEFT_PADDING - KBOTTOM_BTN_WIDTH, CGRectGetMinY(enSureBtn.frame), CGRectGetWidth(enSureBtn.frame), CGRectGetHeight(enSureBtn.frame))];
#else
    UIButton *clearBtn = [self createButton:NSLocalizedString(@"action_clear", @"")];

    [clearBtn setFrame:CGRectMake((self.seedContentView.frame.size.width-KBOTTOM_BTN_WIDTH)/2, CGRectGetHeight(self.seedContentView.frame) - KBOTTOM_BTN_TOP_PADDING, KBOTTOM_BTN_WIDTH, KBOTTOM_BTN_HEIGHT)];
#endif
    [clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self.seedContentView addSubview:clearBtn];
}



- (UIButton *)createButton:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"Button_BG_small"] forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = KTIP_LBL_FONT;
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}

- (void)seedClicked:(UIButton *)sender
{
    NSInteger index = sender.tag;
    [self.datasources removeObjectAtIndex:index];
    [self refreshSeedContent];
    if (self.datasources.count < KSEED_NUM) {
        
        [self showSearch];
    }
}


- (void)ensureAction
{
    [self.view endEditing:YES];
    if (![self validSeed:self.datasources.count]) {
        
        [self showHint:NSLocalizedString(@"over_seed_word_num_two", @"The number of mnemonic is incorrect.")];
        return;
    }
    NSString *seedString = [self seedStringFromSeedArray:self.datasources];
    
    BOOL isSeedValid = [self judgeSeed:seedString];
    if (isSeedValid == NO) {
        
        return;
    }
    
    if (_selectedSeed) {
        
        _selectedSeed(seedString);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        

        LZRegistViewController *regist = [LZRegistViewController new];
        regist.type = self.type;
        regist.seed = seedString;
        [self.navigationController pushViewController:regist animated:YES];

    }
}

- (BOOL)judgeSeed:(NSString *)seed
{
    if (seed.length == 0) {
        
        [self showHint:NSLocalizedString(@"please_enter_correct_brainkey", @"")];
        return NO;
    }
    NSMutableArray *invalidSeeds = [NSMutableArray array];
    ONEError *error = [ONEChatClient seedIsValid:seed invalidWords:&invalidSeeds];
    if (error != nil) {
        
        if (error.errorCode == ONEErrorSeedIsNull) {
            
            [self showHint:NSLocalizedString(@"seed_is_null", @"")];
        } else if (error.errorCode == ONEErrorSeedCountError) {
            
            [self showHint:NSLocalizedString(@"over_seed_word_num_two", @"The number of mnemonic is incorrect.")];
        } else if (error.errorCode == ONEErrorSeedWordError) {
            
            [self showWrongSeeds:invalidSeeds];
        } else {
            
            [self showHint:NSLocalizedString(@"make_sure_seed_error_tip", @"")];
        }
        return NO;
    } else {
        
        return YES;
    }
}

- (void)showWrongSeeds:(NSMutableArray *)wrongSeeds
{
    NSString *seedString = [self seedStringFromSeedArray:wrongSeeds];
    if (seedString.length == 0) {
        
        [self showHint:NSLocalizedString(@"seed_word_wrong", @"")];
        return;
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"seed_word_wrong", @"") message:seedString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)clearAction
{
    [self.datasources removeAllObjects];
    [self refreshSeedContent];
    [self showSearch];
}

- (void)pasteAction
{

    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    NSString *string = pb.string;
    if (string == nil || string.length == 0) {
        
        [self showHint:NSLocalizedString(@"pasteboard_is_null", @"")];
        return;
    }
    NSArray *seedArray = [self seedArrayFromSeedString:string];
    if (seedArray.count > KSEED_NUM) {
        
        [self showHint:NSLocalizedString(@"over_seed_word_num", @"")];
        return;
    }
    [self.datasources removeAllObjects];
    [self.datasources addObjectsFromArray:seedArray];
    if (self.datasources.count >= KSEED_NUM) {
        
        [self hideSearch];
    } else {
        
        [self showSearch];
    }
    [self refreshSeedContent];
}

- (NSArray *)seedArrayFromSeedString:(NSString *)seedString
{
    NSMutableArray *array = [[seedString componentsSeparatedByString:@" "] mutableCopy];
    [array enumerateObjectsUsingBlock:^(NSString *seed, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![self isValid:seed]) {
            
            [array removeObject:seed];
            *stop = NO;
        }
    }];
    return array;
}
- (BOOL)isValid:(NSString *)subSeed
{
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSInteger count = [numberRegular numberOfMatchesInString:subSeed options:NSMatchingReportProgress range:NSMakeRange(0, subSeed.length)];
    if (count > 0) {
        
        return YES;
    } else {
        
        return NO;
    }
}

- (NSString *)seedStringFromSeedArray:(NSArray *)seedArray
{
    if (seedArray.count == 0) {
        
        return nil;
    }
    NSString *seedString = @"";
    for (NSInteger i = 0; i < seedArray.count; i++) {
        
        if (i == seedArray.count - 1) {
            
            seedString = [seedString stringByAppendingString:seedArray[i]];
        } else {
            seedString = [seedString stringByAppendingString:[NSString stringWithFormat:@"%@ ",seedArray[i]]];
        }
    }
    return seedString;
}

#pragma mark - tableview delegate、datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resultCell = @"ResultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resultCell];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resultCell];
    }
    cell.textLabel.text = self.searchResult[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SEARCH_RESULT_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.searchResult == nil) {
        
        return;
    }
    NSString *select = self.searchResult[indexPath.row];
    
    [self.datasources addObject:select];
    [self refreshSeedContent];
    self.searchBar.text = @"";
    [self.searchResult removeAllObjects];
    [self.resultTable reloadData];
    
    if (self.datasources.count >= KSEED_NUM) {
        
        [self hideSearch];
    }
    
}

- (void)showSearch
{
    [self.searchBar setHidden:NO];
    [self.resultTable setHidden:NO];
}

- (void)hideSearch
{
    [self.searchBar setHidden:YES];
    [self.resultTable setHidden:YES];
}

#pragma mark - 搜索

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    if (searchText.length == 0) {
        
        [self.searchResult removeAllObjects];
        [self.resultTable reloadData];
        return;
    }
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.allSeeds searchText:(NSString *)searchText collationStringSelector:nil resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchResult removeAllObjects];
                [weakSelf.searchResult addObjectsFromArray:results];
                [weakSelf.resultTable reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (BOOL)validSeed:(NSInteger)seedCount
{
    if (seedCount == 15 || seedCount == 24 || seedCount ==12 ) {
        return YES;
    } else {
        
        return NO;
    }
}

- (void)startSearch
{
    [self.searchBar becomeFirstResponder];
}


@end

