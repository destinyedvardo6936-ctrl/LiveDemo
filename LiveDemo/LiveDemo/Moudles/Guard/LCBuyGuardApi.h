//
//  LCBuyGuardApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/24.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCBuyGuardApi : LCBaseApi
@property (nonatomic , copy) NSString *liveuid;
@property (nonatomic , copy) NSString *stream;
@property (nonatomic , copy) NSString *guardid;
@end

NS_ASSUME_NONNULL_END
