//
//  JXCategoryTitleBackgroundView.h
//  JXCategoryView
//
//  Created by jiaxin on 2019/8/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "JXCategoryTitleView.h"
#import "JXCategoryTitleBackgroundCellModel.h"
#import "JXCategoryTitleBackgroundCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXCategoryTitleBackgroundView : JXCategoryTitleView

@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *normalBorderColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *selectedBorderColor;
@property (nonatomic, assign) CGFloat borderLineWidth;
@property (nonatomic, assign) CGFloat backgroundCornerRadius;
@property (nonatomic, assign) CGFloat backgroundWidth;
@property (nonatomic, assign) CGFloat backgroundHeight;
@property (nonatomic , assign) CGSize shadowOffset;
@property (nonatomic , assign) CGFloat shadowOpacity;
@property (nonatomic , assign) CGFloat shadowRadius;
@property (nonatomic , strong, nullable) UIColor *shadowColor;
@end

NS_ASSUME_NONNULL_END
