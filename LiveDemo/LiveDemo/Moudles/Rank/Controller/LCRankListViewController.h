//
//  LCRankListViewController.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/25.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCRankListViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic , weak) LCBaseTableView *mainTableView;
@property (nonatomic , assign) BOOL isArchorList;
@property (nonatomic , copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
