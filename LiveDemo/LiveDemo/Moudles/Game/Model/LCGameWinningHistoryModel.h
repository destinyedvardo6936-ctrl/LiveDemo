//
//  LCGameWinningHistoryModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCGameWinningHistoryModel : LCBaseModel
@property (copy, nonatomic) NSString  *datetime;//时间

@property (copy, nonatomic) NSString *totalcoin;//金额

@property (copy, nonatomic) NSString  *is_ok;//是否中奖 1中奖 0没有中奖

@property (copy, nonatomic) NSString *ok; //1开奖

@property (copy, nonatomic) NSString  *game_id; //游戏ID

@property (copy, nonatomic) NSString  *result; //jieguo

@property (copy, nonatomic) NSString  *stateId;//用来获取详情的ID

@property (copy, nonatomic) NSString  *magnification; //倍率

@property (copy, nonatomic) NSString  *expect; //倍率


@property (copy, nonatomic) NSString  *opencode; //倍率
@property (copy, nonatomic) NSString  *title;
@end

NS_ASSUME_NONNULL_END
