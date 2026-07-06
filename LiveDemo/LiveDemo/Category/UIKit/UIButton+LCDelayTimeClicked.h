//
//  UIButton+LCDelayTimeClicked.h
//  LDHeadlines
//
//  Created by mrgao on 2020/2/20.
//  Copyright © 2020 personal. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (LDDelayTimeClicked)

@property (nonatomic, assign) NSTimeInterval eventInterval;
@property (nonatomic, assign) BOOL removeHighlightEffect;
@end

NS_ASSUME_NONNULL_END
