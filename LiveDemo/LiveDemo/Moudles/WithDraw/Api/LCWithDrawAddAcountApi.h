//
//  LCWithDrawAddAcountApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCWithDrawAddAcountApi : LCBaseApi
@property (nonatomic , copy) NSString *type;//1表示支付宝，2表示微信，3表示银行卡
@property (nonatomic , copy) NSString *account_bank;
@property (nonatomic , copy) NSString *account;
@property (nonatomic , copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
