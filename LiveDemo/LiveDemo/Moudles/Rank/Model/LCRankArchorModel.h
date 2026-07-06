//
//  LCRankArchorModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/1.
//

#import "LCBaseModel.h"
#import "LCHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRankArchorModel : LCBaseModel
@property (nonatomic , copy) NSString *user_nicename;
@property (nonatomic , copy) NSString *avatar_thumb;
@property (nonatomic , copy) NSString *totalcoin;
@property (nonatomic , copy) NSString *uid;
@property (nonatomic , copy) NSString *level_anchor;
@property (nonatomic , copy) NSString *level;
@property (nonatomic , copy) NSString *isAttention;
@property (nonatomic , copy) NSString *luohou;
@property (nonatomic , copy) NSString *islive;
@property (nonatomic , assign) NSInteger rankNum;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , strong) LCHomeListModel *live;
@end

NS_ASSUME_NONNULL_END
