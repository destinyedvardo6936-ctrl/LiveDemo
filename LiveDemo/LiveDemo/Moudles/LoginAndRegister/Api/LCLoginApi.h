//
//  LCLoginApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/17.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLoginApi : LCBaseApi
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *code;
@property (nonatomic , copy) NSString *country_code;
@end

NS_ASSUME_NONNULL_END
