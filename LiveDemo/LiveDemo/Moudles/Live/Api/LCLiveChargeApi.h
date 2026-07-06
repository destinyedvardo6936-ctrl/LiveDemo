//
//  LCLiveChargeApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/29.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveChargeApi : LCBaseApi
@property (nonatomic , copy) NSString *roomId;
@property (nonatomic , copy) NSString *stream;
@end

NS_ASSUME_NONNULL_END
