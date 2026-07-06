//
//  LCHomeLiveListViewController.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/22.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCHomeLiveListViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , copy) NSString *currentFirstChannel;
@property (nonatomic , copy) NSString *channelId;

@property (nonatomic , weak) LCBaseCollectionView *mainCollectionView;
@property (nonatomic, copy) void(^scrollListCallback)(UIScrollView *scrollView);
@end

NS_ASSUME_NONNULL_END
