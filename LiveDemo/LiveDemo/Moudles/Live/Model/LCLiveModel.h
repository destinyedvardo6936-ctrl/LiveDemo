//
//  LCLiveModel.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/26.
//

#import "LCBaseModel.h"
#import "LCLiveUserModel.h"
#import "LCLiveDetailGuardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveModel : LCBaseModel
@property (nonatomic , copy) NSArray<NSString *>              * gamebet;
@property (nonatomic , copy) NSString              * barrage_limit;
@property (nonatomic , copy) NSString              * guard_nums;
@property (nonatomic , copy) NSString              * gameid;
@property (nonatomic , copy) NSString              * issuper;

@property (nonatomic , copy) NSString              * votestotal;

@property (nonatomic , copy) NSString              * coin;
@property (nonatomic , copy) NSString              * linkmic_pull;

@property (nonatomic , copy) NSString              * gametime;
@property (nonatomic , copy) NSString              * jackpot_level;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , copy) NSString              * speak_limit;
@property (nonatomic , copy) NSString              * game_banker_avatar;
@property (nonatomic , copy) NSString              * game_banker_limit;
@property (nonatomic , copy) NSString              * isred;
@property (nonatomic , copy) NSString              * gameaction;
@property (nonatomic , copy) NSString              * game_bankerid;

@property (nonatomic , copy) NSString              * isattention;
@property (nonatomic , copy) NSString              * linkmic_uid;

@property (nonatomic , copy) NSString              * userlist_time;

@property (nonatomic , copy) NSString              * chatserver;
@property (nonatomic , copy) NSString              * game_banker_coin;
@property (nonatomic , copy) NSString              * nums;

@property (nonatomic , copy) NSString              * barrage_fee;

@property (nonatomic , copy) NSString              * pull;

@property (nonatomic , copy) NSString              * uid;//主播id

@property (nonatomic , copy) NSString              * stream;//流名

@property (nonatomic , copy) NSArray  <LCLiveUserModel *>*userlists;

@property (nonatomic , copy) NSString              * vip_type;
@property (nonatomic , copy) NSString              * liang_name;
@property (nonatomic , copy) NSString              * guard_type;
@property (nonatomic , strong) LCLiveDetailGuardModel *guard;


@end

NS_ASSUME_NONNULL_END
