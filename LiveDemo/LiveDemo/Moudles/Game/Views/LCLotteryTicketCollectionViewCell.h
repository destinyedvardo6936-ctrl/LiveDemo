//
//  LCLotteryTicketCollectionViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/21.
//

#import "LCBaseCollectionViewCell.h"
#import "LCLotteryTicketPlayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketCollectionViewCell : LCBaseCollectionViewCell
@property (nonatomic , strong) LCLotteryTicketWanFaModel *dataModel;
@end

NS_ASSUME_NONNULL_END
