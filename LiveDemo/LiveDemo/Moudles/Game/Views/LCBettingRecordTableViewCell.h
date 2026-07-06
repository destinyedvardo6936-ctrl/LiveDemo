//
//  LCBettingRecordTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseTableViewCell.h"
#import "LCBettingRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCBettingRecordTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCBettingRecordModel *dataModel;
@end

NS_ASSUME_NONNULL_END
