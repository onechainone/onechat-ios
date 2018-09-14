//
//  LaunchTestView.m
//  OneChainIOS
//
//  Created by lifei on 2018/1/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LaunchTestView.h"
#import "UIImage+GIF.h"
#import "NetworkStatusCell.h"

#define KBANNER_LBL_FONT [UIFont fontWithName:@"PingFangSC-Semibold" size:14.f]
#define KTABLE_ORIGIN_Y HeightScale(68)
#define KTABLE_HEIGHT 38

#define KPASS_BTN_TITLE_COLOR RGBACOLOR(48, 48, 48, 1)
#define KPASS_BTN_TITLE_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:10.f]
#define KPASS_BTN_BORDER_WIDTH 0.5
#define KPASS_BTN_CORNERRADIUS 3.f
#define KPASS_BTN_TOP HeightScale(18)
#define KPASS_BTN_WIDTH 48
#define KPASS_BTN_HEIGHT 22

#define KBANNER_LBL_BTTOM HeightScale(542)
#define KGIF_EDGE 40
@interface LaunchTestView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *bannerLbl;
@property (nonatomic, strong) UIImageView *gifView;
@property (nonatomic, strong) UITableView *nodeTable;
@property (nonatomic, strong) UIButton *passBtn;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UIButton *refreshButton;

@property (nonatomic, strong) UIView *coverView;
@end

@implementation LaunchTestView

- (UIImageView *)imageView
{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        UIImage *image = [UIImage imageNamed:@"launchTest"];
        _imageView.image = image;
    }
    return _imageView;
}

- (UIImageView *)gifView
{
    if (!_gifView) {
        
        _gifView = [[UIImageView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cheking" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *gifImage = [UIImage sd_animatedGIFWithData:data];
        _gifView.image = gifImage;
    }
    return _gifView;
}

- (UIView *)coverView
{
    if (!_coverView) {
        
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor whiteColor];
    }
    return _coverView;
}

- (UILabel *)bannerLbl
{
    if (!_bannerLbl) {
        
        _bannerLbl = [[UILabel alloc] init];
        _bannerLbl.font = KBANNER_LBL_FONT;
        _bannerLbl.textColor = [UIColor colorWithHex:THEME_COLOR];
        _bannerLbl.text = NSLocalizedString(@"config_service_node_ing", @"");
        _bannerLbl.numberOfLines = 0;
        _bannerLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _bannerLbl;
}

- (UITableView *)nodeTable
{
    if (!_nodeTable) {
        
        _nodeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, KTABLE_ORIGIN_Y, self.bounds.size.width, CGRectGetHeight(self.frame) / 2) style:UITableViewStylePlain];
        _nodeTable.bounces = NO;
        _nodeTable.delegate = self;
        _nodeTable.dataSource = self;
        _nodeTable.rowHeight = KTABLE_HEIGHT;
        _nodeTable.tableFooterView = [UIView new];
        _nodeTable.backgroundColor = [UIColor clearColor];
    }
    return _nodeTable;
}

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (UIButton *)passBtn
{
    if (!_passBtn) {
        
        _passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passBtn setTitleColor:KPASS_BTN_TITLE_COLOR forState:UIControlStateNormal];
        _passBtn.titleLabel.font = KPASS_BTN_TITLE_FONT;
        [_passBtn setTitle:NSLocalizedString(@"jump_pass", @"") forState:UIControlStateNormal];
        [_passBtn addTarget:self action:@selector(passAction) forControlEvents:UIControlEventTouchUpInside];
        [_passBtn.layer setBorderColor:[UIColor colorWithHex:THEME_COLOR].CGColor];
        [_passBtn.layer setBorderWidth:KPASS_BTN_BORDER_WIDTH];
        _passBtn.layer.cornerRadius = KPASS_BTN_CORNERRADIUS;
        _passBtn.layer.masksToBounds = YES;
    }
    return _passBtn;
}

- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setTitleColor:[UIColor colorWithHex:THEME_COLOR] forState:UIControlStateNormal];
        _refreshButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.f];
        [_refreshButton setTitle:NSLocalizedString(@"action_refresh", @"") forState:UIControlStateNormal];
        [_refreshButton sizeToFit];
        [_refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    [self addSubview:self.imageView];
    [self addSubview:self.bannerLbl];
    [self addSubview:self.gifView];
    [self addSubview:self.passBtn];
    [self addSubview:self.coverView];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(@(KTABLE_ORIGIN_Y));
    }];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    [self.bannerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(KBANNER_LBL_BTTOM);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(@(KScreenW - KPASS_BTN_HEIGHT));
        
    }];
    
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.bannerLbl);
        make.bottom.equalTo(self.bannerLbl.mas_top);
        make.size.mas_equalTo(CGSizeMake(KGIF_EDGE, KGIF_EDGE));
    }];
    
    [self.passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self.bannerLbl.mas_bottom).offset(KPASS_BTN_TOP);
        make.size.mas_equalTo(CGSizeMake(KPASS_BTN_WIDTH, KPASS_BTN_HEIGHT));
    }];
    [self.passBtn setHidden:YES];
    [self addSubview:self.nodeTable];
    [self addSubview:self.refreshButton];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(40);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    [self.refreshButton setHidden:YES];

}




- (void)showNodeInfo:(NSMutableArray *)nodes
{
    [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:nodes];
    [self.nodeTable reloadData];
    [self.passBtn setHidden:NO];
    [self.refreshButton setHidden:NO];
    [self.gifView removeFromSuperview];
    self.gifView = nil;
    [self.bannerLbl setAttributedText:[self _getAttributedString]];
}

- (NSAttributedString *)_getAttributedString
{
    NSString *str = [NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"test_service_fail_tip", @""),CUSTOMER_SERVICE_EMAIL];
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size:14], NSForegroundColorAttributeName:[UIColor colorWithHex:THEME_COLOR]}];
    
    if ([str rangeOfString:CUSTOMER_SERVICE_EMAIL].location != NSNotFound) {
        
        NSRange range = [str rangeOfString:CUSTOMER_SERVICE_EMAIL];
        
        [mAttr addAttributes:@{NSForegroundColorAttributeName: RGBACOLOR(17, 119, 216, 1), NSFontAttributeName: [UIFont fontWithName:FONT_NAME_REGULAR size:14.f]} range:range];
    }
    NSAttributedString *string = [[NSAttributedString alloc] initWithAttributedString:mAttr];
    
    return string;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NetworkStatusCell";
    NetworkStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[NetworkStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dic = self.datasource[indexPath.row];
    cell.nodeName = [dic objectForKey:@"name"];
    cell.status = [[dic objectForKey:@"status"] boolValue];
    
    return cell;
}


- (void)passAction
{
    !_passBlock ?: _passBlock();
}

- (void)refreshAction
{
    [self.datasource removeAllObjects];
    [self.nodeTable reloadData];
    [self.passBtn setHidden:YES];
    self.bannerLbl.text = NSLocalizedString(@"config_service_node_ing", @"");
    [self addSubview:self.gifView];
    [self.gifView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.bannerLbl);
        make.bottom.equalTo(self.bannerLbl.mas_top);
        make.size.mas_equalTo(CGSizeMake(KGIF_EDGE, KGIF_EDGE));
    }];
    [self.refreshButton setHidden:YES];
    !_refreshBlock ?:_refreshBlock();
    
}


@end
