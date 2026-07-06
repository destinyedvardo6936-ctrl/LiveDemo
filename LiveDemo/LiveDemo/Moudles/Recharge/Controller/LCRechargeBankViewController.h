//
//  LCRechargeBankViewController.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
#import "LCRechargeTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCRechargeBankViewController : LCBaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic , strong) LCRechargeTypeModel *dataModel;

@end

NS_ASSUME_NONNULL_END
