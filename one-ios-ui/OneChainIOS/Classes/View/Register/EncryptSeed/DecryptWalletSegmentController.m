//
//  DecryptWalletSegmentController.m
//  OneChainIOS
//
//  Created by lifei on 2018/3/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "DecryptWalletSegmentController.h"
#import "EncryptSeedExportController.h"
#import "LZBackupWalletViewController.h"

static const CGFloat kHEIGHT = 40;

@interface DecryptWalletSegmentController ()

@property (nonatomic, strong) EncryptSeedExportController *exportController;
@property (nonatomic, strong) LZBackupWalletViewController *backupController;
@end

@implementation DecryptWalletSegmentController


- (UIImage *)imageAtIndex:(NSInteger)index selectedState:(BOOL)l_isSelected
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 2, 40)];
    lbl.backgroundColor = !l_isSelected ? THMColor(@"bg_color") : THMColor(@"bg_white_color");
    lbl.font = [UIFont fontWithName:l_isSelected ? FONT_NAME_MEDIUM : FONT_NAME_REGULAR size:14];
//    lbl.textColor = DEFAULT_BLACK_COLOR;
    lbl.themeMap = @{
                     TextColorName:@"common_text_color"
                     };
    lbl.text = [[self getTitles] objectAtIndex:index];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.adjustsFontSizeToFitWidth = YES;
    UIImage *image = [UIImage imageFromView:lbl];
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = THMColor(@"bg_white_color");
    self.bottomView.backgroundColor = THMColor(@"theme_color");
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"title_activity_backup_seed", nil);
}

- (NSArray *)getTitles
{
    return @[NSLocalizedString(@"seed", @"Mnemonics"),NSLocalizedString(@"encrypted_seed", @"")];
}

- (void)initSubVC
{
    _backupController = [[LZBackupWalletViewController alloc] init];
    _backupController.seed = self.seed;
    _backupController.view.frame = CGRectMake(0, kHEIGHT, self.view.width, self.view.height - kHEIGHT);
    [self addChildViewController:_backupController];
    _exportController = [[EncryptSeedExportController alloc] init];
    _exportController.view.frame = CGRectMake(0, kHEIGHT, self.view.width, self.view.height - kHEIGHT);
    [self addChildViewController:_exportController];
    
    self.currentVC = _backupController;
    [self.view addSubview:_backupController.view];
    [self.view sendSubviewToBack:_backupController.view];

}

- (void)segmentChanged:(UISegmentedControl *)control
{
    if (control.selectedSegmentIndex == 0) {
        
        [self replaceFromOldViewController:_exportController toNewViewController:_backupController];
    } else if (control.selectedSegmentIndex == 1) {
        
        [self replaceFromOldViewController:_backupController toNewViewController:_exportController];
    }
    [self changeBottomViewToIndex:control.selectedSegmentIndex animation:YES];
}

- (void)initNodeCheck
{
    return;
}

@end
