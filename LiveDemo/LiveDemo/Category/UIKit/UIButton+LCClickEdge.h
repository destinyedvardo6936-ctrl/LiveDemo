//
//  UIButton+LCClickEdge.h
//  LDHeadlines
//
//  Created by mrgao on 2020/10/13.
//  Copyright © 2020 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIButton (LDClickEdge)
- (void)setEnlargeEdge:(CGFloat)size;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end

NS_ASSUME_NONNULL_END
