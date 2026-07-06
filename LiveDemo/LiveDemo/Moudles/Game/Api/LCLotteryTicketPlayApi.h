//
//  LCLotteryTicketPlayApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketPlayApi : LCBaseApi
@property (nonatomic , copy) NSString *gameId;
@property (nonatomic , copy) NSString *biaoshi;
@end

NS_ASSUME_NONNULL_END
