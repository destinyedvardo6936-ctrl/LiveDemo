//
//  LCRechargeAgentViewController.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCBaseViewController.h"
#import "LCRechargeTypeModel.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeAgentViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , strong) LCRechargeTypeModel *dataModel;
@end

NS_ASSUME_NONNULL_END
