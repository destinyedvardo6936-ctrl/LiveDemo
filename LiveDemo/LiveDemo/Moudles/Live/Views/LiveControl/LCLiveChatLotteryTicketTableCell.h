//
//  LCLiveChatLotteryTicketTableCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/24.
//

#import "LCBaseTableViewCell.h"
#import "LCChatMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveChatLotteryTicketTableCell : LCBaseTableViewCell
@property (nonatomic , strong) LCChatMessageModel *dataModel;
@property (nonatomic , copy) void (^btnClickedBlock)(LCChatMessageModel *selectModel);
@end

NS_ASSUME_NONNULL_END
