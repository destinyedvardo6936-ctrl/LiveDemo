//
//  LCRechargeMoneyTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCBaseTableViewCell.h"
#import "LCRechargeMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeMoneyTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) NSArray *dataArr;
@property (nonatomic , copy) void(^labelSelectedBlock)(LCRechargeMoneyModel *model);
@end

NS_ASSUME_NONNULL_END
