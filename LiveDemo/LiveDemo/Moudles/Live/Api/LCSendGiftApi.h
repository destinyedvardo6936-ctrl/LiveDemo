//
//  LCSendGiftApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/14.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCSendGiftApi : LCBaseApi
@property (nonatomic , copy) NSString *liveuid;
@property (nonatomic , copy) NSString *stream;
@property (nonatomic , copy) NSString *giftid;
@property (nonatomic , copy) NSString *giftcount;
@property (nonatomic , copy) NSString *touids;
@property (nonatomic , assign) BOOL ispack;
@end

NS_ASSUME_NONNULL_END
