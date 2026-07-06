//
//  LCSendDanMuApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/30.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCSendDanMuApi : LCBaseApi
@property (nonatomic , copy) NSString *liveuid;
@property (nonatomic , copy) NSString *stream;
@property (nonatomic , copy) NSString *content;
@end

NS_ASSUME_NONNULL_END
