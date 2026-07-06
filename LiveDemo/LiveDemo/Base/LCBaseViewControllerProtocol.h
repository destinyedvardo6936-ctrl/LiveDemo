//
//  LCBaseViewControllerProtocol.h
//  liveCommon
//
//  Created by mrgao on 2022/9/28.
//

#import <Foundation/Foundation.h>
#import "LCLoadingView.h"
#import "LCNoDataView.h"
#import "LCNoNetworkView.h"
#import "LCBaseNavigationView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol LCBaseViewControllerProtocol <NSObject>

@optional
@property (nonatomic,assign) BOOL needHiddenInteractivePopGestureRecognizer;
@property (nonatomic,weak) LCLoadingView *loadingAnimationView;
@property (nonatomic,weak) LCNoDataView *emptyDataView;
@property (nonatomic,weak) LCNoNetworkView *disconnectView;
@property (nonatomic,weak) LCBaseNavigationView *navView;

/// 绑定viewmodel
- (void)lc_bindViewModel;

/// 添加子View
- (void)lc_addSubviews;

/// viewWillAppear时刷新数据
- (void)lc_updatePageNewData;

/// viewWillAppear时刷新View
- (void)lc_updatePageViews;
@end

NS_ASSUME_NONNULL_END
