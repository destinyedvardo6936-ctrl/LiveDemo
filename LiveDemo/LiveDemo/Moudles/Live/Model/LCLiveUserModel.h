//
//  LCLiveUserModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/25.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveUserModel : LCBaseModel


@property (nonatomic , copy) NSString              * location;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * votestotal;
@property (nonatomic , copy) NSString              * avatar_thumb;

@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * signature;
@property (nonatomic , copy) NSString              * consumption;
@property (nonatomic , copy) NSString              * issuper;
@property (nonatomic , copy) NSString              * guard_type;
@property (nonatomic , copy) NSString              * level_anchor;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * user_nicename;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * user_status;
@property (nonatomic , copy) NSString              * avatar;

@property (nonatomic , copy) NSString              * contribution;
@property (nonatomic , copy) NSString              * vip_type;
@property (nonatomic , copy) NSString              * liang_name;

@property (nonatomic , copy) NSString              * usertype;


@property(nonatomic,copy)NSString *isAnchor;
@end

NS_ASSUME_NONNULL_END
