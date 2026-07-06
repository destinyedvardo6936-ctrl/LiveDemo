//
//  LCActivityListViewController.h
//  LiveDemo
//
//  Created by mrgao on 2023/1/3.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
#import "LCActivityTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCActivityListViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , strong) LCActivityTypeModel *dataModel;
@end

NS_ASSUME_NONNULL_END
