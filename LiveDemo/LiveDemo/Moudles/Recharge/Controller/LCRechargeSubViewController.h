//
//  LCRechargeSubViewController.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
#import "LCRechargeTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeSubViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , strong) LCRechargeTypeModel *dataModel;
@end

NS_ASSUME_NONNULL_END
