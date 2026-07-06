//
//  LCLotteryTicketConfirmTableCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import "LCBaseTableViewCell.h"
#import "LCLotteryTicketPlayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketConfirmTableCell : LCBaseTableViewCell
@property (nonatomic , strong) LCLotteryTicketWanFaModel *dataModel;
@property (nonatomic , copy) void (^moneyClickBlock)(LCLotteryTicketWanFaModel *selectModel);
@property (nonatomic , copy) void (^deleteBlock)(LCLotteryTicketWanFaModel *selectModel);
@end

NS_ASSUME_NONNULL_END
