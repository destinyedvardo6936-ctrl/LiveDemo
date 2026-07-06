//
//  LCQuotaTransApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCQuotaTransApi : LCBaseApi
@property (nonatomic,copy)NSString *biaoshi;
@property (nonatomic,copy)NSString *action;
@property (nonatomic,copy)NSString *amount;
@end

NS_ASSUME_NONNULL_END
