//
//  ONESelectView.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONESelectView.h"
#import "ONESelectViewCell.h"

static const CGFloat kSelectViewHeight = 45;

@interface ONESelectView()<UITableViewDelegate, UITableViewDataSource>
{
    dispatch_semaphore_t _sema;
}

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation ONESelectView


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.themeMap = @{
                                BGColorName:@"bg_white_color",
                                TableSepColorName:@"conversation_line_color"
                                };
//        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 45;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight =0;
            _tableView.estimatedSectionFooterHeight =0;
        }
    }
    return _tableView;

}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 6)];
        _lineView.themeMap = @{
                               BGColorName:@"conversation_section_color"
                               };
    }
    return _lineView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _items = [NSMutableArray array];
        [self _layoutSubviews];
        _sema = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)_layoutSubviews
{
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:14];
//    [_leftBtn setTitleColor:RGBACOLOR(78, 93, 111, 1) forState:UIControlStateNormal];
    _leftBtn.themeMap = @{
                          TextColorName:@"conversation_title_color"
                          };
    [_leftBtn setTitle:NSLocalizedString(@"all", @"") forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"pulldown_icon"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn sizeToFit];
    [_leftBtn setCenterX:self.width / 4];
    [_leftBtn setCenterY:self.centerY];
    [self resetButtonUI:_leftBtn];
    [self addSubview:_leftBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:14];
//    [_rightBtn setTitleColor:RGBACOLOR(78, 93, 111, 1) forState:UIControlStateNormal];
    _rightBtn.themeMap = @{
                          TextColorName:@"conversation_title_color"
                          };
    [_rightBtn setTitle:NSLocalizedString(@"order_by_comment_time", @"") forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"pulldown_icon"] forState:UIControlStateNormal];

    [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn sizeToFit];
    [_rightBtn setCenterX:(self.width * 3) / 4];
    [_rightBtn setCenterY:self.centerY];
    [self resetButtonUI:_rightBtn];
    [self addSubview:_rightBtn];
    
    [self.tableView setFrame:CGRectMake(0, self.height, self.width / 2, 0)];
    [self addSubview:self.tableView];
}

- (void)resetButtonUI:(UIButton *)btn
{
    CGFloat kPadding = 1;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, - btn.imageView.image.size.width - kPadding , 0, btn.imageView.image.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width + kPadding , 0, -btn.titleLabel.bounds.size.width)];
}


- (NSArray *)leftItems
{
    return @[
             @{@"type":@"left",@"title":NSLocalizedString(@"all", @""),@"cmd":@1},
             @{@"type":@"left",@"title":NSLocalizedString(@"essence", @""),@"cmd":@2},
             @{@"type":@"left",@"title":NSLocalizedString(@"free", @""),@"cmd":@3},
             @{@"type":@"left",@"title":NSLocalizedString(@"charge", @""),@"cmd":@4}
             ];
}

- (NSArray *)rightItems
{
    return @[
             @{@"type":@"right",@"title":NSLocalizedString(@"order_by_comment_time", @""),@"cmd":@6},
             @{@"type":@"right",@"title":NSLocalizedString(@"order_by_time", @""),@"cmd":@1},
             @{@"type":@"right",@"title":NSLocalizedString(@"order_by_comment", @""),@"cmd":@2},
             @{@"type":@"right",@"title":NSLocalizedString(@"order_by_profit_up", @""),@"cmd":@3},
             @{@"type":@"right",@"title":NSLocalizedString(@"order_by_profit_down", @""),@"cmd":@4},
             @{@"type":@"right",@"title":NSLocalizedString(@"order_by_shang", @""),@"cmd":@5}
             ];
}

#pragma mark - public func

- (void)reloadItems:(NSArray *)items left:(BOOL)isLeft
{
    if (!items || items.count == 0) {
        
        [self.items removeAllObjects];
        [self.tableView reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.tableView setHeight:0];
            
        } completion:^(BOOL finished) {
        }];
    } else {
        
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:items];
        CGFloat tableViewH = [self.items count] * kSelectViewHeight + 6;
        [self.tableView reloadData];
        if (isLeft) {
            [self.tableView setX:0];
        } else {
            [self.tableView setX:self.width / 2];
        }
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.tableView setHeight:tableViewH];
        }];
    }
}



#pragma mark - Selectors

- (void)leftBtnAction
{
    _leftBtn.selected = !_leftBtn.isSelected;
    _rightBtn.selected = NO;
    if (_leftBtn.isSelected) {
        
        [self reloadItems:[self leftItems] left:YES];
    } else {
        
        [self reloadItems:nil left:YES];
    }
}

- (void)rightBtnAction
{
    _rightBtn.selected = !_rightBtn.isSelected;
    _leftBtn.selected = NO;
    if (_rightBtn.isSelected) {
        [self reloadItems:[self rightItems] left:NO];
    } else {
        [self reloadItems:nil left:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectCellIdentifier = @"SelectViewCell";
    ONESelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCellIdentifier];
    if (!cell) {
        
        cell = [[ONESelectViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:selectCellIdentifier];
    }
    cell.themeMap = @{
                      BGColorName:@"bg_white_color"
                      };
    NSDictionary *dic = self.items[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.items[indexPath.row];
    if ([dic[@"type"] isEqualToString:@"left"]) {
        
        [_leftBtn setTitle:dic[@"title"] forState:UIControlStateNormal];
        [_leftBtn sizeToFit];
        [self resetButtonUI:_leftBtn];
    } else {
        [_rightBtn setTitle:dic[@"title"] forState:UIControlStateNormal];
        [_rightBtn sizeToFit];
        [self resetButtonUI:_rightBtn];
    }
    [self reloadItems:nil left:NO];
    !_chooseItemBlock ?: _chooseItemBlock(dic);
    _leftBtn.selected = NO;
    _rightBtn.selected = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.lineView;
}

+ (CGFloat)defaultHeight
{
    return kSelectViewHeight;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == nil) {
        
        CGPoint stationPoint = [self.tableView convertPoint:point fromView:self];
        
        if (CGRectContainsPoint(self.tableView.bounds, stationPoint))
        {
            view = self.tableView;
        }
        
    }
    return view;
}
@end
