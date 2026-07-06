//
//  LCLiveActivityTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/10.
//

#import "LCBaseTableViewCell.h"
#import "LCActivityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveActivityTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCActivityModel *dataModel;
@end

NS_ASSUME_NONNULL_END
