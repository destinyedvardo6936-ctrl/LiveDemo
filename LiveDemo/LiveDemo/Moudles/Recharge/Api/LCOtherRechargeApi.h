//
//  LCOtherRechargeApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCOtherRechargeApi : LCBaseApi
@property (nonatomic , copy) NSString *qudaoid;
@property (nonatomic , copy) NSString *paytypeid;
@property (nonatomic , copy) NSString *moneylistid;
@property (nonatomic , copy) NSString *money;
@end

NS_ASSUME_NONNULL_END
