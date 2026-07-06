//
//  LCHomeSubViewController.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCHomeRecommendPageViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , copy) NSString *currentChannel;
@end

NS_ASSUME_NONNULL_END
