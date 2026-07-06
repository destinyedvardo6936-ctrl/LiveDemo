//
//  LCLiveViewController.h
//  liveCommon
//
//  Created by mrgao on 2022/9/29.
//

#import "LCBaseViewController.h"
#import "LCHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveViewController : LCBaseViewController
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
