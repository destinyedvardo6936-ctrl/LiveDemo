//
//  LCGameTypeTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/16.
//

#import "LCBaseTableViewCell.h"
#import "LCGameTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCGameTypeTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCGameTypeModel *dataModel;
@end

NS_ASSUME_NONNULL_END
