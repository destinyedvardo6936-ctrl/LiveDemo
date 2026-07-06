//
//  LCLoginUserNameApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLoginUserNameApi : LCBaseApi
@property (nonatomic , copy) NSString *username;
@property (nonatomic , copy) NSString *password;
@property (nonatomic , copy) NSString *country_code;
@end

NS_ASSUME_NONNULL_END
