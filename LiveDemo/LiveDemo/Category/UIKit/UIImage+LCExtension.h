//
//  UIImage+LCExtension.h
//  LDHeadlines
//
//  Created by mrgao on 2019/12/5.
//  Copyright © 2019 personal. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LCExtension)
+ (instancetype)imageWithColor:(UIColor *)color
                          size:(CGSize)size;
- (NSData *)zipImageToMaxKBit:(NSInteger)kBit;
@end

NS_ASSUME_NONNULL_END
