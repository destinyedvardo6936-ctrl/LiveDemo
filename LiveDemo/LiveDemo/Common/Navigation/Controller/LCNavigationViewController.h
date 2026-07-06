//
//  LDNavigationViewController.h
//  LDHeadlines
//
//  Created by mrgao on 2019/12/3.
//  Copyright © 2019 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNavigationViewController : UINavigationController
@property(nonatomic, assign) BOOL isPushing;
@property (nonatomic,strong,readonly)UIPanGestureRecognizer *backGes;
@end

NS_ASSUME_NONNULL_END
