//
//  LDTabBarViewController.h
//  LDHeadlines
//
//  Created by mrgao on 2019/12/3.
//  Copyright © 2019 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCTabBarViewController : UITabBarController
- (void)makeTabbarViewHidden:(BOOL)hidden;
- (void)selectAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
