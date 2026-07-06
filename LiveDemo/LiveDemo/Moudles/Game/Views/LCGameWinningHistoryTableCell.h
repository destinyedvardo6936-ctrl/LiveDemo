//
//  LCGameWinningHistoryTableCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseTableViewCell.h"
#import "LCGameWinningHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCGameWinningHistoryTableCell : LCBaseTableViewCell
@property (nonatomic , strong) LCGameWinningHistoryModel *dataModel;
@end

NS_ASSUME_NONNULL_END
