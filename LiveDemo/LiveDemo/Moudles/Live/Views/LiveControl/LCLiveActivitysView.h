//
//  LCLiveActivitysView.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/10.
//

#import <UIKit/UIKit.h>
#import "LCActivityListViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCLiveActivitysView : UIView
@property (nonatomic , copy) void (^dismissBlock)(void);
@property (nonatomic , copy) void (^activityClickBlock)(LCActivityModel *selectModel);
@end

NS_ASSUME_NONNULL_END
