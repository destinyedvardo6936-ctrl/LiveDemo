//
//  LCAccountDetailsTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCBaseTableViewCell.h"
#import "LCAccountDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCAccountDetailsTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCAccountDetailsModel *dataModel;
@end

NS_ASSUME_NONNULL_END
