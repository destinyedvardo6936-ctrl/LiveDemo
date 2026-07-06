//
//  UIImageView+LCExtension.h
//  LDHeadlines
//
//  Created by mrgao on 2019/12/2.
//  Copyright © 2019 personal. All rights reserved.
//




#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^UIImageViewCompleteBlock)(UIImage * _Nullable image, NSError * _Nullable error);
@interface UIImageView (LDExtension)
- (void)setImageStr:(NSString *)imageStr;
- (void)setImageStr:(NSString *)imageStr placeholder:(NSString *)placeHolder;
- (void)setImageStr:(NSString *)imageStr placeholderImage:(UIImage *)placeHolder;
- (void)setImageStr:(NSString *)imageStr placeholder:(NSString *_Nullable)placeHolder complete:(UIImageViewCompleteBlock)completeBlock;
@end

NS_ASSUME_NONNULL_END
