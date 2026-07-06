//
//  UIViewController+LCExtension.m
//  LDHeadlines
//
//  Created by mrgao on 2019/12/9.
//  Copyright © 2019 personal. All rights reserved.
//

#import "UIViewController+LCExtension.h"
#import <objc/runtime.h>



@implementation UIViewController (LDExtension)
+ (void)load{
    Method carshMethod = class_getInstanceMethod([self class], @selector(presentViewController: animated: completion:));
    Method newMethod = class_getInstanceMethod([self class], @selector(ttpresentViewController: animated: completion:));
    method_exchangeImplementations(carshMethod, newMethod);
}

- (void)ttpresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (@available
    (iOS
    13.0, *)) {
        // iOS13以后style默认UIModalPresentationAutomatic，以前版本xcode没有这个枚举，所以只能写-2
        if (viewControllerToPresent.modalPresentationStyle == -2 || viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    [self ttpresentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)pushToViewController:(UIViewController *)vc animation:(BOOL)animition {
  


    [self.navigationController pushViewController:vc animated:YES];
}

@end
