//
//  UIButton+LCExtension.h
//  LDHeadlines
//
//  Created by mrgao on 2019/11/29.
//  Copyright © 2019 personal. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle
) {
ButtonEdgeInsetsStyleTop, // image在上，label在下
ButtonEdgeInsetsStyleLeft, // image在左，label在右
ButtonEdgeInsetsStyleBottom, // image在下，label在上
ButtonEdgeInsetsStyleRight // image在右，label在左
};
@interface UIButton (LDExtension)
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

- (void)setEnlargeEdge:(CGFloat)size;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end

NS_ASSUME_NONNULL_END
