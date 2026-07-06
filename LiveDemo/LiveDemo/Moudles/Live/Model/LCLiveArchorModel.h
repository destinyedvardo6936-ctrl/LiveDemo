//
//  LCLiveArchorModel.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveArchorModel : LCBaseModel
@property (nonatomic , copy) NSString              * uid;//主播id
@property (nonatomic , copy) NSString              * user_nicename;//直播昵称
@property (nonatomic , copy) NSString              * level;//主播等级
@property (nonatomic , copy) NSString              * level_anchor;//主播等级
@property (nonatomic , copy) NSString              *isAttention;
@property (nonatomic , copy) NSString               *avatar_thumb;
@end

NS_ASSUME_NONNULL_END
