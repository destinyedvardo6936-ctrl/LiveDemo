//
//  LCBettingRecordListViewController.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCBettingRecordListViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , assign) NSInteger type;
@property (nonatomic , copy) NSString *biaoshi;
@end

NS_ASSUME_NONNULL_END
