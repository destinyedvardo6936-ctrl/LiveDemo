//
//  LCBannerApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCBannerApi : LCBaseApi
@property (nonatomic , copy) NSString *type;//1=PC首页轮播,2=APP首页轮播,5=APP商城轮播,6=APP用户中心轮播
@end

NS_ASSUME_NONNULL_END
