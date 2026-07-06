//
//  LCRechargeRecordTableCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCBaseTableViewCell.h"
#import "LCRechargeRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeRecordTableCell : LCBaseTableViewCell
@property (nonatomic , strong) LCRechargeRecordModel *dataModel;
@end

NS_ASSUME_NONNULL_END
