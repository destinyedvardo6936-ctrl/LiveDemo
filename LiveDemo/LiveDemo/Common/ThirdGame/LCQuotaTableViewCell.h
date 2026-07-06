//
//  LCQuotaTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCBaseTableViewCell.h"
#import "LCQuotaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCQuotaTableViewCell : LCBaseTableViewCell
@property (nonatomic,strong)LCQuotaModel *dataModel;
@property (nonatomic , copy)void (^selectBalanceBlock)(LCQuotaModel *selectModel);
@property (nonatomic , copy)void (^transInBlock)(LCQuotaModel *selectModel);
@property (nonatomic , copy)void (^transOutBlock)(LCQuotaModel *selectModel);
@end

NS_ASSUME_NONNULL_END
