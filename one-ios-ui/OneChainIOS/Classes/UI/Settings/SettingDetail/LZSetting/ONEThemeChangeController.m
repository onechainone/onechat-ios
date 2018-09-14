//
//  ONEThemeChangeController.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/1.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEThemeChangeController.h"
#import "ChoseCell.h"


@interface ONETHemeModel:NSObject

@property (nonatomic) BOOL isChosen;

@property (nonatomic, copy) NSString *theme_id;

@property (nonatomic, copy) NSString *desc;
@end

@implementation ONETHemeModel

- (instancetype)initWithIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        _theme_id = [NSString stringWithFormat:@"%lu",index + 1];
        _isChosen = [[ONEThemeManager sharedInstance].theme.theme_id isEqualToString:_theme_id];
    }
    return self;
}



- (NSString *)desc
{
    if ([_theme_id isEqualToString:@"1"]) {
        return NSLocalizedString(@"default_skin", @"");
    } else if ([_theme_id isEqualToString:@"2"]) {
        return NSLocalizedString(@"black_skin", @"");
    } else {
        return @"";
    }
}
@end


@interface ONEThemeChangeController ()

@property (nonatomic, strong) NSMutableArray *themes;

@property (nonatomic, strong) ONETHemeModel *currentModel;
@end

@implementation ONEThemeChangeController

- (NSMutableArray *)themes
{
    if (!_themes) {
        
        _themes = [NSMutableArray array];
    }
    return _themes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"select_skin", @"");
//    self.navigationItem.rightBarButtonItem = nil;
    self.currentModel = [[ONETHemeModel alloc] initWithIndex:([[ONEThemeManager sharedInstance].theme.theme_id integerValue] - 1)];
    [self loadDatasource];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged:) name:kThemeDidChangeNotification object:nil];
}

- (void)themeChanged:(NSNotification *)noti
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:THMImage(@"nav_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem.tintColor = THMColor(@"conversation_title_color");
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadDatasource
{
    [self.themes removeAllObjects];
    for (NSInteger i = 0; i < 2; i++) {
        
        ONETHemeModel *model = [[ONETHemeModel alloc] initWithIndex:i];
        if (self.currentModel && [self.currentModel.theme_id isEqualToString:model.theme_id]) {
            model.isChosen = YES;
        } else {
            model.isChosen = NO;
        }
        [self.themes addObject:model];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmBtnClick
{
    if (self.currentModel) {
        
        [[ONEThemeManager sharedInstance] switchTheme:self.currentModel.theme_id];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.themes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    ChoseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    ONETHemeModel *model = self.themes[indexPath.row];
    cell.nameLabel.text = model.desc;
    if (model.isChosen) {
        cell.stateV.image = [UIImage imageNamed:@"confrim"];
        cell.isSele = YES;
    } else {
        cell.stateV.image = [UIImage imageNamed:@"circlecnofrim"];
        cell.isSele = NO;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ONETHemeModel *model = self.themes[indexPath.row];
    model.isChosen = YES;
    self.currentModel = model;
    [self loadDatasource];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
