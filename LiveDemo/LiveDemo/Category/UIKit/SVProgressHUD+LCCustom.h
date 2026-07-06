//
//  SVProgressHUD+LCCustom.h
//  LDHeadlines
//
//  Created by mrgao on 2019/12/26.
//  Copyright © 2019 personal. All rights reserved.
//



#import <SVProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVProgressHUD (LCCustom)
+ (void)showImage;
+ (void)showImageWithTitle:(NSString *)title;
+ (void)showImageNoMaskWithTitle:(NSString *)title;

+ (void)showWithMaskView;
+ (void)showMaskViewWithInfo:(NSString *)info;
+ (void)showMaskViewWithSuccess:(NSString *)info;
+ (void)showMaskViewWithFailure:(NSString *)info;
/// 无遮挡手势的loading
+ (void)showNoMaskView;
+ (void)showNoMaskViewWithInfo:(NSString *)info;
+ (void)showNoMaskViewWithSuccess:(NSString *)info;
+ (void)showNoMaskViewWithFailure:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
