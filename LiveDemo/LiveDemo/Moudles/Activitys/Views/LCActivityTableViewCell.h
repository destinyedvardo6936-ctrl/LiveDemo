//
//  LCActivityTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/3.
//

#import "LCBaseTableViewCell.h"
#import "LCActivityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCActivityTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCActivityModel *dataModel;
@end

NS_ASSUME_NONNULL_END
