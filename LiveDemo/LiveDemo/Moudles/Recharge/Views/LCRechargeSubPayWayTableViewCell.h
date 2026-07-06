//
//  LCRechargeSubPayWayTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCBaseTableViewCell.h"
#import "LCRechargeSubTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeSubPayWayTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) NSArray *dataArr;
@property (nonatomic , copy) void(^labelSelectedBlock)(LCRechargeSubTypeModel *model);
@end

NS_ASSUME_NONNULL_END
