//
//  LCRechargePersonalTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCBaseTableViewCell.h"
#import "LCRechargeConnetPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRechargePersonalTableViewCell : LCBaseTableViewCell
@property (nonatomic , strong) LCRechargeConnetPersonModel *dataModel;
@property (nonatomic , copy) void(^btnClickBlock)(LCRechargeConnetPersonModel *selectModel,NSInteger type);//type 1qq 2wx;
@end

NS_ASSUME_NONNULL_END
