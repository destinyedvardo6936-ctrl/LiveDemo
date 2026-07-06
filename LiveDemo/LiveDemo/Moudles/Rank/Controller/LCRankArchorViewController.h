//
//  LCRankArchorViewController.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCRankArchorViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , assign) BOOL isArchorList;
@end

NS_ASSUME_NONNULL_END
