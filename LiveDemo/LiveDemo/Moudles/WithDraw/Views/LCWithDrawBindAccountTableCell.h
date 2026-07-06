//
//  LCWithDrawBindAccountTableCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCWithDrawBindAccountTableCell : LCBaseTableViewCell
@property (nonatomic , copy) NSString *leftTitle;
@property (nonatomic , copy) NSString *rightTitle;
@property (nonatomic , copy) NSString *rightHoldTitle;
@property (nonatomic , copy) void(^textChangeBlock)(NSString *leftTitle,NSString *text);

@end

NS_ASSUME_NONNULL_END
