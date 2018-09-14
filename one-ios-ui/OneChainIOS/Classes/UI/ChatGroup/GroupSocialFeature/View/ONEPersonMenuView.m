//
//  ONEPersonMenuView.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/12.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEPersonMenuView.h"
#import "ONEPersonMenuCell.h"
static const CGFloat MENU_HEIGHT = 48.f;
static const CGFloat EDGE_PADDING = 10.f;
@interface ONEPersonMenuView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) PersonMenuType type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *menus;
@end

@implementation ONEPersonMenuView

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = MENU_HEIGHT;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight =0;
            _tableView.estimatedSectionFooterHeight =0;
        }
    }
    return _tableView;
}

- (NSMutableArray *)menus
{
    if (!_menus) {
        
        _menus = [NSMutableArray array];
    }
    return _menus;
}

- (instancetype)initWithEffect:(UIVisualEffect *)effect type:(PersonMenuType)type
{
    self = [super initWithEffect:effect];
    if (self) {
        _type = type;
        [self setFrame:CGRectMake(0, 0, KScreenW - 2 * EDGE_PADDING, [self heightFromPersonMenuType:_type])];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    [self.contentView addSubview:self.tableView];
    [self.menus removeAllObjects];
    [self.menus addObjectsFromArray:[self datasourceFromPersonMenuType:_type]];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *personCell = @"PersonMenuCell";
    ONEPersonMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:personCell];
    if (!cell) {
        cell = [[ONEPersonMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personCell];
    }
    NSString *menuTitle = self.menus[indexPath.row];
    cell.menuTitle = menuTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.menus[indexPath.row];
    if ([title isEqualToString:NSLocalizedString(@"button_check_means_card", @"")]) {
        if (_delegate && [_delegate respondsToSelector:@selector(personalCenterAction)]) {
            [_delegate personalCenterAction];
        }
    } else if ([title isEqualToString:NSLocalizedString(@"button_banned_to_post", @"")]) {
        if (_delegate && [_delegate respondsToSelector:@selector(userBeingMuted)]) {
            [_delegate userBeingMuted];
        }
    } else if ([title isEqualToString:@"@TA"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(userBeingAted)]) {
            [_delegate userBeingAted];
        }
    } else if ([title isEqualToString:NSLocalizedString(@"button_set_as_manager", @"")]) {
        if (_delegate && [_delegate respondsToSelector:@selector(userBeingSetAdmin)]) {
            [_delegate userBeingSetAdmin];
        }
    } else if ([title isEqualToString:NSLocalizedString(@"button_from_group_delete", @"")]) {
        if (_delegate && [_delegate respondsToSelector:@selector(userBeingRemoved)]) {
            [_delegate userBeingRemoved];
        }
    } else if ([title isEqualToString:NSLocalizedString(@"button_add_blacklist", @"")]) {
        if (_delegate && [_delegate respondsToSelector:@selector(userBeingAddToBlackList)]) {
            [_delegate userBeingAddToBlackList];
        }
    } else if ([title isEqualToString:NSLocalizedString(@"button_cancel", @"")]) {
        if (_delegate && [_delegate respondsToSelector:@selector(cancelAction)]) {
            [_delegate cancelAction];
        }
    }
}


- (CGFloat)heightFromPersonMenuType:(PersonMenuType)type
{
    CGFloat height = 0;
    switch (type) {
        case PersonMenuType_Member:
            height = MENU_HEIGHT * 3;
            break;
            case PersonMenuType_Admin:
            height = MENU_HEIGHT * 6;
            break;
            case PersonMenuType_Owner:
            height = MENU_HEIGHT * 7;
            break;
        default:
            break;
    }
    return height;
}

- (NSArray *)datasourceFromPersonMenuType:(PersonMenuType)type
{
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"button_check_means_card", @"")]];
    switch (type) {
        case PersonMenuType_Member:
        {
            [dataArray addObjectsFromArray:@[@"@TA"]];
        }
            break;
        case PersonMenuType_Admin:
        {
            [dataArray addObjectsFromArray:
                                            @[
                                             NSLocalizedString(@"button_banned_to_post", @""),
                                             @"@TA",
                                             NSLocalizedString(@"button_from_group_delete", @""),
                                             NSLocalizedString(@"button_add_blacklist", @"")
                                             ]
             ];
        }
            break;
            case PersonMenuType_Owner:
        {
            [dataArray addObjectsFromArray:
                                             @[
                                               NSLocalizedString(@"button_set_as_manager", @""),
                                               NSLocalizedString(@"button_banned_to_post", @""),
                                               @"@TA",
                                               NSLocalizedString(@"button_from_group_delete", @""),
                                               NSLocalizedString(@"button_add_blacklist", @"")
                                               ]
             ];
        }
        default:
            break;
    }
    [dataArray addObject:NSLocalizedString(@"button_cancel", @"")];
    
    return [NSArray arrayWithArray:dataArray];
}




@end
