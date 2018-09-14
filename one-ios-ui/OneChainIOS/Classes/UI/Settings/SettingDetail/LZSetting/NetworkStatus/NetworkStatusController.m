//
//  NetworkStatusController.m
//  OneChainIOS
//
//  Created by lifei on 2018/1/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "NetworkStatusController.h"
#import "NetworkStatusCell.h"
//#import "NetworkStatusModel.h"

static const CGFloat TABLE_ROW_HEIGHT = 38;
static const CGFloat NAV_RIGHT_ITEM_FONT = 14.f;

@interface NetworkStatusController ()
@property (nonatomic, strong) NSMutableArray *nodeSources;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation NetworkStatusController

- (NSMutableArray *)nodeSources
{
    if (!_nodeSources) {
        
        _nodeSources = [NSMutableArray array];
    }
    return _nodeSources;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    self.title = NSLocalizedString(@"switch_service_node", @"");
    [self setupSubviews];
    [self refreshNetwork];
}

- (void)setupSubviews
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.rowHeight = TABLE_ROW_HEIGHT;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.themeMap = @{
                                BGColorName:@"bg_white_color",
                                TableSepColorName:@"conversation_line_color"
                                };
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setFrame:CGRectMake(0, 0, 60, 40)];
    _rightBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:NAV_RIGHT_ITEM_FONT];
    _rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightBtn.themeMap = @{
                           TextColorName:@"conversation_title_color"
                           };
    [_rightBtn setTitle:NSLocalizedString(@"action_refresh", @"") forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)refreshBtnClick {
    
    
    [self.nodeSources removeAllObjects];
    __weak typeof(self)weakself = self;
    [_rightBtn setEnabled:NO];
    [self showHudInView:self.view hint:nil];
    
    [[ONEChatClient sharedClient] initNode:^(ServerInfo *si, BOOL state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @synchronized(weakself){
                
                
                NSDictionary *dic = [si dict];
                
                [weakself.nodeSources addObject:dic];
                
                [weakself.tableView reloadData];
            }
            
        });

    } cb:^(BOOL state, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.rightBtn setEnabled:YES];
            [weakself hideHud];
            [weakself.tableView reloadData];
        });

    }];
}

- (void)refreshNetwork {
    
        
    NSArray *cacheList = [ONEChatClient cachedServerInfoList];

    //内存中没有的时候才加载
    
    if ( cacheList== nil || [cacheList isKindOfClass:[NSNull class] ] ||cacheList.count < 1) {
        
        [self refreshBtnClick];
        
    }
    
    [self showCacheInfo:cacheList];
        

}

-(void) showCacheInfo:(NSArray*)  cacheList {
    

    self.nodeSources = cacheList;
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.nodeSources.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"NetworkStatusCell";
    NetworkStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[NetworkStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = self.nodeSources[indexPath.row];
    
    
    
#if !as_is_dev_mode

    NSString* name = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"name"],[dict objectForKey:@"uuid"]];

#else

    NSString* name_fmt = [NSString stringWithFormat:@"%@_",[dict objectForKey:@"name"]];

    NSString* t = [dict objectForKey:@"tag"];
    
    t = [t stringByReplacingOccurrencesOfString:@"service_" withString:name_fmt];
    
    NSString* name =  [NSString stringWithFormat:@"%@-%@",t,[dict objectForKey:@"url"]];

#endif

    cell.nodeName = name;
    
    NSString* url = [dict objectForKey:@"url"];
    
    if( [url isKindOfClass:[NSNull class]] ) {
        
        cell.status =  FALSE;
        
    } else {
        
        cell.status =  TRUE;

    }
    
    
    
    return cell;
}


#if as_is_dev_mode


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
 
    
    NSDictionary *dic = self.nodeSources[indexPath.row];
    [self showServerInfo:dic];
    
}

#endif

- (void)showServerInfo:(NSDictionary *) dict {
    
    
}
@end
