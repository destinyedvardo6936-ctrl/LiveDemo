//
//  LCLotteryTicketXiazhuApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/23.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketXiazhuApi : LCBaseApi
@property (nonatomic , copy) NSString *zhuboid;//主播id
@property (nonatomic , copy) NSString *wanfaxiid;//细分玩法id
@property (nonatomic , copy) NSString *biaoshi;//彩票标识
@property (nonatomic , copy) NSString *zhushu;//注数
@property (nonatomic , copy) NSString *beishu;//倍数
@property (nonatomic , copy) NSString *money;//金额
@property (nonatomic , copy) NSString *value;//投注号码
@end

NS_ASSUME_NONNULL_END
