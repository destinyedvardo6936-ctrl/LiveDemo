//
//  LCLiveLotteryTicketCoinView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import <UIKit/UIKit.h>
#import "LCLotteryTicketPlayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveLotteryTicketCoinView : UIView
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , copy) void (^coinSelectBlock)(LCLotteryTicketCoinModel *model);
@end

NS_ASSUME_NONNULL_END
