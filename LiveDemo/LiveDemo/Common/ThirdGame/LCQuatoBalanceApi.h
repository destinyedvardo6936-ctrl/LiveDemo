//
//  LCQuatoBalanceApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCQuatoBalanceApi : LCBaseApi
@property (nonatomic,copy)NSString *biaoshi;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *code;
@end

NS_ASSUME_NONNULL_END
