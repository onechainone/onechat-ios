
//  LZSearchSelectCoinViewController.m
//  OneChainIOS
//
//  Created by chunzheng wang on 2018/5/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZSearchSelectCoinViewController.h"

@interface LZSearchSelectCoinViewController ()<UISearchBarDelegate>

@end

@implementation LZSearchSelectCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearch];
    
}
-(void)setupSearch {
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    [searchBar setBackgroundImage:[UIImage imageNamed:@"writeBG"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.view addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView.mas_top).offset(-10);
        make.centerX.offset(0);
//        make.width.equalTo(self.tableView.mas_width).offset(0);
        make.width.offset(self.tableView.width);
        make.height.offset(40);
    }];
    [searchBar.layer setBorderWidth:1.f];
    [searchBar.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
//    for (UIView *view in searchBar.subviews.lastObject.subviews) {
//        if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
//            UITextField *textField = (UITextField *)view;
//            //设置输入框的背景颜色
////            textField.clipsToBounds = YES;
////            textField.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
//
//        }
//    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    [self showHint:@"改变"];
    ///
    [self changeTableWithString:searchText];
    
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

-(void)changeTableWithString:(NSString *)str{
    if (str.length<=0) {
//        self.datasource = self.origindatasource;
        [self.datasource addObjectsFromArray:self.origindatasource];
        
    } else {
        [self.datasource removeAllObjects];
        for (int i = 0; i<self.origindatasource.count; i++) {
            RpAssetModel *model = self.origindatasource[i];
            NSDictionary *moneyInfo = [[ONEChatClient sharedClient] assetShowInfoFromAssetCode:model.asset_code];
            NSString *short_name = [moneyInfo objectForKey:@"name"];
            //        NSString *coin_name = [moneyInfo objectForKey:]
            if ([short_name.lowercaseString rangeOfString:str.lowercaseString].location != NSNotFound) {
                
                [self.datasource addObject:model];
                
            }
        }
    }

    [self.tableView reloadData];

    
    
}


//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
////    searchBar.prompt = @"4. 点击取消按钮";
////    searchBar.text = @"";
////    [self setShowsCancelButton:NO animated:YES];
//    // 如果希望在点击取消按钮调用结束编辑方法需要让加上这句代码
//    //[searchBar resignFirstResponder];
//    [self showHint:@"取消"];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
