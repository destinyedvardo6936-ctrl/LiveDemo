//
//  LCRechargeRecordModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/6/8.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeRecordModel : LCBaseModel
@property (nonatomic , copy) NSString              * modelId;
@property (nonatomic , copy) NSString              * money;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * coin_give;
@property (nonatomic , copy) NSString              * addtime;
@property (nonatomic , copy) NSString              * orderno;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * ambient;
@property (nonatomic , copy) NSString              * trade_no;
@property (nonatomic , copy) NSString              * touid;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * coin;
@end

NS_ASSUME_NONNULL_END
