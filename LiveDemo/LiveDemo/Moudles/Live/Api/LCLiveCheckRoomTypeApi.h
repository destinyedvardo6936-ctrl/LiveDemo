//
//  LCLiveCheckRoomTypeApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/25.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveCheckRoomTypeApi : LCBaseApi
@property (nonatomic , copy) NSString *liveuid;
@property (nonatomic , copy) NSString *stream;
@end

NS_ASSUME_NONNULL_END
