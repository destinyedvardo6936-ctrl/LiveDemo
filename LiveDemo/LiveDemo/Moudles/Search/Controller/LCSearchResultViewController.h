//
//  LCSearchResultViewController.h
//  LiveDemo
//
//  Created by mrgao on 2023/2/2.
//

#import "LCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCSearchResultViewController : LCBaseViewController
@property (nonatomic,copy)NSString *searchStr;
- (void)reloadData;
- (void)refreshViewWithoutData;
- (void)releaseController;
@end

NS_ASSUME_NONNULL_END
