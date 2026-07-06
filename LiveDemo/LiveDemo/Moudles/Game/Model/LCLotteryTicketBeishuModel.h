//
//  LCLotteryTicketBeishuModel.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/22.
//

#import "LCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketBeishuModel : LCBaseModel
@property (nonatomic , copy) NSString              * name;

@property (nonatomic , assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
