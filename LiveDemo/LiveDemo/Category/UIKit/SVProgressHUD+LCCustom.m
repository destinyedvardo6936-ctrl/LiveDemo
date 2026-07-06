//
//  SVProgressHUD+LCCustom.m
//  LDHeadlines
//
//  Created by mrgao on 2019/12/26.
//  Copyright © 2019 personal. All rights reserved.
//

#import "SVProgressHUD+LCCustom.h"

@implementation SVProgressHUD (LCCustom)
+ (void)showWithMaskView{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
}
+ (void)showMaskViewWithInfo:(NSString *)info{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showInfoWithStatus:info];
}
+ (void)showMaskViewWithSuccess:(NSString *)info{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showSuccessWithStatus:info];
}
+ (void)showMaskViewWithFailure:(NSString *)info{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showErrorWithStatus:info];
}
/// 无遮挡手势的loading
+ (void)showNoMaskView{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showImage];
}
+ (void)showNoMaskViewWithInfo:(NSString *)info{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showInfoWithStatus:info];
}
+ (void)showNoMaskViewWithSuccess:(NSString *)info{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showSuccessWithStatus:info];
}
+ (void)showNoMaskViewWithFailure:(NSString *)info{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showErrorWithStatus:info];
}
+ (void)showImage{
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 90; i > 0; i --) {
        NSString *imgName = [NSString stringWithFormat:@"loadingCustom%ld",i];
        [images addObject:image(imgName)];
    }
    UIImage *image = [UIImage animatedImageWithImages:images duration:6.3];
    [self showImage:image status:@"正在加载中"];
 
}
+ (void)showImageWithTitle:(NSString *)title{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 90; i > 0; i --) {
        NSString *imgName = [NSString stringWithFormat:@"loadingCustom%ld",i];
        [images addObject:image(imgName)];
    }
    UIImage *image = [UIImage animatedImageWithImages:images duration:6.3];
    [self showImage:image status:title];
}
+ (void)showImageNoMaskWithTitle:(NSString *)title{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}
@end
