//
//  LCGamePlayViewController.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCBaseViewController.h"
#import "LCGameListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketPlayViewController : LCBaseViewController
//@property (nonatomic , copy) NSString *titleStr;
@property (nonatomic , strong) LCGameListModel *dataModel;
@end

NS_ASSUME_NONNULL_END
