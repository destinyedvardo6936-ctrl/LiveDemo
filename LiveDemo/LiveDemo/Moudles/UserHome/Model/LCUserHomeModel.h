//
//  LCUserHomeModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCBaseModel.h"
#import "LCHomeListModel.h"
#import "LCUserContributeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCUserHomeModel : LCBaseModel
@property (nonatomic , copy) NSString              * isblack;
@property (nonatomic , copy) NSArray<LCUserContributeModel *>              * contribute;
@property (nonatomic , copy) NSString              * fans;
@property (nonatomic , copy) NSString              * modelId;

@property (nonatomic , copy) NSString              * level;


@property (nonatomic , copy) NSString              * avatar_thumb;
@property (nonatomic , copy) NSString              * location;
@property (nonatomic , copy) NSString              * islive;

@property (nonatomic , copy) NSString              * votestotal;

@property (nonatomic , copy) NSString              * level_anchor;
@property (nonatomic , strong) LCHomeListModel              * live;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * user_status;
@property (nonatomic , copy) NSString              * birthday;


@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * avatar;

@property (nonatomic , copy) NSString              * user_nicename;

@property (nonatomic , copy) NSString              * isattention;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * follows;

@property (nonatomic , copy) NSString              * signature;

@end

NS_ASSUME_NONNULL_END
