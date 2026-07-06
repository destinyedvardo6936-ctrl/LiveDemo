//
//  LCLotteryTicketCoinView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/21.
//

#import <UIKit/UIKit.h>
#import "LCLotteryTicketPlayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketCoinView : UIView
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , copy) void (^coinSelectBlock)(LCLotteryTicketCoinModel *model);
@end

NS_ASSUME_NONNULL_END
