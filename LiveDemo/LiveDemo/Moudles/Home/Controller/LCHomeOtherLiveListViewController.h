//
//  LCHomeOtherLiveListViewController.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/22.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCHomeOtherLiveListViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , copy) NSString *currentChannel;
@end

NS_ASSUME_NONNULL_END
