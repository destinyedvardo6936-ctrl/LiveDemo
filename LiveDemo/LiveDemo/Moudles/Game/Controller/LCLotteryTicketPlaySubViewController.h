//
//  LCGamePlaySubViewController.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/18.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCLotteryTicketPlaySubViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , strong) NSMutableArray *dataArray;
@end

NS_ASSUME_NONNULL_END
