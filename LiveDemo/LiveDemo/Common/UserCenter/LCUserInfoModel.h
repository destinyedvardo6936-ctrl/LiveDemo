//
//  LCUserInfoModel.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCUserInfoModel : LCBaseModel
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * avatar_thumb;
@property (nonatomic , copy) NSString              * coin;

@property (nonatomic , copy) NSString              * votes;
@property (nonatomic , copy) NSString              * mobile;
@property (nonatomic , copy) NSString              * user_login;
@property (nonatomic , copy) NSString              * source;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , copy) NSString              * signature;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * level_anchor;
@property (nonatomic , copy) NSString              * lives;
@property (nonatomic , copy) NSString              * follows;
@property (nonatomic , copy) NSString              * fans;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * user_nicename;
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , copy) NSString              * vip_type;
@property (nonatomic , copy) NSString              * liang_name;
@property (nonatomic , assign) NSInteger              create_time;
@property (nonatomic , copy) NSString              * country_code;
@property (nonatomic , copy) NSString              * user_status;
@property (nonatomic , copy) NSString              * user_type;
@property (nonatomic , copy) NSString              * isdaili;
@property (nonatomic , copy) NSString              * isyouke;
@end

NS_ASSUME_NONNULL_END
