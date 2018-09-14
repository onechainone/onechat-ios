//
//  LZExchangeRateTableViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/14.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZExchangeRateTableViewController.h"
#import "ChoseCell.h"
#import "LZTabBarController.h"
#import "PrepareController.h"
#import "LZNavigationController.h"

//屏幕宽、高
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@interface LZExchangeRateTableViewController (){
    NSIndexPath * path;
    NSMutableArray * dataArr;        // 所有成员
    UITableView * userTab;
    
}
//切换的哪个语言
@property (nonatomic,copy)NSString *languageType;
//切换那个汇率 languageType
@property (nonatomic,copy)NSString *rateType;

@end

@implementation LZExchangeRateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    dataArr=[NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    self.tableView.themeMap = @{
                                BGColorName:@"bg_white_color",
                                TableSepColorName:@"conversation_line_color"
                                };
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView registerClass:[ChoseCell class] forCellReuseIdentifier:@"cell"];
    if ([self.type isEqualToString:CHAGERATE]) {
        //exchange_type 切换汇率
        self.title = NSLocalizedString(@"exchange_type", nil);
        //        [self getdatas];
        dataArr = @[USD_SYMBOL,CNY_SYMBOL];
        
    }else {
        //切换语言 select_langurafe
        self.title = NSLocalizedString(@"select_langurafe", nil);
        dataArr = @[JIANTIZHONGWEN,ENGLISH,RIYU,HANWEN,YIDALIYU,DEYU,FAYU,FEILVBINYU,PUTAOYAYU,HELANYU,YINDUNIXIYAYU,XIBANYAYU,ALABOYU,YINDUYU];
    }//button_ok
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button_ok", nil) style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnClick)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button_ok", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(confirmBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = THMColor(@"conversation_title_color");
    
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIBarButtonItemStylePlain];

//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHex:BTN_BACKGROUNDCOLOR]];
    
}
-(void)getdatas{
//    for (int i=0;i<10; i++) {
//        [dataArr addObject:[NSString stringWithFormat:@"CNY %d 号",i]];
//    }
//    [userTab reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * inde=@"cell";
    ChoseCell* cell=[tableView dequeueReusableCellWithIdentifier:inde forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (dataArr.count>0) {
        cell.isSele=NO;
        cell.stateV.image=[UIImage imageNamed:@"circlecnofrim"];
        cell.nameLabel.text=dataArr[indexPath.row];
        if ([self.type isEqualToString:CHAGELANGUAGE]) {
            //简体中文
            if (indexPath.row == 0&& [self.passValue isEqualToString:JIANTIZHONGWEN]) {
                
                path = indexPath;
            }
            ///英文
            else if(indexPath.row == 1&&[self.passValue isEqualToString:ENGLISH]){
                
                path = indexPath;
            }
            //            ///日语
            else if(indexPath.row == 2 &&[self.passValue isEqualToString:RIYU]) {
                path = indexPath;
            }
            
            ///韩语
            else if(indexPath.row == 3&&[self.passValue isEqualToString:HANWEN]) {
                path = indexPath;
                
            }
            ///意大利语
            else if(indexPath.row == 4&&[self.passValue isEqualToString:YIDALIYU]) {
                path = indexPath;
            }
            //德语
            else if(indexPath.row == 5 && [self.passValue isEqualToString:DEYU]) {
                path = indexPath;
            }
            //法语
            else if(indexPath.row == 6 && [self.passValue isEqualToString:FAYU]) {
                path = indexPath;
            }
            //菲律宾语
            else if(indexPath.row == 7 && [self.passValue isEqualToString:FEILVBINYU]) {
                path = indexPath;
            }
            //葡萄牙语
            else if(indexPath.row == 8 && [self.passValue isEqualToString:PUTAOYAYU]) {
                path = indexPath;
            }
            //荷兰
            else if(indexPath.row == 9 && [self.passValue isEqualToString:HELANYU]) {
                path = indexPath;
            }
            ///印度尼西亚
            else if(indexPath.row == 10 && [self.passValue isEqualToString:YINDUNIXIYAYU]) {
                path = indexPath;
            }
            ///西班牙语
            else if(indexPath.row == 11 && [self.passValue isEqualToString:XIBANYAYU]) {
                path = indexPath;
            }
            ///阿拉伯语
            else if(indexPath.row == 12 && [self.passValue isEqualToString:ALABOYU]) {
                path = indexPath;
            }
            ///印度语
            else if(indexPath.row == 13 && [self.passValue isEqualToString:YINDUYU]) {
                path = indexPath;
            }

            
        } else {
            
            if (indexPath.row == 0 &&[self.passValue isEqualToString:USD_SYMBOL]) {
                
                path = indexPath;
            } else if(indexPath.row != 0 && [self.passValue isEqualToString:CNY_SYMBOL]){
                
                path = indexPath;
            }
        }
        
        if (indexPath==path) {
            cell.isSele=YES;
            cell.stateV.image=[UIImage imageNamed:@"confrim"];
        }
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChoseCell * cell=(ChoseCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (path) {
        ChoseCell * cell1=(ChoseCell *)[tableView cellForRowAtIndexPath:path];
        cell1.isSele=NO;
        cell1.stateV.image=[UIImage imageNamed:@"circlecnofrim"];
//        cell1.userInteractionEnabled=YES;
        
    }
    path = indexPath; //用来保存选中目标位置
    cell.isSele=YES;
    cell.stateV.image=[UIImage imageNamed:@"confrim"];
//    cell.userInteractionEnabled=NO;
    self.passValue = cell.nameLabel.text;
    
    if ([self.type isEqualToString:CHAGELANGUAGE]) {
        self.languageType = cell.nameLabel.text;
    } else {
        ///这个
        self.rateType = cell.nameLabel.text;
        
    }
    
    
}

- (void)confirmBtnClick {
    
    if ([self.type isEqualToString:CHAGELANGUAGE]) {
        //如果存在的话
        if ([self.languageType isEqualToString:JIANTIZHONGWEN]) {
            //切换中文
            [self changeLanguageTo:@"zh-Hans"];
        } else if ([self.languageType isEqualToString:ENGLISH]) {
            //切换中文
            [self changeLanguageTo:@"en"];
        }///韩语
        else if ([self.languageType isEqualToString:HANWEN]) {
            [self changeLanguageTo:LANGUAGE_KO];
            
        }/// 意大利语
        else if ([self.languageType isEqualToString:YIDALIYU]) {
            [self changeLanguageTo:LANGUAGE_IT];
            
        }
        ///德语
        else if ([self.languageType isEqualToString:DEYU]) {
            [self changeLanguageTo:LANGUAGE_DE];
            
        }
        ///法语
        else if ([self.languageType isEqualToString:FAYU]) {
            [self changeLanguageTo:LANGUAGE_FR];
            
        }
        ///菲律宾
        else if ([self.languageType isEqualToString:FEILVBINYU]) {
            [self changeLanguageTo:LANGUAGE_FIL];
            
        }
        ///葡萄牙语
        else if ([self.languageType isEqualToString:PUTAOYAYU]) {
            [self changeLanguageTo:LANGUAGE_PT];
            
        }
        //荷兰语
        else if ([self.languageType isEqualToString:HELANYU]) {
            [self changeLanguageTo:LANGUAGE_NL];
            
        }
        //印度尼西亚
        else if ([self.languageType isEqualToString:YINDUNIXIYAYU]) {
            [self changeLanguageTo:LANGUAGE_ID];
            
        }
        //西班牙
        else if ([self.languageType isEqualToString:XIBANYAYU]) {
            [self changeLanguageTo:LANGUAGE_ES];
            
        }
        //阿拉伯
        else if ([self.languageType isEqualToString:ALABOYU]) {
            [self changeLanguageTo:LANGUAGE_AR];
            
        }
        //印度
        else if ([self.languageType isEqualToString:YINDUYU]) {
            [self changeLanguageTo:LANGUAGE_HI];
            
        }
        //日语
        else if ([self.languageType isEqualToString:RIYU]) {
            [self changeLanguageTo:LANGUAGE_JA];
            
        }
        
    } else {
        
        if ([self.rateType isEqualToString:CNY_SYMBOL]) {
            [self saveuserArrInfo:self.rateType name:@"moneyType"];
        }
        if ([self.rateType isEqualToString:USD_SYMBOL]) {
            [self saveuserArrInfo:self.rateType name:@"moneyType"];
        }
        
        LZTabBarController *tab = [[LZTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    }
    
    
}
- (void)changeLanguageTo:(NSString *)language {
    // 设置语言
    [NSBundle setLanguage:language];
    
    // 然后将设置好的语言存储好，下次进来直接加载
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:MY_LANGUAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.shouYe) {
        PrepareController *prepare = [[PrepareController alloc] init];
        LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:prepare];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        
    } else{
        // 我们要把系统windown的rootViewController替换掉
        LZTabBarController *tab = [[LZTabBarController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
        // 跳转到设置页
        //    tab.selectedIndex = 2;
    }

}
- (void)saveuserArrInfo:(id)userArrInfo name:(NSString *)name{
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2、添加储存的文件名
    NSString *path  = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver",name]];
    //3、将一个对象保存到文件中
    [NSKeyedArchiver archiveRootObject:userArrInfo toFile:path];
}

@end
