//
//  LCBaseListApi.h
//  liveCommon
//
//  Created by mrgao on 2022/9/28.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCBaseListApi : LCBaseApi
@property(nonatomic, assign) NSInteger page;//翻页页码（从1开始）
@end

NS_ASSUME_NONNULL_END
