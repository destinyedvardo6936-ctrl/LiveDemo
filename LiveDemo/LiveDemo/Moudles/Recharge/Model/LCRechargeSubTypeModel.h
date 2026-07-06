//
//  LCRechargeSubTypeModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCBaseModel.h"
#import "LCRechargeMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeSubTypeModel : LCBaseModel
@property (nonatomic , copy) NSString *modelId;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *payid;
@property (nonatomic , copy) NSString *paycode;
@property (nonatomic , copy) NSString              * qudaoid;
@property (nonatomic , assign) NSInteger type;
@property (nonatomic , copy) NSArray              <LCRechargeMoneyModel *>* moneylist;
@property (nonatomic , copy) NSString              * bianma;




@property (nonatomic , assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
