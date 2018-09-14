//
//  SelectCoinController.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/21.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "SelectCoinController.h"
static const CGFloat kCellHeight = 60;
@interface SelectCoinController ()

@end

@implementation SelectCoinController

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = kCellHeight;
    }
    return _tableView;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
//origindatasource 不变的datasource
- (NSArray *)origindatasource
{
    if (!_origindatasource) {
        
        _origindatasource = [NSArray new];
    }
    return _origindatasource;
}
- (UIView *)headerView
{
    if (!_headerView) {
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.tableView.frame.size.width, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:_headerView.frame];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.text = NSLocalizedString(@"assets_nodata", @"No assets");
        [_headerView addSubview:label];
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (instancetype)initWithDatasources:(NSArray *)datasource
{
    self = [super init];
    if (self) {
        
        [self.datasource addObjectsFromArray:datasource];
        ///这个是始终不会变的
//        [self.origindatasource addObjectsFromArray:datasource];
        self.origindatasource = datasource;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pure_BG"]];
    [self.view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        
    }];
    img.userInteractionEnabled = YES;
    // 点击视图收起键盘
    UITapGestureRecognizer *tapViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewGesture:)];
    [img addGestureRecognizer:tapViewGesture];
    
    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, HeightScale(300))];
    [self.view addSubview:self.tableView];
//    [self.tableView setCenter:self.view.center];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.centerX.offset(0);
        make.width.offset(self.view.frame.size.width - 60);
        make.height.offset(HeightScale(300));
    }];
    
    [self.tableView.layer setBorderWidth:1.f];
    [self.tableView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)tapViewGesture:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SelectCoinCell";
    LZSendRedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[LZSendRedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    RpAssetModel *model = self.datasource[indexPath.row];
    cell.name = model.showName;
    cell.icon = model.iconUrl;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RpAssetModel *model = self.datasource[indexPath.row];
    
    !_selectCoin ?: _selectCoin(model);
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
