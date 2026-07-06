//
//  LCBaseViewController.h
//  liveCommon
//
//  Created by mrgao on 2022/9/28.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager.h>
#import "LCBaseViewControllerProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCBaseViewController : UIViewController<LCBaseViewControllerProtocol>
- (void)pushToViewController:(UIViewController *)vc;

- (void)pushToViewController:(UIViewController *)vc animation:(BOOL)animition;

- (void)popBack;
@end

NS_ASSUME_NONNULL_END
