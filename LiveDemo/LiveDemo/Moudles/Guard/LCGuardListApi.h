//
//  LCGuardListApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/24.
//

#import "LCBaseListApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCGuardListApi : LCBaseListApi
@property (nonatomic , copy) NSString *liveId;
@property (nonatomic , assign) NSInteger page;
@end

NS_ASSUME_NONNULL_END
