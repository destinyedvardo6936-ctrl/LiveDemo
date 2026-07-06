//
//  LCUpdatePersonalInfoApi.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCUpdatePersonalInfoApi : LCBaseApi
@property (nonatomic , copy) NSString *nickname;

@property (nonatomic , copy) NSString *profile;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString *sex;
@property (nonatomic , copy) NSString *avaterStr;
@end

NS_ASSUME_NONNULL_END
