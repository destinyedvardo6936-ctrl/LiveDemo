//
//  LCLiveDetailApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveDetailApi : LCBaseApi
@property (nonatomic , copy) NSString *liveuid;
@property (nonatomic , copy) NSString *stream;

@end

NS_ASSUME_NONNULL_END
