//
//  ONEGroupMemberCell.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/30.
//  Copyright © 2018 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ONEGroupMemberCellDelegate<NSObject>

- (void)didLongPressItem:(NSString *)remark;

@end

@interface ONEGroupMemberCell : UICollectionViewCell

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger roleType;

@property (nonatomic, weak) id<ONEGroupMemberCellDelegate>delegate;
@end
