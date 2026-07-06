//
//  LCBetingRecordViewController.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/9.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCTotalBetingRecordViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , assign) BOOL isBc;
@end

NS_ASSUME_NONNULL_END
