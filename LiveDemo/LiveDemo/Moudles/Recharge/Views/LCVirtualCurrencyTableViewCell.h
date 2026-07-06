//
//  LCVirtualCurrencyTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCBaseTableViewCell.h"
#import "LCRechargeConnetPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCVirtualCurrencyTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCRechargeConnetPersonModel *dataModel;
@property (nonatomic , copy) void(^submitBlock)(void);
@end

NS_ASSUME_NONNULL_END
