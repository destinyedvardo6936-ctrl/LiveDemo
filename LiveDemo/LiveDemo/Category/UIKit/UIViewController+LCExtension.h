//
//  UIViewController+LCExtension.h
//  LDHeadlines
//
//  Created by mrgao on 2019/12/9.
//  Copyright © 2019 personal. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LDExtension)

- (void)pushToViewController:(UIViewController *)vc animation:(BOOL)animition;
@end

NS_ASSUME_NONNULL_END
