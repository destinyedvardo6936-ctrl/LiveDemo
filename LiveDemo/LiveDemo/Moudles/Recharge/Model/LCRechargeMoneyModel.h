//
//  LCRechargeModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeMoneyModel : LCBaseModel
@property (nonatomic , copy) NSString              * payWayId;
@property (nonatomic , copy) NSString              * list_order;
@property (nonatomic , copy) NSString              * addtime;
@property (nonatomic , copy) NSString              * coin_paypal;
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * product_id;
@property (nonatomic , copy) NSString              * coin;
@property (nonatomic , copy) NSString              * coin_ios;
@property (nonatomic , copy) NSString              * give;
@property (nonatomic , copy) NSString              * money;

@property (nonatomic , assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
