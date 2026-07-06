//
//  LCRechargeConnetPersonModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeConnetPersonModel : LCBaseModel
@property (nonatomic , copy) NSString              * qq;
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * payWayId;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * wx;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * bankare;
@property (nonatomic , copy) NSString              * bankno;
@property (nonatomic , copy) NSString              * type;


//虚拟币数量
@property (nonatomic , copy) NSString              * virtualCount;
@end

NS_ASSUME_NONNULL_END
