//
//  LCUserInfoApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/4.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCUserInfoApi : LCBaseApi
@property (nonatomic , copy) NSString *userId;
@property (nonatomic , copy) NSString *userToken;
@end

NS_ASSUME_NONNULL_END
